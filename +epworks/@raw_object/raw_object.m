classdef raw_object < handle
    %
    %
    %   epworks.raw_object
    %
    %   This might generalize to the tst files as well ...
    %
    %   IMPROVEMENTS:
    %   -------------------------------------------------------------
    %   I might get a decent speedup on this by removing the handle
    %   usage ...
    
    properties
%         %d0 = '----- Helper Info -----'
%         index %Order in which the object was created
%         parent_index = -1
%         depth = 1
    end
    
    properties
%         %total_byte_length %Total byte length of object
%         raw_start_I
%         raw_end_I
%         name      = 'TOP_LEVEL_OBJECT'
%         full_name   %'a.b.c.d.f' instead of just 'f'
%         type = -1
%         %-1 - no data
%         %0  - length => 4
%         %
%         %   From looking at some things the meaning
%         %   changes depending upon the property
%         %   i32,[u16 u16], etc
%         %
%         %1  - length => 8
%         %   
%         %   Again, meaning seems to be variable
%         %
%         %2  - string
%         %
%         %3  - variable length
%         %
%         %   SourceData is in this example.
%         %   Some IDs look like they are in this example
%         %
%         %5  - objects - see value in children
%         %
%         
%         n_props      %???? -> I think this is what this is ...
%         
%         %d3 = '-----  Data Properties  ------'
%         %has_data     = true;
%         data_start_I = NaN %point to first index after size specifiation
%         data_length  = 0   %NOTE: It is important to have this at 0
%         %as it is used to know if we have data or not.
%         data_value         %This is the final data value. Only type = 2 is 
%         %populated on construction.
%         %raw_data %This is populated with the raw bytes of data from the file
%         %that corresponds to the data section of the object (with the name
%         %and length information removed)
%         children_indices %Indexes of the children in the raw_object array
    end
    
    methods (Static)
        function roa = getIOMrawObjects(raw_data)
            %
            %
            %    epworks.iom_raw_object.getIOMrawObjects
            
            %IOM FORMAT
            %------------------------------------------
            %
            %    First bytes in the file ...
            %    --------------------------------------------------
            %    a a a a a a a a a a a a a a a a b b b b c c c ....
            %
            %    a - 16 byte lead in ID, this is repeated
            %        for every top level object
            %    b - u32, seems to always be 1 (bytes 17 - 20)
            %    c - same as a, but this is the first top level
            %        object
            %        bytes (21 - 36)
            %        The first top level object starts parsing at byte 21.
            %        See 'top level object' definition below.
            %        
            %    For each top level object
            %    -------------------------
            %
            %    c c c c c c c c c c c c c c c c d d d d 5 d d d d e e e e
            %
            %    c - 16 byte lead in
            %        I = 1:16
            %    d - u32, byte length (starting at 5)
            %        I = 17:20
            %    5 - I = 21
            %    d - u32
            %        I = 22:25 <- 2nd instance of d
            
            %    e - # of objects
            %
            %    5 - object identifier
            %
            %    Once we know where the 6's are, we can call
            %    the createRawObjects
            
            INTRO_LENGTH       = 20;
            
            cur_data_index   = INTRO_LENGTH + 1;
%             all_data_objects = cell(1,MAX_NUMBER_OBJECTS);
            cur_obj_index    = 0;
            
            %Initialization of the output
            %------------------------------------
            roa = epworks.raw_object_array;
            
            %Processing of the top-level objects
            %--------------------------------------------------------------
            while cur_data_index < length(raw_data)
                cur_obj_index = cur_obj_index + 1;
                
%                 temp_obj = epworks.raw_object;
%                 temp_obj.index = cur_obj_index;
                
                roa.type(cur_obj_index) = 5;
                
