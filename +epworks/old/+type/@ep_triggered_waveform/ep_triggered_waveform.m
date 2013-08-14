classdef ep_triggered_waveform < epworks.type
    %
    %   Class:
    %       epworks.type.ep_triggered_waveform
    
    %Populated Data
    %--------------------------------------------------
    %    ep_triggered_waveform with properties:
    %
    %                 data: [1x602 single]
    %      hardware_fc_low: 20
    %     hardware_fc_high: 15000
    %               fc_low: 30
    %              fc_high: 1000
    %            fc_cutoff: -1
    %              fs_orig: 30000
    %                   fs: 30000
    %                range: 200
    %       stim_intensity: 15
    %            timestamp: 6.3504e+10
    %           is_alarmed: 0
    %          is_captured: 0
    %      sequence_number: 1
    %            parent_id: [1x1 epworks.type.ep_trace]
    %           set_obj_id: [1x1 epworks.type.ep_set]
    %              self_id: [4964079180608779236 15649972919516673155]
    %         trace_obj_id: [1x1 epworks.type.ep_trace]
    %        matlab_parent: [1x1 epworks.main]
    
    
    
    properties (Dependent)
        name             %Retrieved from trace object
        timestamp_date
    end
    
    properties (Dependent)
        d = '---- Set Properties ----'
        set_number
        num_accepted
        num_rejected
    end
    
    properties
        %Sensitity - ignoring, only relevant for display
        %Timebase  - "              "
        fs       %(Units: Hz) Sampling Frequency
        range    %(Units: uV)
        %? reject threshold
        %? reject delay
    end
    
    properties (Dependent)
        d1 = '----- Stimulus Properties -----'
        trigger_source_name
        trigger_delay  %(Units: ms), 
        %?sweep duration
        %?sweeps/avg  - from group
    end
    
    properties 
        stim_intensity  %(Units: mA)  What was actually applied??? (mA)
        %or what was intended?
        %Where are these distinguished??????? 
    end
    
    %Useful Properties
    properties
        d3 = '----- Results -----'
        data            %([1 x n] double)
    end
    
    properties (Dependent)
        time  %(Units: ms) Relative to stimulus onset
        %? or trigger onset ????
    end

    
    properties
        d4 = '----- NOTE INFORMATION ------'
        prev_note_index   = -1
        prev_note_title   = ''
        prev_note_comment = ''
        next_note_index   = -1
        next_note_title   = ''
        next_note_comment = ''
    end
    
    properties
        d5 = '----- Filter Parameters ------'
        hardware_fc_low   %(Hz)
        hardware_fc_high  %(Hz)
        fc_low            %(Hz)
        fc_high           %(Hz)
        fc_notch          %(Hz), usually -1 observed indicating it is off

        d6 = '---- Other Properties -----'
        is_alarmed      %Indicates that the stimulator saturated ?
        
        is_captured = 0 %Why would this be false?
        
        sequence_number = NaN  %Not in all objects ?? What is this?
        %Observed values: 1, but only for the first few values, then
        %it is in none of the other values ...
        fs_orig     %??? What is this ...
        timestamp   %(double) see epworks/documentaton/Common_Property_Types
        %This is the numeric version for data comparison
    end
    
    properties (Hidden)
        raw_data %Unfiltered data
    end
    
    properties
        d7 = '---- OBJECT POINTERS -----'
        prev_note         = []
        next_note         = []
        parent        % Class: epworks.type.ep_trace
        set           % Class: epworks.type.ep_set
        trace         % Seems to be the same as the parent ...
    end
    
    properties (Dependent)
        group
        trigger_source
    end

    properties (Hidden)
        self_id       %
    end
    
    %SET/GET Methods  =====================================================
    methods
        function value = get.trigger_source_name(obj)
            ts = obj.trigger_source;
            if isempty(ts)
                value = '';
            else
                value = ts.phys_name;
            end
        end
        function value = get.trigger_source(obj)
            if isnumeric(obj.group)
                value = [];
            else
                value = obj.group.trigger_source;
            end
        end
        function value = get.trigger_delay(obj)
            if isnumeric(obj.group)
                value = 0;
            else
                value = obj.group.trigger_delay;
            end
        end
        function value = get.time(obj)
            %What's the delay?
            
            n     = length(obj.data);
            value = 1000*(0:n-1)./obj.fs; %transform into ms
            value = value + obj.trigger_delay;
            
        end
        function value = get.group(obj)
            if isnumeric(obj.trace)
                value = [];
            else
                value = obj.trace.group;
            end
        end
        function value = get.name(obj)
            if isnumeric(obj.trace)
                value = 'NULL TRACE LINK';
            else
                value = obj.trace.name;
            end
        end
        function value = get.timestamp_date(obj)
            value = obj.getTimeString(obj.timestamp);
        end
        function value = get.set_number(obj)
            if isnumeric(obj.set)
                value = -1;
            else
                value = obj.set.set_number;
            end
        end
        function value = get.num_accepted(obj)
            if isnumeric(obj.set)
                value = -1;
            else
                value = obj.set.num_accepted;
            end
        end
        function value = get.num_rejected(obj)
            if isnumeric(obj.set)
                value = -1;
            else
                value = obj.set.num_rejected;
            end
        end
    end
    
    properties (Constant,Hidden)
        %Please keep sorted ...
        %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
        FILTER_ORDER = 1  %actually twice this due to filt/filt
        REQUESTED_VALUES_AND_FUNCTIONS = {
            'AppliedHWFilterHFF'    'hardware_fc_high'
            'AppliedHWFilterLFF'    'hardware_fc_low'
            'HffCutoff'             'fc_high'
            'Id'                    'self_id'
            'IsAlarmedWave'         'is_alarmed'
            'IsCaptured'            'is_captured'
            'LffCutoff'             'fc_low'
            'NotchCutoff'           'fc_notch'
            'OriginalSampFreq'      'fs_orig'
            'Parent'                'parent'
            'Range'                 'range'
            'SampFreq'              'fs'
            'SavedStimIntensity'    'stim_intensity'
            'SequenceNumber'        'sequence_number'
            'SetObjId'              'set'
            'SourceData'            'raw_data'
            'Timestamp'             'timestamp'
            'TraceObjId'            'trace'
            }
        SELF_ID   = 'self_id'
        OTHER_IDS = {'parent' 'set' 'trace'}
    end
    
