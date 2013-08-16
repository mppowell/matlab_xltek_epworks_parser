classdef trace < epworks.ep
    %
    %   Class:
    %   ep.epworks.trace
    %
    %   Trace is the definition of a waveform (result).
    
    properties (Hidden)
       ActiveWaveformObjId
       GroupObjId
       OChanId
       TestObjId
    end
    
    properties
        Name
        GroupName
        d0 = '----  Data Properties  ----'
        
        CreateTime    %(Units: Matlab Time)
        RawSweepsMode %?????
        RejectionOriginator  
        STLiveNumAccepted   
        STLiveTimestamp
        State
        %   See group enumeration ...
        
        d1 = '----  Pointers to Other Objects  ----'
        active_waveform
        group
        ochan
        test
        parent
        d2 = '----  Reverse Pointers  ----'
        freerun_waveform
        triggered_waveforms
        rec_file
        d3 = '----  Display Properties  ----'
        OriginX
        OriginY
    end
    
    methods
        function value = get.GroupName(obj)
           value = obj.group.Name;
        end
    end
    
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {
            'ActiveWaveformObjId' 'active_waveform'
            'GroupObjId'          'group'
            'OChanId'             'ochan'
            'TestObjId'           'test'
            'Parent'              'parent'
            }
    end
    
    methods
    end
    
end

%
%{

'EPTrace'
'EPTrace.Children'
'EPTrace.Data'
'EPTrace.Data.ActiveWaveformObjId'
'EPTrace.Data.CreateTime'
'EPTrace.Data.GroupObjId'
'EPTrace.Data.Name'
'EPTrace.Data.OChanId'
'EPTrace.Data.OriginX'
'EPTrace.Data.OriginY'
'EPTrace.Data.RawSweepsMode'
'EPTrace.Data.RejectionOriginator'
'EPTrace.Data.STLiveNumAccepted'
'EPTrace.Data.STLiveTimestamp'
'EPTrace.Data.State'
'EPTrace.Data.TestObjId'
'EPTrace.Id'
'EPTrace.IsRoot'
'EPTrace.Parent'
'EPTrace.Schema'
'EPTrace.Type'


%}

