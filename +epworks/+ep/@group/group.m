classdef group < epworks.ep
    %
    %   Class:
    %   epworks.ep.group
    
    properties
        d0 = '----   Data Properties  ----' 
        BaselineSetId = uint64([0 0])
        CaptureEnable
        CaptureThreshold
        DisplayMode
        GroupId
        Name
        RawSweepSetId = uint64([0 0])
        RollingWindow
        SignalType
        State
        SweepsPerAvg
        TestObjId
        TriggerDelay
        TriggerSource
        d1 = '----  Pointers to Other Objects  ----'
        baseline_set
        group2 %what does this point to?
        raw_sweep_set
        test
        trigger_source
        parent
    end
    
    properties (Constant,Hidden)
       ID_PROP_INFO_1 = {
           'BaselineSetId'      'baseline_set'
           'GroupId'            'group2'
           'RawSweepSetId'      'raw_sweep_set'
           'TestObjId'          'test'
           'TriggerSource'      'trigger_source'
           'Parent'             'parent'
           }
    end
    
    methods
    end
    
end

%{
'EPGroup'
'EPGroup.Children'
'EPGroup.Data'
'EPGroup.Data.BaselineSetId'
'EPGroup.Data.CaptureEnable'
'EPGroup.Data.CaptureThreshold'
'EPGroup.Data.DisplayMode'
'EPGroup.Data.GroupId'
'EPGroup.Data.Name'
'EPGroup.Data.RawSweepSetId'
'EPGroup.Data.RollingWindow'
'EPGroup.Data.SignalType'
'EPGroup.Data.State'
'EPGroup.Data.SweepsPerAvg'
'EPGroup.Data.TestObjId'
'EPGroup.Data.TriggerDelay'
'EPGroup.Data.TriggerSource'
'EPGroup.Id'
'EPGroup.IsRoot'
'EPGroup.Parent'
'EPGroup.Schema'
'EPGroup.Type'
%}

