classdef triggered_waveform < epworks.ep
    %
    %   Class:
    %   epworks.ep.triggered_waveform
    
    properties (Hidden)
       Clone = uint64([0 0]); 
       SetObjId
       TraceObjId
    end
    
    properties
       d0 = '----  Data Properties  ----' 
       
       df1 = '----  Filtering Properties  -----'
       AppliedHWFilterHFF
       AppliedHWFilterLFF
       HffCutoff
       LffCutoff
       NotchCutoff
       
       
       
       Baseline  %logical? Not sure if this indicates using one of if
       %it would indicate being one
       
       
       
       IOMLocalObject   %logical?
       IsAlarmedWave    %Indicates stimulator saturation?
       IsCaptured       %not always set
       IsRejectedData   %not always set, each channel gets to
       %have a rejection threshold specified
       
       
       MeClone %logical?
       
       OriginalDecim
       OriginalSampFreq
       Range        %(Units: uV)
       RawSweepNum  %Not always present
       Resolution   %normally 16 -> bits?
       
       SampFreq
       SavedStimIntensity %(Units: uA or V?), how to tell
       SequenceNumber %Only observed 1
       
       SmoothSel    %Not always present
       SourceData   %This is a structure, populated in:
       %epworks.iom_parser.translateData
       %
       Timebase     %(Units: ms/div)
       Timestamp    %(Units: Matlab Time)
       TriggerDelay %(Units: ms)
       
       Visible      %Not always present 
       WasBaseline  %Not always present
       d1 = '----  Pointers to Other Objects  ----'
       clone
       set
       trace
       parent
       rec_file_waveform %This is populated by
       d2 = '----   Reverse Pointers  ----'
       cursors
       
       d3 = '----  Display Properties  -----'
       AudioVolume
       Color
       LeftDisplayGain
       RightDisplayGain
       UISettings   %Not always present
       
       d4 = '----  Dependent Values  ----'
    end
    
    properties (Dependent)  
       data 
    end
    
    methods
        function value = get.data(obj)
            sd = obj.SourceData;
            if ~isempty(sd)
                value = obj.SourceData.data;
            else
                value = [];
            end
        end
    end
    
    properties (Constant,Hidden)
       ID_PROP_INFO_1 = {
           'Clone'      'clone'
           'SetObjId'   'set'
           'TraceObjId' 'trace'
           'Parent'     'parent'
           }
    end
    
    %SourceData struct
    %----------------------------------------------------------------
    %            unknown_16: {}
    %           unknown_u16: 32767
    %          unknown_null: [0 0 0]
    %           unknown_u64: 1080864192281516928
    %         unknown_null2: 0
    %             timestamp: 7.3513e+05
    %                  data: [1x600 single]
    %     unknown_end_bytes: [0 0]
    
    
    methods
        
    end
    
end

%{

'EPTriggeredWaveform'
'EPTriggeredWaveform.Children'
'EPTriggeredWaveform.Data'
'EPTriggeredWaveform.Data.AppliedHWFilterHFF'
'EPTriggeredWaveform.Data.AppliedHWFilterLFF'
'EPTriggeredWaveform.Data.AudioVolume'
'EPTriggeredWaveform.Data.Baseline'
'EPTriggeredWaveform.Data.Clone'
'EPTriggeredWaveform.Data.Color'
'EPTriggeredWaveform.Data.HffCutoff'
'EPTriggeredWaveform.Data.IOMLocalObject'
'EPTriggeredWaveform.Data.IsAlarmedWave'
'EPTriggeredWaveform.Data.IsCaptured'
'EPTriggeredWaveform.Data.IsRejectedData'
'EPTriggeredWaveform.Data.LeftDisplayGain'
'EPTriggeredWaveform.Data.LffCutoff'
'EPTriggeredWaveform.Data.MeClone'
'EPTriggeredWaveform.Data.NotchCutoff'
'EPTriggeredWaveform.Data.OriginalDecim'
'EPTriggeredWaveform.Data.OriginalSampFreq'
'EPTriggeredWaveform.Data.Range'
'EPTriggeredWaveform.Data.RawSweepNum'
'EPTriggeredWaveform.Data.Resolution'
'EPTriggeredWaveform.Data.RightDisplayGain'
'EPTriggeredWaveform.Data.SampFreq'
'EPTriggeredWaveform.Data.SavedStimIntensity'
'EPTriggeredWaveform.Data.SequenceNumber'
'EPTriggeredWaveform.Data.SetObjId'
'EPTriggeredWaveform.Data.SmoothSel'
'EPTriggeredWaveform.Data.SourceData'
'EPTriggeredWaveform.Data.Timebase'
'EPTriggeredWaveform.Data.Timestamp'
'EPTriggeredWaveform.Data.TraceObjId'
'EPTriggeredWaveform.Data.TriggerDelay'
'EPTriggeredWaveform.Data.UISettings'
'EPTriggeredWaveform.Data.Visible'
'EPTriggeredWaveform.Data.WasBaseline'
'EPTriggeredWaveform.Id'
'EPTriggeredWaveform.IsRoot'
'EPTriggeredWaveform.Parent'
'EPTriggeredWaveform.Schema'
'EPTriggeredWaveform.Type'



%}
