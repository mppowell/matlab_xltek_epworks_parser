classdef raw_object_array < handle
    %
    %   Class:
    %   epworks.raw_object_array
    %
    %   See Also
    %   --------
    %   epworks.raw_object
    
    %These propertie are all arrays, which speeds up processing, rather
    %than single elements with multiple objects.
    
    %TODO: Update these definitions from epworks.raw_object class
    properties
       VERSION = 1
       parent_index %index of the parent, -1 indicates no parent
       
       depth
       total_byte_length
       raw_start_I %index (byte #) in the raw data file of where
       %the object specification starts
       raw_end_I 
       name
       
       full_name %cellstr
       %%'a.b.c.d.f' instead of just 'f'
       
       type %
       % -1 : no data
       %  0 : length 4, interpretation seems to vary
       %  TODO: finish - see raw_object
       %  1 :
       %  2 : string
       
       n_props
       data_start_I
       data_length
       data_value
       raw_data
       children_indices
       n_objs %The size of all the arrays above
    end
    
    methods
        function obj = raw_object_array
           INIT_SIZE = 100000;
           obj.parent_index = -1*ones(1,INIT_SIZE);
           obj.depth        = ones(1,INIT_SIZE);
           obj.total_byte_length = zeros(1,INIT_SIZE);
           obj.raw_start_I  = zeros(1,INIT_SIZE);
           obj.raw_end_I    = zeros(1,INIT_SIZE);
           obj.name         = cell(1,INIT_SIZE);
           %obj.full_name    = cell(1,INIT_SIZE);
           %We do this later ...
           obj.type         = -1*ones(1,INIT_SIZE);
           obj.n_props      = ones(1,INIT_SIZE);
           obj.data_start_I = zeros(1,INIT_SIZE);
           obj.data_length  = zeros(1,INIT_SIZE);
           obj.data_value   = cell(1,INIT_SIZE);
           obj.raw_data     = cell(1,INIT_SIZE);
           obj.children_indices = cell(1,INIT_SIZE);
        end
        function trim(obj,current_object_index)
           c = current_object_index + 1;
           obj.parent_index(c:end) = [];
           obj.depth(c:end)        = [];
           obj.total_byte_length(c:end) = [];
           obj.raw_start_I(c:end)  = [];
           obj.raw_end_I(c:end)    = [];
           obj.name(c:end)         = [];
           %obj.full_name(c:end)    = [];
           obj.type(c:end)         = [];
           obj.n_props(c:end)      = [];
           obj.data_start_I(c:end) = [];
           obj.data_length(c:end)  = [];
           obj.data_value(c:end)   = [];
           obj.raw_data(c:end)     = [];
           obj.children_indices(c:end) = [];
           obj.n_objs = current_object_index;
        end
    end
    
end

