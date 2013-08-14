%{

This function is meant to document the steps that are followed to go from
the original data file to Matlab objects that represent that file.

The object generation outline can be followed by reading the epworks.study
constructor. I've added some extra details in here.

1) Notes are parsed. The notes are kept in a file that is separate from the
main data file.

2) The entire data file is read into memory. These files tend to be small.
I make the assumption that this is alright since it makes things a lot
easier for me.

3) Tags are parsed. In retrospect, tags is probably a bad name. In reality
it would really be better to think of these as properties. I find out what
the tag is called, where it starts and ends in the file, what data type it
contains, etc

JAH TODO: This is unfinished
%------------------------------------------------------------------
4) Object hierarchy and tree creation
5) Going from these trees to objects
6) Linking everything


%}