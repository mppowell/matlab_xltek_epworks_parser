function sortObjects(obj)


%1) Sort tests
%--------------------------------------------------------------------------
tests_local = obj.tests;
n_tests    = length(tests_local);

[~,I] = sort([tests_local.CreationTime]);

%Apply sort
obj.tests = obj.tests(I);

test_numbers = num2cell(1:n_tests);
[obj.tests.test_number] = deal(test_numbers{:});

for iTest = 1:n_tests
    cur_test = tests_local(iTest);
    group_def_array = cur_test.Settings.GroupDef;
    group_def_numbers = num2cell(1:length(group_def_array));
    [group_def_array.array_index] = deal(group_def_numbers{:});
end

%2) Sort groups
%--------------------------------------------------------------------------
%??? - how do we know which is #1, #2, etc?
g = obj.groups;
group_tests = [g.test];
group_defs  = [g.group_def];
group_test_numbers = [group_tests.test_number];
group_def_index_numbers = [group_defs.array_index];

[~,I] = sortrows([group_test_numbers(:) group_def_index_numbers(:)]);
obj.groups = obj.groups(I);

%3) Waveforms
%--------------------------------------------------------------------------
tw = obj.triggered_waveforms;
if ~isempty(tw)
   [~,I] = sort([tw.Timestamp]);
   obj.triggered_waveforms = tw(I); 
end

fr = obj.freerun_waveforms;
if ~isempty(fr)
   [~,I] = sort([fr.Timestamp]);
   obj.freerun_waveforms = fr(I);
end



%4) Set organization
%--------------------------------------------------------------------------

%- First we break things into the different types
%- Eventually this should be done on object construction
g = obj.groups;
bs = [g.baseline_set];
rs = [g.raw_sweep_set];

%TODO: This should just be a method
%assignScalarToStructArray()
if ~isempty(bs)
    [bs.is_baseline_set]  = epworks.sl.struct.dealScalar(true);
end
if ~isempty(rs)
    [rs.is_raw_sweep_set] = epworks.sl.struct.dealScalar(true);
end

% true_rep = num2cell(repmat(true,1,length(rs)));
% 
% [rs.is_raw_sweep_set] = deal(true_rep{:});

obj.baseline_sets  = bs;
obj.raw_sweep_sets = rs;

s    = obj.sets;
mask = [s.is_baseline_set] | [s.is_raw_sweep_set];
s(mask)  = [];
obj.sets = s;


%groups
%-> baseline_sets
%-> raw_sweep_set

