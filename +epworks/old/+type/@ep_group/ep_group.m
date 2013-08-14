classdef ep_group < epworks.type
    %
    %   Class:
    %   epworks.type.ep_group
  
%Populated Example
%-----------------------------------
%                  name: 'R Cort. Stim'
%        capture_enable: 1
%     capture_threshold: 0
%          display_mode: 65544
%        rolling_window: 0
%           signal_type: 1
%                 state: 2
%        sweeps_per_avg: 1
%         trigger_delay: 2
%        trigger_source: [5228311538150057610 18016896017799487131]
%               is_root: 0
%               self_id: [4743508566153460007 17812465320770767801]
%       baseline_set_id: [1x1 epworks.type.ep_set]
%              group_id: [4975787843761246931 4773096283081693630]
%             parent_id: [1x1 epworks.type.ep_test]
%      raw_sweep_set_id: []
%           test_obj_id: [1x1 epworks.type.ep_test]
%         matlab_parent: [1x1 epworks.main]

%What is a EPTest GroupDef
%How do we sort groups????

    properties
        name            %User assigned name for group
        %ex. R. Cort. Stim
    end
    
    properties (Dependent)
        test_number  %From test pointer
    end
    
    methods 
        function value = get.test_number(obj)
           if isnumeric(obj.test)
              value = -1;
           else
              value = obj.test.test_number;  
           end
        end
    end
    
    properties
        sweeps_per_avg  %Where are the averages?
        %Are the triggers averages of multiple responses?
        trigger_delay   %(Units: ms), delay from onset of trigger to the 
        %start of data capture. I think that the onset of the stimulus
        %is dependent upon the delay in the stimulus.
    end
    
    properties
        d1 = '----   Object Pointers   ----'
        baseline_set    %Class: epworks.type.ep_set     
        groupdef        %Class: epworks.type.groupdef        

        parent          %Class: epworks.type.ep_test
        test            %same as parent
        trigger_source  %Class: epworks.type.electrical_stim
        
        raw_sweep_set_id = uint64([0 0]) %Not always set
        %
        %   Example of raw_sweep_set_id
        %     set_number: 4294967295
        %   num_accepted: NaN
        %   num_rejected: NaN   
        %       group_id: [0 0]
        
        d2 = '----   Reverse Pointers  -----'
        normal_sets
    end
    
    properties
       self_id 
    end

    %Not so useful properties
    %---------------------------------------    
    properties
       d = '-----  Other Properties  -----' 
       capture_enable      %(boolean or enumeration????), One can disable 
       %capture for a group by editing the test 
       
       capture_threshold  %(Units: uV), When in Free Run data above this
       %value is used to capture an epoch of data
       
       %display_mode     %65544 ??? - might be 8 (8 0 1 0), i.e. not
       %    sure if this is 4 bytes or 2 sets of 2 bytes
       %
       %- Vertical Display Stack - A maximum of 50 traces are displayed
       %            consecutively in and spacted apart vertically
       %- Overlay                 - set of traces are superimposed
       %- Replace                 - displays the number of sets of traces 
       %                that are in the replace mode option
       %
       %    What about the Display Stack?
       %    # Disp Stack
       %        - Sets Stack   - organizes traces by traces aquired at the
       %                         same time
       %        - Traces Stack - Organizes traces according to inputs    
       %
       %rolling_window   %0     ???
       
       signal_type      %enumeration
       %- Free Run
       %- Triggered
       %- Averaged
       
       state            %enumeration
       %I think on the options screen this is the "capture options"
       %---------------------------------------------------------------
       %0) Stop Capturing - don't capture data
       %1) Threshold: use a threshold value to determine whether or not
       %        to threshold
       %2) Show Live Waveform - captures response, ignoring threshold
       %3) Chime - with a bunch of different muscial chime options  
       %    - plays tone on threshold crossing (does it capture data as
       %    well?)
       
       %is_root          %None of these are roots :/     
    end
    
    properties (Hidden)
       state_orig
       signal_type_orig 
    end
    
    methods
        function set.state(obj,value)
           %NOTE: I'm not 100% sure about these values ...
           %
           %
           obj.state_orig = value; %#ok<MCSUP>
           STATE_OPTIONS = {'Don''t Capture' 'Capture on Threshold Crossing' 'Always Capture: Ignore Threshold' 'Chime on Threshold Cross'};
           obj.state     = STATE_OPTIONS{value+1};
        end
        function set.signal_type(obj,value)
           obj.signal_type_orig = value; %#ok<MCSUP>
           %Not sure why this doesn't follow enumeration
           %I've observed 
           %1 - Triggered
           %3 - Normal Avg
           SIGNAL_TYPE_OPTIONS = {'Triggered' 'Free Run' 'Averaged'};
           obj.signal_type      = SIGNAL_TYPE_OPTIONS{value};  
        end
    end



    properties (Constant,Hidden)
        %Please keep sorted ...
        %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
        
        REQUESTED_VALUES_AND_FUNCTIONS = {
            'BaselineSetId'       'baseline_set'
            'CaptureEnable'       'capture_enable'
            'CaptureThreshold'    'capture_threshold'
            %'DisplayMode'         'display_mode'
            'GroupId'             'groupdef'
            'Id'                  'self_id'
            %'IsRoot'              'is_root'
            'Name'                'name'
            'Parent'              'parent'
            'RawSweepSetId'       'raw_sweep_set_id'
            %'RollingWindow'       'rolling_window'
            'SignalType'          'signal_type'
            'State'               'state'
            'SweepsPerAvg'        'sweeps_per_avg'
            'TestObjId'           'test'
            'TriggerDelay'        'trigger_delay'
            'TriggerSource'       'trigger_source'
            }
       SELF_ID   = 'self_id'
       OTHER_IDS = {'baseline_set' 'groupdef' 'parent' 'raw_sweep_set_id' 'test' 'trigger_source'} %NONE
    end
    
%     properties (Constant,Hidden)
%         %***Make sure to update the class name if copying from another class
%         TAGS_TO_GET = epworks.type.ep_group.REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
%         NEW_NAMES   = epworks.type.ep_group.REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
%     end
%     
    methods (Hidden)
        function obj = ep_group(parent_obj,prop_names,values)
            obj@epworks.type(parent_obj,prop_names,values);
%             for iProp = 1:length(prop_names)
%                 obj.(prop_names{iProp}) = values{iProp};
%             end
        end
        function objs_out = sort(objs_in)
           %
           %
           %    objs_out = sort(objs_in)
           %
           %    This assumes that the groupdef property
           %    is now a pointer ...
           
           %NOTE: I believe this sorting is partially necessary
           %due to the use of ismember when grabbing objects (I think I use
           %ismember)
           
           if any(arrayfun(@(x) any(isnumeric(x.groupdef)),objs_in))
              %TODO: Should use formattedWarning here ...
              objs_out = objs_in;
              fprintf(2,'Not sorting groups due to inability to resolve links\n');
              return
           end
           
           group_def_objs    = [objs_in.groupdef];
           group_def_indices = [group_def_objs.object_index];
           test_numbers      = [objs_in.test_number];
           
           [~,Isort]      = sortrows([test_numbers(:) group_def_indices(:)]);
           objs_out       = objs_in(Isort);
        end
    end
    
end

