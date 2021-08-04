classdef dat_file < epworks.RNEL.handle_light
    %
    %   Class:
    %   epworks.history.dat_file
    %
    %
    %   Improvements:
    %   -------------------------------------------------------------------
    %   1) Most of this is uint32 byte aligned so we can take advantage of
    %   that and read the file faster.
    
    properties
        file_path
        d1 = '----- Intro Properties  -------'
        first_ID
        first_unknown   %I've only ever observed a value of 2
        file_timestamp  %matlab time converted to seconds
        file_timestamp_string %datestr of time
        n_entries
        
        d2 = '-----  Parsed Entries  ------'
        entries %epworks.history.dat_entries
    end
    
    methods
        function obj = dat_file(file_path)
            
            F.toTime     = @epworks.sl.datetime.msBase1601ToMatlab;
            F.typeMatrix = @epworks.sl.io.typecastMatrix;
            
            obj.file_path = file_path;
            
            data = epworks.sl.io.fileRead(file_path,'*uint8');
            
            intro = data(1:80);
            
            %Intro Format
            %--------------------------------------------------
            %1)
            %    - 1:16
            %    - some version/magic string
            %    - 'first_ID'
            %2)
            %    - 17:20
            %    - 'first_unknown'
            %3)
            %    - 21:28
            %    - 'file_timestamp'
            %4)
            %    - 29:44
            %    - null
            %5)
            %    - 45:48
            %    - 'n_segs'
            %6)
            %    - 49:80
            %    - null
                        
            obj.first_ID       = typecast(intro(1:16),'uint64');
            obj.first_unknown  = typecast(intro(17:20),'uint32');
            
            if obj.first_unknown ~= 2
                %What happens when this is not 2?
                error('Assumption violated')
            end
            
            obj.file_timestamp        = F.toTime(typecast(intro(21:28),'uint64'));
            obj.file_timestamp_string = datestr(obj.file_timestamp);
                        
            if ~all(intro(29:44) == 0)
                error('Padded zeros assumption violated')
            end
            
            obj.n_entries = typecast(intro(45:48),'uint32');
            
            if ~all(intro(49:80) == 0)
                error('Padded zeros assumption violated')
            end
            
            %Data Parsing
            %------------------------------------------------------------
            %
            %   Assumed format:
            %
            %a) ID      - u64 x2
            %
            %   I = 1:16
            %
            %b) # items - u32
            %
            %   I = 17:20;
            %
            %c) a series of IDs, followed by a u32 value
            %   
            %   - u64 x2, u32 x1
            %   - this is repeated for the number in (b)
            %
            %d) # items - u32 (seems the same as (b))
            %e) a series of IDs (same as 3, followed by timestamps)
            %
            %   - u64 x2, u64
            
            if obj.n_entries > 0
                s_all(obj.n_entries) = epworks.history.dat_entries;

                %u32_data = typecast(data(81:end),'uint32');

                cur_index = 81;
                for iSeg = 1:obj.n_entries
                    s = s_all(iSeg);

                    s.TraceID = typecast(data(cur_index:cur_index+15),'uint64');
                    cur_index = cur_index + 16;

                    n1 = typecast(data(cur_index:cur_index+3),'uint32');
                    cur_index = cur_index + 4;

                    s.n = n1;

                    %NOTE: Apparently sometimes this can be zero

                    if n1 == 0
                        %When this happens, it seems the next 4 bytes are
                        %always 0
                        if ~all(data(cur_index:cur_index:3) == 0)
                            error('Null padding assumption violated, change code')
                        end
                        cur_index = cur_index + 4;
                        continue
                    end


                    %Part 3
                    %---------------------------------
                    n_bytes   = n1*20;
                    temp      = reshape(data(cur_index:cur_index + n_bytes - 1),20,n1)';
                    cur_index = cur_index + n_bytes;

                    ids1  = temp(:,1:16); %We'll translate later
                    s.u32 = F.typeMatrix(temp(:,17:end),'uint32',false);

                    %Part 4
                    %---------------------------------
                    n2 = typecast(data(cur_index:cur_index+3),'uint32');
                    cur_index = cur_index + 4;

                    if n1 ~= n2
                        error('Same size assumption violated')
                    end

                    %Part 5
                    %---------------------------------
                    n_bytes = n1*24;
                    temp = reshape(data(cur_index:cur_index + n_bytes - 1),24,n1)';
                    ids2 = temp(:,1:16);
                    cur_index = cur_index + n_bytes;

                    if ~isequal(ids1,ids2)
                        error('Same IDs assumption violated')
                    end

                    %Since equal, we can use ids1 or ids2
                    s.IDs = F.typeMatrix(ids1,'uint64',false);

                    s.timestamps = F.toTime(F.typeMatrix(temp(:,17:end),'uint64',false));
                end
                obj.entries = s_all;
            end
            
        end
    end
    
end

