classdef patient < epworks.ep
    %
    %   Class:
    %   epworks.ep.patient

    %Not imported
    %------------------------------------
    %Connections
    %
    
    properties
        d0 = '----   Data Properties  ----'
        Anesthesiologist
        CaseID
        DesignatedReviewerLabel
        Diagnosis
        Facility
        Info %Object
        Instrumentation_Used
        Insurance
        IsNew
        IsRemote
        IsReview
        Notes
        Other_Staff
        Data_Schema
        Social_Insurance
        Surgeon
        Surgical
        Tech
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

'EPPatient.Data'
'EPPatient.Data.Anesthesiologist'
'EPPatient.Data.CaseID'
'EPPatient.Data.Connections'
'EPPatient.Data.Connections.Client'
'EPPatient.Data.Connections.Client.ProcessId'
'EPPatient.Data.Connections.Sink'
'EPPatient.Data.Connections.Sink.Host'
'EPPatient.Data.Connections.Source'
'EPPatient.Data.Connections.Source.Host'
'EPPatient.Data.DesignatedReviewerLabel'
'EPPatient.Data.Diagnosis'
'EPPatient.Data.Facility'
'EPPatient.Data.Info'

'EPPatient.Data.Info.Address'
'EPPatient.Data.Info.Address.Address1'
'EPPatient.Data.Info.Address.Address2'
'EPPatient.Data.Info.Address.City'
'EPPatient.Data.Info.Address.Country'
'EPPatient.Data.Info.Address.State'
'EPPatient.Data.Info.Address.StateLabel'
'EPPatient.Data.Info.Address.ZIP'
'EPPatient.Data.Info.Address.ZIPLabel'

'EPPatient.Data.Info.Admin'
'EPPatient.Data.Info.Admin.BillingID'
'EPPatient.Data.Info.Admin.BillingIDLabel'
'EPPatient.Data.Info.Admin.CategoryLabel'
'EPPatient.Data.Info.Admin.ChartNoLabel'
'EPPatient.Data.Info.Admin.ID'
'EPPatient.Data.Info.Admin.IDLabel'
'EPPatient.Data.Info.Admin.RefPhys'
'EPPatient.Data.Info.Admin.RefPhysLabel'
'EPPatient.Data.Info.Admin.Telephone'
'EPPatient.Data.Info.Admin.TelephoneLabel'
'EPPatient.Data.Info.Admin.WardLabel'

'EPPatient.Data.Info.Name'
'EPPatient.Data.Info.Name.FirstName'
'EPPatient.Data.Info.Name.LastName'
'EPPatient.Data.Info.Name.MiddleName'

'EPPatient.Data.Info.Personal'
'EPPatient.Data.Info.Personal.Age'
'EPPatient.Data.Info.Personal.AgeLabel'
'EPPatient.Data.Info.Personal.BirthDate'
'EPPatient.Data.Info.Personal.BirthDateLabel'
'EPPatient.Data.Info.Personal.Gender'
'EPPatient.Data.Info.Personal.GenderLabel'
'EPPatient.Data.Info.Personal.Height'
'EPPatient.Data.Info.Personal.HeightFeet'
'EPPatient.Data.Info.Personal.HeightInches'
'EPPatient.Data.Info.Personal.Weight'

'EPPatient.Data.Instrumentation Used'
'EPPatient.Data.Insurance'
'EPPatient.Data.IsNew'
'EPPatient.Data.IsRemote'
'EPPatient.Data.IsReview'
'EPPatient.Data.Notes'
'EPPatient.Data.Other Staff'
'EPPatient.Data.Schema'
'EPPatient.Data.Social Insurance'
'EPPatient.Data.Surgeon'
'EPPatient.Data.Surgical'
'EPPatient.Data.Tech'
'EPPatient.Id'
'EPPatient.IsRoot'
'EPPatient.Parent'
'EPPatient.Schema'
'EPPatient.Type'



%}