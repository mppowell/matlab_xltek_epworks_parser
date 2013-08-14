classdef prop_link_info
    %
    %   Class:
    %   epworks.prop_link_info
    %
    %   See Also:
    %   epworks.id_object
    
    properties
       type
       obj_refs       %{n x 1}
       old_prop_names %{n x 1}
       new_prop_names %{n x 1}
       prop_ID_values %[n x 2]
    end
    
    methods
        function obj = prop_link_info(handle_objs,old_props,new_props)
           if size(handle_objs,2) > 1
               handle_objs = handle_objs';
           end
           if size(old_props,1) > 1
               old_props = old_props';
           end
           if size(new_props,1) > 1
               new_props = new_props';
           end
           
           obj.type = class(handle_objs);
           
           %column vector
           %old_props - row
           %new-props - row
           
           n_objs  = length(handle_objs);
           n_props = length(old_props);
           
           temp_1 = repmat(num2cell(handle_objs),1,n_props);
           temp_2 = repmat(old_props,n_objs,1);
           temp_3 = repmat(new_props,n_objs,1);
           temp_4 = cellfun(@(x,y) x.(y),temp_1(:),temp_2(:),'un',0);
           if any(cellfun('isempty',temp_4))
              %TODO: Fill this in with a more specific error
               error('Property of class:"%s" is empty, need to initialize to null',class(handle_objs))
           end
           
           n_total = n_objs*n_props;
           
           if numel(temp_1) ~= n_total
              error('Some properties were dropped') 
           end
           
           obj.obj_refs       = temp_1(:);
           obj.old_prop_names = temp_2(:);
           obj.new_prop_names = temp_3(:);
           obj.prop_ID_values = vertcat(temp_4{:});
        end
    end
    
end

