classdef notes < epworks.RNEL.handle_light
    %
    %   Class:
    %   epworks.notes
    %
    %   This class holds all of the notes entries. It was the first file
    %   that I tried to parse since the object seemed fairly simple.
    %   
    %
    %   IMPROVEMENTS:
    %   -------------------------------------------------------------------
    %   1) Handle the case of non-existant notes ...
    %
    %   Notes are stored in a different file than the rest of the objects.
    %   This was also the first file that I parsed, as it was much simpler
    %   than the other objects.
    %
    %   See Also:
    %   epworks.notes.entry
    %
    %   Documentation Unfinished
    
    properties
       entries  %Class: epworks.notes.entry
    end
    
    properties (Constant)
        TAG_LIST = {'Category' 'ChangeHistory' 'Comment' 'CreationTimestamp' ...
            'Creator' 'Administrator' 'EndTimestamp' 'LastChangeTimestamp' ...
            'ModificationTimestamp' 'StartTimestamp' 'Title' 'Type' 'UserDeleted'};
        %TIMESTAMPS:
        %------------------------------------------------------------------
        %Followed by: [0 3 13 0 0 0] - not sure of the meaning
        %of [0 3], the next 4 bytes are a uint32, indicating the stopping
        %length, this has always been 13, which indicates the 14th index
        %value (13 is 0 based)
        %i.e. grab from 7:14 => this gives 8 bytes
        %=> convert
        %
    end
    
    %For debugging ...
    properties
       null_prop = '--- DEBUGGING ----'
       raw_str 
       raw_ustr
       tag_id_groups
       tag_text_groups
    end
    
    properties
        TAG_INIT_SIZE = 10000; %Maximum # of expected note tags, this isn't
        %super critical
    end
    
    methods (Hidden)
       [sorted_tag_ids,tag_text] = getTagText(obj)
       [tag_id_groups,tag_text_groups] = tagsToGroups(obj,sorted_tag_ids,tag_text)
    end
    
    methods
        function obj = notes(notes_file_path)
           %
           
           %Reading the file 
           %---------------------------------------------------
           fid = fopen(notes_file_path,'r');
           obj.raw_ustr = fread(fid,[1 Inf],'*uint8');
           fclose(fid);

           obj.raw_str = char(obj.raw_ustr);
           
           %Parsing out text for each object
           %------------------------------------------------------
           [sorted_tag_ids,tag_text] = obj.getTagText();
           
           %Now we need to go from all tags to groups of tags ...
           %--------------------------------------------------------------
           [obj.tag_id_groups,obj.tag_text_groups] = obj.tagsToGroups(sorted_tag_ids,tag_text);
           
           n_groups = length(obj.tag_id_groups);
           
           %I could probably pass this into the constructor to do the loop
           %..., but I really dislike the null call in the constructor ...
           for iGroup = 1:n_groups
              temp_obj(iGroup) = epworks.notes.entry(...
                  obj.tag_id_groups{iGroup},obj.tag_text_groups{iGroup});
           end
           
           times = [temp_obj.created_time];
           [~,I_Sort] = sort(times);
           
           obj.entries = temp_obj(I_Sort);
        end
    end
    
end

