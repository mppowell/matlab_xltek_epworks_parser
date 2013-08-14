function getDepthInformation(obj)
%getDepthInformation
%
%   getDepthInformation(obj)
%
%   FULL PATH:
%   epworks.id_handler.getDepthInformation
%
%   The goal of this file is to get information on how many levels down you
%   would need to go to access each object. This is based on the extents of
%   each object
%
%   The hyphens here are meant to indicate extents.
%
%   a  -----------------------------------
%         b ----------  
%                        c -------------
%                                           d ---------------------------
%
%   Roughly speaking, from the extents we would assume that
%   a is at the top level, as is d
%   b and c are children of a
%
%   So
%   a: 1
%   b: 2
%   c: 2
%   d: 2
%
%   In tree form we might think of these as:
%   a
%   a.b
%   a.c
%   d
%
%   Documentation Unfinished



%   Properties from tag_obj   ----------------
t = obj.tag_obj;
tag_data_ends_local   = t.tag_data_ends;
tag_data_starts_local = t.tag_data_starts;
n_tags                = t.n_tags;
top_level_starts      = t.top_level_tag_starts;
top_level_ends        = t.top_level_tag_ends;
tag_names_local       = t.tag_names;


[~,tag_or_group_end_I] = histc(tag_data_ends_local,tag_data_starts_local);
%tag_or_group_end_I - indicates the last tag in the group
%If it is a single value, then it is not considered a group

tag_or_group_end_I(end) = n_tags;
group_start_mask_local  = tag_or_group_end_I ~= 1:n_tags;


%Depths
%+1 : at value greater than itself (or itself)
%   - this is the difference between depths_1 or depths_2
%-1 : to value after the group ends

all_depths_1_local = ones(1,n_tags);
correction_value   = zeros(1,n_tags);

cur_depth = 1;
for iTag = 1:n_tags
    cur_depth = cur_depth + correction_value(iTag);
    
    if group_start_mask_local(iTag)
        cur_depth = cur_depth + 1;
        correction_index = tag_or_group_end_I(iTag) + 1;
        correction_value(correction_index) = correction_value(correction_index) - 1;
    end
    all_depths_1_local(iTag) = cur_depth;
end

all_depths_2_local = all_depths_1_local;
all_depths_2_local(group_start_mask_local) = ...
                all_depths_2_local(group_start_mask_local) - 1;

            
%Merge in top level groupings ...
%------------------------------------------------------------
%NOTE: Starts are unique, ends are not
%Ends are also not really 
starts_temp = find(group_start_mask_local);
all_starts  = [top_level_starts  starts_temp];
all_ends    = [top_level_ends    tag_or_group_end_I(starts_temp)]; 

%NOTE: Don't assign above then sort, otherwise starts and ends won't be
%matched
%group_start_mask_local(top_level_starts) = true;

[all_starts_fixed,I_sort] = sort(all_starts);
all_ends_fixed = all_ends(I_sort); 


%Property assignment
%--------------------------------------------------------------------------
obj.is_top_level_grouping = I_sort <= length(top_level_starts);

%obj.group_start_mask = group_start_mask_local;
obj.group_start_I    = all_starts_fixed;
obj.group_end_I      = all_ends_fixed;
obj.all_depths_1     = all_depths_1_local;
obj.all_depths_2     = all_depths_2_local;
obj.max_depth        = max(all_depths_1_local); %1 or 2 doesn't' matter here
obj.n_groups         = length(obj.group_start_I);
obj.group_tag_names  = tag_names_local(obj.group_start_I);
obj.group_depths     = all_depths_1_local(all_starts_fixed);
[~,obj.I_sort_group_depths] = sort(obj.group_depths);

end