classdef cursor_calc < epworks.id_object
    %
    %   Class:
    %   epworks.ep.test.settings.cursor_calc
    
    properties
       AlarmInPrcnt
       AlarmLevel
       AreaType
       DisplayType
       FromDef = uint64([0 0])
       ID = uint64([0 0])
       IsMarker
       Name
       NegAlarmLevel
       ToDef = uint64([0 0])
       ValueType
       d1 = '----  Pointers to Other Objects  ----'
       from_def
       to_def
    end
    
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {
            'FromDef'   'from_def'
            'ToDef'     'to_def'
            }
    end
    
    methods
    end
    
end

%{
'EPTest.Data.Settings.CursorCalc.000.AlarmInPrcnt'
'EPTest.Data.Settings.CursorCalc.000.AlarmLevel'
'EPTest.Data.Settings.CursorCalc.000.AreaType'
'EPTest.Data.Settings.CursorCalc.000.DisplayType'
'EPTest.Data.Settings.CursorCalc.000.FromDef'
'EPTest.Data.Settings.CursorCalc.000.ID'
'EPTest.Data.Settings.CursorCalc.000.IsMarker'
'EPTest.Data.Settings.CursorCalc.000.Name'
'EPTest.Data.Settings.CursorCalc.000.NegAlarmLevel'
'EPTest.Data.Settings.CursorCalc.000.ToDef'
'EPTest.Data.Settings.CursorCalc.000.ValueType'
%}