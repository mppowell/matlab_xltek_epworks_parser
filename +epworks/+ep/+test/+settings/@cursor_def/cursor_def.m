classdef cursor_def < epworks.id_object
    %
    %   Class:
    %   epworks.ep.test.settings.cursor_def
    
    properties
        DisplayName
        GroupDef = uint64([0 0])
        ID
        IsMarker
        LatencyFrom
        LatencyTo
        Name
        Placement
        Style
        TraceID = uint64([0 0])
        UseType
        VisiblePlacementOnly
        d1 = '----  Pointers to Other Objects  ----'
        group
        trace
    end
    
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {
            'GroupDef'   'group'
            'TraceID'    'trace'
            }
    end
    
    methods
    end
    
end

%{
'EPTest.Data.Settings.CursorDef'
'EPTest.Data.Settings.CursorDef.000'
'EPTest.Data.Settings.CursorDef.000.DisplayName'
'EPTest.Data.Settings.CursorDef.000.GroupDef'
'EPTest.Data.Settings.CursorDef.000.ID'
'EPTest.Data.Settings.CursorDef.000.IsMarker'
'EPTest.Data.Settings.CursorDef.000.LatencyFrom'
'EPTest.Data.Settings.CursorDef.000.LatencyTo'
'EPTest.Data.Settings.CursorDef.000.Name'
'EPTest.Data.Settings.CursorDef.000.Placement'
'EPTest.Data.Settings.CursorDef.000.Style'
'EPTest.Data.Settings.CursorDef.000.TraceID'
'EPTest.Data.Settings.CursorDef.000.UseType'
'EPTest.Data.Settings.CursorDef.000.VisiblePlacementOnly'

%}