%{

The following is a brief outline of how I started parsing these files. It
is specifically geared towards the main data file, not the notes file. My
parsing approach seems to work but is very generic and likely is missing
some slight nuances that would make the parsing more robust to future
changes (if any).

===========================================================================
1) The first thing I noticed when parsing these files was the regular text.
It turns out that these regular text indicated the names of properties (I
refer to them internally as tags).

2) By looking before these tags, I noticed that they tended to be proceeded
by a set of bytes that indicated how many bytes the name took up. Before
this appeared to be a consistent set of bytes that seemed to be saying
something to the effect of "now onto the next tag".

NOTE: It is common in most current systems to indicate size using a uint32
(32 bit unsigned integer, which in uint8s is represented as 4 numbers)
When looking at size numbers that are small, you tend to see things like
0 0 # # or 0 0 0 #. When aligned properly these are fairly easy to pick
out. By aligning byte snippets to the text, I could see these things:

NOTE: This is a rough summary, I think the numbers were actuallly off by a
constant value, but never-the-less they seemed to consistently indicate the
size of the tag.

# # # # 0 0 0 8 e p _ t r a c e
# # # # 0 0 0 6 e p _ s e t


3) Following the tag, it looked like there was a type specifier, followed
by a size specifier, followed by data.
 

SUMMARY SO FAR

MAGIC_#  SIZE_OF_TAG TAG_NAME TYPE_ENUMERATOR  SIZE_OF_DATA  DATA

This took a bit of work trying to figure out what the TYPE_ENUMERATORS
indicated, and how to interpret the data. Some of this was helped by having
plain text for the name.

4) I got to this point and was stumped for a bit. I had parsed the majority
of the file, but it was very unclear how to know what properties applied to
what objects. I went back to looking for bytes that I was not using that
were fairly common. I found another magic string. When aligned by that
string, I noticed a size specifier next to it. Importantly, this size
specifier covered the entire data file and provided the final grouping
information that I needed, so I knew what belonged to what.


WHAT AM I DOING WRONG?
===========================================================================
1) After parsing the file, it became clear that the entire file is
basically like a tree, and instead of randomly searching and putting things
together after the fact, a better parser would recursively process the
tree, starting with a top most object, grabbing its data, then parsing the
objects that the top most object has as its properties.

2) There is still in the file what I refer to as dark matter. Some of this
I think is related to some caching for rendering things more quickly. In
addition I think there are identifiers which completely disambiguate what
type of object you are about to encounter when parsing a section of the
code. Instead of hardcoding these values (which I should probably do but
would require moer work) I just keep track of child/parent relationships.
When extracting objects, I look for objects that are at a certain depth in
the tree structure, that have certain properties in them, or that have
parents with certain properties and values.



%}