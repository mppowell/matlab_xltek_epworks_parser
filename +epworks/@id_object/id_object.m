classdef id_object < handle
    %
    %   Class:
    %   epworks.id_object
    
    properties
    end
    
    methods
        %NOTE: I'm not sure if I am going to use this or not yet ...
        function IDs = getSelfID(objs)
           IDs = vertcat(objs.ID); 
        end
        function output = getPropLinkInfo(objs)
           if isempty(objs)
               output = epworks.prop_link_info.empty;
           elseif isempty(objs(1).ID_PROP_INFO_1)
               output = epworks.prop_link_info.empty;
           else
           output = epworks.prop_link_info(objs,...
               objs(1).ID_PROP_INFO_1(:,1),objs(1).ID_PROP_INFO_1(:,2));
           end
        end
        %???? How to get child objects with ids???
    end
    
end

