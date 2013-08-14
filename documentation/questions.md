This file is meant to document things that I find confusing about the data
structure.

1. For some of my files the sampling frequency of the waveform is 30000 and the sweep duration
is 50 ms but when I export the data to a text file I only get 600 points.
These 600 points look like they occupy the same length as the original
data. At a sampling frequency of 30000, 600 points is only 20 ms, not 50
ms. What's happening?
 
2. Where is the # of samples that I would like to collect per
trigger? Is this inferred from the # of divisions in the group and the
timebase for each trace?
 
3. What does the initial intensity for the electric stimulators mean?
**Answer:** This is meant as a time saver. It sets the system up so that it will
stimulate at that intensity without needing to change the amplitude in GUI.
In other words, this is not a stimulus bias, but a default setting for the GUI.

4. Why are the .iom and .rec traces for triggered stimuli different? The .rec file looks like it might be a filtered version of the .iom version.