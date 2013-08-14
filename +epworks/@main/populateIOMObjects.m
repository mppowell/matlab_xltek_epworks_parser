function populateIOMObjects(obj,parsed_iom_data)
%
%   
%   INPUTS
%   --------------------------------------------------
%   parsed_iom_data : epworks.iom_parser
%   
%   This method takes an array of raw objects, epworks.raw_object, from the
%   parsed_iom_data object and builds a final set of objects that this
%   class will hold onto. For example, a raw object of depth 1 and with a
%   property EPTest will be converted to a epworks.ep.test object.
%   
%
%   See Also:
%   epworks.iom_data_model
%
%   Full Path:
%   epworks.main.populateIOMObjects


r = parsed_iom_data.raw_objects;

n_objects = r.n_objs;

dom    = epworks.iom_data_model;

%Property extraction from r to arrays
%---------------------------------------------------------------
depths           = r.depth';
full_names       = r.full_name';
fixed_full_names = regexprep(full_names,'\.\d{3}','.000');

ispresent = ismember(fixed_full_names,dom.full_names);

obj.non_dom_names = fixed_full_names(~ispresent);
obj.ignored_names = dom.full_names(~dom.import_property);

%Translation of properties that are specified for unique objects 
%to the raw object properties that we currently have where each object
%type can have multiple instances
%--------------------------------------------------------------------------
dom_full_names_with_objects = dom.full_names(dom.is_new_object);
fh_temp = dom.new_object_fh(dom.is_new_object);

[import_object,loc] = ismember(fixed_full_names,dom_full_names_with_objects);

import_object_function_handles = cell(1,n_objects);
import_object_function_handles(import_object) = fh_temp(loc(import_object));

custom_init = dom.custom_init(dom.is_new_object);
use_custom_init = false(1,n_objects);
use_custom_init(import_object) = custom_init(loc(import_object));

%For each property, determine if we should import the property or not
[import_property,loc] = ismember(fixed_full_names,dom.full_names);

import_object_property_names = cell(1,n_objects);
import_object_property_names(import_property) = dom.prop_names(loc(import_property));

import_property(import_property) = dom.import_property(loc(import_property));

%The main loop which builds the objects
%--------------------------------------------------------------------------
all_created_objects    = cell(1,n_objects);
created_object_present = false(1,n_objects);

starting_depth = max(depths(import_object));

is_array_object = false(1,r.n_objs);
mask = strcmp(r.name,'000');
is_array_object(r.parent_index(mask)) = true;

%NOTE: We'll do top level objects separately
%Specifically, we need to get props from data ...
for cur_depth = starting_depth:-1:1
    I = find(depths == cur_depth & import_object);
    for iIndex = 1:length(I)
        cur_index   = I(iIndex);
        cur_fh      = import_object_function_handles{cur_index};
        temp        = cur_fh();
        %cur_raw_obj = r(cur_index);
        
        children_indices = r.children_indices{cur_index};
        
        if isempty(children_indices)
            %Do nothing ...
        elseif is_array_object(cur_index) %strcmp(r(children_indices(1)).name,'000')
            %Array construction ...
            %
            %   Here we are going from something like:
            %   EPTest.Data.Settings.CursorCalc with children
            %   EPTest.Data.Settings.CursorCalc.000
            %   EPTest.Data.Settings.CursorCalc.001
            %   EPTest.Data.Settings.CursorCalc.002
            %
            %   to the final EPTest.Data.Settings.CursorCalc object
            %   being an array of length 2, with the properties
            %   the properties that are kept in the raw 000,001,and 002
            %
            
            n_children = length(children_indices);
            
            %Initialize a vector of objects, instead of just one
            temp(n_children) = cur_fh();
            
            for iArrayObject = 1:n_children
                cur_final_array_object = temp(iArrayObject);
                local_child_indices    = r.children_indices{children_indices(iArrayObject)};
                
                helper__populateObject(r,...
                    use_custom_init(cur_index),...
                    local_child_indices,...
                    import_object_property_names,...
                    import_property,...
                    created_object_present,...
                    all_created_objects,...
                    cur_final_array_object)

            end
        else
            if cur_depth == 1
                child_names = r.name(children_indices);
                
                data_mask = strcmp(child_names,'Data');
                if sum(data_mask) ~= 1
                    error('Code assumption violated, rewrite to accommodate missing data')
                end
                
                %Remove data object and promote children to assignment as
                %top-level properties
                %i.e. something like:
                %'EPTriggeredWaveform.Data.Range'
                %becomes
                %EPTriggeredWaveform.Range
                children_indices = [children_indices(~data_mask) r.children_indices{children_indices(data_mask)}];
            end
            
            helper__populateObject(r,...
                use_custom_init(cur_index),...
                children_indices,...
                import_object_property_names,...
                import_property,...
                created_object_present,...
                all_created_objects,...
                temp)
        end
        created_object_present(cur_index) = true;
        all_created_objects{cur_index}    = temp;
        %NOTE: If a child is a #, we'll need to build an array of these
        %objects ...
    end
end

%At this point all of the objects are in an array. Here we pull out the
%top level objects and assign them to this class as properties.
final_prop_instructions = {
    'cursors' 'EPCursor'
    'freerun_waveforms' 'EPFreerunWaveform'
    'groups'    'EPGroup'
    'patient'   'EPPatient'
    'sets'      'EPSet'
    'study'     'EPStudy'
    'tests'     'EPTest'
    'traces'    'EPTrace'
    'triggered_waveforms' 'EPTriggeredWaveform'
    };

%NOTE: 'I' should still point to depths == 1

final_prop_names = final_prop_instructions(:,1);
full_names_of_final_props = final_prop_instructions(:,2);
n_props = length(final_prop_names);

full_names_top_level = full_names(I);

for iProp = 1:n_props
    obj.(final_prop_names{iProp}) = [all_created_objects{I(strcmp(...
        full_names_top_level,full_names_of_final_props{iProp}))}];
end

end

function helper__populateObject(r,...
    use_custom_init_element,...
    children_indices,...
    import_object_property_names,...
    import_property,...
    created_object_present,...
    all_created_objects,...
    obj_to_populate_ref)

if use_custom_init_element
    %If this is true it basically says that instead of doing the default
    %behavior where we assign values to properties based on matching
    %names, we call a custom initialization method
    %
    %Unfortunately, at this point we only have the children indices
    %and the constructor, and initialization scheme needs to know the
    %parent
    %
    %See for example:
    %epworks.ep.test.settings.history_sets
    %epworks.ep.test.settings.trend_sets
    %
    %These are outlined in the .csv file under needing custom initializers
    %
    %Yikes, this is a hack for now ...
    %Should pass in correct index ...
   obj_to_populate_ref.initialize(r,children_indices);
   return
end

data_values = r.data_value(children_indices);
for iChild = 1:length(children_indices)
    cur_child_index = children_indices(iChild);
    if import_property(cur_child_index)
        cur_child_prop_name = import_object_property_names{cur_child_index};
        if created_object_present(cur_child_index)
            obj_to_populate_ref.(cur_child_prop_name) = all_created_objects{cur_child_index};
        else
            %cur_child_obj   = r(cur_child_index);
            %This prevents overriding defaults ...
            cur_data_value = data_values{iChild};
            if ~isempty(cur_data_value)
                obj_to_populate_ref.(cur_child_prop_name) = cur_data_value;
            end
        end
    end
end


end
