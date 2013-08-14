classdef ep_trace < epworks.type
    %
    %   Class:
    %       epworks.type.ep_trace
    %
    %   A trace is a a waveform. In the context I have used them they are
    %   typically a triggered response to a stimulus. I think in some cases
    %   the trigger is a 
    %
    %   From Screenshot:
    %   - Name of Trace 
    %   - whether enabled or not
    %   - filter properties (NOTE: I think these are software filters that
    %   are applied on the collected data. Importantly, the data is not
    %   stored with the software filters in place, only the hardware
    %   filters)
    %   - Sensitivity uV/div
    %   - Timebase 5 ms/div
    %   - Sampling Frequency
    %
    
    properties
       name     %Channel Name - example 'L AT', 'L Tri'
    end
    
    properties (Dependent)
       create_time_string 
    end
    
    properties
        stlive_num_accepted  %???? Why are things accepted
        %The numbers are high, not 1:1 with triggered waveforms
        %
        %In general accepted indicates that the waveform was within
        %the rejection threshold
    end
    
    properties (Dependent)
       stlive_timestamp_string 
    end
    
    properties
       is_root  %??? What does this indicate
       %None of the observed values are root ...
    end
    
    properties (Hidden)
       create_time 
       stlive_timestamp
    end
    
    %Not Implementing
    %----------------------
    %{
    ActiveWaveformObjId
    OriginX
    OriginY
    State
    Schema
    Children
    %}
    
    methods 
        function value = get.create_time_string(obj)
           value = obj.getTimeString(obj.create_time); 
        end
    end
    
    properties
        d2 = '----  Object Pointers  ----'
        parent   %Class: epworks.type.ep_test
        group    %Class: epworks.type.ep_group
        ochan    %Class: epworks.type.ochans
        test     %same as parent
    end
    
    properties
        self_id 
    end
    
    properties (Constant,Hidden)
       %Please keep sorted ...
       %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
       REQUESTED_VALUES_AND_FUNCTIONS = {
            'CreateTime'           'create_time'        
            'GroupObjId'           'group'           
            'Id'                   'self_id'            
            'IsRoot'               'is_root'            
            'Name'                 'name'               
            'OChanId'              'ochan'           
            'Parent'               'parent'                  
            'STLiveNumAccepted'    'stlive_num_accepted'
            'STLiveTimestamp'      'stlive_timestamp'   
            'TestObjId'            'test' 
           }
       SELF_ID   = 'self_id'
       OTHER_IDS = {'group' 'ochan' 'parent' 'test'} %NONE
    end
    
%     properties (Constant,Hidden)
%        TAGS_TO_GET = epworks.type.ep_trace.REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
%        NEW_NAMES   = epworks.type.ep_trace.REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
%     end
%     
    methods
        function obj = ep_trace(varargin)
            obj@epworks.type(varargin{:});
%             for iProp = 1:length(prop_names)
%                 obj.(prop_names{iProp}) = values{iProp};
%             end
        end
    end
    
end

