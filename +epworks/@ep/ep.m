classdef ep < epworks.id_object
    %
    %   Class:
    %   epworks.ep
    %
    %   This is inherited by the top level IOM objects which all have
    %   these properties.
    
    %NOTE: This can be hidden or unhidden as necessary.
    properties (Hidden)
        %d5 = '----  Top Level Properties ----'
        Children = uint64([0 0])
        ID
        IsRoot
        Parent   = uint64([0 0])
        Schema
        Type
    end
    
    methods
        function listIDs(obj)
           %
           %    listIDs(obj)
            
           temp = obj.ID_PROP_INFO_1;
           old_prop_names = temp(:,1);
           for iProp = 1:length(old_prop_names)
              cur_prop = old_prop_names{iProp};
              id_value = obj.(cur_prop);
              fprintf('%s: [%d %d]\n',cur_prop,id_value(1),id_value(2))
           end
           id_value = obj.ID;
           fprintf('%ID: [%d %d]\n',id_value(1),id_value(2))
        end
    end
    
end