%     properties (Constant,Hidden)
%         TAGS_TO_GET = epworks.type.ep_triggered_waveform.REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
%         NEW_NAMES   = epworks.type.ep_triggered_waveform.REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
%     end
    
    %Initialization Methods  ==============================================
    methods (Hidden)
        function obj = ep_triggered_waveform(varargin)
            
            obj@epworks.type(varargin{:});
%             for iProp = 1:length(prop_names)
%                 obj.(prop_names{iProp}) = values{iProp};
%             end
        end
        function setupNoteInfo(objs,note_entries)
            %setupNoteInfo For each waveform finds previous and next note
            %
            %   setupNoteInfo(objs,note_entries)
            %   
            %   FULL PATH:
            %   epworks.type.ep_triggered_waveform.setupNoteInfo
            
            all_timestamps  = [objs.timestamp];
            note_timestamps = [note_entries.created_time_seconds];
            

            [I1,I2] = epworks.RNEL.computeEdgeIndices(all_timestamps,[0 note_timestamps],[note_timestamps Inf]);
            
            %prev       1    2     3      4     5    6     7     8     9    10    11     12    13
            %next       2    3     4      5     6    7
            %I1 = 1     1     7    31    37    37    40    55    55    55   240   300   300     1
            %I2 = 0     6    30    36    36    39    54    54    54   239   299   299   539     0
            
            for iNote = find(I2 - I1 ~= -1)
                if iNote ~= 1
                    prev_note_local = note_entries(iNote-1);
                    [objs(I1(iNote):I2(iNote)).prev_note]            = deal(prev_note_local);
                    [objs(I1(iNote):I2(iNote)).prev_note_index]      = deal(iNote-1);
                    [objs(I1(iNote):I2(iNote)).prev_note_title]      = deal(prev_note_local.title);
                    [objs(I1(iNote):I2(iNote)).prev_note_comment]    = deal(prev_note_local.comment);
                end
                if iNote ~= length(I2)
                    next_note_local = note_entries(iNote);
                    [objs(I1(iNote):I2(iNote)).next_note]            = deal(next_note_local);
                    [objs(I1(iNote):I2(iNote)).next_note_index]      = deal(iNote);
                    [objs(I1(iNote):I2(iNote)).next_note_title]      = deal(next_note_local.title);
                    [objs(I1(iNote):I2(iNote)).next_note_comment]    = deal(next_note_local.comment);
                end
            end
            
        end
        function objs_out = sortByTimestamp(objs_in)
            %sortByTimestamp  Sorts objects based on their creation time
            %
            %   objs_out = sortByTimestamp(objs_in)
            %
            
            temp_times = [objs_in.timestamp];
            [~,I] = sort(temp_times);
            objs_out = objs_in(I);
        end
        function filterData(objs_in)
            %
            %   filterData(objs_in)
            %
            %   Improvement note:
            %   --------------------------------------------------------------
            %   # We could put all properties into a matrix, find unique rows
            %     then filter those together ...
            %   # Our filtering is different than theirs ...
            %
            %   IMPORTANT
            %   -----------------------------------------------------------
            %   This function requires the signal processing toolbox
            
            
            %The current approach to filtering is to do it one object at at
            %time. The speed of this could be improved but it would require
            %a bit more coding effort than I was willing to put in at the
            %time I was writing this.
            
