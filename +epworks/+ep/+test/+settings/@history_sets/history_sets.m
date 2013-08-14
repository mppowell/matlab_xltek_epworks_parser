classdef history_sets < epworks.id_object
    %
    %   Class:
    %   epworks.ep.test.settings.history_sets
    %
    %NOTE: Due to the way the code is currently written, if there are no
    %children of an object, then the object is not initialized. 
    %   
    %   See Also:
    %   epworks.main.populateIOMObjects
    
    properties
       HistoryTraceIDs
       ID   = uint64([0 0])
       Name = ''
    end
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {}
    end
    methods
        function initialize(obj,roa,children_indices)
           
           %child_objs = all_raw(raw_obj.children_indices);
           prop_names = roa.name(children_indices);
           obj.ID     = roa.data_value{children_indices(strcmp(prop_names,'ID'))};
           obj.Name   = roa.data_value{children_indices(strcmp(prop_names,'Name'))};
           %TODO: We should check that the history traces have IDs of 1:n
           %or rather 0:n-1
           %
           %NOTE: These may not be sorted properly due to
           %number padding
           %1
           %10
           
           [output,is_matched] = epworks.sl.cellstr.regexpSingleMatchTokens(prop_names,'HistoryTrace(\d+)');
           
           children_indices(~is_matched) = [];
           output(~is_matched) = [];
           
           [~,I] = sort(str2double(output));
           
           obj.HistoryTraceIDs = vertcat(roa.data_value{children_indices(I)});
        end
    end
    
end

%{
'EPTest.Data.Settings.HistorySets.000'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace0'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace1'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace10'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace11'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace12'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace13'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace14'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace15'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace16'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace17'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace2'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace3'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace4'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace5'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace6'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace7'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace8'
'EPTest.Data.Settings.HistorySets.000.HistoryTrace9'
'EPTest.Data.Settings.HistorySets.000.ID'
'EPTest.Data.Settings.HistorySets.000.Name'
%}
