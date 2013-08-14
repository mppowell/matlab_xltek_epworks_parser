function getStringValues(obj)
%
%   JAH TODO: Document me ...
%

I_char = find(obj.tag_data_type == 2);

n_char_tags = length(I_char);

data_starts_local = obj.tag_data_starts(I_char);
data_ends_local   = obj.tag_data_ends(I_char) - 1; %Remove null termination
str               = obj.raw_str;

temp_strings = cell(1,n_char_tags);
for iChar = 1:n_char_tags
   temp_strings{iChar} = str(data_starts_local(iChar):data_ends_local(iChar));
end

obj.tag_values(I_char) = temp_strings;
obj.tag_value_assigned(I_char) = true;
obj.tag_value_set_methods(I_char) = 1;

end