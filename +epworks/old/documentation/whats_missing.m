%{

The following is a brief summary of some things that I think are missing
from this work.

1) Official documentation. 
---------------------------------------------------------------------------
This is a hack. I have tried to verify that my
parsing results match the official results, but without documentation, it
is difficult to know how well I did.

That being said, I have done some verification of the results and it is
hard to make random errors in the code. For example, the links between
objects are pretty clear and it would be very surprising if only a few
random links out the set were incorrect. I would expect either none of them
to be right, or for them all to be right. A similar thing can be said about
properties. One exception to this is enumerated types (see next section).

2) Enumerated Type Support. 
---------------------------------------------------------------------------
An enumerated type is something that only takes
on meaning based on knowledge of some list. For example, an enumerated type
could be used to represent colors. Generally, but not always, enumerated
types are 0 or 1 based and increase by 1, where each number represents a
value. So for the color example, we might have:
0 - red
1 - blue
2 - green
3 - orange

Importantly, in the code, all I can see is 0, 1, 2, 3 and it will probably
have the property color, but until I go in the program and test every
value, it is difficult to know what 2 means without having the list.

Some enumerated types have set functions attached to them. For example, see
epworks.type.electrical_stim

In this class there is a method -> set.mode(obj,value)

In this method we change the value from being numeric (although that is
stored in a hidden value) to being a more intelligble string.

3) Extraneous Properties. 
---------------------------------------------------------------------------
This file format contains a lot of information
which I was not interested in. Ignored things include:
    - presentation format/coloring
    - patient information
    - billing information

    This information is present in the deep level parsed data, but is not
    exposed in the final Matlab objects. It is relatively easy to bring
    non-exposed data into Matlab objects.

4) Information retrieval and plotting functions
---------------------------------------------------------------------------
The Matlab classes are still fairly rough and could use some added
functionality for organization, data filtering, and plotting.
    
5) File Analysis
---------------------------------------------------------------------------
I created a bunch of temporary files in trying to understand the file
format. Eventually I need to add those. In addition, it would be good to
create summary methods, that for example, show all IDs and what they link
to. This would be useful in the case where IDs are not matching. Do they
just not exist or am I failing to request the correct object?

NOTE: This is already happening with groups and groupdef objects, where
some groupdef pointers from group objects are not getting resolved...

%}