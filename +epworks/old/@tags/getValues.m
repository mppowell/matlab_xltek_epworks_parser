function getValues(obj)
%
%   getValues(obj)
%
%   This is the main method for populating values of objects. The string
%   values are populated elsewhere.
%

%Improvement:
%   - take all ids then sort and dole out those indices to those
%   that care
%
%   all_names_to_match = [a b c d e]
%   [ispresent,loc] = ismember(all_names_to_match,tag_names)
%   


   helper__getTimestampValues(obj)
   
   helper__getIDs(obj)
   
   helper__getDoubles(obj)
   
   helper__getIntegers(obj)
   
   helper__getSourceData(obj)
   %keyboard
   
   %NON-4,5,6 data type values still not converted:
   %- 'AcquisitionTimeZone'    'FullScreen'    'Minimized'    'StartWaiting'
   
end

function helper__getSourceData(obj)

   I_use = find(obj.tag_data_type == 3 & strcmp(obj.tag_names,'SourceData')');

   if isempty(I_use)
       return
   end
   
   n_values = length(I_use);
   
   %The first 20 values are the same, not sure what they indicate ...
   % 124    9    0    0  255  127    0    0    0  128  171   49  139 65  255  255    3    0   88    2

   data_starts_local = obj.tag_data_starts(I_use) + 28;
   data_ends_local   = obj.tag_data_ends(I_use);

   ustr = obj.raw_ustr;
   
   
   
   
   
   
   
   
   
%    %We'll just let this fail if it does ...
%
   data_lengths = data_ends_local - data_starts_local;
   if ~all(data_lengths == data_lengths(1))
       error('Assumption of same size of SourceData was violated')
   end
   
   all_data = zeros(data_ends_local(1)-data_starts_local(1)+1,n_values,'uint8');
   
   for iValue = 1:n_values
      all_data(:,iValue) = ustr(data_starts_local(iValue):data_ends_local(iValue)); 
   end

   temp_values = double(epworks.RNEL.typecastC(all_data,'single',true));
   
   temp_cell = cell(1,n_values);
   for iValue = 1:n_values
      temp_cell{iValue} = temp_values(:,iValue)';
   end
   
   helper__setValues(obj,temp_cell,I_use,6)
   
end

function helper__setValues(obj,values,I_use,method_number)
    obj.tag_values(I_use)            = values;
    obj.tag_value_assigned(I_use)    = true;
    obj.tag_value_set_methods(I_use) = method_number;
end

function temp_table = getExampleTable(obj,I_use,values)
   [temp,IB] = unique(obj.tag_names(I_use));
   temp = temp';
   temp_table = [temp obj.tag_fully_qualified_name_strings(I_use(IB))' values(IB)];
end

function helper__getIntegers(obj)
%     matching_indices = find(obj.tag_data_type == 0 & obj.tag_data_length == 4);
%    [temp,IB] = unique(obj.tag_names(matching_indices));
%    temp = temp';
%    temp_table = [temp obj.tag_fully_qualified_name_strings(matching_indices(IB))'];
   
   [all_data,I_use] = helper__getData(obj,obj.INTEGER_VALUE_TAGS,4);
   
   temp_integer_values = double(epworks.RNEL.typecastC(all_data','uint32'));
      
   helper__setValues(obj,num2cell(temp_integer_values),I_use,5)
   %temp_table = getExampleTable(obj,I_use,num2cell(temp_integer_values))
end

function helper__getDoubles(obj)
   %See Double List with Units in documentation ...
%    matching_indices = find(obj.tag_data_type == 1 & obj.tag_data_length == 8);
%    [temp,IB] = unique(obj.tag_names(matching_indices));
%    temp_table = [temp(:) obj.tag_fully_qualified_name_strings(matching_indices(IB))'];
   
    [all_data,I_use] = helper__getData(obj,obj.DOUBLE_VALUE_TAGS,8);

    temp_double_values = epworks.RNEL.typecastC(all_data','double');
    
    helper__setValues(obj,num2cell(temp_double_values),I_use,4)
    
    %temp_table = getExampleTable(obj,I_use,num2cell(temp_double_values))
    %keyboard
end

function helper__getTimestampValues(obj)

   [all_data,I_use] = helper__getData(obj,obj.TIMESTAMP_TAGS,8);
   
   temp_time_values = epworks.timestampToSeconds(all_data');
   
   helper__setValues(obj,num2cell(temp_time_values),I_use,2)

end

function helper__getIDs(obj)
   %TODO: Should do type = 3 check ...
   
   [all_data,I_use] = helper__getData(obj,obj.ID_TAGS,16);
   
   %This was for getting the list of things I wanted to check
   %In general it is safer to request via name (I think)
   %temp = unique(obj.tag_names(obj.tag_data_type == 3 & obj.tag_data_length == 16));
   
   n_values = length(I_use);
   
   temp = reshape(epworks.RNEL.typecastC(all_data','uint64'),[2 n_values])';
   
   %For debugging - might be temporary ...
   %-----------------------------------
   %obj.all_id_tag_values = temp;
   %obj.I_id_tags         = I_use;
   
   temp_cell = cell(1,n_values);
   for iVal = 1:n_values
      temp_cell{iVal} = temp(iVal,:); 
   end
   
   helper__setValues(obj,temp_cell,I_use,3)
      
end

function [all_data,I_use] = helper__getData(obj,tags_get,data_size)

   %NOTE: We might be able to remove the extra check if we 
   %add on the 5 # # value to each tag which I think might be
   %some enumeration of unique types ...

   I_use = find(obj.tag_data_length == data_size & ismember(obj.tag_names,tags_get)');
      
   n_values = length(I_use);
   
   data_starts_local = obj.tag_data_starts(I_use);
   data_ends_local   = obj.tag_data_ends(I_use);
   
   all_data = zeros(n_values,data_size,'uint8');
   
   ustr = obj.raw_ustr;
   
   for iValue = 1:n_values
      all_data(iValue,:) = ustr(data_starts_local(iValue):data_ends_local(iValue));
   end
end