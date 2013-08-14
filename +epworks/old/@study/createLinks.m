function createLinks(obj)
%createLinks Creates links between different objects.
%
%   createLinks(obj)
%
%   epworks.study.createLinks
%
%   Internally each object is saved with a 128 bit integer which is
%   identified as its "ID" property. In addition, many objects have other
%   properties in their files which are 128 bit integers as well. For
%   example, trace objects, 'epworks.type.ep_trace', have a property called
%   parent. The value of parent is an ID which matches a test object
%   'epworks.type.ep_test' (or more specifically, the value in the 'ID'
%   property of some test object.
%
%   This method should be called after all of the objects are created. Once
%   this is done, each object is asked what it's ID is, as well what other
%   IDs it has (as properties).
%
%   As a simple example, consider the objects a,b, and c, with ID values of
%   1, 2, and 3.
%
%   a.ID = 1
%   a.my_child  = 2
%   a.my_parent = 3
%
%
%   b.ID = 2
%   b.my_parent = 1
%
%   c.ID = 3
%   c.my_child = 1
%
%   A would specify it has an ID of 1, and it wants to get the objects
%   whose ids are 2 & 3. Note, it also specifies that these should be
%   applied to its 'my_child' and 'my_parent' properties respectively.
%   After running 'a' looks like this:
%
%   a.ID = 1
%   a.my_child  = b
%   a.my_parent = c
%
%
%   IMPROVEMENT NOTES:
%   ---------------------------------------------------
%   1) Avoid repmat
%   2) Add another level of indirection to avoid replicating handles
%       => examine need for this after repmat
%   3) Instead of the magic numbers below, identify these properties
%
%
%   See Also:
%   epworks.type.getIDInfo

n_tests = length(obj.tests);

N_MAIN_OBJECTS     = 6;

TEST_OBJECT_PROPERTIES = epworks.type.ep_test.OBJECT_PROPERTIES;

N_TEST_SUB_OBJECTS = length(TEST_OBJECT_PROPERTIES);

all_id_structs    = cell(1,N_MAIN_OBJECTS + N_TEST_SUB_OBJECTS*n_tests);

%Method being used:
%   epworks.type.getIDInfo
all_id_structs{1} = obj.triggered_waveforms.getIDInfo();
all_id_structs{2} = obj.tests.getIDInfo();
all_id_structs{3} = obj.sets.getIDInfo();
all_id_structs{4} = obj.groups.getIDInfo();
all_id_structs{5} = obj.traces.getIDInfo();
all_id_structs{6} = obj.freerun_waveforms.getIDInfo();

cur_index = N_MAIN_OBJECTS;
for iTest = 1:n_tests
    cur_test = obj.tests(iTest);
    %test => epworks.type.ep_test
    
    %TODO: replace with test_sub_objects here
    %cur_test.(test_sub_objects{}).getIDInfo();
    %NOTE: Order is not important here, only that every object
    %gets to contribute its ID, and request the IDs of others
    
    for iTestObject = 1:N_TEST_SUB_OBJECTS
        cur_index = cur_index + 1;
        cur_object_name = TEST_OBJECT_PROPERTIES{iTestObject};
        all_id_structs{cur_index} = cur_test.(cur_object_name).getIDInfo();
    end
    
% % %     %These are objects that get added to test instead of being assigned
% % %     %directly to the study object.
% % %     all_id_structs{cur_index+1} = cur_test.ochans.getIDInfo();
% % %     all_id_structs{cur_index+2} = cur_test.electrical_stims.getIDInfo();
% % %     all_id_structs{cur_index+3} = cur_test.tcemep_stims.getIDInfo();
% % %     all_id_structs{cur_index+4} = cur_test.electrodes.getIDInfo();
% % %     all_id_structs{cur_index+5} = cur_test.groupdefs.getIDInfo();
% % %     all_id_structs{cur_index+6} = cur_test.ichans.getIDInfo();
% % %     cur_index = cur_index + N_TEST_SUB_OBJECTS;
end

%            all_id_structs{1}
%                 ids: [539x2 uint64]
%             handles: {1x539 cell}
%          prop_names: {1x1617 cell}
%     request_handles: {1x871563 cell}
%         request_ids: [1617x2 uint64]

self_ids_all = helper__getStructArrayProp(all_id_structs,'ids',1);
ids_to_get   = helper__getStructArrayProp(all_id_structs,'request_ids',1);

%This is where we match numbers
[ispresent,loc] = ismember(ids_to_get,self_ids_all,'rows');

prop_names_all      = helper__getStructArrayProp(all_id_structs,'prop_names',2);
request_handles_all = helper__getStructArrayProp(all_id_structs,'request_handles',2);
handles_all         = helper__getStructArrayProp(all_id_structs,'handles',2);

%Assignment of the matched objects to the object that requested them
for iProp = 1:length(loc)
    if ispresent(iProp)
        cur_obj   = request_handles_all{iProp};
        link_obj  = handles_all{loc(iProp)};
        prop_name = prop_names_all{iProp};
        cur_obj.(prop_name) = link_obj;
    end
end
end

function output_value = helper__getStructArrayProp(sa,prop_name,cat_dim)
%
%   This concatenates a field from different structures, where each
%   structure is in a cell array element
%
%   output_value = helper__getStructArrayProp(sa,prop_name,cat_dim)
%
%   INPUTS
%   =======================================================================
%   sa : cell array with a structure inside each element.
%        I forget what I meant sa to stand for :/
%   prop_name : name to extract from each structure
%   cat_dim : dimension to concatenate along
%
temp_cell_values = cellfun(@(x) x.(prop_name),sa,'un',0);
output_value     = cat(cat_dim,temp_cell_values{:});
end