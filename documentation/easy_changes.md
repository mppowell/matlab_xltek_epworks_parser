## Easy Changes ##

This document is meant to discuss changes that are relatively easy for me to make that I could see doing in the future.

**- Changes to property layout.**

It is relatively easy to reorder, rename, or hide properties.

**- Addition of dependent properties.**

It is relatively easy to add a property that is a calculation based on another property or that points to another property. An example of this can be seen in the test objects where the name is retrieved from the Settings property.

**- Resolution of Enumerated Values.**

Enumerated values are those that only make sense when compared to a list. A simple example of an enumerated value can be seen in the test object where 0 = 'Active' and 1 = 'Inactive'.

**- Default Properties.**

Some properties are not specified by default. This can cause problems when concatenating these properties across objects because you end up with less properties than there are objects. Where it makes sense it is easy to insert a default property value like NaN.