classdef entry < epworks.RNEL.handle_light
    %
    %   CLASS:
    %       epworks.notes.entry
    %
    %   See Also:
    %   epworks.notes
    %
    %   Documentation Unfinished
    
    properties
       title
       comment
       created_time
       created_time_string
    end
    
    %Still debugging these ...
    properties
       null_prop = '------ STILL DEBUGGING THESE -----'
       category
       %Categories appear to be some sort of 16 byte enumerated value
       %[0 3 21 0 0 0] => 21 => go from 7 to 22
       %
       %    Two categories observed, generic and impedance testing
       type 
    end
    
    methods
        function obj = entry(tag_ids,tag_text)
            
           %Do I want to switch to text here ???
           %tag_text = epworks.notes.TAG_LIST(tag_ids);
            
           n_ids = length(tag_ids);
           for iID = 1:n_ids
              cur_ID   = tag_ids(iID);
              cur_text = tag_text{iID};
              switch cur_ID
                  case 1 %Category - ENUMERATED TYPE?
                     stop_index   = typecast(uint8(cur_text(3:6)),'uint32')+1;
                     obj.category = uint8(cur_text(7:stop_index));
                  case 2 %ChangeHistory
                      %Do Nothing
                  case 3 %Comment - TEXT
                      stop_index  = typecast(uint8(cur_text(3:6)),'uint32');
                      obj.comment = cur_text(7:stop_index);
                  case 4 %CreationTimestamp
                      obj.created_time = epworks.sl.datetime.msBase1601ToMatlab(typecast(uint8(cur_text(7:14)),'uint64'));
                      obj.created_time_string = datestr(obj.created_time);
                  case 5 %Creator
                  case 6 %Administrator
                  case 7 %EndTimestamp
                  case 8 %LastChangeTimestamp
                  case 9 %ModificationTimestamp
                  case 10 %StartTimestamp
                  case 11 %Title  - TEXT
                      stop_index  = typecast(uint8(cur_text(3:6)),'uint32');
                      obj.title = cur_text(7:stop_index);
                  case 12 %Type  - ENUMERATED TYPE?
                      %stop_index  = typecast(uint8(cur_text(3:6)),'uint32');
                      obj.type    = uint8(cur_text);
                  case 13 %UserDeleted
              end
           end
           
            
        end
    end
    
end

