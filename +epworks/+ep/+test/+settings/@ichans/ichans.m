classdef ichans < epworks.id_object
    %
    %   Class:
    %   epworks.ep.test.settings.ichans
    
    properties
        d0 = '----   Data Properties  ----' 
        ActiveElectrode
        AudioVolume
        EventThreshold
        HardwareLFF
        ID
        IsSquelch
        LogicalChan
        MontageChanId
        OldLogChan
        Range
        RefElectrode
        Resolution
        SamplingFreq
        SquelchThreshold
        ThresholdDelay
        d1 = '----  Pointers to Other Objects  ----'
        active_electrode
        montage_chan
        ref_electrode
    end
    
    properties (Constant,Hidden)
       ID_PROP_INFO_1 = {
           'ActiveElectrode'   'active_electrode'
           'MontageChanId'     'montage_chan'
           'RefElectrode'      'ref_electrode'
           }
    end
    
    
    methods
    end
    
end

%{

'EPTest.Data.Settings.IChans.000'
'EPTest.Data.Settings.IChans.000.ActiveElectrode'
'EPTest.Data.Settings.IChans.000.AudioVolume'
'EPTest.Data.Settings.IChans.000.EventThreshold'
'EPTest.Data.Settings.IChans.000.HardwareLFF'
'EPTest.Data.Settings.IChans.000.ID'
'EPTest.Data.Settings.IChans.000.IsSquelch'
'EPTest.Data.Settings.IChans.000.LogicalChan'
'EPTest.Data.Settings.IChans.000.MontageChanId'
'EPTest.Data.Settings.IChans.000.OldLogChan'
'EPTest.Data.Settings.IChans.000.Range'
'EPTest.Data.Settings.IChans.000.RefElectrode'
'EPTest.Data.Settings.IChans.000.Resolution'
'EPTest.Data.Settings.IChans.000.SamplingFreq'
'EPTest.Data.Settings.IChans.000.SquelchThreshold'
'EPTest.Data.Settings.IChans.000.ThresholdDelay'


%}