classdef study < epworks.ep
    %
    %   Class:
    %   epworks.ep.study
    
    properties
       d0 = '----   Data Properties  ----'
       AcquisitionInstrument
       AcquisitionTimeZone
       CommChannelHandle
       CreationTime
       Creator
       Duration
       EegNoLabel
       EndTime
       FileName
       IOMUIVersionHigh
       IOMUIVersionLow
       LocalInitializationComplete
       ModificationTime
       PerformedProcedures
       ProductVersionHigh
       ProductVersionLow
       d1 = '----  Pointers to Other Objects  ----'
       parent
    end
    properties (Constant,Hidden)
       ID_PROP_INFO_1 = {
           'Parent'      'parent'
           }
    end
    methods
    end
    
end

%{

'EPStudy'
'EPStudy.Children'
'EPStudy.Data'
'EPStudy.Data.AcquisitionInstrument'
'EPStudy.Data.AcquisitionTimeZone'
'EPStudy.Data.CommChannelHandle'
'EPStudy.Data.CreationTime'
'EPStudy.Data.Creator'
'EPStudy.Data.Duration'
'EPStudy.Data.EegNoLabel'
'EPStudy.Data.EndTime'
'EPStudy.Data.FileName'
'EPStudy.Data.IOMUIVersionHigh'
'EPStudy.Data.IOMUIVersionLow'
'EPStudy.Data.LocalInitializationComplete'
'EPStudy.Data.ModificationTime'
'EPStudy.Data.PerformedProcedures'
'EPStudy.Data.ProductVersionHigh'
'EPStudy.Data.ProductVersionLow'
'EPStudy.Id'
'EPStudy.IsRoot'
'EPStudy.Parent'
'EPStudy.Schema'
'EPStudy.Type'


%}