%                 temp_obj.type   = 5;
                
                %We'll skip the ID (c) and the 1st specification
                %of the size (d-1)
                cur_data_index = cur_data_index + 21;
                
                %Length seems to include the 5, and
                %the value itself is an advancement indicator
                total_byte_length = ...
                    double(typecast(raw_data(cur_data_index:cur_data_index+3),'uint32')) - 1;
                
                roa.total_byte_length(cur_obj_index) = total_byte_length;
                    
                %temp_obj.total_byte_length = double(typecast(raw_data(cur_data_index:cur_data_index+3),'uint32')) - 1;
                roa.raw_start_I(cur_obj_index) = cur_data_index - 1;
                
                %temp_obj.raw_start_I = cur_data_index - 1;
                
                %temp_obj.n_props  = 1; %We'll make this look
                %like most other objects for now ...
                
                roa.data_start_I(cur_obj_index) = cur_data_index + 4;
                roa.data_length(cur_obj_index)  = total_byte_length - 5;
                
                %temp_obj.data_start_I = cur_data_index + 4;
                %temp_obj.data_length  = temp_obj.total_byte_length - 5;
                
                cur_data_index = cur_data_index + total_byte_length;
                
                %cur_data_index = cur_data_index + temp_obj.total_byte_length;
                %NOTE: At this point we point to another (c)
  
                %temp_obj.raw_end_I   = cur_data_index - 1;
                
                %all_data_objects{cur_obj_index} = temp_obj;
            end
            
            new_parent_indices = 1:cur_obj_index;
            roh = epworks.raw_object_helper(raw_data,roa,cur_obj_index);
            
            roa = epworks.raw_object.recursiveGetAllObjects(roh,cur_obj_index,new_parent_indices);
            
            epworks.raw_object.applyCharDataValues(roa,roh)
            epworks.raw_object.createFullNames(roa,true);
            epworks.raw_object.finalizeObjects(roa,roh)
        end
        function roa = getTSTrawObjects(raw_data)
            %
            %
            %   epworks.iom_raw_object.getTSTrawObjects
            %
            START_BYTE       = 82; %point to first value after:
            %5 a a a a
            %
            %   (a) is a u32 representing the size
            %
            %5 is proceeded by a bunch of nulls
            
            cur_obj_index    = 0;
            
            roa = epworks.raw_object_array;
            
            roh = epworks.raw_object_helper(raw_data,roa,cur_obj_index);
            
            %Yikes, this is a bit of a hack ...
            roh.depth = 0;
            %The roh code is setup to assume that we have already specified
            %the first level ...
            
            new_parent_indices = -1*START_BYTE; %Look away :/
            %See the hack I put in createRawObjects for when no
            %parents are actually present, instead we point to
            %the start index, the negative value indicates the difference
            %in interpretation between true parent_indices and the start
            %value
            
            roa = epworks.raw_object.recursiveGetAllObjects(roh,cur_obj_index,new_parent_indices);

            epworks.raw_object.applyCharDataValues(roa,roh)
            epworks.raw_object.createFullNames(roa,false);
            epworks.raw_object.finalizeObjects(roa,roh)
        end
        function roa = recursiveGetAllObjects(roh,cur_obj_index,new_parent_indices)
            %
            %   epworks.raw_object.recursiveGetAllObjects(roh,cur_obj_index,new_parent_indices)
            %
            %   Inputs
            %   ------
            %   roh : epworks.raw_object_helper
            %       This class holds the raw data, as well as a pointer
            %       to n instance of epworks.raw_object_array
            %   new_parent_indices : 
            %       Indices of the parents in the raw_object_array class
            %       whose children we need to parse.
            
            %TODO: rename, this isn't really recursive
            
            done = false;
            while ~done
                
                starting_obj_index = cur_obj_index+1;
                
                %Main processing call ...
                epworks.raw_object.createRawObjects(roh,new_parent_indices);
                
                cur_obj_index    = roh.cur_obj_index;
                roa = roh.raw_obj_array;
                
                %Analysis of new objects to see if we need to go deeper
                just_added_object_indices = starting_obj_index:cur_obj_index;
                                
                %We only need to parse children for objects have a type of
                %5, all other objects hold terminal values such as a string
                %or number
                new_parent_indices = just_added_object_indices(roa.type(just_added_object_indices) == 5);
                
                done = isempty(new_parent_indices);
            end
            
            roa.trim(cur_obj_index);
        end
        
        function createRawObjects(roh,parent_indices)
            %
            %   epworks.iom_raw_object.createRawObjects(roh,parent_indices)
            %
            %   HACK MODE: for tst files
            %   epworks.iom_raw_object.createRawObjects(roh,-1*start_index)
            %
            %   This creates all children of objects at a specified depth
            %
            %   INPUTS
            %   ------------------------------------------
            %   roh : epworks.raw_object_helper
            
            %NOTE: Initialization of objects takes a fairly significant
            %amount of time. To try and reduce this time I create a bunch
            %of objects all at once (which is faster) and then grab
            %the created objects, one at a time.
            
            
