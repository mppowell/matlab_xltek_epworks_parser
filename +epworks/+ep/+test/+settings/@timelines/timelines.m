classdef timelines < epworks.id_object
    %
    %   Class:
    %   epworks.ep.test.settings.timelines
    
    
    properties
        ID = uint64([0 0])
        IsEnabled
        IsPaused
        IsRunning
        IsWaiting
        RestartDelay
        %- Never
        %- Continuous
        %- On Interval
        StartWaiting
        Type %Enumerated Value?
        %0 - Interleaved
        %1 - Consecutive
    end
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {}
    end
    methods
    end
    
end

%{
'EPTest.Data.Settings.Timelines'
'EPTest.Data.Settings.Timelines.000'
'EPTest.Data.Settings.Timelines.000.ID'
'EPTest.Data.Settings.Timelines.000.IsEnabled'
'EPTest.Data.Settings.Timelines.000.IsPaused'
'EPTest.Data.Settings.Timelines.000.IsRunning'
'EPTest.Data.Settings.Timelines.000.IsWaiting'
'EPTest.Data.Settings.Timelines.000.RestartDelay'
'EPTest.Data.Settings.Timelines.000.StartWaiting'
'EPTest.Data.Settings.Timelines.000.Type'

%}