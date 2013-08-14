# XLTek EPWorks Parser #

This code attempts to parse data collected using XLTek's EPWorks software. It is implemented using Matlab. The parsing is done without any official documentation or specifications given to me by the company and as such any parsing should be checked against known results using their software. 

## Documentation ##

[Questions](documentation/questions.md)
[Parsing Strategy](documentation/parsing_strategy.md)
[What's Missing](documentation/whats_missing.md)

## Usage ##

1. Make sure the epworks package is on the Matlab path. The subfolders should not be added to the path.

The main entry call is *epworks.main*.

The simplest usage case is to call:

    r = epworks.main;

This will allow the user to select a study to parse.

Alternatively, it is possible to create a file which tells the code where a bunch of studies are located. Instructions on how to do this are below.


2) *(Optional)* Creation of an options.txt file in the same directory that contains the package (not in the package directory), that currently only has one required value (line entry):

	study_parent_folder = [insert path here]

Example:
	
	study_parent_folder = C:\emg_tests\

The result object can then be obtained by specifying the name of the study (folder name) as an input to the main constructor.

	r = epworks.main('my_emg_1_study')

## Future Updates ##

1. I need to document the parsing process.
2. Some objects have only a certain subset of their properties valid depending on type. Currently this means that the user sees a lot of extra properties that they really don't need to see.
3. Some of the links are not yet resolved.
4. A couple of files are not parsed.