% % %             INIT_OBJ_SIZE   = 5*length(parent_indices);
% % %             GROWTH_SIZE     = 500; %On running out of objects, how many
% % %             %should I get ...
% % %             local_obj_count = 0;
% % %             %tic
% % %             initialized_local_objects(INIT_OBJ_SIZE) = epworks.raw_object;
% % %             %toc
            
            use_hack  = length(parent_indices) == 1 & parent_indices < 1;
            
            raw_data      = roh.raw_data_u8; 
            raw_char_data = roh.raw_data_char;
            raw_data_u32  = roh.raw_data_u32_as_double;
            depth         = roh.getNextDepth; 
            %all_data_objects = roh.all_data_objects;
            cur_obj_index = roh.cur_obj_index;
            roa = roh.raw_obj_array;
            
            %NOTE: Below the parent is used in 3 ways:
            %-------------------------------------------------
            %1) To know where to start parsing in the file
            %2) To assign a parent index
            %3) We assign the children to the parent
            %
            %Currently we don't link backwards, so creating
            %a fake temporary object is no problem as it will be discarded
            %after the loop. The alternative is to propagate the 'if'
            %statement further down the code, which I'd rather not do
            if use_hack
                n_parents = 1;
                data_start_index      = abs(parent_indices);
%                 temp_obj              = epworks.raw_object;
%                 temp_obj.data_start_I = data_start_index;
%                 parent_objects        = {temp_obj};
                parent_indices        = -1;
            else
                n_parents = length(parent_indices);
