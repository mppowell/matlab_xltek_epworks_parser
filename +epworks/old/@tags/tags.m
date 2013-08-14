classdef tags < epworks.RNEL.handle_light
    %
    %   Class:
    %       epworks.tags
    %
    %
    %   NOTE: In retrospect tags is probably a bad name. These can really
    %   be thought of as properties. Given my parsing approach, I first
    %   discovered the properties. Later on I realized that the entire
    
    %REDESIGNS:
    %==========================================
    %1) It would have been better to remove the tag from in front of
    %everything and break things down by type
    %I_name_starts
    %I_name_ends
    %I_data_starts
    %I_data_ends
    %length_data
    
    properties
        d0 = '--- Tag Names and Extents ----'
        %.getTagNamesAndExtents()
        %------------------------------------------------------------------
        tag_names       %(cellstr) Base name of each tag
        tag_name_starts %([1 x n] double) Indices of first char of name
        tag_name_ends   %([1 x n] double) Indices of last  char of name
        n_tags          %# of tags founds
        
        d1 = '--- Data Types, Lengths, Extents ----'
        
        %.getTagDataTypesSizesExtents()
        %------------------------------------------------------------------
        tag_data_type   %([n x 1] double), this value seems to roughly
        %indicate the type of data to expect.
        %
        %   0 - uint32 - all seem to occupy 4 bytes
        %   1 - double - "          "       8 bytes
        %   2 - string -
        %   3 - see notes on lengths below
        %   4 - Object Start Identifier??? - This seems to be reserved
        %       for indicating the start of an object in the file
        %       where following entries are properties of the object being
        %       specified
        %   5 - seems similar to 4
        %   6 -                    - all seem to occupy 16 bytes
        tag_data_length %([n x 1] double) this specifies the length of
        %the object or property (in bytes)
        %
        %   For data type 3, we observe 5 values for length:
        %   ??  - the length of the response source data ...
        %   172 - Acquisition Time Zone - not sure what this is ...
        %   16  - Object IDs
        %   8   - Timestamps
        %   2   - logicals and other simple values uint16????
        %
        tag_data_starts %([1 x n] double) Indices of first byte of data
        tag_data_ends   %([1 x n] double) Indices of last byte of data
        
        top_level_raw_starts  %Indices correspond to places in the file
        %like most of the other indices in this object
        top_level_raw_ends
        top_level_tag_starts  %Indices correspond to tag indices
        top_level_tag_ends
        
        d5 = '----- Tag Values  -----'
        %I'd like to write a function which takes this data and tries
        %to convert the data here ...
        tag_values
        tag_value_assigned      %Should be removed, this is redundant 
        %with set method since if the set method is 0, this indicates 
        %the proprety is not set
        
        tag_value_set_methods
        %0 - not set
        %1 - character strings  .getStringValues()
        %2 - timestamps         .getValues()
        %3 - ids                .getValues()
        %4 - doubles            .getValues()
        %5 - integers           .getValues()
        %6 - sourceDataArrays   .getValues()
        
        %tag_values_colloquial   %- might introduce to specify how each value
        %was set 1) char 2) timestamps 3) Ids, etc
    end
    
    properties
        %.tags()
        raw_ustr  %(uint8) raw uint8 data => uint8(raw_str)
        raw_str   %(char)  raw string data
    end
    
    %Possible Debuggining Content
    %----------------------------------------------------------------------
    %1) - unique tag data type and length combos observed
    %2) - extra content after the specified size ...
    
    properties (Constant,Hidden)
        TAG_IDENTIFIER_MAGIC_STRING = char([0 0 2 0 0 0 2])
        %This set of characters seems to proceed all valid tags.
        %
        %   This seems to always be proceeded by 3 bytes:
        %   5 # #, it is unclear what the function of these 3 bytes are
        %   I think they may indicate some kind of type
        %
        %   This is always followed by 4 bytes:
        %   These 4 bytes are a uint32 specifying the size of the name
        %   after subtracting 6
        
        TOP_LEVEL_MAGIC_STRING = uint8([0,32,198,126,29,67,25,212,17,178,99,0,96,151,25,137,87])
        
        TAG_NAME_REGEXP_PATTERN = '^[A-Z0-9][A-Za-z0-9 ]*'
        %Weirdly it seems ok for variables to start with a #
        %This seems to occur for an array of objects ...
        %Perhaps these will be filtered at the object level
        %NOTE: We only need to match a single character (e.g. X and Y are valid)
        
        OBJECT_TYPE_TAG_NAME = 'Type'
        
        TIMESTAMP_TAGS     = epworks.tags.getConstantTagValues('timestamp')
        
        ID_TAGS            = epworks.tags.getConstantTagValues('id')
        
        DOUBLE_VALUE_TAGS  = epworks.tags.getConstantTagValues('double')
        
        INTEGER_VALUE_TAGS = epworks.tags.getConstantTagValues('integer')
        
    end
    
    methods (Static,Hidden)
        %This helps to initialize the constant values
        %and just hides the values in a function (See constant props
        %in the above section)
        output = getConstantTagValues(type)
    end
    
    %Constructor call =====================================================
    methods
        function obj = tags(str,ustr)
            %
            %   obj = tags(str,ustr)
            %
            %   INPUTS
            %   ===========================================================
            %   str  : Characters read in from the file
            %   ustr : (uint8), byte array of these characters ... 
            
            obj.raw_ustr = ustr;
            obj.raw_str  = str;
            
            %epworks.tags.getTagNamesAndExtents
            obj.getTagNamesAndExtents();
            
            obj.getTagDataTypesSizesExtents();
            
            obj.getTopLevelDivisions();
            
            %Move into getValues, along with getStringValues method ...
            obj.tag_values            = cell(1,obj.n_tags);
            obj.tag_value_assigned    = false(1,obj.n_tags);
            obj.tag_value_set_methods = zeros(1,obj.n_tags);
            
            obj.getStringValues();
            obj.getValues();
            
        end
    end
    
    methods
        %         function displaySummaryDataTagIndex(obj,indices)
        %            %TODO: Finish function
        %            %show name, surrounding data, value, etc
        %
        %            for iIndex = 1:length(indices)
        %               fprintf(2,'Showing results for index: %d\n',indices(iIndex))
        %
        %
        %            end
        %         end
    end
    
    methods (Hidden)
        function getTagNamesAndExtents(obj)
            %
            %
            %   Requires:
            %       Nothing other than starting inputs
            
            tag_name_size_I  = strfind(obj.raw_str,obj.TAG_IDENTIFIER_MAGIC_STRING) + ...
                length(obj.TAG_IDENTIFIER_MAGIC_STRING);
            obj.n_tags = length(tag_name_size_I);
            
            ustr = obj.raw_ustr;
            str  = obj.raw_str;
            
            %Grabbing the name of each tag
            %--------------------------------------------------------------
            tag_name_size_uint8_temp(1,:) = ustr(tag_name_size_I);
            tag_name_size_uint8_temp(2,:) = ustr(tag_name_size_I+1);
            tag_name_size_uint8_temp(3,:) = ustr(tag_name_size_I+2);
            tag_name_size_uint8_temp(4,:) = ustr(tag_name_size_I+3);
            
            %- 6 is to correct for the size specification (4 bytes)
            %which is included in the value returned below as well
            %as the null at the end of the string, as well as some
            %mystery byte :/
            tag_name_lengths = double(typecast(tag_name_size_uint8_temp(:),'uint32'))' - 6;
            
            tag_name_starts_I = tag_name_size_I + 4;
            
            tag_name_ends_I   = tag_name_starts_I + tag_name_lengths - 1;
            
            %27 is the observed max name length ...
            
            
            first_char      = str(tag_name_starts_I);
            ignore_tag_mask = first_char == '{';
            good_tag_mask   = ~ignore_tag_mask;
            
            %Examples of ignored tags:
            % '{BB5CDC30-75CC-11D3-A8A7-00105AA89390}WindowName'
            % '{ED4C5E78-90CF-4CE8-B5EB-010873AEEA1B}CursorViewAbsRelRatio'
            % '{EE11DFC5-A426-11D3-A8C6-00105AA89390}CursorView'
            % '{EE11DFC5-A426-11D3-A8C6-00105AA89390}ViewWidthInDivisions'
            % '{EE11DFC5-A426-11D3-A8C6-00105AA89390}ViewZoomIndex'
            % '{EE11DFC5-A426-11D3-A8C6-00105AA89390}ViewZoomSelect'
            % '{EE11DFC5-A426-11D3-A8C6-00105AA89390}WindowPlacement'
            
            temp_strings    = cell(1,obj.n_tags);
            for iTag = find(good_tag_mask)
                temp_strings{iTag} = str(tag_name_starts_I(iTag):tag_name_ends_I(iTag));
            end

            %Object Property Assignment
            %--------------------------------------------------------------
            obj.tag_name_starts = tag_name_size_I(good_tag_mask) + 4;
            obj.tag_names       = temp_strings(good_tag_mask);
            tag_name_lengths(~good_tag_mask) = [];
            obj.tag_name_ends   = obj.tag_name_starts + tag_name_lengths - 1;
        end
        function getTagDataTypesSizesExtents(obj)
            
            ustr            = obj.raw_ustr;
            tag_info_starts = obj.tag_name_ends + 2;
            obj.n_tags      = length(tag_info_starts);
            temp_tag_info   = zeros(obj.n_tags,5,'uint8');
            %             for iTag = 1:obj.n_tags
            %                 cur_start = tag_info_starts(iTag);
            %                 temp_tag_info(iTag,:) = ustr(cur_start:cur_start+4);
            %             end
            
            temp_tag_info(:,1) = ustr(tag_info_starts);
            temp_tag_info(:,2) = ustr(tag_info_starts+1);
            temp_tag_info(:,3) = ustr(tag_info_starts+2);
            temp_tag_info(:,4) = ustr(tag_info_starts+3);
            temp_tag_info(:,5) = ustr(tag_info_starts+4);
            
            
            %Object Property assignment
            %---------------------------------------------------------------
            obj.tag_data_type   = double(temp_tag_info(:,1));
            
            %The - 5 is a correction for the type and size bytes
            obj.tag_data_length = double(epworks.RNEL.typecastC(temp_tag_info(:,2:5)','uint32')) - 5;
            obj.tag_data_starts = tag_info_starts + 5;
            obj.tag_data_ends   = obj.tag_data_starts + obj.tag_data_length' - 1;
        end
        
    end
    
end