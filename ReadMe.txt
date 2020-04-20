Project 4: Birdsong
Team: Lillian Anderson & Angad Daryani 
Assignment: Feature Extraction, Classification, and Removal of Automobile Sounds from RAW Audio Clips


There are multiple files associated with this project, which have been consolidated into 3 sets

1. Updated Data Files - Raw Data, Training Data, Test Data
2. Experiments.m
3. Main1.m 

**HOW TO RUN: FOR PROFESSORS**************************************************

To run, open up Main.m in Matlab and run it. 

File 'Train.wav' must be in the current directory as well as desired testing audio files. Currently the 
script is set up to test files ASB (1-10, 13, 17, and 24).

**UPDATED DATA FILES**************************************************

The RAW data files provided by the professor have been renamed according to the following convention

Anderson-serviceberry-selected --> ASB 
ArchitectureWest-selected --> AW
CherryEmerson-selected -->  CE
EBB-selected --> EBB

For example, file name ‘5E6BA3C8’ was renamed as ‘ASB (1)’.

-Training Data

-Test Data 


**EXPERIMENTS.M********************************************************

This matlab script must be manually edited to accomodate for different file names and times/indices of access. After this it will automatically compute and plot features. 
The script uses functions to test, compute, and visualise FFT, Short Term Energy, Pitch, Wavelet Packet Transform, and Spectral Flux on shorted/full audio files. 
The length/indices of the vectors must be changed to access specific parts of an audio file.

**MAIN1.M**************************************************************

This matlab script must be manually edited at the top of the script to accomodate for different file names and times/indices of access.
The script implements feature extraction, trains an SVM Model, and classifies audio files as either automobile or bird.
