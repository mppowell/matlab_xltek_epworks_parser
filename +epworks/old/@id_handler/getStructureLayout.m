function getStructureLayout(obj)
%
%   Not yet implemented. The goal was to return some sort of structure
%   that would make this all easier to look at.
%

I_top_level = find(obj.is_top_level_grouping);



s = struct('id',num2cell(I_top_level),'children',[],'type','');
% 
% for iTop = 1:
%     
% end

end