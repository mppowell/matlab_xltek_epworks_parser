classdef cursor < epworks.ep
    %
    %   Class:
    %   epworks.ep.cursor
    
    properties
       d0 = '----   Data Properties  ----' 
       Amp
       Clone = uint64([0 0])
       CursorDefId
       HasDragged
       Label     %ex. P12
       Lat
       OriginX
       OriginY
       Placement %?Enumeration?
       Style     %?Enumeration?
       d1 = '----  Pointers to Other Objects  ----'
       clone
       cursor_def
       parent
    end
    
    properties (Constant,Hidden)
       ID_PROP_INFO_1 = {
           'Clone'       'clone'
           'CursorDefId' 'cursor_def'
           'Parent'      'parent'
           }
    end
    
    methods

    end
    
end

%{

'EPCursor'
'EPCursor.Children'
'EPCursor.Data'
'EPCursor.Data.Amp'
'EPCursor.Data.Clone'
'EPCursor.Data.CursorDefId'
'EPCursor.Data.HasDragged'
'EPCursor.Data.Label'
'EPCursor.Data.Lat'
'EPCursor.Data.OriginX'
'EPCursor.Data.OriginY'
'EPCursor.Data.Placement'
'EPCursor.Data.Style'
'EPCursor.Id'
'EPCursor.IsRoot'
'EPCursor.Parent'
'EPCursor.Schema'
'EPCursor.Type'



%}