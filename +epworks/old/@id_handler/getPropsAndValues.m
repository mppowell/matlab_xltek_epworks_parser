function pv_struct = getPropsAndValues(obj,object_indices,tags_to_get,new_names,min_depth,max_depth)
%
%    [pv_struct] = ...
%               getPropsAndValues(obj,object_indices,tags_to_get,new_names,min_depth,max_depth)
%
%   This is the main method for extracting object (group) data from
%   the this and the tag class.
%
%   INPUTS
%   =======================================================================
%   object_indices : indices of objects that we wish to retrieve data for
%   tags_to_get    : (cellstr), names of the tags we wish to process
%   new_names      : (cellstr), new names to assign to each tag, these
%           names are the names of the properties that the final Matlab
%           class will use
%
%   OPTIONAL INPUTS
%   =======================================================================
%   min_depth      : (default 1) Minimum depth that a tag must be at to 
%           consider for usage. This allows us to only return tags that 
%           are at a certain level. This may be really important for some
%           objects where child objects contain properties with the same 
%           names as the parent object. 
%
%           Use a value of -1 to specify that no filter should be used.
%
%   max_depth      : (default: obj.max_depth), Last depth that is included
%           in the results.
%
%   OUTPUTS
%   =======================================================================
%   pv_struct. (structure) 
%       I_start : start of each group, indexes into prop_names and prop_values
%               specifies the start of where to start taking values
%       I_end   : end of each group, specifies the end of where to take values
%               from ...
%       prop_names  : cellstr
%       prop_values : cell array
%
%   IMPROVEMENTS:
%   -------------------------------------------------------
%   1) We should verify that all tag names for an object are unique. There
%   could be nested objects with the same name.


if ~exist('min_depth','var')
    min_depth = 1;
end

if ~exist('max_depth','var')
   max_depth = obj.max_depth; 
end

t = obj.tag_obj;

%Retrieve indices for all tags that match the given object indices
%---------------------------------------------------------------------------
n_objects_retrieve    = length(object_indices);

if n_objects_retrieve == 0
    pv_struct = struct([]);
    return
end

starts_local_filtered = obj.group_start_I(object_indices);
ends_local_filtered   = obj.group_end_I(object_indices);

n_tags_by_group = ends_local_filtered - starts_local_filtered + 1;
n_tags_total    = sum(n_tags_by_group);

all_tag_indices   = zeros(1,n_tags_total); %We need to keep track of
%the tag indices for grabbing values and tag names
all_index_obj_ids = zeros(1,n_tags_total);

cur_end = 0;
for iObj = 1:n_objects_retrieve
    cur_start   = cur_end + 1;
    cur_end     = cur_start + n_tags_by_group(iObj) - 1;
    all_index_obj_ids(cur_start:cur_end) = iObj;
    all_tag_indices(cur_start:cur_end)   = starts_local_filtered(iObj):ends_local_filtered(iObj);
end

%Filter out only the tags we wish to keep, based on the name ...
%--------------------------------------------------------------------------
%Design Note: I think the depth check first, then the string comparison
%on the filtered data is faster than doing them both together ...
%(speed difference not checked)
%Depth filtering

depths_of_tags = obj.all_depths_1(all_tag_indices);

if min_depth == -1 || (min_depth == 1 && max_depth == obj.max_depth)
    %No filtering on depth
else
    if min_depth == max_depth
        depth_mask  = depths_of_tags == min_depth;
    elseif min_depth == 1
        depth_mask  = depths_of_tags <= max_depth;
    elseif max_depth == obj.max_depth
        depth_mask  = depths_of_tags >= min_depth;
    end

    all_tag_indices   = all_tag_indices(depth_mask);
    all_index_obj_ids = all_index_obj_ids(depth_mask);
end

%Name filtering
all_tag_names = t.tag_names(all_tag_indices);

[ispresent,loc] = ismember(all_tag_names,tags_to_get);


prop_names   = new_names(loc(ispresent));
tag_obj_ids  = all_index_obj_ids(ispresent);
tag_indices  = all_tag_indices(ispresent);


%Population of outputs
%--------------------------------------------------------------------------
%Here we determine where the object ids change.
%Note, that the ids will be consecutive
%and we don't need to worry about out of order ids.
%
%e.g. 1 1 1 1 1 2 2 2 3 3 3 3 3 3 3 4 4 5 5 5 5 5

Iend   = [find(diff(tag_obj_ids) ~= 0) length(tag_obj_ids)];
Istart = [1 Iend(1:end-1)+1];

%cell_output = 

%TODO: Make method of tag_obj with check ...
prop_values = t.tag_values(tag_indices);
props_set   = t.tag_value_assigned(tag_indices);
if ~all(props_set)
   %TODO: Add more detail
   %=> indicates that requested value was not translated from the file
   %so the returned value will be empty, not the true value of the file
   %=> update the getValues function
   error('Not all requested property values are set') 
end

pv_struct = struct;
pv_struct.Istart      = Istart;
pv_struct.Iend        = Iend;
pv_struct.prop_names  = prop_names;
pv_struct.prop_values = prop_values;

%Create an ID for each ...

end