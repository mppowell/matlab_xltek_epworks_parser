function [sorted_tag_ids,tag_text] = getTagText(obj)
   %tag_starts
   %tag_ends
   %tag_ids
   %tag_text

   %Extract tag ids, and start and stop indices
   %-----------------------------------------------------------------------
   [tag_ids_all,tag_starts_I_all,tag_ends_I_all] = helper__getTagStartsEndsIdsUnsorted(obj);
   
   %Sort the results ....
   %-----------------------------------------------------------------------
   [sorted_start_I,I_sort] = sort(tag_starts_I_all);
   sorted_end_I            = tag_ends_I_all(I_sort);
   sorted_tag_ids          = tag_ids_all(I_sort);
   
   %Grab the text
   %-----------------------------------------------------------------------
   n_tags   = length(sorted_tag_ids);
   tag_text = cell(1,n_tags);
   
   str_local = obj.raw_str; %Object prop access is slow ...
   for iTag = 1:n_tags
      if iTag ~= n_tags
          cur_start      = sorted_end_I(iTag)+1;
          cur_end        = sorted_start_I(iTag+1)-1;
          tag_text{iTag} = str_local(cur_start:cur_end);
      else
          cur_start      = sorted_end_I(iTag)+1;
          tag_text{iTag} = str_local(cur_start:end);          
      end
   end
   
   
   
end

function [tag_ids_all,tag_starts_I_all,tag_ends_I_all] = helper__getTagStartsEndsIdsUnsorted(obj)
%
%
%   [tag_ids_all,tag_starts_I_all,tag_ends_I_all] = helper__getTagStartsEndsIdsUnsorted(obj)
%


n_unique_tags = length(obj.TAG_LIST);

tag_ids_all    = zeros(1,obj.TAG_INIT_SIZE);
tag_starts_I_all = zeros(1,obj.TAG_INIT_SIZE);
tag_ends_I_all   = zeros(1,obj.TAG_INIT_SIZE);
count = 0;
for iTag = 1:n_unique_tags
    
    cur_note_tag = obj.TAG_LIST{iTag};
    
    tag_starts_I = strfind(obj.raw_str,cur_note_tag);
    
    n_values = length(tag_starts_I);
    
    tag_ids_all(count+1:count+n_values)    = iTag;
    tag_starts_I_all(count+1:count+n_values) = tag_starts_I;
    tag_ends_I_all(count+1:count+n_values)   = tag_starts_I + length(cur_note_tag) - 1;
    
    count = count + n_values;
end

tag_ids_all(count+1:end)      = [];
tag_starts_I_all(count+1:end) = [];
tag_ends_I_all(count+1:end)   = [];


end