classdef group_def < epworks.id_object
    %
    %   Class:
    %   epworks.ep.test.settings.group_def
    
    properties
        CaptureChime
        CaptureEnable
        CaptureThreshold
        CollectMaxData
        DesiredUpdateInterval
        DiscreteReadings
        DisplayMode
        EMGCableMode
        FWaveFilter
        ForcedDecimation
        ID
        IsEegGroup
        LimitedHBDecimation
        Location
        MaacsGroupId
        Name
        NumDivisionsToCollect
        PreTriggerDCOffset
        PreTriggerTriggerDelay
        RollingWindow
        ShowLiveTriggered
        SignalType
        SpecialType
        StartOnTestActivation
        SweepsPerAvg
        TimelineID
        TriggerDelay
        TriggerSource
        d1 = '----  Pointers to Other Objects  ----'
        maacs_group
        timeline
        trigger_source
    end
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {
            'MaacsGroupId'      'maacs_group'
            'TimelineID'        'timeline'
            'TriggerSource'     'trigger_source'
            }
    end
    
    methods
    end
    
end

%{
'EPTest.Data.Settings.GroupDef'
'EPTest.Data.Settings.GroupDef.000'
'EPTest.Data.Settings.GroupDef.000.CaptureChime'
'EPTest.Data.Settings.GroupDef.000.CaptureEnable'
'EPTest.Data.Settings.GroupDef.000.CaptureThreshold'
'EPTest.Data.Settings.GroupDef.000.CollectMaxData'
'EPTest.Data.Settings.GroupDef.000.DesiredUpdateInterval'
'EPTest.Data.Settings.GroupDef.000.DiscreteReadings'
'EPTest.Data.Settings.GroupDef.000.DisplayMode'
'EPTest.Data.Settings.GroupDef.000.EMGCableMode'
'EPTest.Data.Settings.GroupDef.000.FWaveFilter'
'EPTest.Data.Settings.GroupDef.000.ForcedDecimation'
'EPTest.Data.Settings.GroupDef.000.ID'
'EPTest.Data.Settings.GroupDef.000.IsEegGroup'
'EPTest.Data.Settings.GroupDef.000.LimitedHBDecimation'
'EPTest.Data.Settings.GroupDef.000.Location'
'EPTest.Data.Settings.GroupDef.000.MaacsGroupId'
'EPTest.Data.Settings.GroupDef.000.Name'
'EPTest.Data.Settings.GroupDef.000.NumDivisionsToCollect'
'EPTest.Data.Settings.GroupDef.000.PreTriggerDCOffset'
'EPTest.Data.Settings.GroupDef.000.PreTriggerTriggerDelay'
'EPTest.Data.Settings.GroupDef.000.RollingWindow'
'EPTest.Data.Settings.GroupDef.000.ShowLiveTriggered'
'EPTest.Data.Settings.GroupDef.000.SignalType'
'EPTest.Data.Settings.GroupDef.000.SpecialType'
'EPTest.Data.Settings.GroupDef.000.StartOnTestActivation'
'EPTest.Data.Settings.GroupDef.000.SweepsPerAvg'
'EPTest.Data.Settings.GroupDef.000.TimelineID'
'EPTest.Data.Settings.GroupDef.000.TriggerDelay'
'EPTest.Data.Settings.GroupDef.000.TriggerSource'
%}