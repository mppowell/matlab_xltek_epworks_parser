classdef trace < epworks.ep
    %
    %   Class:
    %   ep.epworks.trace
    
    properties
        d0 = '----  Data Properties  ----'
        ActiveWaveformObjId
        CreateTime
        GroupObjId
        Name
        OChanId
        OriginX
        OriginY
        RawSweepsMode
        RejectionOriginator
        STLiveNumAccepted
        STLiveTimestamp
        State
        TestObjId
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

