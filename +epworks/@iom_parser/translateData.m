function translateData(obj)
% 
%   epworks.iom_parser.translateData
%
%   The goal of this function is to take a set of raw bytes from the data
%   file and to convert those bytes into a value. For example, we might
%   take a property like 'CreationTime' from a set of 8 bytes (uint8) to a
%   double which represents a Matlab time and which, via datestr, can be
%   printed as a meaningful date.
%
%   This function makes the assumption that we can parse the data
%   based on the full name of the property.
%
%   i.e., the following would violate this assumption
%
%   EP.data = 3
%   EP.data = 'a'
%
%   since in one case we have a number and in another a string ...

r = obj.raw_objects;
%Class: epworks.raw_object_array

%                    d0: '----- Helper Info -----'
%                 index: 1
%          parent_index: -1
%                 depth: 1
%     total_byte_length: 3862
%           raw_start_I: 41
%             raw_end_I: 3903
%                  name: 'TOP_LEVEL_OBJECT'
%                  type: 5
%               n_props: 1
%              has_data: 1
%          data_start_I: 46
%           data_length: 3857
%            data_value: []
%              raw_data: []
%                parsed: 1
%             full_name: 'EPTriggeredWaveform'
%              children: [1x7 epworks.raw_object]
%      children_indices: [1349 1350 1351 1352 1353 1354 1355]

%See the data object model for help with names:
%CSV file in:
%

%C - constants ...
%---------------------------------------------------------
C.TYPE_0_COLORS = {
    'EPFreerunWaveform.Data.Color'
    'EPTest.Data.Settings.OChans.000.Color'
    'EPTriggeredWaveform.Data.Color'
};

C.TYPE_0_HIGH_U16 = {
    'EPStudy.Data.IOMUIVersionHigh'
    'EPStudy.Data.ProductVersionHigh'
};

C.TYPE_0_OTHERS = {
    'EPGroup.Data.DisplayMode'      %[8 0 1 0] ????
    'EPTest.Data.Settings.GroupDef.000.DisplayMode'
};

%I think this is a single ..., only values observed are NaN which makes a
%lot more sense than 2147483647
C.TYPE_0_FLOAT = {
    'EPTest.Data.Settings.Timelines.000.RestartDelay'
};

%------------------------------------------------------

C.TYPE_1_TIMESTAMPS = {
    'EPStudy.Data.CreationTime'
    'EPStudy.Data.ModificationTime'
    'EPTest.Data.CreationTime'
};

C.TYPE_3_LENGTHS = [2 8 16 172 176 2428 2430];

C.TYPE_4_NAMES = {
    'ChanNames'
    'Channels'
    'Children'    
    'HalfMontageChannels'    
    'InputChannels'    
    'UISettings'
};

C.MAX_DEPTH = 6;

%F - function handles 
F.typeMat   = @epworks.sl.io.typecastMatrix;
F.time1     = @epworks.sl.datetime.msVariantToMatlab;
F.time2     = @epworks.sl.datetime.msBase1601ToMatlab;
F.rows      = @epworks.sl.array.rowsToCell;
F.subsCell1 = @epworks.sl.cell.subsToMatrixByStartsAndLength;
F.subsCell2 = @epworks.sl.cell.subsToCellArrayByStartsAndLengths;

%T - temporary
T.depths     = r.depth;
T.types      = r.type;
T.full_names = r.full_name;
T.fixed_full_names = regexprep(T.full_names,'\.\d{3}','.000');
T.names = r.name;

helper__type0(r,C,T,F)

helper__type1(r,C,T,F)

%type 2 - characters, already processed

helper__type3(r,C,T,F)

%--------------------------------------------------------------------------
%                           Type 4
%--------------------------------------------------------------------------
mask    = T.types == 4 & T.depths <= C.MAX_DEPTH;

all_type_4_data = r.raw_data(mask)';
%len_4_data     = cellfun('length',all_type_4_data);

%Handling Children
%--------------------------------------------------------------------------
%Format:
%
% a a a a
% # of children?
%
%   Then an array of:
%   3 21 0 0 0 b x16
%
%   I am guessing that b x16 is an id
%

children_mask = strcmp(T.names(mask),'Children');

children_data = all_type_4_data(children_mask);

n_children = F.typeMat(F.subsCell1(children_data,1,4),'uint32',false);

