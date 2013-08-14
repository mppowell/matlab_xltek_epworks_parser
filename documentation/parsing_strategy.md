# Parsing Strategy #

**UNFINISHED**

The main parsing file is epworks.main. Currently the .IOM file is parsed fairly thoroughly. Some information is filtered out as it is translated from raw objects to the objects shown in epworks.main. For the most part it is GUI settings that are not translated (although they could be).

## epworks.iom_parser.translateData ##

This method is responsible for translating raw byte values to values that will be used as properties in the output objects (for IOM properties). If a IOM property is not being translated correctly, this is the place to change it.

## epworks.main.populateIOMObjects ##

This method takes the raw objects and builds them into a hierarchy that is ultimately kept in the epworks.main class instance.

## epworks.iom_data_model ##

Population of the IOM objects relies on this class and the underlying csv file for understanding how to go from the raw objects to the objects that are kept in epworks.main.