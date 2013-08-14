classdef ep_freerun_waveform < epworks.type
    %
    %
    %   Class:
    %       epworks.type.ep_freerun_waveform
    %
    %   Not yet used. I don't know what the data for this object looks like
    %   or how it is stored. I can't find it in the data file.
        
    properties
        is_root
        is_alarmed_wave
        saved_stim_intensity
        trigger_delay
        timestamp
        timebase
        seq_number
    end
    
    properties
        self_id
        parent
        trace
        set
    end
    
% 'Id'
% 'IsRoot'
% 'Parent'
% 'Schema'
% 'Type'
% 'Data.AudioVolume'
% 'Data.Color'
% 'Data.HffCutoff'
% 'Data.IsAlarmedWave'
% 'Data.LeftDisplayGain'
% 'Data.LffCutoff'
% 'Data.NotchCutoff'
% 'Data.OriginalDecim'
% 'Data.OriginalSampFreq'
% 'Data.Range'
% 'Data.Resolution'
% 'Data.RightDisplayGain'
% 'Data.SampFreq'

%Finished ...
% 'Data.SavedStimIntensity'
% 'Data.SequenceNumber'
% 'Data.SetObjId'
% 'Data.Timebase'
% 'Data.Timestamp'
% 'Data.TraceObjId'
% 'Data.TriggerDelay'
% 'Data.Visible'

    
    
    
    
    
    properties (Constant,Hidden)
       %Please keep sorted ...
       %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
       REQUESTED_VALUES_AND_FUNCTIONS = {
            'Id'                    'self_id'             
            'IsAlarmedWave'         'is_alarmed_wave'     
            'IsRoot'                'is_root'             
            'Parent'                'parent'              
            'SavedStimIntensity'    'saved_stim_intensity'
            'SequenceNumber'        'seq_number'          
            'SetObjId'              'set'                 
            'Timebase'              'timebase'            
            'Timestamp'             'timestamp'           
            'TraceObjId'            'trace'               
            'TriggerDelay'          'trigger_delay'  
           }
       SELF_ID   = 'self_id'
       OTHER_IDS = {'parent' 'trace' 'set'} %NONE
    end
    
%     properties (Constant,Hidden)
%        TAGS_TO_GET = epworks.type.ep_freerun_waveform.REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
%        NEW_NAMES   = epworks.type.ep_freerun_waveform.REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
%     end
    
    methods
        function obj = ep_freerun_waveform(parent_obj,prop_names,values)
            obj@epworks.type(parent_obj,prop_names,values);
%             for iProp = 1:length(prop_names)
%                 obj.(prop_names{iProp}) = values{iProp};
%             end
        end
    end
    
end

