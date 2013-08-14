function getObjectIdsAtAllLevels(obj)
%
%   getObjectIdsAtAllLevels(obj)
%
%   The goal of this function is to generate a matrix which indicates
%   for each tag which group ids apply to it at each level.
%
%   Addition:
%       We threw into this function something that maps the parent
%   
%
%   Improvements:
%       Separate the two jobs that this function is currently performing


tag_obj = obj.tag_obj;
n_tags  = tag_obj.n_tags;

all_ids_all_levels_local = zeros(n_tags,obj.max_depth);

depths_group_local  = obj.group_depths; %Put depth at children ...

group_start_I_local = obj.group_start_I;
group_end_I_local   = obj.group_end_I;
is_top_level_grouping_local = obj.is_top_level_grouping;
n_groups_local      = obj.n_groups;

%TODO: Need to distinguish between parents and top level parents

parent_child_matrix_local = zeros(2*n_groups_local,2);

cur_parent_child_index = 0;
for iGroup = 1:n_groups_local 
    cur_start = group_start_I_local(iGroup);
    cur_end   = group_end_I_local(iGroup);
    cur_depth = depths_group_local(iGroup);
    
    cur_parent_child_index = cur_parent_child_index + 1;
    
    %For each object, we start with a row with a 0 second value
    %This row will later be ignored, but it ensures that each group shows
    %up at least once in this matrix as a parent. If the length of the # 
    %of entries in this matrix is 1, then we know it has no children.
    %This allows us to directly index into start & stop values, without
    %searching for which start & stop values apply to the group
    %
    %   i.e. consider the case where we only keep valid parents
    %
    %   Then we might have
    %   starts = 10 30 40
    %   ends   = 15 35 45
    %   group_indices = 1 3 5
    %
    %   If we want to get things for group 5, we first need to find out
    %   which index (in tihs case 3) in the starts and ends to use
    %
    %   Alternatively:
    %   starts = 10 16 30 36 40
    %   ends   = 15 16 35 36 45
    %
    %   We now can index into 5, to get starts and ends for 5, we also
    %   know that since starts(2) = ends(2), 2 has no children
    %
    %
    parent_child_matrix_local(cur_parent_child_index,:) = [iGroup 0];
    
    if is_top_level_grouping_local(iGroup)
        all_ids_all_levels_local(cur_start:cur_end,1) = iGroup;
    else
        all_ids_all_levels_local(cur_start:cur_end,cur_depth) = iGroup;
        cur_parent_child_index = cur_parent_child_index + 1;
        parentID = all_ids_all_levels_local(cur_start,cur_depth-1);
        parent_child_matrix_local(cur_parent_child_index,:) = [parentID iGroup];
    end
end

obj.all_ids_all_levels = all_ids_all_levels_local;

temp = all_ids_all_levels_local;
obj.most_specific_group_id  = max(temp,[],2);
temp(temp == 0) = Inf; %Need to make 0 high to grab next lowest value
obj.least_specific_group_id = min(temp,[],2);



parent_child_matrix_local(cur_parent_child_index+1:end,:) = [];

obj.parent_child_matrix = sortrows(parent_child_matrix_local);

I_temp = find(diff(obj.parent_child_matrix(:,1)) == 1)';

obj.pc_ends   = [I_temp length(I_temp)+1];
obj.pc_starts = [1 I_temp+1];



end