classdef study < epworks.RNEL.handle_light
    %
    %   Class:
    %   epworks.study
    %
    %   A study is the highest level object in the file.
    
    %   Adding a new object
    %   -----------------------------------------------
    %   1) Create object of type, call in constructor
    %   2) modify epworks.study.createLinks
    %
    
    
    %TODO:
    %1) Finish Excel importing - stimulus locations ...
    %
    %2) Move all initialization code of types
    %into epworks.type for better documentaton and less errors
    
    properties
        %.study()
        study_name  %Name of the study for reference. This could be useful
        %if combining objects from multiple studies. With the links that
        %are in place between objects, it is possible to get the study name
        %of each object by getting parent objects. 
        %
        %   See:
        %   epworks.type.matlab_parent
    end
    
    properties (Constant,Hidden)
       TOP_LEVEL_OBJECTS = {'groups' 'sets' 'tests' 'traces' ...
           'triggered_waveforms' 'freerun_waveforms'};
    end
    
    properties
        %.study()
        d1 = '------  Study Objects ------'
        groups                %Class: epworks.type.groups
        sets                  %Class: epworks.type.sets
        %I remove the baseline and raw_sweep_sets in:
        %epworks.study.additionalLinkHandling
        
        tests                 %Class: epworks.type.tests
        traces                %Class: epworks.type.ep_trace
        triggered_waveforms   %Class: epworks.type.triggered_waveforms
        freerun_waveforms     %Class: epworks.type.ep_freerun_waveform
        
        %.epworks.study.additionalLinkHandling()
        group_baseline_sets   %Class: epworks.type.sets
        group_raw_sweep_sets  %Class: epworks.type.sets
        
        notes                 %Class: epworks.notes
        

    end
    
    %Parsing objects ======================================================
    properties
        d3 = '-----  File Parsing Info  ------'
        tags         %Class: epworks.tags
        
        %In retrospect this is a bad name and should be changed ...
        id_handler   %Class: epworks.id_handler
        
        id_manager   %epworks.id_manager
    end
    
    %Some testing functions  ==============================================
    methods (Static,Hidden)
        function test(study_name__or__study_folder)
            %
            %   epworks.study.test(*study_name__or__study_folder)
            %
            %   This method was written to allow calling this class without
            %   providing an output which makes it easier to make changes
            %   and have classes be cleared since no instances of the class
            %   are in the base workspace.
            %
            %   i.e. if you call:
            %   epworks.study(study_name);
            %
            %   Then the variable 'ans' will have an instance of this class
            %   in memory. Changes to this class without deleting this
            %   variable will likely throw an error as the class has
            %   changes.
            %
            %   Instead, if you call this method, no instances of the class
            %   should exist. This means that when the class is changed, it
            %   is reparsed and you are always running the latest version
            %   of the class code.
            
            epworks.study(study_name__or__study_folder);
        end
        function allDirLoadTest(study_parent_folder)
            %allDirLoadTest
            %
            %    epworks.study.allDirLoadTest(*study_parent_folder)
            %
            %   This is a method I wrote that loads each study into memory,
            %   verifying that I can parse each study.
            %
            %   OPTIONAL INPUTS
            %   ===========================================================
            %   study_parent_folder : (default -> read from options file)
            %           This should point to a folder which contains
            %           studies; not a study folder, but a folder that
            %           contains study folders.
            %   
            
            if ~exist('study_parent_folder','var')
                study_parent_folder = epworks.study.getDefaultStudyParentDirectory();
            end
            
            all_study_folder_names = epworks.study.getAllStudyFolders(study_parent_folder);
            
            n_directories = length(all_study_folder_names);
            t_all = tic;
            for iDir = 1:length(all_study_folder_names)
                cur_dir = all_study_folder_names{iDir};
                fprintf('Loading study %d/%d : %s\n',iDir,n_directories,cur_dir);
                exp_directory_to_load = fullfile(study_parent_folder,cur_dir);
                t = tic;
                epworks.study(exp_directory_to_load);
                fprintf('Study load time: %0.3fs\n',toc(t));
            end
            fprintf('Total time elapsed: %0.3f\n',toc(t_all));
        end
    end
    
    %Pathing ==============================================================
    methods  (Static,Hidden)
        function exp_directory = resolveExperimentDirectory(study_name__or__study_folder)
            %resolveExperimentDirectory
            %
            %   exp_directory = epworks.study.resolveExperimentDirectory(study_name__or__study_folder)
            %
            %   This method allows you to pass in either the name of a
            %   study or the full path to the study folder
            %
            %   INPUT
            %   ===========================================================
            %   study_name__or__study_folder : This can either be:
            %       1) study_name   : name of the study to read
            %       2) study_folder : a path to the study folder
            %
            %   OUTPUT
            %   ===========================================================
            %   exp_directory : path to the study folder
            
            if exist(study_name__or__study_folder,'dir')
                exp_directory = study_name__or__study_folder;
                %We expect a single data (*.iom file)
                %---------------------------------------------------------------
            else
                %Input is thought to be a name, not a folder
                study_name_local = study_name__or__study_folder;
                
                %Get the base path from the user_options
                user_options_obj = epworks.user_options.getInstance;
                exp_directory    = fullfile(user_options_obj.study_parent_folder,study_name_local);
            end
        end
        function iom_file_path = getIOMFilePath(exp_directory)
            %getIOMFilePath
            %
            %   iom_file_path = epworks.study.getIOMFilePath(exp_directory)
            %
            %   The iom file (extension .iom) is the main data file. This
            %   is a simple function to return the path to that file.
            
            data_file_path_struct = dir(fullfile(exp_directory,'*.iom'));
            if length(data_file_path_struct) ~= 1
                error('Unable to find singular .iom data file, unhandled case')
            end
            
            iom_file_path = fullfile(exp_directory,data_file_path_struct.name);
        end
        function all_study_folder_names = getAllStudyFolders(study_parent_folder)
            %getAllStudyFolders
            %
            %   all_study_folder_names = getAllStudyFolders(*study_parent_folder)
            %
            %   INPUTS
            %   ===========================================================
            %   study_parent_folder : (default -> read from options file), 
            %               folder that contains a set of studies
            %
            %   OUTPUTS
            %   ===========================================================
            %   all_study_folder_names : (cellstr), list of study folders
            %               in the parent directory
            
            if ~exist('study_parent_folder','var')
                study_parent_folder = epworks.study.getDefaultStudyParentDirectory();
            end
            all_study_folder_names = epworks.RNEL.listNonHiddenFolders(study_parent_folder);
        end
        function study_parent_folder = getDefaultStudyParentDirectory()
            user_options_obj    = epworks.user_options.getInstance;
            study_parent_folder = user_options_obj.study_parent_folder;
        end
    end
    
    %PATHING CONTINUED ====================================================
    methods (Static)
        function study_names = getStudyNames(study_parent_folder)
            %getStudyNames
            %
            %   study_names = getStudyNames(*study_parent_folder)
            %
            %   Returns a list of study names that are in the folder
            %
            %   INPUTS
            %   ===========================================================
            %   study_parent_folder : (default -> uses options), should
            %       point to a folder that contains one or more study folders
            
            if ~exist('study_parent_folder','var')
                study_parent_folder = epworks.study.getDefaultStudyParentDirectory();
            end
            study_names = epworks.study.getAllStudyFolders(study_parent_folder);
        end
    end

    %Constructor Call =====================================================
    methods (Hidden)
        function obj = study(study_name__or__study_folder)
            %study
            %
            %   obj = epworks.study(study_name__or__study_folder)
            %
            %   TODO
            %   ===========================================================
            %   1) Allow a cell array of study names to return an array of
            %   objects. This might be better implemented by a call to a
            %   static method since in older versions of Matlab there can
            %   be a memory leak when creating multiple objects in the
            %   constructor.
            %
            
            exp_directory = obj.resolveExperimentDirectory(study_name__or__study_folder);
            
            [~,obj.study_name] = fileparts(exp_directory);
            
            %The iom file is the main data file.
            iom_file_path      = obj.getIOMFilePath(exp_directory);
            
            %Notes
            %--------------------------------------------------------------
            obj.notes = epworks.notes(exp_directory);
            
            %Reading of file into memory
            %--------------------------------------------------------------
            %These files tend to be pretty small. We'll read the entire
            %thing into memory and do our processing on that.
            fid      = fopen(iom_file_path,'r');
            raw_ustr = fread(fid,[1 Inf],'*uint8');
            fclose(fid);
            
            raw_str = char(raw_ustr);
            
            %Initial processing of the file data
            %---------------------------------------------------------------
            obj.tags       = epworks.tags(raw_str,raw_ustr);
            
            obj.id_handler = epworks.id_handler(obj.tags);

            %==============================================================
            %               MAIN OBJECT POPULATION
            %==============================================================
            
            
            %TRIGGERED WAVEFORMS
            %--------------------------------------------------------------
            %NOTE: triggered waveforms are not necessarily stored in order
            obj.triggered_waveforms = sortByTimestamp(obj.getObjectsOfType(...
                'EPTriggeredWaveform','epworks.type.ep_triggered_waveform',[1 2]));
            %
            %   [1 2] specifies that we only want objects and properties
            %   that are at depths 1 or 2. Unfortunately (or fortunately?)
            %   we don't maintain depth information when creating the final
            %   objects. As an example we might have (made up props)
            %
            %   trig.data       = 
            %   trig.source     = 
            %   trig.display.x  =
            %   trig.display.y  = 
            %
            %   We might only return in this case, data and source names
            %   and values.
            %
            %   NOTE: This could potentially cause problems if we had
            %   something like
            %
            %   trig.display.source
            %   
            %   and we didn't filter out a depth of 3, because now we would
            %   have two source properties, only one of which would be kept.
            %
            
            %Here we do the software filtering that the data specifies
            %NOTE: This can be changed in the program. We also store a copy
            %of the original data so that it could be refiltered without
            %reloading from the file.
            filterData(obj.triggered_waveforms);
            
            %This is a method of triggered waveforms:
            setupNoteInfo(obj.triggered_waveforms,obj.notes.entries)
            
            %Other objects
            %_-------------------------------------------------------------
            %epworks.type.sets.sortBySetNumber
            obj.sets = sortBySetNumber(obj.getObjectsOfType('EPSet','epworks.type.ep_set',[-1 0])); 
            %Use of -1 implies no filtering on depth
            
            obj.groups = obj.getObjectsOfType('EPGroup','epworks.type.ep_group',[-1 0]);
            
            obj.traces = obj.getObjectsOfType('EPTrace','epworks.type.ep_trace',[-1 0]);
            
            obj.tests = sortByCreationTime(obj.getObjectsOfType('EPTest','epworks.type.ep_test',[1 2]));

            obj.freerun_waveforms = obj.getObjectsOfType('EPFreerunWaveform','epworks.type.ep_freerun_waveform',[1 2]);
            
            %Creation of objects in the test class
            %--------------------------------------------------------------
            %Function inputs:
            %1) Name of the object 
            %2) Subtype to further filter on, leave empty if not necessary
            %3) name of class to create
            %4) property name in the test object to assign to
            setEPTestClassObjects(obj,'OChans',     '',             'epworks.type.ochans',             'ochans')
            setEPTestClassObjects(obj,'IChans',     '',             'epworks.type.ichans',             'ichans')
            setEPTestClassObjects(obj,'Stims',      'Electrical', 	'epworks.type.electrical_stim',    'electrical_stims')
            setEPTestClassObjects(obj,'Stims',      'TceMEP',      	'epworks.type.tcemep',             'tcemep_stims')
            setEPTestClassObjects(obj,'Electrodes', '',             'epworks.type.electrode',          'electrodes')
            setEPTestClassObjects(obj,'GroupDef',   '',             'epworks.type.groupdef',           'groupdefs')
            
            %Not implemented ...
            %            setEPTestClassObjects(obj,'Electrodes','epworks.type.electrode','auditory_stims')
            %            setEPTestClassObjects(obj,'Electrodes','epworks.type.electrode','external_stims')
            %            setEPTestClassObjects(obj,'Electrodes','epworks.type.electrode','visual_stims')
            
            %Linking code
            %--------------------------------------------------------------
            %See: epworks.study.createLinks
            %
            %   NOTE: It is very important this this method call follows
            %   population of all objects.
            %
            %TODO: Implement backwards linking as well ...
            %obj.createLinks;
            obj.id_manager = epworks.id_manager(obj.tags,obj.id_handler,obj);

                     
            
            %   :/  I am not sure why I placed this informaton
            %The groups are sorted based on which groupdef they belong
            %to ..., as well as what test they belong to
            %
            %I was still a bit unclear with the sorting
            %
            %This needs to come after the linking when the groupdef
            %is no longer a pointer
            obj.groups = sort(obj.groups);
            
            %I am probably going to change this ...
            obj.additionalLinkHandling;
            
            
            %Not yet finished
            

            %Not yet finished
            %--------------------------------------------
            %obj.detectButtonPushes;
        end
    end
    
    %Constructor helper functions =========================================
    methods (Hidden)
        %NOTE: Since these are only used by the constructor they would be 
        %better off as helper functions
        function setEPTestClassObjects(obj,tag_name_filter,sub_type_filter,matlabClassName,epPropertyName)
            %
            %   setEPTestClassObjects(obj,iomClassName,matlabClassName,epPropertyName)
            %
            %   INPUTS
            %   ===========================================================
            %
            %               %Function inputs:
            %       1) Name of the object 
            %       2) Subtype to further filter on
            %       3) name of class to create
            %       4) property name in the test object to assign to
            %
            %   Documentation Unfinished
            
            tests_indices = [obj.tests.object_index];
            
            h_id = obj.id_handler;
            
            for iObject = 1:length(tests_indices)
                
                cur_test_index   = tests_indices(iObject);
                
                child_indices_1          = h_id.getChildrenObjectIndices(cur_test_index,1);
                
                child_indices_1_filtered = h_id.filterIndicesByTagName(child_indices_1,tag_name_filter);
                
                child_indices_2          = h_id.getChildrenObjectIndices(child_indices_1_filtered,1);
                
                if ~isempty(sub_type_filter)
                    child_indices_final = h_id.filterIndicesByTypeName(child_indices_2,sub_type_filter);
                else
                    child_indices_final = child_indices_2;
                end
                
                if ~isempty(child_indices_final)
                    pv_struct        = getDataForObjects(obj,child_indices_final,matlabClassName,[3 3]);
                    obj.tests(iObject).(epPropertyName) = ...
                        instantiateObjects(obj,pv_struct,matlabClassName,child_indices_final);
                else
                    obj.tests(iObject).(epPropertyName) = feval([matlabClassName '.empty']);
                end
            end
        end
        function object_array = getObjectsOfType(obj,top_level_type,type_function_string,depth_filter_range)
            %
            %   object_array = getObjectsOfType(obj, top_level_type, type_function_string, depth_filter_range)
            %
            %   INPUTS
            %   ===========================================================
            %   tag_name_filter      : There is a list of top-level tags 
            %           somewhere :/ that this filters by first.
            %   type_function_string : This is a string of the class to
            %           create using the filter results.
            %   depth_filter_range
            %   
            %   EXAMPLE INPUT
            %   -----------------------------------------------------------
            %   obj.getObjectsOfType('EPTest','epworks.type.ep_test',[1 2]);
            %
            
            object_indices = obj.id_handler.getUniqueObjects_ByType(top_level_type);
            
            pv_struct      = getDataForObjects(obj,object_indices,type_function_string,depth_filter_range);
            
            object_array   = instantiateObjects(obj,pv_struct,type_function_string,object_indices);
        end
        function object_array = instantiateObjects(obj,pv_struct,typeFunctionString,object_indices)
            %
            %   object_array = instantiateObjects(obj,pv_struct,typeFunctionString,object_indices)
            %
            %   Documentation Unfinished
            
            n_objects_of_type = length(pv_struct.Istart);
            
            %NOTE: I might not need a link to the parent object
            %So I might be able to move this into the constructor
            %of the child and still avoid a memory leak
            for iObject = 1:n_objects_of_type
                
                cur_start = pv_struct.Istart(iObject);
                cur_end   = pv_struct.Iend(iObject);
                
                object_array(iObject) = feval(...
                    typeFunctionString,...
                    obj,...
                    pv_struct.prop_names(cur_start:cur_end),...
                    pv_struct.prop_values(cur_start:cur_end));
                
                object_array(iObject).object_index = object_indices(iObject);
            end
        end
        function pv_struct = getDataForObjects(obj,object_indices,typeFunctionString,depth_filter_range)
            %
            %    pv_struct = getDataForObjects(obj,object_indices,typeFunctionString,depth_filter_range)
            %
            %   Documentation Unfinished
            
            %TODO: Move into static method of epworks.type
            temp = eval([typeFunctionString '.REQUESTED_VALUES_AND_FUNCTIONS']);
            
            tags_to_get = temp(:,1)';
            new_names   = temp(:,2)';
            
            pv_struct = obj.id_handler.getPropsAndValues(object_indices,...
                tags_to_get,new_names,depth_filter_range(1),depth_filter_range(2));
        end
    end
    
end


