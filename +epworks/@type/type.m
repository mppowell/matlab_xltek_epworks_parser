classdef type < epworks.RNEL.handle_light
    %
    %   Class:
    %   epworks.type
    %
    %   This is an abstract class for most of the objects.
    %
    %   These objects include: (incomplete list)
    %   -------------------------------------------------------------------
    %   epworks.type.groups
    %   epworks.type.sets
    %   epworks.type.tests
    %   epworks.type.ep_trace
    %   epworks.type.triggered_waveforms
    %
    %   Constructor Design
    %   -------------------------------------------------------------------
    %   I went and changed all of the subclass constructors to call the
    %   constructor of this class. In retrospect I might have been better
    %   off just creating a factor method ...
    
    properties 
        d_type = '---- Props from epworks.type  -----'
        matlab_parent %This is generally a reference to a study or a test object.
        %It is labeled as the matlab_parent because this is based on how I
        %organized the code in Matlab, not based on what the file specifies
        %should be the parent. Once the linking is in place, I'm not sure
        %that there is a difference ...
        
        object_index  %This refers to the group id value from processing
        %the raw file. Ideally this would be passed into the contructor.
        %Currently it is populated in the epworks.study consctructor.
    end
    
    properties (Constant,Abstract,Hidden)
        REQUESTED_VALUES_AND_FUNCTIONS
        %Column 1: tags to get from the file
        %Coumnn 2: new name for the property in the class
        
        %         TAGS_TO_GET
        %         NEW_NAMES
        
        SELF_ID     %(string), for each object this is the name of the
        %property which holds the ID which identifies that object
        OTHER_IDS   %(cellstr), this identifies the names of properties
        %that currently hold ids that point to other objects. We would like
        %to replace these ids with pointers to the actual objects
    end
    
    %Constructor     ======================================================
    methods (Hidden)
        function obj = type(parent_obj,prop_names,prop_values)
            %type
            %
            
            obj.matlab_parent = parent_obj;
            
            for iProp = 1:length(prop_names)
                obj.(prop_names{iProp}) = prop_values{iProp};
            end
            
        end
    end
    
    methods (Hidden)
        function idStruct = getIDInfo(objs)
            %getIDInfo
            %
            %   idStruct = getIDInfo(objs)
            %
            %   This function is used to create links between different
            %   objects. The data file stores links based on unique id
            %   numbers (128 bit numbers). Later on we go back and replace
            %   the property that has the id numbers with the objects that
            %   they represent.
            %
            %   INPUTS
            %   ===========================================================
            %   objs : an array of objects that have epworks.type as their
            %       superclass. Note, they are all of the same class (not
            %       mixed)
            %
            %   OUTPUTS
            %   ==========================================
            %   idStruct (structure)
            %       .ids                ([n1 x 2] uint64)
            %       .handles            {1 x n1}
            %       .prop_names         {1 x n2}
            %       .request_handles    {1 x n2}
            %       .request_ids        ([n2 x 2] uint64)
            %
            %   See Also:
            %   
            
            if isempty(objs)
                idStruct = struct(...
                    'ids',              [],...
                    'handles',          {{}},...
                    'prop_names',       {{}},...
                    'request_handles',  {{}},...
                    'request_ids',      []);
                return
            end
            
            %Since objects are all of the same type the value of these
            %properties is the same for all instances (the property itself
            %is constant by object type)
            self_id_name   = objs(1).SELF_ID;
            other_id_names = objs(1).OTHER_IDS;
            
            n_objects   = length(objs);
            n_other_ids = length(other_id_names);
            idStruct    = struct;
            
            idStruct.ids     = vertcat(objs.(self_id_name)); %Must vertically
            %concatenate since ids are row vectors ...
            
            idStruct.handles = num2cell(objs);
            
            idStruct.prop_names      = repmat(other_id_names,[1 n_objects]);
            if size(idStruct.handles,1) ~= 1
                error('Assumption in code violated, please fix')
            end
            
            temp                     = repmat(idStruct.handles,[n_other_ids 1]);
            
            idStruct.request_handles = temp(:)';
            
            %idStruct.request_handles = repmat(idStruct.handles,[1 n_other_ids]);
            request_ids              = zeros(n_objects*n_other_ids,2,'uint64');
            cur_index = 0;
            for iObject = 1:n_objects
                cur_obj = objs(iObject);
                for iOtherID = 1:n_other_ids
                    cur_other_id_name = other_id_names{iOtherID};
                    cur_index = cur_index + 1;
                    
                    %NOTE: This fails when an id property is unset ... :/
                    %
                    %This means unset properties should have a default
                    %value ... uint64([0 0])
                    request_ids(cur_index,:) = cur_obj.(cur_other_id_name);
                end
            end
            idStruct.request_ids = request_ids;
        end
    end
    
    methods
        function [tags,new_names] = getTagsAndNewNames(class_name)
            %NOTE: I don't think this method is ever used ...
            tags      = epworks.type.(class_name).REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
            new_names = epworks.type.(class_name).REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
        end
    end
    
    methods (Hidden)
        function value = getTimeString(~,number_in)
            value = datestr(number_in/(24*60*60),'HH:MM:SS');
        end
        
    end
    
end

