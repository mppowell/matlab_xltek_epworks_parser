function analyzeDarkData(obj)
%
%
%   I wrote this method to explore the bytes in the file
%   that I was not using.
%   
%


%38620 - # of values I am not currently using ...

MAGIC_BEFORE_LENGTH = 10;

u_str   = obj.raw_ustr;

is_dark = true(1,length(u_str));

starts  = obj.tag_name_starts - MAGIC_BEFORE_LENGTH;
ends    = obj.tag_data_ends;

for iTag = 1:obj.n_tags
  is_dark(starts(iTag):ends(iTag)) = false;
end

d_is_dark = diff(is_dark);
I_end   = find(d_is_dark == -1);
I_start = [1 find(d_is_dark == 1)];

run_lengths = I_end - I_start + 1;

%Run lengths occur in 2 common sizes:
%1) 5 => ~ 4100 of ~4700 runs
%2) 34 => occurs 669 times ...

keyboard

I = find(run_lengths == 5);
%4078

temp_5s = zeros(length(I),5,'uint8');
temp_starts = I_start(I);
temp_ends   = I_end(I);

for iRun = 1:length(I)
   temp_5s(iRun,:) = u_str(temp_starts(iRun):temp_ends(iRun));
end

[u5,~,IC5] = unique(temp_5s,'rows');
%334 unique values ...

%Of the 5 values:
%1) varies
%2) always 5
%3) varies
%4) varies
%5) always 0

I = find(run_lengths == 34);
%669 values

temp_34s = zeros(length(I),34,'uint8');
temp_starts = I_start(I);
temp_ends   = I_end(I);

for iRun = 1:length(I)
   temp_34s(iRun,:) = u_str(temp_starts(iRun):temp_ends(iRun));
end

[u34,IB34,IC34] = unique(temp_34s,'rows');


end

