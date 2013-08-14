classdef electrode < epworks.type
    %
    %   Class:
    %       epworks.type.electrode
    
%'Unpopulated' Value:
%           location: [1x0 char]
%     phys_electrode: 3
%          phys_name: 'NONE'
%            self_id: [5647138943692794698 5649015485638562444]
%      matlab_parent: [1x1 epworks.main]
    
%Populated Value
%           location: 'L Tri+'
%     phys_electrode: 4
%          phys_name: 'E1'
%            self_id: [5003087627570134968 15043761184625310100]
%      matlab_parent: [1x1 epworks.main]
    
    properties
       location         %
       phys_electrode
       phys_name
       self_id 
    end
    
    properties (Constant,Hidden)
       %Please keep sorted ...
       %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
       REQUESTED_VALUES_AND_FUNCTIONS = {
            'ID'                'self_id'
            'Location'          'location'
            'PhysElectrode'     'phys_electrode'
            'PhysName'          'phys_name'
           }
       SELF_ID   = 'self_id'
       OTHER_IDS = {} %NONE
    end
    
    methods
        function set.location(obj,value)
           if isempty(value)
              value = ''; %Prefer this instead of [1x0 char]
           end
           obj.location = value;
        end
    end
    
%     properties (Constant,Hidden)
%        TAGS_TO_GET = epworks.type.electrode.REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
%        NEW_NAMES   = epworks.type.electrode.REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
%     end
    
    methods
        function obj = electrode(parent_obj,prop_names,values)
            obj@epworks.type(parent_obj,prop_names,values);
%             for iProp = 1:length(prop_names)
%                 obj.(prop_names{iProp}) = values{iProp};
%             end
        end 
    end
    
end

