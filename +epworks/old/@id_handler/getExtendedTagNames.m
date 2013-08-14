function getExtendedTagNames(obj)
%
%   getExtendedTagNames(obj)
%
%   This creates the full name of each object relative to
%   the top level, for example:
%   
%   Visible, will become:
%   Data.UISettings.Settings.Visible
%
%   NOTE: We still require the type to know what this is
%
%   For this example we see that Data.Type = 'EPTriggeredWaveform'
%
%   This is only called upon request because it ends up taking a long
%   time to implement with the string concatenation and it isn't normally
%   used in analysis.
%
%   FULL PATH:
%   epworks.id_handler.getExtendedTagNames



t               = obj.tag_obj;
tag_names_local = t.tag_names;
n_tags          = t.n_tags;

depth_values_local = obj.all_depths_2;

%Temporary variable for faster concatenation
%i.e. instead of concatenating every depth on every iteration
%we only concatenate with the previous depth's full name
cur_strings_by_depth = cell(1,obj.max_depth);

full_tag_names_without_types_temp = cell(1,n_tags);

for iTag = 1:n_tags
   cur_depth    = depth_values_local(iTag);
   cur_tag_name = tag_names_local{iTag};
      
   if cur_depth == 1
      %This cases avoids indexing into a non-existant parent level
      cur_strings_by_depth{1} = cur_tag_name;
   else
      cur_strings_by_depth{cur_depth} = [cur_strings_by_depth{cur_depth-1} '.' cur_tag_name]; 
   end
   
   full_tag_names_without_types_temp(iTag) = cur_strings_by_depth(cur_depth);
end
    
%Property assignment
%-----------------------------------
obj.full_tag_names_sans_type = full_tag_names_without_types_temp;

end