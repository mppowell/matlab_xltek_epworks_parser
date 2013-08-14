classdef id_handler < epworks.RNEL.handle_light
    %
    %   Class:
    %   epworks.id_handler
    
    %REDESIGN
    %--------------------------------------
    %1) Move object parsing code into here from tags, this should become
    %the "objects" class
    
    
    properties
        %.getDepthInformation()
        d0 = '-------   Depth Properties   ----------'
        %----------         Depth properties       ------------------
        
        %A group indicates an object. The start and ends indicates which
        %properties belong to that object.
        
        group_start_I   %([1 x n_groups]) Indices into tags of start of group
        %NOTE: The first index indicates the parent object, the rest are
        %children of that parent
        group_end_I     %Last tag index of tags in group
        group_tag_names %([1 x n_groups]) tag name for each group header
        
        
        is_top_level_grouping %([1 x n_groups]) For each group, indicates
        %whether or not the group is top level or whether it indicates the
        %start of a lower level. The top level groups come from the magic
        %strings we extracted, where as the lower level groups came from
        %finding tags who are parents to other tags
        
        all_depths_1  %([1 x n_tags]) The start of a group i.e.
        %EPTriggeredWaveform.Data is at the same depth as its properties:
        %EPtriggeredWaveform.Data.AppliedHWFilterHFF
        %EPtriggeredWaveform.Data.AppliedHWFilterLFF
        %i.e. EPTriggeredWaveform.Data => Depth = 2
    end
    
    properties (Hidden)
        %.getDepthInformation()
        %----------         Depth properties       ------------------
        %Only used for name generation ...
        all_depths_2  %([1 x n_tags]) The start of a group is not at the depth of
        %its child properties, but is one above it
        %
        %   In other words we might have: (values on right are depths)
        %   a       1
        %   a.b     2
        %   a.b.c   3
        %   a.b.d   3
        %   a.b.e   3
        %
    end
    
    properties
        %.getDepthInformation()
        %----------         Depth properties       ------------------
        max_depth   %How many levels down the deepest properties are.
        %For example, if we determine we have something like:
        %
        %   a.b.c.final_prop, this would be a depth of 4
        %
        n_groups    %# of objects in the file
        
        group_depths         %([1 x n_groups]), depth values for each group
        %value, the group depth corresponds to where its data is
        %i.e. the depth of EPTriggeredWaveform.Data is at depth 2
        %
        %   Based on the above example I think we have:
        %   a       1
        %   a.b     3
        %   a.b.c   3
        %   a.b.d   3
        %   a.b.e   3
        %
        I_sort_group_depths  %([1 x n_groups]), how to sort the group depths
        %so that they go from low depths to high depths
        %
        %   I was using this to assign some property value where the lowest
        %   depth or the highest depth (I forget which) got to go first
        %
        %   TODO: ??? - who uses this property and why
    end
    %================== END OF DEPTH PROPERTIES ===========================
    
    
    
    
    properties
        d2 = '-----   Group Ids   -------'
        %
        %   NOTE: The group id is just a counter from 1 to n_groups
        %   that increments every time we encounter a new object. I think
        %   properties do not receive group ids
        
        %.getObjectIdsAtAllLevels()
        %-------------------------------------------------------
        all_ids_all_levels  %([n_tags x max_depth]) For each tag
        %this indicates the groups it is in at various depths
        %IMPORTANT: The current implementation does not assign
        %the deepest properties a group at their down depth, but
        %rather at their parents depths
        %
        %   This variable was created for trying to assign
        %   types to different objects ...
        most_specific_group_id      %([n_tags x 1]) for each tag, this
        %specifies the most specific group that the tag belongs to
        least_specific_group_id     %([n_tags x 1]) for each tag this specifies
        %the top most group that the tag belongs to
        %
        %Values indicate group #s. Group #s go from 1 to n, so they can be
        %thought of as indices into the above properties that are [1 x n_groups]
    end
    
    properties
        d3 = '------   Type Handling  -------'
        %.getTypes()
        %--------------------------------------------------------
        type_names         %([1 x n_types]) values for each property .Type property
        %
        %   i.e. if the tag name is 'Type', then this is the value of that tag
        
        n_types            %# of type properties observed
        
        type_main_group_id              %([1 x n_types]), indexes into the
        %groups above specifying which group contains the type tag as its
        %property. Not all objects contain a .Type property
        
        most_specific_type_id__by_group %([1 x n_groups]) indexes into type_names
        top_level_types__by_group       %([1 x n_groups]) indexes into type_names
        
        parent_child_matrix  %([n x 2])
        %Column 1 - parent group ids
        %Column 2 - children group ids
        
        pc_starts  %([1 x n_groups]) start of group as parent in parent_child_matrix
        %The first row of an object is always 0 for the child index, which is
        %a way of ensuring that all group ids exist as parents, and that
        %we can index directly into the matrix instead of doing a search
        pc_ends    %([1 x n_groups]) end of group as parent in parent_child_matrix
        
        d4 = '----  Extra derived type/name information  ----'
    end
    
    %These properties ended up being a little difficult to figure out
    %so I made them explicit
    properties (Dependent)
        top_level_type_by_tags     %{1 x n_tags}
        most_specific_type_by_tags %{1 x n_tags}
    end
    
    properties
        full_tag_names_with_type   %{1 x n_tags}
        %.getExtendedTagNames()
        %-------------------------------------------------------
        full_tag_names_sans_type       %([1 x n_tags]), full tag name for each
        %tag, which includes the name of all parents
        %parent.child1.child2.current_tag
    end
    
    methods
        function value = get.top_level_type_by_tags(obj)
            value = obj.type_names(obj.top_level_types__by_group(obj.least_specific_group_id));
        end
        function value = get.most_specific_type_by_tags(obj)
            value = obj.type_names(obj.most_specific_type_id__by_group(obj.most_specific_group_id));
        end
        function value = get.full_tag_names_with_type(obj)
            value = obj.full_tag_names_with_type;
            if isempty(value)
                value = cellfun(@(x,y,z) sprintf('{%s}__%s.%s',x,y,z),...
                    obj.top_level_type_by_tags,...
                    obj.most_specific_type_by_tags,...
                    obj.full_tag_names_sans_type,'un',0);
                obj.full_tag_names_with_type = value;
            end
        end
        function value = get.full_tag_names_sans_type(obj)
            if isempty(obj.full_tag_names_sans_type)
                %epworks.id_handler.getExtendedTagNames
                obj.getExtendedTagNames;
            end
            value = obj.full_tag_names_sans_type;
        end
    end
    
    properties (Constant)
        OBJECT_TYPE_TAG_NAME = 'Type';
    end
    
    properties
        %.id_handler()
        tag_obj  %epworks.tags
    end
    
    %Constructor call =====================================================
    methods
        function obj = id_handler(tag_obj)
            
            %Copy relevant properties from tag object ...
            %--------------------------------------------------------
            obj.tag_obj = tag_obj;
            
            obj.getDepthInformation();
            
            %obj.getExtendedTagNames();
            %I removed this call in favor of lazy evaluation
            
            obj.getObjectIdsAtAllLevels();
            obj.getTypes();
        end
    end
    
    %Query Methods ========================================================
    methods
        function group_indices_out = getUniqueObjects_ByType(obj,type_to_match)
            %Uses main ID
            %
            %   ??? - not sure what this means????
            %
            %   Who uses this and why?
            %
            group_indices_out = obj.type_main_group_id(strcmp(type_to_match,obj.type_names));
        end
        function group_indices_out = filterIndicesByTagName(obj,group_indices_in,tag_name_filter)
            %
            %
            group_indices_out = group_indices_in(strcmp(tag_name_filter,obj.group_tag_names(group_indices_in)));
        end
        function group_indices_out = filterIndicesByTypeName(obj,group_indices_in,sub_type_filter)
            %
            %
            %    Could allow filtering on lower or upper type
            %
            %
            
            type_names__by_group_id = obj.type_names(obj.most_specific_type_id__by_group);
            group_indices_out       = group_indices_in(strcmp(sub_type_filter,type_names__by_group_id(group_indices_in)));
        end
    end
    
end

