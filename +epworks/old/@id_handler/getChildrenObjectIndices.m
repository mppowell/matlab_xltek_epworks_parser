function children_object_indices = getChildrenObjectIndices(obj,parent_object_indices,levels_down_to_go)
%
%   children_object_indices = getChildrenObjectIndices(obj,parent_object_indices,levels_down_to_go)
%
%   INPUTS
%   ====================================================
%   

   children_object_indices = helper__getIndicesHelper(obj,parent_object_indices,levels_down_to_go);
end

%Recursive function
function children_object_indices = helper__getIndicesHelper(obj,parent_object_indices,current_depth)
   n_parents = length(parent_object_indices);
   temp_cell = cell(1,n_parents);
%            parent_child_matrix
%            pc_starts
%            pc_ends
   for iParent = 1:n_parents
      cur_parent_index = parent_object_indices(iParent);
      temp_cell{iParent} = obj.parent_child_matrix(obj.pc_starts(cur_parent_index)+1:obj.pc_ends(cur_parent_index),2)'; 
   end
   children_object_indices = [temp_cell{:}]; 
   current_depth = current_depth -1;
   if current_depth == 0
       return
   else
      children_object_indices = helper__getIndicesHelper(obj,children_object_indices,current_depth);
   end
end