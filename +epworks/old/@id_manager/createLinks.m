function createLinks(obj,study_obj)
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

%Grab information about each object, their IDs, and the properties
%they have which have IDs that need to be matched 
%--------------------------------------------------------------------------
n_test_objects = length(study_obj.tests);

MAIN_OBJECT_PROPERTIES = study_obj.TOP_LEVEL_OBJECTS;
N_MAIN_OBJECTS         = length(MAIN_OBJECT_PROPERTIES);

TEST_OBJECT_PROPERTIES = epworks.type.ep_test.OBJECT_PROPERTIES;
N_TEST_SUB_OBJECTS     = length(TEST_OBJECT_PROPERTIES);

all_id_structs    = cell(1,N_MAIN_OBJECTS + N_TEST_SUB_OBJECTS*n_test_objects);

%Method being used:
%   epworks.type.getIDInfo

for iIndex = 1:N_MAIN_OBJECTS
    cur_prop = MAIN_OBJECT_PROPERTIES{iIndex};
    all_id_structs{iIndex} = study_obj.(cur_prop).getIDInfo();
end

cur_index = N_MAIN_OBJECTS;
for iTest = 1:n_test_objects
    cur_test = study_obj.tests(iTest);
    
    for iTestObject = 1:N_TEST_SUB_OBJECTS
        cur_index       = cur_index + 1;
        cur_object_name = TEST_OBJECT_PROPERTIES{iTestObject};
        all_id_structs{cur_index} = cur_test.(cur_object_name).getIDInfo();
    end
end
%--------------------------------------------------------------------------

%A                 ids: [4x2 uint64]  %ids of these objects
%B             handles: {1x4 cell}    %matlab object references
%         ----------------------------------------------------------
%C          prop_names: {1x24 cell}   %propery names to match
%D     request_handles: {1x24 cell}   %matlab object references
%E         request_ids: [24x2 uint64] %id to match
%
%   NOTE: the 'request_ids' will not be in the set 'ids'

%Somewhere, we have something like:
%B.self_ID    = A
%B.C = E
%
%   When we find an E that matches an A, we grab the corresponding
%   D and replace E with D

%Algorithm, find request_ids that match ids
%for each match, assign to handles the 

%Aggregate results ...
%--------------------------------------------------------------------------
self_ids_all = helper__getStructArrayProp(all_id_structs,'ids',1);
ids_to_get   = helper__getStructArrayProp(all_id_structs,'request_ids',1);

prop_names_all      = helper__getStructArrayProp(all_id_structs,'prop_names',2);
request_handles_all = helper__getStructArrayProp(all_id_structs,'request_handles',2);
handles_all         = helper__getStructArrayProp(all_id_structs,'handles',2);

obj.all_object_ids  = self_ids_all;
obj.all_object_refs = handles_all;

%Apply matches
%--------------------------------------------------------------------------
[ispresent,loc] = ismember(ids_to_get,self_ids_all,'rows');

I_match = find(ispresent)';

obj.unmatched_prop_names  = prop_names_all(~ispresent);
obj.unmatched_ids         = ids_to_get(~ispresent,:);
obj.unmatched_class_names = cellfun(@class,request_handles_all(~ispresent),'un',0);

%???? - what do we hold onto for reverse matches ????


%Assignment of the matched objects to the object that requested them
for iProp = I_match
    cur_obj   = request_handles_all{iProp};
    link_obj  = handles_all{loc(iProp)};
    prop_name = prop_names_all{iProp};
    cur_obj.(prop_name) = link_obj;
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