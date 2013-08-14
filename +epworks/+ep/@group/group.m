classdef group < epworks.ep
    %
    %   Class:
    %   epworks.ep.group
    
    properties (Hidden)
        BaselineSetId = uint64([0 0])
        RawSweepSetId = uint64([0 0])
        GroupId
        TestObjId
        TriggerSource
    end
    
    %Hidden enumeration properties   --------------------------------------
    properties (Hidden)
        SignalType  %Enumeration
        % 0 - Free Run
        % 1 - Triggered
        % 2 - ?????
        % 3 - Averaged 
        DisplayMode   %[1 x 2], u16 
        %     8    0    1    0
        %     8    0    1    0
        %     8    0    1    0
        %     8    0    1    0
        %     8    0    1    0
        %     8    0    1    0  Replace, Traces Stack
        %     1    0    1    0  Vertical Curve Stack, Traces Stack
        %     1    0    1    0  Vertical Curve Stack, --- Disp Stack
        %     4    0    1    0  Overlay, --- Disp Stack
        %     
        %
        %- Vertical Display Stack - A maximum of 50 traces are displayed
        %    consecutively and spaced apart vertically
        %- Overlay - set of traces are superimposed
        %- Replace - displays the number of sets of traces
        %    that are in the replace mode option
        %
        %    What about the Display Stack? This is the option next to the 
        %    display mode
        %
        %    # Disp Stack
        %        - Sets Stack   - organizes traces by traces aquired at the
        %                         same time
        %        - Traces Stack - Organizes traces according to inputs
    end
    
    properties
        Name
        d0 = '----   Data Properties  ----'
        CaptureEnable %logical?, one can disable capture for a group by
        %editing the test
        CaptureThreshold %(Units: uV), when in free run data above this
        %value is used to capture an epoch of data


        RollingWindow %0 ???

        State  %enumeration
        %I think on the options screen this is the "capture options"
        %---------------------------------------------------------------
        %0) Stop Capturing - don't capture data
        %1) Threshold: use a threshold value to determine whether or not
        %        to threshold
        %2) Show Live Waveform - captures response, ignoring threshold
        %3) Chime - with a bunch of different muscial chime options  
        %    - plays tone on threshold crossing (does it capture data as
        %    well?)

        SweepsPerAvg
        TriggerDelay %(Units: ms) delay from the onset of the trigger
        %to the start of data capture. Note, I think that the trigger onset
        %is different than the stimulus onset.
        d1 = '----  Pointers to Other Objects  ----'
        baseline_set
        group_def       %always present
        raw_sweep_set   %not always present
        test            %always present
        trigger_source  %not always present
        parent
        d2 = '---- Reverse Pointers  ----'
        sets
        traces
        d3 = '----  Enumerated Values ----'
    end
    
    properties (Dependent)
        signal_type
        display_mode
    end
    
    methods
        function value = get.signal_type(obj)
           VALUES   = {'Free Run' 'Triggered' '??? Unknown Type' 'Averaged'};
           value = VALUES{obj.SignalType+1};
        end        
        function value = get.display_mode(obj)
           try
              VALUES   = {'Vertical Curve Stack' '??? Unknown Type' 'Overlay' 'Replace'};
              bits = bitget(obj.DisplayMode(1),1:8);
              value = VALUES{find(bits,1)};
           catch ME
              value = 'ERROR: Unknown display mode value'; 
           end
        end
    end
    
    %Possible things to add:
    %- test number
    %-
    
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {
            'BaselineSetId'      'baseline_set'
            'GroupId'            'group_def'
            'RawSweepSetId'      'raw_sweep_set'
            'TestObjId'          'test'
            'TriggerSource'      'trigger_source'
            'Parent'             'parent'
            }
        ENUMERATED_PROPS = {'SignalType'}
    end
    
    methods
    end
    
end

%{
'EPGroup'
'EPGroup.Children'
'EPGroup.Data'
'EPGroup.Data.BaselineSetId'
'EPGroup.Data.CaptureEnable'
'EPGroup.Data.CaptureThreshold'
'EPGroup.Data.DisplayMode'
'EPGroup.Data.GroupId'
'EPGroup.Data.Name'
'EPGroup.Data.RawSweepSetId'
'EPGroup.Data.RollingWindow'
'EPGroup.Data.SignalType'
'EPGroup.Data.State'
'EPGroup.Data.SweepsPerAvg'
'EPGroup.Data.TestObjId'
'EPGroup.Data.TriggerDelay'
'EPGroup.Data.TriggerSource'
'EPGroup.Id'
'EPGroup.IsRoot'
'EPGroup.Parent'
'EPGroup.Schema'
'EPGroup.Type'
%}

