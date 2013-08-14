function getTagFullNames(obj)
%
%   getTagFullNames(obj)
%
%

%===================================
%       OBSOLETE FUNCTION
%===================================


%Get the type name for each object ...
%Technically we only need it for the first instance ...
top_level_obj_types_local = obj.tag_top_level_object_types(obj.tag_top_level_object_id);

is_start_of_type = false(1,obj.n_tags);
is_start_of_type(obj.tag_top_level_object_starts) = true;

depth_level_local         = obj.tag_depth_level;
tag_names_local           = obj.tag_names;

temp_full_names = cell(1,obj.n_tags);

cur_full_strings_by_depth = cell(1,max(obj.tag_depth_level));
cur_strings_by_depth      = cell(1,max(obj.tag_depth_level));

for iTag = 1:obj.n_tags
    cur_depth    = depth_level_local(iTag);
    cur_tag_name = tag_names_local{iTag};
    
%     if iTag == 3128
%        keyboard 
%     end
    
    cur_strings_by_depth{cur_depth} = cur_tag_name;
    
    %Yikes, I ran into a situation in which type did not delinieate
    %differences in objects. This just became a complete mess ...
    if cur_depth == 1
        cur_full_strings_by_depth{1}         = [top_level_obj_types_local{iTag} '.' cur_tag_name];
    elseif is_start_of_type(iTag)
        %see 1396 in example file ...
        %3127
%         cur_strings_by_depth{1}      = [top_level_obj_types_local{iTag} '.' cur_strings_by_depth{1}];
%         cur_full_strings_by_depth(1) = cur_strings_by_depth(1);
%         if iTag == 3127
%            keyboard 
%         end
        cur_full_strings_by_depth(1) = top_level_obj_types_local(iTag);
        cur_strings_by_depth(1) = top_level_obj_types_local(iTag);
        
        for temp_depth = 2:cur_depth
            cur_full_strings_by_depth{cur_depth} = helper__cellArrayToString(cur_strings_by_depth(1:temp_depth));
        end
        
    else
        cur_full_strings_by_depth{cur_depth} = [cur_full_strings_by_depth{cur_depth-1} '.' cur_tag_name];
    end
    
    temp_full_names(iTag) = cur_full_strings_by_depth(cur_depth);
end

%Property Assignment
%--------------------------------------------------------------
obj.tag_full_names = temp_full_names;

end

function string_output = helper__cellArrayToString(cellstr_input)
    P = cellstr_input(:)';
    P(2,:) = {'.'};
    P{2,end} = [] ; 
    string_output = sprintf('%s',P{:});
end