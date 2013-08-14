classdef trend_sets < epworks.id_object
    %
    %   Class:
    %   epworks.ep.test.settings.trend_sets
    %
    
    properties
       TrendCalcs
       ID
       Name 
    end
    %NOTE: I don't have suppport yet for resolving an array of values
    %so TrendCalcs is not resolved to objects.
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {}
    end
    methods
        function initialize(obj,roa,children_indices)
            
           prop_names = roa.name(children_indices);
           obj.ID   = roa.data_value{strcmp(prop_names,'ID')};
           obj.Name = roa.data_value{strcmp(prop_names,'Name')};
           %TODO: We should check that the history traces have IDs of 1:n
           %or rather 0:n-1
           %
           %NOTE: These may not be sorted properly due to
           %number padding
           %1
           %10
           
           [output,is_matched] = epworks.sl.cellstr.regexpSingleMatchTokens(prop_names,'TrendCalc(\d+)');
           
           children_indices(~is_matched) = [];
           output(~is_matched) = [];
           
           [~,I] = sort(str2double(output));
           
           obj.TrendCalcs = vertcat(roa.data_value{children_indices(I)});
        end
    end
    
end

%{
'EPTest.Data.Settings.TrendSets'
'EPTest.Data.Settings.TrendSets.000'
'EPTest.Data.Settings.TrendSets.000.ID'
'EPTest.Data.Settings.TrendSets.000.Name'
'EPTest.Data.Settings.TrendSets.000.TrendCalc0'
'EPTest.Data.Settings.TrendSets.000.TrendCalc1'    
%}
