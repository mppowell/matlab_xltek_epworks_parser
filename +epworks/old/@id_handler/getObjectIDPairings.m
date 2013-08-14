function output_ca = getObjectIDPairings(obj)
%
%   This method is for debugging links and is not used normally.
%
%   Performing:
%   ur = uniqueRowsCA(output_ca(:,[1 3]),'rows');
%   was very informative.
%
%  
%   
%
%   Some results from my test file:
%   1) Of the 2228 other ids present, 118 don't link to main ids
%   
%

%For each link:
%host_name
%host tag #
%linked_name
%link tag #

%For example (tag #s made up)

%Consider a link from a triggered waveform to a trace
%            top level type        more specific type  property
%host_name = {EPTriggeredWaveform}EPTriggeredWaveform.Parent
%
%linked_name = {EPTrace}EPTrace.Id


%NOTE: Linked names should only have tags of Id or ID ...

t = obj.tag_obj;
tag_names  = t.tag_names;
tag_values = t.tag_values;

id_tag_I = find(cellfun('isclass',tag_values,'uint64'));

id_tag_names    = tag_names(id_tag_I);
full_tag_names_sans_type  = obj.full_tag_names_sans_type(id_tag_I); 
most_specific_group_id_local  = obj.most_specific_group_id(id_tag_I);
least_specific_group_id_local = obj.least_specific_group_id(id_tag_I); 

most_specific_type_id  = obj.most_specific_type_id__by_group(most_specific_group_id_local);
least_specific_type_id = obj.top_level_types__by_group(least_specific_group_id_local);

most_specific_type_names  = obj.type_names(most_specific_type_id);
least_specific_type_names = obj.type_names(least_specific_type_id);

tags_for_output = cellfun(@(x,y,z) sprintf('{%s}__%s.%s',x,y,z),...
    least_specific_type_names,most_specific_type_names,full_tag_names_sans_type,'un',0);

is_main_id_mask = strcmp(id_tag_names,'Id') | strcmp(id_tag_names,'ID');

main_id_I  = id_tag_I(is_main_id_mask);
other_id_I = id_tag_I(~is_main_id_mask);

main_ids  = vertcat(tag_values{main_id_I});
other_ids = vertcat(tag_values{other_id_I});

tags_for_output_main  = tags_for_output(is_main_id_mask);
tags_for_output_other = tags_for_output(~is_main_id_mask);


[ispresent,loc] = ismember(other_ids,main_ids,'rows');

I_present   = find(ispresent);
loc_present = loc(I_present);
n_present   = length(I_present);
output_ca   = cell(n_present,4);
output_ca(:,1) = tags_for_output_other(I_present);
output_ca(:,2) = num2cell(other_id_I(I_present));
output_ca(:,3) = tags_for_output_main(loc_present);
output_ca(:,4) = num2cell(main_id_I(loc_present));

%Unique_values
%ur = uniqueRowsCA(output_ca(:,[1 3]),'rows');
