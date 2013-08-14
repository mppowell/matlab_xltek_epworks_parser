classdef tcemep < epworks.type
    %
    %   Class:
    %       epworks.type.tcemep
    
%Unpopulated Value
%        constant_voltage: []
%                   delay: 0
%                 self_ID: [5683811021761096095 17751090587952323001]
%                    mode: []
%               phys_name: 'Left Auditory'
%                phys_num: 1
%                polarity: []
%             priming_gap: []
%          priming_pulses: []
%          pulse_duration: 30
%         pulse_intensity: 0
%        pulses_per_train: []
%                   range: []
%                    rate: 11.1000
%              relay_port: []
%              sw_stim_id: 0
%     trigger_to_stim_lat: 0
%           matlab_parent: [1x1 epworks.main]
          
%Populated Values
%        constant_voltage: 1
%                   delay: 0
%                 self_ID: [5558282444330477523 12589209842534135204]
%                    mode: 3
%               phys_name: 'TceMEP'
%                phys_num: 7
%                polarity: 0
%             priming_gap: 0
%          priming_pulses: 0
%          pulse_duration: 0.0500
%         pulse_intensity: 0
%        pulses_per_train: 9
%                   range: 1000
%                    rate: 100
%              relay_port: 2
%              sw_stim_id: 24
%     trigger_to_stim_lat: 0
%           matlab_parent: [1x1 epworks.main]

    properties
        constant_voltage
        delay
        self_id
        mode
        phys_name
        phys_num
        polarity
        priming_gap
        priming_pulses
        pulse_duration
        pulse_intensity
        pulses_per_train
        range
        rate
        relay_port
        sw_stim_id
        trigger_to_stim_lat
    end
    
    properties
    end
    
    properties (Constant,Hidden)
        %Please keep sorted ...
        %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
        REQUESTED_VALUES_AND_FUNCTIONS = {
            'ConstVoltage'        'constant_voltage'
            'Delay'               'delay'
            'ID'                  'self_id'
            'Mode'                'mode'
            'PhysName'            'phys_name'
            'PhysNum'             'phys_num'
            'Polarity'            'polarity'
            'PrimingGap'          'priming_gap'
            'PrimingPulses'       'priming_pulses'
            'PulseDuration'       'pulse_duration'
            'PulseIntensity'      'pulse_intensity'
            'PulsesPerTrain'      'pulses_per_train'
            'Range'               'range'
            'Rate'                'rate'
            'RelayPort'           'relay_port'
            'SwStimId'            'sw_stim_id'
            'TriggerToStimLat'    'trigger_to_stim_lat'
            }
       SELF_ID   = 'self_id'
       OTHER_IDS = {} %NONE
    end
    
%     properties (Constant,Hidden)
%         TAGS_TO_GET = epworks.type.tcemep.REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
%         NEW_NAMES   = epworks.type.tcemep.REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
%     end
    
    methods
        function obj = tcemep(parent_obj,prop_names,values)
            obj@epworks.type(parent_obj,prop_names,values);
%             for iProp = 1:length(prop_names)
%                 obj.(prop_names{iProp}) = values{iProp};
%             end
        end
    end
    
end

