function getTopLevelDivisions(obj)
%getTopLevelDivisions
%
%   getTopLevelDivisions(obj)
%
%   With some fiddling around with the numbers, it seems like
%   adding 20 gives a good specification for the true length of the group.
%   These groups cover all tags. Where one group ends, another begins (with
%   no overlap)
%
%   ?? Is this only for the top most level or does it indicate the start of
%   an object
%
%
%   Documentation of code unfinished

CORRECTION_FACTOR = 20;

ustr = obj.raw_ustr;
I_starts = strfind(ustr,obj.TOP_LEVEL_MAGIC_STRING);

n_starts = length(I_starts);

start_length_I = I_starts + length(obj.TOP_LEVEL_MAGIC_STRING);

start_lengths_uint8 = zeros(4,n_starts,'uint8');

%JAH NOTE: This would be more efficient if unrolled into 4 statements

for iStart = 1:n_starts
    cur_start             = start_length_I(iStart);
    start_lengths_uint8(:,iStart) = ustr(cur_start:cur_start+3);
end

start_lengths = double(typecast(start_lengths_uint8(:),'uint32'))' + CORRECTION_FACTOR;

obj.top_level_raw_starts = I_starts;
obj.top_level_raw_ends   = I_starts + start_lengths;

[I1,I2] = epworks.RNEL.computeEdgeIndices(obj.tag_name_starts,...
    obj.top_level_raw_starts,obj.top_level_raw_ends);

top_level_object_id = zeros(obj.n_tags,n_starts);

for iStart = 1:n_starts
    top_level_object_id(I1(iStart):I2(iStart),iStart) = iStart;
end

obj.top_level_tag_starts = I1;
obj.top_level_tag_ends   = I2;

end