%                 parent_objects = all_data_objects(parent_indices);
            end
            
            for iParent = 1:n_parents
                %Format:
                %-----------------------------------------------------------
                %b b b b
                %   u32
                %
                %    b - # of objects
                %
                %    Then for each object we have:
                %
                %    --------------------------------------------
                %
                %5 c c c c a a a a 2 d d d d [name] 0 e f f f f
                %   u32              u32
                %
                %  a - I don't know what this is, I've only
                %      see [2 0 0 0] or [1 0 0 0]
                %  c - byte length of child object
                %  d - how far to advance to get to e
                %  e - type
                %  f - pointer to next object, data length is 1 less
                
                %cur_parent_index = parent_indices(iParent);
                %cur_parent_obj   = parent_objects{iParent};
                
                cur_parent_index = parent_indices(iParent);
                
                if use_hack
                   cur_data_index = data_start_index;
                else
                   cur_data_index = roa.data_start_I(cur_parent_index); 
                end
                
                
                
                %(b)
                %----------------------------------------------------------
                n_objects      = raw_data_u32(cur_data_index);
                cur_data_index = cur_data_index + 4;
                %cur_data_index now points to the first child 5
                
                child_start_index = cur_obj_index + 1;
                
                %TODO: Do check on roa
                if cur_obj_index + n_objects > length(roa.parent_index)
                    error('Case not yet supported, need to resize arrays')
                end
                
                roa.parent_index(cur_obj_index+1:cur_obj_index+n_objects) = cur_parent_index;
                roa.depth(cur_obj_index+1:cur_obj_index+n_objects) = depth;


                for iObject = 1:n_objects
                    cur_obj_index = cur_obj_index + 1;
                                        
                    roa.raw_start_I(cur_obj_index) = cur_data_index;
                    
                    %Move past 5 - 5 indicates an object type ...
                    %------------------------------------------------------
                    cur_data_index = cur_data_index + 1;
                    
                    %(c)
                    %------------------------------------------------------
                    
                    total_byte_length = raw_data_u32(cur_data_index);
                    
                    roa.total_byte_length(cur_obj_index) = total_byte_length;
                    
                    %temp_obj.total_byte_length = raw_data_u32(cur_data_index);
                    cur_data_index  = cur_data_index + 4;
                    
                    roa.raw_end_I(cur_obj_index) = roa.raw_start_I(cur_obj_index) + total_byte_length - 1;
                    
                    %temp_obj.raw_end_I = temp_obj.raw_start_I + temp_obj.total_byte_length - 1;
                    
                    %Move past size
                    
                    
                    roa.n_props(cur_obj_index) = raw_data_u32(cur_data_index);
                    
                    %temp_obj.n_props = raw_data_u32(cur_data_index);
                    cur_data_index   = cur_data_index + 4;
                    
                    %Example of n_props = 1
                    %
                    %[5,18,0,0,0,1,0,0,0,2,9,0,0,0,65,103,101,0,5,32,0,0,0,2,0,0,0,2,14,0,0]
                    %            x <- this is unexpected       / \
                    %      normally this is what I call a type  |
                    %
                    %   NOTE: On further inspection, it looks like
                    %   the object ends, and a new object starts
                    %   and there is no data ...
                    %
                    %   *******  IMPORTANT  ******
                    %   ----------------------------------------
                    %   perhaps this indicates how much this object
                    %   has, i.e. this object only has one object
                    %   a character array (type 2)
                    %   instead of most others that have 2 things
                    %   a character array and some data.
                    
                    if raw_data(cur_data_index) ~= 2 
                        error('parse error, I expect a 2 at this location to identify a string') 
                    end
                    cur_data_index = cur_data_index + 1;
                    
                    %(d)
                    %------------------------------------------------------
                    name_length    = raw_data_u32(cur_data_index) - 6;
                    cur_data_index = cur_data_index + 4;
                    
                    roa.name{cur_obj_index} = raw_char_data(cur_data_index:cur_data_index+name_length-1);
                    
                    %temp_obj.name = raw_char_data(cur_data_index:cur_data_index+name_length-1);
                    
                    switch roa.n_props(cur_obj_index)
                        case 2
                            %skip null and go to type
                            cur_data_index = cur_data_index + name_length + 1;
                            
                            %(e)
                            %------------------------------------------------------
                            
                            roa.type(cur_obj_index) = raw_data(cur_data_index);
                            %temp_obj.type  = double(raw_data(cur_data_index)); %#ok<PROP>
                            cur_data_index = cur_data_index + 1;
                            
                            %(f)
                            %------------------------------------------------------
                            roa.data_length(cur_obj_index) =  raw_data_u32(cur_data_index) - 5;
                            %temp_obj.data_length  = raw_data_u32(cur_data_index) - 5;
                            
                            roa.data_start_I(cur_obj_index) = cur_data_index + 4;
                            %temp_obj.data_start_I = cur_data_index + 4;
                        case 1
                            %The prop is just the name, nothing else
                            %temp_obj.has_data = false;
                        otherwise
                            error('unexpected unknown_32 value')
                    end
                    
                    %all_data_objects{cur_obj_index} = temp_obj;
                    cur_data_index = roa.raw_end_I(cur_obj_index) + 1;
                end
                child_end_index = cur_obj_index;
                
                %cur_parent_obj.children         = [all_data_objects{child_start_index:child_end_index}];
                if ~use_hack
                    roa.children_indices{cur_parent_index} = child_start_index:child_end_index;
                    %cur_parent_obj.children_indices = child_start_index:child_end_index;
                end
            end
            
            roh.raw_obj_array = roa;
            roh.cur_obj_index = cur_obj_index;
        end
        function finalizeObjects(roa,roh)
           %epworks.raw_object_helper
           %
           %    
           
           data = roh.raw_data_u8;
            
           mask = roa.type ~= 5 & roa.type ~= 2 & roa.data_length ~= 0;
           
           lengths_local = roa.data_length(mask);
           starts_local  = roa.data_start_I(mask);
           ends_local    = starts_local + lengths_local - 1;

           n = sum(mask);
           raw_data = cell(1,n);
           
           for iIndex = 1:n
               raw_data{iIndex} = data(starts_local(iIndex):ends_local(iIndex));
           end
           roa.raw_data(mask) = raw_data;
        end
        function applyCharDataValues(roa,roh)
            %
            %
            %   For all objects with types == 2 this populates
            %   the property .data_value
            %
            %   type = 2 indicates a character data value
            %
            
