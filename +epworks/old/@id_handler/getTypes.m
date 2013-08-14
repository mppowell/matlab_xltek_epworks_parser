function getTypes(obj)
%
%   getTypes(obj)
%
%   See end of code for property assignments made to class
%
%   Documentation Unfinished


t               = obj.tag_obj;
tag_names_local = t.tag_names;

%Step 1 - find all types
%--------------------------------------------------------------------------
I_type            = find(strcmp(tag_names_local,obj.OBJECT_TYPE_TAG_NAME));
%TODO: Replace with method ...
type_names_all    = t.tag_values(I_type);
type_names_all(~cellfun('isclass',type_names_all,'char')) = {'NULL'};
n_type_tags       = length(I_type);

%Assign type tags to groups
%--------------------------------------------------------------------------
all_ids_all_levels_local = obj.all_ids_all_levels;
tag_depth_local          = obj.all_depths_1;   %By tags

group_ids_for_each_type = zeros(1,n_type_tags);
for iTypeTag = 1:n_type_tags
   cur_tag_index = I_type(iTypeTag); 
   cur_depth     = tag_depth_local(cur_tag_index); 
   group_ids_for_each_type(iTypeTag) = all_ids_all_levels_local(cur_tag_index,cur_depth);  
end

%Above only ensures a group for each type, not a type for each group
%We'll assign a type to each group based on assigning less specific depths
%first, then going deeper. This isn't great but should suit our querying
%needs ...
depths_of_type        = tag_depth_local(I_type);
[~,type_assign_order] = sort(depths_of_type);

%NOTE: We currently don't have a list of which groups are under other
%groups. This means we can't say, for example, group 10 hold the type
%specifier, since 10 holds groups 11,12,13 & 14, we'll assign types to them
%as well
%Instead we assign to every tag the group spans, then we go back to the 
%indices of the group starts, and grab the type values that 
%were assigned to them
group_starts_local = obj.group_start_I;
group_ends_local   = obj.group_end_I;

all_tags_type_id_specific = zeros(1,t.n_tags);
for iTypeTag = type_assign_order
     cur_group_id_for_type = group_ids_for_each_type(iTypeTag);
     cur_start = group_starts_local(cur_group_id_for_type);
     cur_end   = group_ends_local(cur_group_id_for_type);
     all_tags_type_id_specific(cur_start:cur_end) = iTypeTag;
end

all_tags_type_id_top = zeros(1,t.n_tags);
types_at_level_1     = find(depths_of_type == 1);
for iTypeTag = types_at_level_1
     cur_group_id_for_type = group_ids_for_each_type(iTypeTag);
     cur_start = group_starts_local(cur_group_id_for_type);
     cur_end   = group_ends_local(cur_group_id_for_type);
     all_tags_type_id_top(cur_start:cur_end) = iTypeTag; 
end

%Property Assignment
%----------------------------------------------------------------------
obj.type_names         = type_names_all;
obj.n_types            = n_type_tags;
obj.type_main_group_id = group_ids_for_each_type; 

obj.most_specific_type_id__by_group = all_tags_type_id_specific(group_starts_local);
obj.top_level_types__by_group       = all_tags_type_id_top(group_starts_local);


end