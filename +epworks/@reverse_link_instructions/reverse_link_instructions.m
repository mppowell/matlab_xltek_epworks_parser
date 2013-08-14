classdef reverse_link_instructions < handle
    %
    %   Class:
    %   epworks.reverse_link_instructions
    %   
    %   See Also:
    %   epworks.id_manager
    %   epworks.iom_data_model
    
    properties
       file_path 
    end
    properties
       objs_with_prop_names %{n x 1}
       prop_names           %{n x 1}
       objs_to_assign_names %{n x 1}
       new_prop_names       %{n x 1}
    end
    
    methods
        function obj = reverse_link_instructions()
           base_path     = epworks.RNEL.getMyPath;
           csv_file_path = fullfile(base_path,'ID_assignments.csv');
           obj.file_path = csv_file_path;
           
           output        = epworks.RNEL.readDelimitedFile(csv_file_path,',');
           
           %o_orig_name   = output(2:end,1);
           
           %Remove leading and ending apostrophe ...
           %---------------------------------------------------------------
           %Yikes! Look away ...
           %This used to be consistent but apparently on copy/paste
           %I accidentally started removing apostrophes ...
           
           output = regexprep(output,'^''','');
           output = regexprep(output,'''$','');
           
%            start_apostrophe = cellfun(@(x) x(1) == '''',output);
%            end_apostrophe = cellfun(@(x) x(end) == '''',output);
%            
%            output(start_apostrophe) = cellfun(@(x) x(2:end),output(start_apostrophe),'un',0);
%            output(end_apostrophe) = cellfun(@(x) x(2:end),output(end_apostrophe),'un',0);
           
           use_mask = [false; ~cellfun('isempty',output(2:end,4))];
           
           obj.objs_with_prop_names = output(use_mask,1);
           obj.prop_names           = output(use_mask,2);
           obj.objs_to_assign_names = output(use_mask,3);
           obj.new_prop_names       = output(use_mask,4);
           
%            o_orig_name(start_apostrophe) = cellfun(@(x) x(2:end),o_orig_name(start_apostrophe),'un',0);
%            o_orig_name(end_apostrophe)   = cellfun(@(x) x(1:end-1),o_orig_name(end_apostrophe),'un',0);
%            
%            o_new_name    = output(2:end,2);
%            o_dont_import = output(2:end,3);
%            o_class_name  = output(2:end,4);
%            o_custom_init = output(2:end,5); 
        end
    end
    
end