%             r      = all_objects_out;
%             types  = [r.type];
%             len    = [r.data_length];
%             starts = [r.data_start_I];
%             ends   = starts + len - 2; %Remove null as well
%             
%             mask = types == 2;
%             char_starts = starts(mask);
%             char_ends   = ends(mask);
%             
%             n_matches   = length(char_starts);
%             char_values = cell(1,n_matches);
            
            all_char_data = roh.raw_data_char;
            mask = roa.type == 2;
            
            char_starts = roa.data_start_I(mask);
            char_ends   = char_starts + roa.data_length(mask) - 2;
            
            n_matches   = length(char_starts);
            char_values = cell(1,n_matches);
            
            for iChar = 1:n_matches
                cur_start = char_starts(iChar);
                cur_end   = char_ends(iChar);
                char_values{iChar} = all_char_data(cur_start:cur_end);
            end
            
            char_values(cellfun('isempty',char_values)) = {''};
            
            roa.data_value(mask) = char_values;
            
            
            %[r(mask).data_value] = deal(char_values{:}); %#ok<NASGU>
        end
        function createFullNames(roa,replace_top_name)
            %
            %   replace_top_name : should be true for iom, false
            %   for the tst file
            %
            %   The iom file infers the name based on the type property
            %   where as the tst file specifies a name for each top level
            %   object
            %
            %   This populates the full name of each object based
            %   on the name given to the property/object, and all
            %   proceeding parent names
            %
            %   'c' might become 'a.b.c'
            
            F.joinStringPairs = @epworks.sl.cellstr.joinStringPairs;
%             
%             r      = all_objects_out;
%             depths = [r.depth];
%             names  = {r.name};
%             types  = [r.type];
%             
%             n_objs = length(depths);
%             
%             child_type_indices = zeros(1,n_objs);
            
            full_names = cell(1,roa.n_objs);
            
            parent_indices = roa.parent_index;
            names          = roa.name;
            
            is_type = strcmp(names,'Type') & roa.type == 2;
            
            %child_type_indices(parent_indices(is_type)) = find(is_type);
            
            
            [uDepth,uI] = epworks.RNEL.unique2(roa.depth);
            
            if replace_top_name
                %For is_type entry, assign its index to its parent
                %So if for an object at 10, it's child is at 20
                %the child will have a parent index at 10, and so at 10
                %we assign the value 20
                child_type_indices = zeros(1,roa.n_objs);
                child_type_indices(parent_indices(is_type)) = find(is_type);
                full_names(uI{1}) = roa.data_value(child_type_indices(uI{1}));
            else
                full_names(uI{1}) = roa.name(uI{1});
            end
            
            max_depth  = max(uDepth);
            for iDepth = 2:max_depth
                cur_names    = names(uI{iDepth});
                parent_names = full_names(parent_indices(uI{iDepth}));
                full_names(uI{iDepth}) = F.joinStringPairs(parent_names,cur_names,'.');
            end
            
            roa.full_name = full_names;
            
        end
    end
    
end

