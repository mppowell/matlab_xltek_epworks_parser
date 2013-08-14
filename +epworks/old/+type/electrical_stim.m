classdef electrical_stim < epworks.type
    %
    %   Class:
    %       epworks.type.electrical_stim
    %
    %   TODO:
    %   Much more work is needed here to fully understand what this class
    %   is saying
    
    
    %Populated value
    %     second_pulse_intensity: 0
    %              const_voltage: 0
    %                      delay: 0
    %                device_type: 4.2950e+09  %0    0  224  255  255  255  239   65
    %             init_intensity: 0
    %                  intensity: []
    %       inter_pulse_duration: 2
    %                       mode: 2
    %                      nerve: 'L Cort. Stim'
    %           number_of_phases: 1
    %                  phys_name: 'E Stim 2a'
    %                phys_number: 6
    %                   polarity: 0
    %             pulse_duration: 0.2000
    %            pulse_intensity: 35
    %           pulses_per_train: 5
    %                      range: 200
    %                       rate: 350
    %         relay_switch_delay: 0
    %                 sw_stim_id: 14
    %                 train_rate: 1.1000
    %        trigger_to_stim_lat: 0
    %                    self_id: [4856490145835561001 4085616260451390136]
    %              matlab_parent: [1x1 epworks.main]
    
    properties
        mode  %enumeration: I believe this indicates how the stimulus
        %button works
        %--------------------------------
        %0 - Repetitive Pulses
        %1 - Single Pulse
        %2 - Repetitive Trains
        %3 - Single Train
        %
        %
        %NOTE: Repetitive Paired and Single Paired are not avaialable
        %in the current version of EPWorks
        nerve       %Ex. 'L Cort. Stim'
        %I think this is the label .... ??
        
        phys_name   %Ex. 'E Stim 2a'
        %This name is hardcoded and indicates the physical name of the
        %channel used on the stimulator
        
        phys_number %I believe this is a number, starting at 1, that
        %indicates the physical plug on the stimulator that we are
        %stimulating through ...
        
        d1 = '---- Stimulus Waveform Parameters ----'
        polarity   %enumeration - changed to +/- 1
        %0 - positive
        %1 - negative
        pulse_duration    %(Units: ms)
        pulse_intensity   %(Units: mA)
        number_of_phases  %1, only monophasic ever observed
        
        d2 = '---- Train Parameters ----'
        pulses_per_train  %This in conjunction with the rate specifies
        %the duration of the train
        pulse_rate              %(Units: Hz) The current maximum rate is 500 Hz
        train_rate        %(Hz)
        
        d3 = '---- Other Parameters ----'
        max_intensity  %(mA) I believe this just sets the maximum range of
        %the slider ...
        
        default_intensity_level %(mA) This value indicates where the stim
        %intensity adjustment slider starts when running the program.
        
        delay  %(Groups Tab) Use the Stim Delay 
        %column to set the stimulation delay for groups with Interleaved 
        %timelines. The Stim Delay sets the delay from one stimulation 
        %to another. The delay can range from 0 to 5000 ms (milliseconds).
    end
    
    properties (Dependent)
        time_between_train_starts
    end
    
    properties 
        inter_pulse_duration    %2  (Units???) I think this is only for
        %repetitive pulses ... 
    end
    
    %Original values for enumeration
    properties (Hidden)
       polarity_orig
       mode_orig
    end
    
    methods
        function set.polarity(obj,value)
            obj.polarity_orig = value; %#ok<MCSUP>
            POLARITY_OPTIONS = [1 -1];
            obj.polarity     = POLARITY_OPTIONS(value + 1);
        end
        function set.mode(obj,value)
            obj.mode_orig = value; %#ok<MCSUP>
            MODE_OPTIONS = {'Repetitive Pulses' 'Single Pulse' 'Repetitive Trains' 'Single Train'};
            obj.mode    = MODE_OPTIONS{value + 1};
        end
        function value = get.time_between_train_starts(obj)
            value = 1/obj.train_rate;
        end
    end
    %Not so interesting properties ...
    properties
        d4 = '----- What are these? ----- '
        second_pulse_intensity   %?
 
        const_voltage  %?
        device_type    %????
        
        relay_switch_delay
        sw_stim_id
        trigger_to_stim_lat
        
        intensity
        
    end
    
    properties
        self_id
    end
    
    properties (Constant,Hidden)
        %Please keep sorted ...
        %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
        REQUESTED_VALUES_AND_FUNCTIONS = {
            '2ndPulseIntensity'     'second_pulse_intensity'
            'ConstVoltage'          'const_voltage'
            'Delay'                 'delay'
            'DeviceType'            'device_type'
            'ID'                    'self_id'
            'InitIntensity'         'default_intensity_level'
            'Intensity'             'intensity'
            'InterPulseDuration'    'inter_pulse_duration'
            'Mode'                  'mode'
            'Nerve'                 'nerve'
            'NumberOfPhases'        'number_of_phases'
            'PhysName'              'phys_name'
            'PhysNum'               'phys_number'
            'Polarity'              'polarity'
            'PulseDuration'         'pulse_duration'
            'PulseIntensity'        'pulse_intensity'
            'PulsesPerTrain'        'pulses_per_train'
            'Range'                 'max_intensity'
            'Rate'                  'pulse_rate'
            'RelaySwitchDelay'      'relay_switch_delay'
            'SwStimId'              'sw_stim_id'
            'TrainRate'             'train_rate'
            'TriggerToStimLat'      'trigger_to_stim_lat'
            }
        SELF_ID   = 'self_id'
        OTHER_IDS = {} %NONE
    end
    
%     properties (Constant,Hidden)
%         TAGS_TO_GET = epworks.type.electrical_stim.REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
%         NEW_NAMES   = epworks.type.electrical_stim.REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
%     end
    
    methods
        function obj = electrical_stim(parent_obj,prop_names,values)
            obj@epworks.type(parent_obj,prop_names,values);
%             for iProp = 1:length(prop_names)
%                 obj.(prop_names{iProp}) = values{iProp};
%             end
        end
    end
    
    methods
        function plot(obj)
            %TODO, include polarity
            %
            %intensity       - ?
            %init_intensity  - initial intensity is basica
            
            %pulse_intensity
            %pulse_duration      0.2 ms
            %pulses_per_train    5
            %rate                350 Hz
            %train_rate          1.1 Hz
            
            %Conversion to ms
            
            n_pulses = obj.pulses_per_train;
            
            x_start = 1000*((0:(n_pulses-1))./obj.rate);
            x_end   = x_start + obj.pulse_duration;
            
            x_temp  = [x_start; x_end];
            
            x_plot  = [x_temp(:)' x_end(end)+2];
            
            y_start = obj.pulse_intensity*ones(1,n_pulses);
            y_end   = zeros(1,n_pulses);
            
            y_temp  = [y_start; y_end];
            
            y_plot  = [y_temp(:)' 0];
            
            stairs(x_plot,y_plot)
            
            keyboard
            
            %stairs
            
            %total_time
            %start_time = 0;
            
            
        end
    end
    
end

