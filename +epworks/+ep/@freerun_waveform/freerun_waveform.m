classdef freerun_waveform < epworks.ep
    %
    %   Class:
    %   epworks.ep.freerun_waveform
    %
    %   In main as:
    %   freerun_waveforms
    
    properties
        d0 = '----   Data Properties  ----'
        AudioVolume
        Color
        HffCutoff
        IsAlarmedWave
        LeftDisplayGain
        LffCutoff
        NotchCutoff %-1, no notch
        OriginalDecim
        OriginalSampFreq
        Range
        Resolution
        RightDisplayGain
        SampFreq
        SavedStimIntensity
        SequenceNumber
        SetObjId
        Timebase
        Timestamp
        TraceObjId
        TriggerDelay
        %UISettings - not imported ...
        Visible
        d1 = '----  Pointers to Other Objects  ----'
        set
        trace
        parent
    end
    
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {
            'SetObjId'      'set'
            'TraceObjId'    'trace'
            'Parent'        'parent'
            }
    end
    
    methods
    end
    
end

%{
'EPFreerunWaveform'
'EPFreerunWaveform.Children'
'EPFreerunWaveform.Data'
'EPFreerunWaveform.Data.AudioVolume'
'EPFreerunWaveform.Data.Color'
'EPFreerunWaveform.Data.HffCutoff'
'EPFreerunWaveform.Data.IsAlarmedWave'
'EPFreerunWaveform.Data.LeftDisplayGain'
'EPFreerunWaveform.Data.LffCutoff'
'EPFreerunWaveform.Data.NotchCutoff'
'EPFreerunWaveform.Data.OriginalDecim'
'EPFreerunWaveform.Data.OriginalSampFreq'
'EPFreerunWaveform.Data.Range'
'EPFreerunWaveform.Data.Resolution'
'EPFreerunWaveform.Data.RightDisplayGain'
'EPFreerunWaveform.Data.SampFreq'
'EPFreerunWaveform.Data.SavedStimIntensity'
'EPFreerunWaveform.Data.SequenceNumber'
'EPFreerunWaveform.Data.SetObjId'
'EPFreerunWaveform.Data.Timebase'
'EPFreerunWaveform.Data.Timestamp'
'EPFreerunWaveform.Data.TraceObjId'
'EPFreerunWaveform.Data.TriggerDelay'
'EPFreerunWaveform.Data.UISettings'
'EPFreerunWaveform.Data.Visible'
'EPFreerunWaveform.Id'
'EPFreerunWaveform.IsRoot'
'EPFreerunWaveform.Parent'
'EPFreerunWaveform.Schema'
'EPFreerunWaveform.Type'
%}