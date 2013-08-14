classdef ep_test < epworks.type
    %
    %
    %   Class:
    %       epworks.type.ep_test
    %
    %   NOTE: A study can contain multiple tests. 
    
    properties
        name
        %.sortByCreationTime()
        test_number  %This is the index # of the test after sorting
        %by the time the test was created
        
        state  %enumeration
        %0 - Active
        %1 - Inactive

    end
    
    properties (Hidden)
       state_orig 
    end
    
    methods
        function set.state(obj,value)
            obj.state_orig = value; %#ok<MCSUP>
            STATE_VALUES   = {'Inactive' 'Active'};
            obj.state      = STATE_VALUES{value+1};
        end
    end
    
    properties (Dependent)
        creation_time_string
    end
    
    properties (Constant,Hidden)
       %Updates this if other properties are added to the test
       %that are themselves epworks.type objects ...
       OBJECT_PROPERTIES = {'ochans' 'electrical_stims' 'tcemep_stims' ...
           'electrodes' 'groupdefs' 'ichans'}
    end
    
    properties
        groupdefs  %Class: epworks.type.groupdef
        %
        %   ?? - What is a groupdef
        
        ichans    
        ochans     %Class: epworks.type.ochans
        %
        %   - these point to ichans
        %   - ichans point to electrodes
        %   -
        
        %auditory_stims      %Stims
        %external_stims      %
        %visual_stims        %Stims
        
        %NOTE: non-existant objects once observed may have been an error
        electrical_stims    = epworks.type.electrical_stim.empty;
        %Class: epworks.type.electrical_stim
        tcemep_stims        = epworks.type.tcemep.empty;
        %Class: epworks.type.tcemep
        
        
        electrodes          %Class: epworks.type.electrode
        %These are the descriptions of the physical electrode, including
        %location, index #, and name (like G)
    end
    
    properties
        d1 = '----  Object Pointers  ----'
        parent_id  %??? What's the parent?
    end
    
    properties
        self_id
        creation_time
    end
    

    
    %Not so useful properties
    %---------------------------------------
    properties
        d = '------  OTHER PROPERTIES ------'
        simulation_mode         %0 - enumeration?
        is_root
        stimbox_connected       %boolean, not sure why we care about this ...
        test_set_object_count   %??? - what does this represent?
    end
    
    methods
        function value = get.creation_time_string(obj)
            value = obj.getTimeString(obj.creation_time);
        end
    end
    
    methods (Hidden)
        function objs_out = sortByCreationTime(objs_in)
            %This should only be called once, by ep_study
            creation_times = [objs_in.creation_time];
            [~,I_sort]     = sort(creation_times);
            objs_out       = objs_in(I_sort);
            test_numbers   = num2cell(1:length(I_sort));
            [objs_out.test_number] = deal(test_numbers{:});
        end
    end
    
    %----------------------------------------------------------------------
    properties (Constant,Hidden)
        %Top level ignored properties
        %-------------------------------
        %- HardwareConfig   - 4
        %- HBType           - 10
        %- ForceFixChanMap  -
        %- Fix Name
        %- DefaultTemplate
        %- ConfigData
        %- BoardRevision
        %- ActiveLayout
        
        %Groups we're ignoring
        %-------------------------------
        %HistorySets
        %ElementLayouts
        %EEG
        %CursorDef
        %CursorCalc
        %AppTestSettings
        %timelines           %Timelines
        
        %Please keep sorted ...
        %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
        REQUESTED_VALUES_AND_FUNCTIONS = {
            'CreationTime'      'creation_time'
            'Id'                'self_id'
            'IsRoot'            'is_root'
            'Name'              'name'
            'Parent'            'parent_id'
            'SimulationMode'    'simulation_mode'
            'State'             'state'
            'StimboxConnected'  'stimbox_connected'
            'TestSetObjCount'   'test_set_object_count'
            }
        SELF_ID   = 'self_id'
        OTHER_IDS = {'parent_id'} %NONE
    end
    
%     properties (Constant,Hidden)
%         TAGS_TO_GET = epworks.type.ep_test.REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
%         NEW_NAMES   = epworks.type.ep_test.REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
%     end
    
    methods
        function obj = ep_test(varargin)
            obj@epworks.type(varargin{:});
        end
    end
    
end