% %             for iObj = 1:length(objs_in)
% %                 cur_obj = objs_in(iObj);
% %                 fc      = [cur_obj.fc_low cur_obj.fc_high];
% %                 [B,A]   = butter(cur_obj.FILTER_ORDER,fc*(2/cur_obj.fs));
% %                 
% %                 %Note the distinction between raw data and filtered data
% %                 %in terms of the different properties.
% %                 
% %                 cur_obj.data = filtfilt(B,A,cur_obj.raw_data);
% %             end
            
            %            fs_all      = [objs_in.fs];
            %            length_all  = arrayfun(@(x) length(x.data),objs_in);
            %            fc_low_all  = [objs_in.fc_low];
            %            fc_high_all = [objs_in.fc_high];
            %            notch_all   = [objs_in.fc_notch];
            %
            %            if any(notch_all ~= -1)
            %               error('Notch filtering not yet supported')
            %            end
            %
            %            if any(fc_low_all ~= fc_low_all(1)) || any(fc_high_all ~= fc_high_all(1))
            %               error('Different filtering parameters per waveform are not yet supported')
            %            end
            %
            %            if any(fs_all ~= fs_all(1)) || any(length_all ~= length_all(1))
            %               error('Unsupported case of different data lengths or different sampling frequencies')
            %            end
            %
            %            all_data_temp = vertcat(objs_in.data)';
            %
            %            fc = [fc_low_all(1) fc_high_all(1)];
            %
            %            [B,A] = butter(obj.FILTER_ORDER,fc*(2/fs_all(1)));
            %
            %            filtered_data = filtfilt(B,A,all_data_temp);
            %
            %            for iObj = 1:length(objs_in)
            %               objs_in(iObj).data = filtered_data(:,iObj)';
            %            end
        end
    end
    
    methods
        function obj_out = getInstance(objs_in,set_number,name,group_name)
           %getInstance  Simple filtering method for getting the waveform of interest
           %
           %    obj_out = getInstance(objs_in,set_number,name,*group_name)
           %
           %    INPUTS
           %    ===========================================================
           %    set_number : (numeric)
           %    name       : name given to the trace which contains this
           %                  object
           %    group_name : If not present, then we don't filter based on
           %        the group name as well
           
           sn    = [objs_in.set_number];
           names = {objs_in.name};
           
           mask = sn == set_number & strcmpi(names,name);
           
           if exist('group_name','var')
              g = [objs_in.group];
              g_names = {g.name};
              mask = mask & strcmpi(g_names,group_name);
           end
           
           I = find(mask);
           
           %This fails when we have multiple groups
           %TODO: Allow multiple instances????
           if length(I) ~= 1
               error('Unable to find singular match for waveform with set number: #%d and name: %s',...
                   set_number,name)
           end
           obj_out = objs_in(I);
           
        end
        function plot(obj)
            %
            %   TODO: Add on stimulus times to display
            %
            %   ??? - multiply by -1?????
            
            plot(obj.time,obj.data)
            set(gca,'FontSize',18) %#ok<CPROP>
            xlabel('Time after stimulus onset (ms)')
            %??? stimulus or trigger?
            %if obj.num_accepted == 1
            %title(sprintf('%s: %d waveforms ',obj.name,obj.num_accepted
            title(obj.name)
        end
    end
    
end
