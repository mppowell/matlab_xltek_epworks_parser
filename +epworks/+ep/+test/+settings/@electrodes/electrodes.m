classdef electrodes < epworks.id_object
    %
    %   Class:
    %   epworks.ep.test.settings.electrodes
    
    properties
       EEGSiteGUID
       ID
       Location
       PhysElectrode
       PhysName
       d1 = '----  Pointers to Other Objects  ----'
       eeg_site_gui
    end
    
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {
            'EEGSiteGUID'   'eeg_site_gui'
            }
    end
    
    methods
    end
    
end

%{
'EPTest.Data.Settings.Electrodes.000'
'EPTest.Data.Settings.Electrodes.000.EEGSiteGUID'
'EPTest.Data.Settings.Electrodes.000.ID'
'EPTest.Data.Settings.Electrodes.000.Location'
'EPTest.Data.Settings.Electrodes.000.PhysElectrode'
'EPTest.Data.Settings.Electrodes.000.PhysName'
%}