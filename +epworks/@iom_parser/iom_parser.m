classdef iom_parser < handle
    %
    %   Class:
    %   epworks.iom_parser
    
    properties
       %Filter properties
    end
    
    properties
        raw_u8_data  %The raw data as uint8
        raw_objects     
    end
    
    methods
        function obj = iom_parser(file_path)
            
            obj.raw_u8_data = epworks.sl.io.fileRead(file_path,'*uint8');
            
            obj.raw_objects = epworks.raw_object.getIOMrawObjects(obj.raw_u8_data);
               
            %This is an interesting view
            %obj.s = obj.translateObjects();
            
            %This populates data_value for each raw objects (or most raw
            %objects)
            obj.translateData();
            
        end
        function unique_names = getUniqueNamesToHandle(obj)
            MAX_DEPTH = 6;
            
            
            r = obj.raw_objects;
            all_full_names = {r.full_name};
            
            %Let's examine the truly unique name objects
            %that we care about ...
            
            depths = [r.depth];
            r2 = r;
            r2(depths > MAX_DEPTH) = [];
            all_full_names = {r2.full_name};
            
            %Replace .### with .000
            all_full_names = regexprep(all_full_names,'\.\d{3}','.000');
            unique_names = unique(all_full_names)'; 
        end
    end
end


