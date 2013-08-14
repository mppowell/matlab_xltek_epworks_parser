# XLTek EPWorks Parser #

This code attempts to parse .iom files collected using XLTek's EPWorks software. It is implemented using Matlab. The parsing is done without any official documentation or specifications given to me by the company and as such any parsing should be checked against known results using their software. 

## Documentation ##

[questions]('documentation/questions.md')

## Usage ##

Currently only a subset of the their data is parsed out and put into Matlab classes. The current parent class is epworks.study . Initialization requires the following:

1) Making sure the epworks package is on the Matlab path
2) Creation of an options.txt file in the same directory that contains the package (not in the package directory), that currently only has one required value (line entry):

	study_parent_folder = [insert path here]

Example:
	
	study_parent_folder = C:\emg_tests\

The study object can be obtained by specifying the name of the study (folder name) as an input to the study constructor.

	s = epworks.study('my_emg_1_study')

Future Updates

1. I need to document the parsing process.
2. Stimulation grouping of triggered waveforms needs to be implemented to allow for easier averaging
3. Incorportation of Excel notes on study configurations for easier data analysis. 

