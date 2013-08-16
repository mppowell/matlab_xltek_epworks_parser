classdef ichans < epworks.id_object
    %
    %   Class:
    %   epworks.ep.test.settings.ichans
    %
    %   This seems to be the specification for a recording channel.
    %   The channel consists of a active and reference electrodes.
    %   
    
    properties (Hidden)
       ActiveElectrode
       ID
       MontageChanId
       RefElectrode
    end
    
    properties
        d0 = '----   Data Properties  ----' 
        
        AudioVolume
        EventThreshold
        HardwareLFF
        
        IsSquelch
        LogicalChan
        
        OldLogChan
        Range %(Units: uV), adjust the sensitivity of the amplifier
        
        Resolution
        SamplingFreq
        SquelchThreshold
        ThresholdDelay %The delay before the processor begins to use
        %the reject threshold to reject data
        d1 = '----  Pointers to Other Objects  ----'
        active_electrode %epworks.ep.test.settings.electrodes
        montage_chan
        ref_electrode    %epworks.ep.test.settings.electrodes
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