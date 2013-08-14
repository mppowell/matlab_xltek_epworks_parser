classdef set < epworks.ep
    %
    %   Class:
    %   epworks.ep.set
    %   Set Types:
    %   -------------------------------------------------------------------
    %   1) A baseline set
    %   2) Raw sweep id
    %   3) Normal (not 1 or 2)
    %
    %   Improvements
    %   -------------------------------------------------------------------
    %   1) We could create different set types objects as some of these
    %   properties only make sense for the normal set type object ...
    %
    %
    %   Normal Sets:
    %   
    %   Raw Sweep Sets:
    %          GroupObjId: [0 0]
%          IOMLocalObject: []
%                IsActive: []
%             NumAccepted: []
%             NumRejected: []
    
    properties
       d0 = '----   Data Properties  ----' 
       
       %These props are only relevant for normal sets
       %---------------------------------------------------
       GroupObjId = uint64([0 0])
       IOMLocalObject   %Logical ?????
       %These next 3 seem only relevant when not local.
       IsActive
       NumAccepted = 0
       NumRejected = 0
       %---------------------------------------------------
       
       SetNumber
       %-1 - for raw sweep ids
       %0  - for baseline sets
       %#  - for normal sets
       
       d1 = '----  Pointers to Other Objects  ----'
       group  %Only valid for normal pointers
       parent %Always valid, points to a group object
       d2 = '----  Reverse Pointers  ----'
       raw_sweep_p %TODO: If I differentiate than I might not need these
       %in the main set object
       baseline_p
       freerun_waveform
       triggered_waveforms
       d3 = '---- Computed Properties ----'
       %These are currently defined by links from the groups
       is_baseline_set = false
       is_raw_sweep_set = false
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

