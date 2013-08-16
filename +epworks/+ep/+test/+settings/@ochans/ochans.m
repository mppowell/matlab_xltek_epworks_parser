classdef ochans < epworks.id_object
    %
    %   Class:
    %   epworks.ep.test.settings.ochans
    %
    %   ?? what is an ochan vs a ichan???
    
    properties (Hidden)
       From
       GroupDef
       To
    end
    
    properties
        FilteringStyle
        HffCutoff
        ID
        IsChannelEnabled
        IsChannelTrigger
        IsRejectionOnStimSaturation
        LeftDisplayGain
        LffCutoff
        MaacsTraceId
        MaxUserVariation
        Name
        NotchCutoff
        ResponseChime
        RightDisplayGain
        Timebase
        
        d1 = '----  Pointers to Other Objects  ----'
        from
        group
        to
        d2 = '----  Reverse Pointers  ----'
        %See ID_assignments.csv
        traces
        rec_file
        cursor_defs
        d3 = '----  Display Properties  -----'
        Color
    end
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {
            'From'       'from'
            'GroupDef'   'group'
            'To'         'to'
            }
    end
    methods
    end
    
end

%{

'EPTest.Data.Settings.OChans'
'EPTest.Data.Settings.OChans.000'
'EPTest.Data.Settings.OChans.000.Color'
'EPTest.Data.Settings.OChans.000.FilteringStyle'
'EPTest.Data.Settings.OChans.000.From'
'EPTest.Data.Settings.OChans.000.GroupDef'
'EPTest.Data.Settings.OChans.000.HffCutoff'
'EPTest.Data.Settings.OChans.000.ID'
'EPTest.Data.Settings.OChans.000.IsChannelEnabled'
'EPTest.Data.Settings.OChans.000.IsChannelTrigger'
'EPTest.Data.Settings.OChans.000.IsRejectionOnStimSaturation'
'EPTest.Data.Settings.OChans.000.LeftDisplayGain'
'EPTest.Data.Settings.OChans.000.LffCutoff'
'EPTest.Data.Settings.OChans.000.MaacsTraceId'
'EPTest.Data.Settings.OChans.000.MaxUserVariation'
'EPTest.Data.Settings.OChans.000.Name'
'EPTest.Data.Settings.OChans.000.NotchCutoff'
'EPTest.Data.Settings.OChans.000.ResponseChime'
'EPTest.Data.Settings.OChans.000.RightDisplayGain'
'EPTest.Data.Settings.OChans.000.Timebase'
'EPTest.Data.Settings.OChans.000.To'


%}