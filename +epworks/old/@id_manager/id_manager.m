classdef id_manager < epworks.RNEL.handle_light
    %
    %   Class:
    %   epworks.id_manager
    

    %   Complete pairing
    %   --------------------------------------------------
    %   1) receiver object 
    %   2) receiver id
    %   3) receiver property
    %   4) receiver property id value
    %   5) self_ID
    %   6) self_object
    %   7) receiver reverse property
    %   8) receiver reverse type to match
    %   9) receiver 
    % 
    %   Example
    %   ---------------------------------------------------
    %   1) triggered_waveform
    %   2) triggered_waveform.self_id 
    %   3) triggered_waveform.set
    %   4) value at triggered_waveform.set
    %   5) sets.self_id
    %   6) sets
    %   7) sets.triggered_waveforms
    %   8) set <-> triggered_waveform
    %   9) class(1)
    %
    %   Forward
    %   -------------------------------------------------------
    %   Find 5 == 4, 3 = 6
    %
    %   Reverse
    %   -------------------------------------------------------
    %   For all forward matches, use the following:
    %   2, 3 <- unique on this set
    %   7 = 
    %   
    %
    %
    %   For every match, keep track of the class we match and the property
    %   for this pair, see if we have a reverse value to use ...
   
    
    %Unfinished steps
    %----------------------------------------------------------------------
    %1) Create a list of all ids in the study object
    %2) Build a quick linking mechanism to look up ids and get objects
    %3)
    
    
    properties (Hidden)
        is_id_mask
        id_handler
        tags
    end
    
    properties
        d1 = '----  From files  ----'
        ids_in_iom_file
    end
    
    properties (Dependent)
        full_tag_names
    end
    
    properties
       d2 = '----  From parsed iom file objects in study  -----'
       all_object_ids %[n x 2] IDs of all the objects we are parsing out, we can
       %compare this to all objects in the file to see what we are not
       %parsing out
       all_object_refs %{1 x n} These are object references that go 1 to 1
       %with the all_object_ids prop above ...
       unmatched_ids
       unmatched_prop_names
       unmatched_class_names
    end
    
    methods
        function value = get.full_tag_names(obj)
            value = obj.id_handler.full_tag_names_with_type(obj.is_id_mask);
        end
    end
    
    methods
        function obj = id_manager(tag_obj,id_handler,study_obj)
            obj.tags = tag_obj;
            obj.id_handler = id_handler;
            %Ideally this would be a method call instead
            %of directly processing the property ...
            obj.is_id_mask = tag_obj.tag_value_set_methods == 3;
            
            obj.ids_in_iom_file = vertcat(tag_obj.tag_values{obj.is_id_mask});

            obj.createLinks(study_obj);
            
        end
    end
end

