classdef id_manager < handle
    %
    %   Class:
    %   epworks.id_manager
    %
    %   See Also:
    %   epworks.reverse_link_instructions
    
    properties
        IOM_TOPS = {
            'cursors'
            'freerun_waveforms'
            'groups'
            'patient'
            'sets'
            'study'
            'tests'
            'traces'
            'triggered_waveforms'}
    end
    
    properties
        d1 = '----   Self References   ----'
        self_id_values
        self_id_obj_references
        
        self_id_is_referenced_in_other_prop %This can be used for reverse linking
        
        d2 = '----   Props with IDs Info  ----'
        
        id_properties
        object_references
    end
    
    methods
        function obj = id_manager(main_obj)
            %Might be useful to get a deep struct
            %function
            
            IOM_TOPS_LOCAL  = obj.IOM_TOPS;
            F.rowsToCell    = @epworks.sl.array.rowsToCell;
            F.ismember_rows = @epworks.sl.cellstr.ismember_rows;
            
            %Gather all objects that have IDs
            %-------------------------------------------------------
            %- first, top level objects from the main_obj
            n_iom_top = length(IOM_TOPS_LOCAL);
            
            objs_by_type  = cell(n_iom_top,1);
            for iObj = 1:n_iom_top
                cur_obj_name = IOM_TOPS_LOCAL{iObj};
                objs_by_type{iObj} = main_obj.(cur_obj_name)';
            end
            
            %- second, from test objects
            test_objs = main_obj.tests;
            
            objs_by_type = [objs_by_type; test_objs.getSubIDObjects];
            
            %- third, from the rec files
            rec_files     = main_obj.rec_files;
            if ~isempty(rec_files)
                rec_waveforms = [rec_files.waveforms];
                objs_by_type = [objs_by_type; {rec_files'}; {rec_waveforms'}];
            end
            
            %Note, this occurs, for example, when we have no cursor objects
            objs_by_type(cellfun('isempty',objs_by_type)) = [];
            %--------------------------------------------------------------
            
            
            
            
            %Now, for each of these objects, get their ID
            %It is possible that some of these values will be [0 0]
            ids_by_type = cellfun(@getSelfID,objs_by_type,'un',0);
            
            %NOTE: objs_by_type is a cell array, where each entry contains
            %an array of objects of the same type. This is useful because we
            %can retrieve object specific information about an array of
            %objects must faster than we can about individual objects.
            
            %These next couple of lines merge all of the arrays into one
            %big cell array where the length of each cell is 1
            obj.self_id_values = vertcat(ids_by_type{:});
            temp = cellfun(@num2cell,objs_by_type,'un',0);
            obj.self_id_obj_references = vertcat(temp{:});
            
            [matched_ids,...
                matched_id_obj_with_prop,...
                matched_id_obj_for_assignment_as_prop,...
                matched_id_prop_to_assign_to] = helper__makeForwardMatches(obj,objs_by_type);
            
            helper__makeReverseMatches(...
                matched_id_obj_for_assignment_as_prop,...
                matched_id_obj_with_prop,...
                matched_ids,...
                matched_id_prop_to_assign_to,...
                F);
        end
    end
    
end

function [matched_ids,...
    matched_id_obj_with_prop,...
    matched_id_obj_for_assignment_as_prop,...
    matched_id_prop_to_assign_to] = helper__makeForwardMatches(obj,objs_by_type)


%Get information as to properties that need to be resolved to objects
%
%    For example, we might have:
%
%    trace.OChanId = [5528552816703849858 5453045610028244131]
%
%    Note, IDs are 16 byte numbers, which I represent as 2 uint64's
%
%    Somewhere, there should be a ochan object with that same
%    ID. We then make the assignment:
%
%    trace.ochan = ochan_object;
%
%    NOTE: I had chosen to replace the ID with the number, but
%    it made the matching comparison difficult because I
%    couldn't see the ID that the number had replaced.
%
%---------------------------------------------------------------------
prop_link_info_by_type = cellfun(@getPropLinkInfo,objs_by_type,'un',0);
%epworks.prop_link_info

%Merge, no need to keep object specific anymore
prop_link_info_by_type = [prop_link_info_by_type{:}];

prop_id__all_objs  = vertcat(prop_link_info_by_type.obj_refs);
prop_id__new_props = vertcat(prop_link_info_by_type.new_prop_names);
prop_id__id_values = vertcat(prop_link_info_by_type.prop_ID_values);

