classdef tst_parser < epworks.RNEL.handle_light
    %
    %   Class:
    %   epworks.tst_parser
    
    properties
        raw_data
        all_objects_out
    end
    
    methods
        function obj = tst_parser(file_path)
            obj.raw_data = epworks.sl.io.fileRead(file_path,'*uint8');
            
            obj.all_objects_out = epworks.raw_object.getTSTrawObjects(obj.raw_data);
            
        end
    end
    
end

