classdef main < epworks.RNEL.handle_light
    %
    %   Class:
    %   epworks.main
    %
    %   This is the new main class for accessing data.
    
    properties
        d1 = '----   IOM Objects   ----'
        cursors %epworks.ep.cursor
        freerun_waveforms %epworks.ep.cursor
        groups %epworks.ep.group
        patient %epworks.ep.patient
        sets  %epworks.ep.set
        study %epworks.ep.study
        tests %epworks.ep.test
        traces %ep.epworks.trace
        triggered_waveforms %epworks.ep.triggered_waveform
        d1_5 = '----  Moved Objects  -----'
        baseline_sets
        raw_sweep_sets
    end
    
    properties
        d2 = '----   History Files   -----'
        rec_files %epworks.rec_file
        dat_file
        notes
    end
    
    properties
        d4 = '----  Debugging IOM  ----'
        non_dom_names
        ignored_names
        d5 = '----  Others   ----'
        id_man
    end
    
    
    
    methods
        function obj = main(study_name_or_path)
            
            if nargin == 0
                study_name_or_path = '';
            end
            
            file_manager    = epworks.file_manager(study_name_or_path);
            %Class: epworks.file_manager
            
            parsed_iom_data = epworks.iom_parser(file_manager.iom_file_path);
            %Class: epworks.iom_parser
            %
            %NOTE: This data could be interesting as it shows the raw data
            %in the file before we drop objects. This class is not held onto
            %for the final output.
            
            obj.populateIOMObjects(parsed_iom_data);
            
            %Hack, fixes stim objects in settings ...
            settings_objects = [obj.tests.Settings];
            settings_objects.fixStimsObjects();
            
            %rec files
            %---------------------------------------------------------------
            all_rec_files  = [file_manager.rec_file_paths{:}];
            
            n_rec_files    = length(all_rec_files);
            
            rec_files_cell = cell(1,n_rec_files);
            
            for iRec = 1:n_rec_files
                rec_files_cell{iRec} = epworks.history.rec_file(all_rec_files{iRec});
            end
            
            obj.rec_files = [rec_files_cell{:}];
            
            %history dat file
            %---------------------------------------------------------------
            if exist(file_manager.history_dat_path,'file')
                obj.dat_file = epworks.history.dat_file(file_manager.history_dat_path);
            end
            
            %notes files
            %---------------------------------------------------------------
            notes_file_path = file_manager.notes_file_path;
            if ~isempty(notes_file_path)
                obj.notes = epworks.notes(notes_file_path);
            end
            
            %Id Linking
            %---------------------------------------------------------------
            obj.id_man = epworks.id_manager(obj);
            
            %This bit of code links the rec_file_wavforms to the triggered
            %waveforms. I haven't been able to match the other IDs, with
            %the exception of the history file, although I don't know if
            %that does any good ...
            if ~isempty(obj.rec_files)
                r     = obj.rec_files;
                w     = [r.waveforms];
                wids  = vertcat(w.ID);
                tw    = obj.triggered_waveforms;
                twids = vertcat(tw.ID);
                [mask,loc] = ismember(wids,twids,'rows');
                if any(mask)
                    matching_tw      = tw(loc(mask));
                    matching_tw_cell = num2cell(matching_tw);
                    [w(mask).triggered_waveform] = deal(matching_tw_cell{:});
                    w_cell = num2cell(w(mask));
                    [matching_tw(mask).rec_file_waveform] = deal(w_cell{:}); %#ok<NASGU>
                end
            end
            
            %Reorganizing results
            %---------------------------------------------------------------
            obj.sortObjects();
            
            %tst files
            %---------------------------------------------------------------
            %This looks redundant with the iom file ...
% % % %             tst_file_paths = file_manager.tst_file_paths;
% % % %             n_tst = length(tst_file_paths);
% % % %             
% % % %             tst_all = cell(1,n_tst);
% % % %             for iTST = 1:n_tst
% % % %                 tst_all{iTST} = epworks.tst_parser(tst_file_paths{iTST});
% % % %             end
% % % %             
% % % %             tst = [tst_all{:}];
% % % %             a = [tst.all_objects_out];
% % % %             
% % % %             all_full_names = [a.full_name]';
% % % %             u_full = unique(all_full_names);
%             keyboard
        end
    end
    
end

