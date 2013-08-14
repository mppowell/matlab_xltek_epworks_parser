function [tag_id_groups,tag_text_groups] = tagsToGroups(obj,sorted_tag_ids,tag_text)
%
%
%   [tag_id_groups,tag_text_groups] = tagsToGroups(obj,sorted_tag_ids,tag_text)
%
%   OUTPUTS
%   =======================================================================
%   tag_id_groups : cell array of arrays, values in the arrays are tag
%                   ids (index into obj.TAG_LIST to get name)
%                   ex => {[1 2 3 4],[1 2 3 4]}
%   tag_text_groups : cell array of cellstr, values are the text for that
%                   tag
%                   ex => {{'a' 'b' 'c' 'de'} {'a' 'ce' 'def' 'fer'}}
%
%
%   INPUTS
%   =======================================================================
%   sorted_tag_ids : [1 x # of tags found], id for each tag, sorted by the
%           order encountered in the file, index into obj.TAG_LIST to get
%           the name of the tag
%   tag_text       : {1 x # of tags found}, associated text with each
%                   string, goes from just after the end of the tag to just
%                   before the new tag}

%Previous assumptions that tags would be ordered and all present was
%violated so I rewrote the code to be more general ...

I_start = find(sorted_tag_ids == 1);
I_end   = [I_start(2:end)-1 length(sorted_tag_ids)];
%If this ever happens the code needs to be rewritten ..
if I_start(1) ~= 1
    error('Assumption that Category indicates the start of a tag was violated')
end

n_groups = length(I_start);
tag_id_groups   = cell(1,n_groups);
tag_text_groups = cell(1,n_groups); 

for iGroup = 1:n_groups
   cur_start = I_start(iGroup);
   cur_end   = I_end(iGroup);
   tag_id_groups{iGroup}   = sorted_tag_ids(cur_start:cur_end);
   tag_text_groups{iGroup} = tag_text(cur_start:cur_end);
   
   %TODO: Should check that ids are unique for the group ...
end