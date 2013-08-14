classdef triggered_waveform < epworks.ep
    %
    %   Class:
    %   epworks.ep.triggered_waveform
    
    properties
       d0 = '----  Data Properties  ----' 
       AppliedHWFilterHFF
       AppliedHWFilterLFF
       AudioVolume
       Baseline %logical?
       Clone = uint64([0 0]);
       Color
       HffCutoff
       IOMLocalObject %logical?
       IsAlarmedWave
       IsCaptured
       IsRejectedData
       LeftDisplayGain
       LffCutoff
       MeClone %logical?
       NotchCutoff
       OriginalDecim
       OriginalSampFreq
       Range
       RawSweepNum
       Resolution
       RightDisplayGain
       SampFreq
       SavedStimIntensity
       SequenceNumber
       SetObjId
       SmoothSel
       SourceData
       Timebase
       Timestamp
       TraceObjId
       TriggerDelay
       UISettings
       Visible
       WasBaseline
       d1 = '----  Pointers to Other Objects  ----'
       clone
       set
       trace
       parent
    end
    
    properties (Dependent)
       data 
    end
    
    methods
        function value = get.data(obj)
           value = obj.SourceData.data;
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
