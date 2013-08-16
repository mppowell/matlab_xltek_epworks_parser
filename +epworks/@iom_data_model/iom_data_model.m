classdef iom_data_model
    %
    %   Class:
    %   epworks.iom_data_model
    
    %NOTES:
    %----------------------------------------------------------------------
    %1) If the property is not specified in the csv file, it will not be
    %   imported
    %2) Even if specified, importing can be overridden
    %3) Data from the 2nd to top level is not imported ...
    
    properties
       file_path 
    end
    
    properties
       full_names  %{n x 1} ex. EPGroup.Data.CaptureThreshold
       prop_names  %{n x 1} ex. CaptureThreshold
       import_property %[n x 1] 
       new_object_name %{n x 1} Only defined for where .is_new_object is true
       new_object_fh   %{n x 1} function handles
       is_new_object   %[n x 1] 
       custom_init     %[n x 1] The object should implement .initialize()
       custom_fh       %{n x 1}
       %use_custom_fh   %[n x 1]
       %This was added for :
       %    epworks.ep.test.settings.history_sets
    end
    
    methods
        function obj = iom_data_model()
            
           base_path     = epworks.RNEL.getMyPath;
           csv_file_path = fullfile(base_path,'data_model_hierarchy.csv');
           obj.file_path = csv_file_path;
           
           output        = epworks.RNEL.readDelimitedFile(csv_file_path,',');
           o_orig_name   = output(2:end,1);
           
           %Remove leading and ending apostrophe ...
           %---------------------------------------------------------------
           %Yikes! Look away ...
           %This used to be consistent but apparently on copy/paste
           %I accidentally started removing apostrophes ...
           start_apostrophe = cellfun(@(x) x(1) == '''',o_orig_name);
           end_apostrophe = cellfun(@(x) x(end) == '''',o_orig_name);
           
           o_orig_name(start_apostrophe) = cellfun(@(x) x(2:end),o_orig_name(start_apostrophe),'un',0);
           o_orig_name(end_apostrophe)   = cellfun(@(x) x(1:end-1),o_orig_name(end_apostrophe),'un',0);
           
           o_new_name    = output(2:end,2);
           o_dont_import = output(2:end,3);
           o_class_name  = output(2:end,4);
           o_custom_init = output(2:end,5);
           o_custom_fh   = output(2:end,6);
           
           obj.full_names = o_orig_name;
           
           %Use properties from full names unless another value is specified
           obj.prop_names = regexp(obj.full_names,'[^\.'']*$','match','once');
           mask = ~cellfun('isempty',o_new_name);
           
           obj.prop_names(mask) = o_new_name(mask);
           
           
           obj.import_property  = cellfun('isempty',o_dont_import);
           
           obj.is_new_object    = ~cellfun('isempty',o_class_name);
           
           obj.new_object_name  = o_class_name;
           
           obj.new_object_fh    = cell(length(obj.new_object_name),1);

           %NOTE: We must restrict it to non-empties as str2func doesn't
           %work for empty entries
           obj.new_object_fh(obj.is_new_object)   = cellfun(@str2func,obj.new_object_name(obj.is_new_object),'un',0);
        
           obj.custom_init = ~cellfun('isempty',o_custom_init);
           
           obj.custom_fh             = cell(length(obj.new_object_name),1);
           mask = ~cellfun('isempty',o_custom_fh);
           %obj.use_custom_fh = mask;
           obj.custom_fh(mask)   = cellfun(@str2func,o_custom_fh(mask),'un',0);
           
           %Update new objects so we are sure
           %to use custom constructors as well
           obj.is_new_object = obj.is_new_object | mask;
           
        end
    end
    
end

