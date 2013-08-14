classdef raw_object_helper < epworks.RNEL.handle_light
    %
    %   Class:
    %   epworks.raw_object_helper
    %
    %   This basically just holds the raw data between the various static
    %   function calls being made in the raw_object class. I'm not thrilled
    %   with the organization of this class but it works for now.
    %
    %
    %   This is currently used by: 
    %   epworks.raw_object
    
    properties
       raw_data_u8
       raw_data_char
       raw_data_u32_as_double
       
       d0 = '----  Read and write each loop  ----'
       raw_obj_array %epworks.raw_object_array
       all_data_objects       
       cur_obj_index
    end
    
    properties
       d1 = '----  Use getNextDepth  ----'
       depth = 1     %Use getNextDepth 
    end
    
    methods
        function obj = raw_object_helper(raw_data_u8,roa,cur_obj_index)
            
            %NOTE: To speed up data reading we can typecast the data using
            %different shifts. Thus, instead of typecasting multiple times
            %we just index into indexed data with different shifts. This
            %speed comes at the cost of more memory usage, but since we
            %assume these files are small, that shouldn't be a problem.
            
            %TOTAL DATA EXPANSION
            %u8     1x
            %char   1x
            %u32    4x
            %double 8x
            %
            %   Data grows by 10
            %
            %   which for 5 - 10 MB is not that big a deal ...
            %
            %   If need be we can remove the double ...
            
            obj.raw_obj_array = roa;
            %obj.all_data_objects = all_data_objects;
            obj.cur_obj_index    = cur_obj_index;
            
            obj.raw_data_u8    = raw_data_u8;
            obj.raw_data_char  = char(raw_data_u8);
            %NOTE: This assumes these files are extremely small,
            %which in my experience has been the case
            obj.raw_data_u32_as_double = double(epworks.sl.io.allU32FromU8(raw_data_u8));
        end
        function next_depth = getNextDepth(obj)
            next_depth = obj.depth + 1;
            obj.depth  = next_depth;
        end
    end
    
end

