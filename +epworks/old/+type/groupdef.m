classdef groupdef < epworks.type
    %
    %   Class:
    %   epworks.type.groupdef
    
    %   Doesn't seem all too useful, although ochans point
    %   to these as well
    %
    %   GroupDef:
    properties
        name
        
        d = '---- Other Properties ----'
        
        capture_chime
        capture_enable
        capture_threshold
        collect_max_data
        desired_update_interval
        discrete_readings
        EMG_cable_mode
        forced_decimation
        fwave_filter
        
        is_eeg_group
        limited_hb_decimation
        location
        
        num_divisions_to_collect %Traces tab specifies the time per division
        %and presumably together they determine the # of samples. Then
        %again, this might just be a display thing.
        
        pre_trigger_dc_offset
        
        pre_trigger__trigger_delay
        trigger_delay   %Why both values ...????
        
        rolling_window
        show_live_triggered
        signal_type
        special_type
        start_on_test_activation
        sweeps_per_avg
    end
    
    properties
       d1 = '----- Object Pointers -----'
       timeline_id
       maacs_group_id
       trigger_source
       self_id
    end
    
    properties (Constant,Hidden)
        %Please keep sorted ...
        %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
        
        REQUESTED_VALUES_AND_FUNCTIONS = {
            'CaptureChime'             'capture_chime'
            'CaptureEnable'            'capture_enable'
            'CaptureThreshold'         'capture_threshold'
            'CollectMaxData'           'collect_max_data'
            'DesiredUpdateInterval'    'desired_update_interval'
            'DiscreteReadings'         'discrete_readings'
            'EMGCableMode'             'EMG_cable_mode'
            'FWaveFilter'              'fwave_filter'
            'ForcedDecimation'         'forced_decimation'
            'ID'                       'self_id'
            'IsEegGroup'               'is_eeg_group'
            'LimitedHBDecimation'      'limited_hb_decimation'
            'Location'                 'location'
            'MaacsGroupId'             'maacs_group_id'
            'Name'                     'name'
            'NumDivisionsToCollect'    'num_divisions_to_collect'
            'PreTriggerDCOffset'       'pre_trigger_dc_offset'
            'PreTriggerTriggerDelay'   'pre_trigger__trigger_delay'
            'RollingWindow'            'rolling_window'
            'ShowLiveTriggered'        'show_live_triggered'
            'SignalType'               'signal_type'
            'SpecialType'              'special_type'
            'StartOnTestActivation'    'start_on_test_activation'
            'SweepsPerAvg'             'sweeps_per_avg'
            'TimelineID'               'timeline_id'
            'TriggerDelay'             'trigger_delay'
            'TriggerSource'            'trigger_source'
            }
        SELF_ID   = 'self_id'
        OTHER_IDS = {'timeline_id' 'maacs_group_id' 'trigger_source'} %NONE
    end
    
    methods
        function obj = groupdef(parent_obj,prop_names,values)
            obj@epworks.type(parent_obj,prop_names,values);
        end
    end
    
end