%Match property ID values to the list of IDs that is 1:1 with
%the objects.
%i.e. for our ochan example, somewhere we have:
%    ochan.ID = [5528552816703849858 5453045610028244131]
[id_matches_mask,loc] = ismember(prop_id__id_values,obj.self_id_values,'rows');

%This is just a little bit of debugging ...
obj.self_id_is_referenced_in_other_prop = false(1,length(obj.self_id_values));
obj.self_id_is_referenced_in_other_prop(loc(id_matches_mask)) = true;

%Form match info
%------------------------------------------------------
%Now I get the relevant information for all matches and carry
%out the assignment.

matched_ids = prop_id__id_values(id_matches_mask,:);

%Some objects don't actually have IDs, but they have properties
%with IDs, unfortunately I use a null id value in their
%initialization. This line just prevents these from getting
%assigned to the many objects that have properties with null IDs
filter_mask = matched_ids(:,1) == uint64(0) & matched_ids(:,2) == uint64(0);

self_id_obj_references_local = obj.self_id_obj_references;
matched_id_obj_for_assignment_as_prop = self_id_obj_references_local(loc(id_matches_mask));
matched_id_obj_for_assignment_as_prop(filter_mask) = [];

matched_id_obj_with_prop = prop_id__all_objs(id_matches_mask);
matched_id_obj_with_prop(filter_mask) = [];

matched_id_prop_to_assign_to = prop_id__new_props(id_matches_mask);
matched_id_prop_to_assign_to(filter_mask) = [];

matched_ids(filter_mask,:) = [];

n_assignments = length(matched_id_obj_for_assignment_as_prop);
for iMatch = 1:n_assignments
    cur_obj_with_prop       = matched_id_obj_with_prop{iMatch};
    cur_prop                = matched_id_prop_to_assign_to{iMatch};
    cur_obj_for_assignment  = matched_id_obj_for_assignment_as_prop{iMatch};
    cur_obj_with_prop.(cur_prop) = cur_obj_for_assignment;
end

end

function helper__makeReverseMatches(...
    matched_id_obj_for_assignment_as_prop,...
    matched_id_obj_with_prop,...
    matched_ids,...
    matched_id_prop_to_assign_to,...
    F)

%Reverse property matching
%---------------------------------------------------------------
%NOTE: This is me being a bit lazy, shortening matched_id to mid
mid_class_of_obj_for_assignment = cellfun(@class,matched_id_obj_for_assignment_as_prop,'un',0);
mid_class_of_obj_with_prop      = cellfun(@class,matched_id_obj_with_prop,'un',0);
mid_prop_to_assign_to           = matched_id_prop_to_assign_to;

%The first three columns are of the format:
%1    2       3
%obj.(prop) = value <- where value is an object
%
%We also hold onto the ID that was matched
%
%Now we want to do:
%value.(new_prop) = objs , where objs is an array of all
%objects where 'value' was assigned
%
%For example:
%triggered_waveform.trace = trace_obj
%
%Now we want to do:
%trace_obj.triggered_waveforms = triggered_waveform_objs
mid_matrix = [...
    mid_class_of_obj_with_prop(:) ...
    mid_prop_to_assign_to(:) ...
    mid_class_of_obj_for_assignment(:) ...
    F.rowsToCell(matched_ids)'];

%This 'temp' line is for my own info
%What are the unique combination of assignments observed ...
%temp = epworks.RNEL.uniqueRowsCA(mid_matrix(:,1:3);

%NOTE: I need the objects as well, not just the names ...
[u_entries,~,J] = epworks.RNEL.uniqueRowsCA(mid_matrix);

rli = epworks.reverse_link_instructions();

rli_matrix = [rli.objs_with_prop_names rli.prop_names rli.objs_to_assign_names];

[ispresent,loc] = F.ismember_rows(u_entries(:,1:3),rli_matrix);

new_props_names = rli.new_prop_names;
I = find(ispresent);

for iEntry = I(:)'
    I_assign  = find(J == iEntry);
    prop_name = new_props_names{loc(iEntry)};
    objs_1    = [matched_id_obj_with_prop{I_assign}]; %Same type of obj for all
    obj_2     = matched_id_obj_for_assignment_as_prop{I_assign(1)}; %Same obj for all
    obj_2.(prop_name) = objs_1;
end
end