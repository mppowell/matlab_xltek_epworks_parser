classdef ichans < epworks.type
    %
    %   Class:
    %       epworks.type.ichans
    
    %What is an ichan? Input channel?
    %This class points to electrodes
    
    properties
        %audio_volume
        event_threshold
        hw_fc_low
        
        %is_squelch
        logical_chan
        montage_chan_id
        old_log_chan
        range
        
        resolution
        fs
        %squelch_threshold
        threshold_delay
    end
    
    properties
       d = '-----  Object Pointers -----' 
       active_electrode
       ref_electrode
    end
    
    properties (Hidden)
        self_id
    end
    
    
    properties (Constant,Hidden)
        %Please keep sorted ...
        %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
        REQUESTED_VALUES_AND_FUNCTIONS = {
            'ActiveElectrode'      'active_electrode'
            %'AudioVolume'          'audio_volume'
            'EventThreshold'       'event_threshold'
            'HardwareLFF'          'hw_fc_low'
            'ID'                   'self_id'
            %'IsSquelch'            'is_squelch'
            'LogicalChan'          'logical_chan'
            'MontageChanId'        'montage_chan_id'
            'OldLogChan'           'old_log_chan'
            'Range'                'range'
            'RefElectrode'         'ref_electrode'
            'Resolution'           'resolution'
            'SamplingFrequency'    'fs'
            %'SquelchThreshold'     'squelch_threshold'
            'ThresholdDelay'       'threshold_delay'
            }
        SELF_ID   = 'self_id'
        OTHER_IDS = {'active_electrode' 'ref_electrode'} %NONE
    end
%     
%     properties (Constant,Hidden)
%         TAGS_TO_GET = epworks.type.ichans.REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
%         NEW_NAMES   = epworks.type.ichans.REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
%     end
%     
    methods
        function obj = ichans(parent_obj,prop_names,values)
            obj@epworks.type(parent_obj,prop_names,values);
%             for iProp = 1:length(prop_names)
%                 obj.(prop_names{iProp}) = values{iProp};
%             end
        end
    end
    
end

