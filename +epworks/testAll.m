function testAll(study_parent_folder)
%
%   epworks.testAll(*study_parent_folder)
%   


if ~exist('study_parent_folder','var')
    user_options_obj = epworks.user_options.getInstance;
    study_parent_folder = user_options_obj.study_parent_folder;
end

all_study_folder_names = epworks.RNEL.listNonHiddenFolders(study_parent_folder);

n_directories = length(all_study_folder_names);
t_all = tic;
for iDir = 1:length(all_study_folder_names)
    cur_dir = all_study_folder_names{iDir};
    fprintf('Loading study %d/%d : %s\n',iDir,n_directories,cur_dir);
    exp_directory_to_load = fullfile(study_parent_folder,cur_dir);
    t = tic;
    epworks.main(exp_directory_to_load);
    fprintf('Study load time: %0.3fs\n',toc(t));
end
fprintf('Total time elapsed: %0.3f\n',toc(t_all));

end