%This could be improved significantly with a little bit of effort ...

all_ids_local = cell(1,length(n_children));

I = find(n_children(:)' ~= 0);

for iIndex = I
   temp_data = reshape(children_data{iIndex}(5:end),21,n_children(iIndex))';
   all_ids_local{iIndex} = F.typeMat(temp_data(:,6:end),'uint64',false); 
end

r.data_value(children_mask) = all_ids_local;

%[r(children_mask).data_value] = deal(all_ids_local{:});

%wtf2 = unique(T.names(mask))
%'ChanNames'    'Channels'    'Children'    'HalfMontageChannels'    'InputChannels'    'UISettings'

chan_names_mask = strcmp(T.names(mask),'ChanNames');

chan_names_data = all_type_4_data(chan_names_mask);

if any(~cellfun(@(x) isequal(x,uint8([0 0 0 0])),chan_names_data))
   error('Chan names data not empty, code needs to be adjusted') 
end

channels_mask = strcmp(T.names(mask),'Channels');

channels_data = all_type_4_data(channels_mask);
if any(~cellfun(@(x) isequal(x,uint8([0 0 0 0])),channels_data))
   error('channels data not empty, code needs to be adjusted') 
end

half_montage_mask = strcmp(T.names(mask),'HalfMontageChannels');

half_montage_data = all_type_4_data(half_montage_mask);
if any(~cellfun(@(x) isequal(x,uint8([0 0 0 0])),half_montage_data))
   error('half montage data not empty, code needs to be adjusted') 
end

input_channels_mask = strcmp(T.names(mask),'InputChannels');

input_channels_data = all_type_4_data(input_channels_mask);
if any(~cellfun(@(x) isequal(x,uint8([0 0 0 0])),input_channels_data))
   error('input channels data not empty, code needs to be adjusted') 
end

all_type_4_names = unique(T.names(mask));
missing_names = setdiff(all_type_4_names,C.TYPE_4_NAMES);
if ~isempty(missing_names)
    error('Unhandled type 4 name, code needs to be updated')
end

%We'll ignore uisettings for now ...

% [u_names,IB] = unique(T.fixed_full_names(mask)');
% both = [u_names,num2cell(len_4_data(IB))];

%type 5 - objects, all set

%--------------------------------------------------
%   Type 6 - 16 bytes - IDs
%-------------------------------------------------
mask    = T.types == 6 & T.depths <= C.MAX_DEPTH;

%all_type_6_data = {r(mask).raw_data}';
%len_6_data     = cellfun('length',all_type_6_data);

type_6_data = vertcat(r.raw_data{(mask)});

IDS_cell = F.rows(F.typeMat(type_6_data,'uint64',false));

r.data_value(mask) = IDS_cell;

%[r(mask).data_value] = deal(IDS_cell{:});

% [u_names,IB] = unique(T.fixed_full_names(mask)');
% both = [u_names,num2cell(len_6_data(IB))];

end

function value_out = helper__toColor(value_in)
   %Conversion to true color as double
   %
   %    Go from:
   %    [255 0 128 0] to:
   %
   %    size(value_out)  => [1 1 3] single RBG triple
   %    value_out(1,1,1) => 1
   %    value_out(1,1,2) => 0
   %    value_out(1,1,3) => 0.5ish
   %
   %    image(value_out) shows colors
   
   temp     = typecast(value_in,'uint8');
   value_out = permute(double(temp(1:3)/255),[3 1 2]);
end

function helper__type0(r,C,T,F)
%
%   helper__type0()
%

%--------------------------------------------------------------------------
%              TYPE 0 - We assume these are all 4 bytes
%--------------------------------------------------------------------------
mask = T.types == 0 & T.depths <= C.MAX_DEPTH;
type_0_full_names = T.fixed_full_names(mask);

temp_data = vertcat(r.raw_data{mask});

conv_data = F.typeMat(temp_data,'int32',false);

%These values are timestamps, change to correct number
%then when in cell mode, convert to strings.
% needs_fixin = ismember(type_1_full_names,TYPE_1_UINT64);
% conv_data(needs_fixin) = sl.datetime.msVariantToMatlab(conv_data(needs_fixin));

conv_data_cell = num2cell(double(conv_data)); %NOTE: We'll lose some
%memory but Matlab and non-doubles are not friends ...

needs_fixin = ismember(type_0_full_names,C.TYPE_0_OTHERS);
conv_data_cell(needs_fixin) = F.rows(double(F.typeMat(temp_data(needs_fixin,:),'uint16',false)));

needs_fixin = ismember(type_0_full_names,C.TYPE_0_HIGH_U16);
conv_data_cell(needs_fixin) = num2cell(double(F.typeMat(temp_data(needs_fixin,3:4),'uint16',false)));

needs_fixin = ismember(type_0_full_names,C.TYPE_0_FLOAT);
conv_data_cell(needs_fixin) = num2cell(double(F.typeMat(temp_data(needs_fixin,:),'single',false)));

needs_fixin = ismember(type_0_full_names,C.TYPE_0_COLORS);
conv_data_cell(needs_fixin) = cellfun(@helper__toColor,conv_data_cell(needs_fixin),'un',0);

r.data_value(mask) = conv_data_cell;

%[r(mask).data_value] = deal(conv_data_cell{:});

% [u_names,IB] = unique(fixed_full_names(mask)');
% both = [u_names,conv_data_cell(IB)];

end

function helper__type1(r,C,T,F)

%--------------------------------------------------------------------------
%                           TYPE 1 - 8 bytes
%--------------------------------------------------------------------------
mask    = T.types == 1 & T.depths <= C.MAX_DEPTH;

type_1_full_names = T.full_names(mask);

temp_data = vertcat(r.raw_data{mask});

%sl.datetime.msVariantToMatlab

conv_data = F.typeMat(temp_data,'double',false);

%These values are timestamps, change to correct number
%then when in cell mode, convert to strings.
needs_fixin = ismember(type_1_full_names,C.TYPE_1_TIMESTAMPS);
conv_data(needs_fixin) = F.time1(conv_data(needs_fixin));

conv_data_cell = num2cell(conv_data);

%We'll leave these as timestamps now for sorting ...
%conv_data_cell(needs_fixin) = arrayfun(@datestr,conv_data(needs_fixin),'un',0);

r.data_value(mask) = conv_data_cell;

%[r(mask).data_value] = deal(conv_data_cell{:});
%[u_names,IB] = unique(T.fixed_full_names(mask)');
%both = [u_names,conv_data_cell(IB)];
%--------------------------------------------------------------------------


end

function helper__type3(r,C,T,F)

%--------------------------------------------------------------------------
%                           Type 3 - Yikes!
%--------------------------------------------------------------------------
%2  - uint16?
%8  - timestamps
%16 - ID
%
%'EPStudy.Data.AcquisitionTimeZone' 172 - character?
%
%   Partially, won't parse out for now ...
%
%   E a s t e r n   S t a n d a r d   T i m e    
%   E a s t e r n   D a y l i g h t   T i m e 
%
%
%'EPTest.Data.VersionInfo' - 176 character?
%
%   2 0 0 0 1 0 0 0 - then what looks like 19 doubles (9:160)
%
%   8.51	2.01	1	2	4	1	1	255	1.02	1.04	4	3	0	1	2	3	3	161	0.1
%
%   I = 161:176
%   Finally [0,0,0,0,1,2,2,1,1,2,2,1,2,0,0,0]
%   
%
%   Finally, the source data ...


mask    = T.types == 3 & T.depths <= C.MAX_DEPTH;

type_3_full_names = T.full_names(mask);

n_type_3 = length(type_3_full_names);

all_type_3_data = r.raw_data(mask)';
len_3_data      = cellfun('length',all_type_3_data);

u_lengths = unique(len_3_data);

%Since these values are not all the same length, and since I have no formal
%instructions, it is possible that the length of a value might change
%and then I will parse the data wrong. As I get new examples of what data
%looks like this needs to be updated to handle these differences.
unhandled_lengths = setdiff(u_lengths,C.TYPE_3_LENGTHS);
if ~isempty(unhandled_lengths)
   error('Unhandled type 3 lengths, update to code needed') 
end

conv_data_cell = cell(1,n_type_3);

%Conversion of IDs
%----------------------------------------
mask_len  = len_3_data == 16;
temp_data = vertcat(all_type_3_data{mask_len});
conv_data_cell(mask_len) = F.rows(F.typeMat(temp_data,'uint64',false));

%Timestamp conversion
%--------------------------------------------------------------------------
mask_len  = len_3_data == 8;
temp_data = vertcat(all_type_3_data{mask_len});
uint64_data = F.typeMat(temp_data,'uint64',false);

%arrayfun(@datestr,conv_data(needs_fixin),'un',0);
conv_data_cell(mask_len) = F.rows(F.time2(uint64_data));

%I've only seen 1 value with length 2
%EPTest.Data.Settings.ConfigData.{57CF9D5C-AC2F-11D3-A8CC-00105AA89390}ShowSplitGains'
%--------------------------------------------------------------------------
mask_len  = len_3_data == 2;
if any(mask_len)
    temp_data = vertcat(all_type_3_data{mask_len});
    conv_data_cell(mask_len) = num2cell(F.typeMat(temp_data,'uint16',false));
end

%172 - AcquisitionTimeZone - Not Handled Yet
%--------------------------------------------------------------------------
% mask_len  = len_3_data == 172;
% temp_data = vertcat(all_type_3_data{mask_len});

%176 - EPTest.Data.VersionInfo
%--------------------------------------------------------------------------
% mask_len  = len_3_data == 176;
% temp_data = vertcat(all_type_3_data{mask_len});


%2428, 2430 - 'EPTriggeredWaveform.Data.SourceData'
%--------------------------------------------------------------------------
mask2 = ismember(type_3_full_names,'EPTriggeredWaveform.Data.SourceData');

source_data_length = len_3_data(mask2);

if ~isempty(source_data_length)
    if ~all(source_data_length == source_data_length(1))
       error('Unhandled cases of varying stimulus data length, code needs to be updated') 
    end

    raw_source_data = vertcat(all_type_3_data{mask2});
    s_cell = num2cell(helper__getSourceData(raw_source_data,C,T,F));

    conv_data_cell(mask2) = s_cell;
end

r.data_value(mask) = conv_data_cell;

%[r(mask).data_value] = deal(conv_data_cell{:});

end

function s = helper__getSourceData(raw_source_data,C,T,F)
%Format notes:
%--------------------------------------------------------------
% 
%   a a a a
%   u32 - length of the data ...
%   I = 1:4
%   
%   b b
%   u16? - ??? Not sure what this is
%   I = 5:6
%
%   c c c
%   nulls
%   I = 7:9
%   
%   d d d d d d d d
%   some eight bit ID??? 4 u16s?
%   I = 10:17
%
%   e
%   single byte null
%   I = 18
%
%   f f
%   u16 - # of bytes of data
%   I = 19:20
%   
%   g g g g g g g g 
%   u64 -> timestamp
%   I = 21:28
%
%   h -> the data
%   - # of bytes specified in (f)
%   
%   i i
%   u16????
%   I = last 2 bytes
%   This isn't always present

% a = raw_source_data(:,1:4);
% s.first_unknown_u32 = F.typeMat(a,'uint32',false);

n_rows = size(raw_source_data,1);
%n_cols = size(raw_source_data,2);

s = struct('unknown_16',repmat({{}},1,n_rows));

b  = raw_source_data(:,5:6); 
bc = num2cell(F.typeMat(b,'uint16',false)); %bc - b cell
[s.unknown_u16] = deal(bc{:});

%c
cc = F.rows(raw_source_data(:,7:9));
[s.unknown_null] = deal(cc{:});

%d
d  = raw_source_data(:,10:17);
dc = num2cell(F.typeMat(d,'uint64',false));
[s.unknown_u64]  = deal(dc{:});


%e
ec = num2cell(raw_source_data(:,18));
[s.unknown_null2] = deal(ec{:});

%f
f = raw_source_data(:,19:20);
data_sizes = F.typeMat(f,'uint16',false);
if ~all(data_sizes == data_sizes(1))
   error('Code is not programmed to handle differing data sizes')
end

%g
g = raw_source_data(:,21:28);
gc = num2cell(F.time2(F.typeMat(g,'uint64',false)));
[s.timestamp] = deal(gc{:});


%h
h  = raw_source_data(:,29:29+data_sizes(1)*4-1);
h2 = F.typeMat(h,'single',false);
hc = F.rows(h2);
[s.data] = deal(hc{:});

start_index_i = 29+4*data_sizes(1);

i = raw_source_data(:,start_index_i:end);
ic = F.rows(i);
[s.unknown_end_bytes] = deal(ic{:});

end
