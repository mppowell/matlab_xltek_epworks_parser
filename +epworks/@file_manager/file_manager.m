classdef file_manager < epworks.RNEL.handle_light
    %
    %   Class:
    %   epworks.file_manager
    %
    %   This class can be used to get all relevant file paths.
    
    properties
        study_name
        iom_file_path
        history_dat_path
        notes_file_path  = '' %This may or may not exist
        %
        %    1) When modifications are made it appears that backups are made
        %     in the format of:
        %        _BAK#.NOT
        %    2) I am guessing the name is some sort of checksum/hash.
        
        tst_file_paths   %
        tst_folder_names %
        rec_file_paths   %{1 x n_tst}{1 x n_rec}
    end
    
    methods
        function obj = file_manager(study_name_or_path)
            %
            %
            %   obj = file_manager(*study_name_or_path)
            %
            %   study_name : must match the folder name that you wish to
            %   read in the base study folder
            %
            %   base_study_folder/[study_name]/something.iom
            %
            %   OR
            %
            %   study_path = 'C:/path/to/my_study/ which contains a .iom
            %   file
            %
            
            if ~exist('study_name_or_path','var') || isempty(study_name_or_path)
                [iom_file_name, base_path] = uigetfile( ...
                    {'*.iom', 'InterOperative Mon. (*.iom)'},'Please select an IOM file');
                if iom_file_name == 0
                   %Eventually it might be nice to output a null ... 
                   error('User canceled') 
                end
            else
                if exist(study_name_or_path,'dir')
                    base_path = study_name_or_path;
                    %We expect a single data (*.iom file)
                    %---------------------------------------------------------------
                else
                    %Input is thought to be a name, not a folder
                    study_name_local = study_name_or_path;

                    %Get the base path from the user_options
                    user_options_obj = epworks.user_options.getInstance;
                    base_path        = fullfile(user_options_obj.study_parent_folder,study_name_local);
                end 
                iom_file_name = '';
            end
            
            %fileparts with a trailing file separator only strips the file
            %separator, not the directory name
            if base_path(end) == filesep
               base_path(end) = [];
            end
            
            %base_path - path to study folder
            %which contains .iom file
            
            [~,obj.study_name] = fileparts(base_path);
            
            %Resolve iom file name if empty (i.e. not selected by user)
            if isempty(iom_file_name)
               iom_file_struct = dir(fullfile(base_path,'*.iom'));
               if length(iom_file_struct) ~= 1
                   error('Unable to find singular .iom file in:\n%s\n',base_path);
               end
               iom_file_name = iom_file_struct.name;
            end

            obj.iom_file_path = fullfile(base_path,iom_file_name);
            
            history_base_path = fullfile(base_path,'History');
            
            obj.history_dat_path = fullfile(history_base_path,'History.dat');
            
            %TODO: replace with directory enumerator
            %-----------------------------------------------------------
            note_file_struct = dir(fullfile(history_base_path,'*.NOT'));
            all_note_names   = {note_file_struct.name};
            not_backup_mask  = cellfun('isempty',regexp(all_note_names,'_BAK\d+\.NOT$','once'));
            note_file_name   = all_note_names(not_backup_mask);
            if length(note_file_name) ~= 1
                if ~isempty(note_file_name)
                    error('More than one note file found, unhandled case')
                end
                obj.notes_file_path = '';
            else
                obj.notes_file_path = fullfile(history_base_path,note_file_name{1});
            end
            
            
            
            tst_folder_names_local = epworks.RNEL.listNonHiddenFolders(history_base_path);
            
            n_tst = length(tst_folder_names_local);
            
            tst_file_paths_local = cell(1,n_tst);
            rec_file_paths_local = cell(1,n_tst);
            
            for iTST = 1:n_tst
                cur_tst_base_path = fullfile(history_base_path,tst_folder_names_local{iTST});
                
                tst_file_struct = dir(fullfile(cur_tst_base_path,'*.TST'));
                if isempty(tst_file_struct)
                    continue
                elseif length(tst_file_struct) ~= 1
                    error('Unhandled case')
                else
                    tst_file_paths_local{iTST} = fullfile(cur_tst_base_path,tst_file_struct.name);
                end
                
                %ASSUMPTION: If there are no tst files, there are no rec files
                
                rec_file_struct = dir(fullfile(cur_tst_base_path,'*.REC'));
                if ~isempty(rec_file_struct)
                    rec_file_paths_local{iTST} = epworks.sl.dir.fullfileCA(cur_tst_base_path,{rec_file_struct.name});
                end
            end
            
            obj.tst_file_paths = tst_file_paths_local;
            obj.tst_folder_names = tst_folder_names_local;
            obj.rec_file_paths = rec_file_paths_local;
            
        end
    end
end

