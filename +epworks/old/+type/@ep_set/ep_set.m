classdef ep_set < epworks.type
    %
    %   Class:
    %   epworks.type.ep_set
    %
    %   Set Types:
    %   -------------------------------------------------------------------
    %   1) A baseline set
    %   2) Raw sweep id
    %   3) Normal (not 1 or 2)
    %
    %   Improvements
    %   -------------------------------------------------------------------
    %   1) We could create different set types objects as some of these
    %   properties only make sense for the normal set type object ...
    %
    
    properties
       is_baseline_set = false;
       is_raw_sweep_id = false;
       %It seems like it is only possible to be one of the two of the above
       %propertie, or neither, but not both
       
       set_number   %
       %intmax('uint32') - for raw sweep ids
       %0 - for baseline sets
       %# - for normal sets
    end
    
    properties (Dependent)
       test_number  %-1 if test link is not present
    end
    
    methods
        function value = get.test_number(obj)
            value = obj.test.test_number;
        end 
    end

    properties
        %These are only valid for normal set objects although
        %I suppose 0 is a valid value in the other cases
        %
        %They are only set in the data for normal objects
        num_accepted = 0 %Not in each object
        %Shows the total number of aquired waveforms that
        %were within the rejection thresholds
        
        num_rejected = 0 %Not in each object
    end
    
    properties
        d1 = '----   Object Pointers   ----'
        group  = uint64([0 0]) %Null in some instances ...
        %This seems to be null when it is a baseline set or a raw_sweep
        %set ...
        parent %epworks.type.ep_group
    end
    
    properties (Dependent)
        test    %Pointer to 'test' object, which is obtained through
        %the parent object.
    end
    
    methods 
        function value = get.test(obj)
           %This used to be a reference to the group object
           %I changed it to being the parent, I think this always exists.
           
           value = obj.parent.test;
        end
    end
    
    properties
        self_id 
    end
    
    properties (Constant,Hidden)
        %Please keep sorted ...
        %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
        REQUESTED_VALUES_AND_FUNCTIONS = {
            'GroupObjId'     'group'
            'Id'             'self_id'
            'NumAccepted'    'num_accepted'
            'NumRejected'    'num_rejected'
            'Parent'         'parent'
            'SetNumber'      'set_number'
            }
       SELF_ID   = 'self_id'
       OTHER_IDS = {'group' 'parent'}
    end
      
    methods
        function obj = ep_set(parent_obj,prop_names,values)
            obj@epworks.type(parent_obj,prop_names,values);
        end
    end
    
    methods (Hidden)
        function objs_out = sortBySetNumber(objs_in)
           %
           %    objs_out = sortBySetNumber(objs_in)
           %
           %    This should only be called once by the epworks.study constructor 
           
           set_numbers = [objs_in.set_number];
           [~,I_sort]  = sort(set_numbers);
           objs_out    = objs_in(I_sort);
        end
    end
    
end

