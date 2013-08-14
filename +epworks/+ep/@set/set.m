classdef set < epworks.ep
    %
    %   Class:
    %   epworks.ep.set
    
    properties
       d0 = '----   Data Properties  ----' 
       GroupObjId = uint64([0 0])
       IOMLocalObject   %Logical ?????
       %These next 3 seem only relevant when not local.
       IsActive
       NumAccepted
       NumRejected
       SetNumber
       d1 = '----  Pointers to Other Objects  ----'
       group
       parent
       d2 = '----  Reverse Pointers  ----'
       raw_sweep_p %TODO: If I differentiate than I might not need these
       %in the main set object
       baseline_p
       freerun_waveform
       triggered_waveforms
    end
    
    properties (Constant,Hidden)
       ID_PROP_INFO_1 = {
           'GroupObjId'  'group'
           'Parent'      'parent'
           }
    end
    
    
    methods
    end
    
end

%{

'EPSet'
'EPSet.Children'
'EPSet.Data'
'EPSet.Data.GroupObjId'
'EPSet.Data.IOMLocalObject'
'EPSet.Data.IsActive'
'EPSet.Data.NumAccepted'
'EPSet.Data.NumRejected'
'EPSet.Data.SetNumber'
'EPSet.Id'
'EPSet.IsRoot'
'EPSet.Parent'
'EPSet.Schema'
'EPSet.Type'


%}

