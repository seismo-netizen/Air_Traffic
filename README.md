# Air_Traffic

The Matlab code and example data are created by Haoran Meng (h2meng@ucsd.edu) and Yehuda Ben-Zion to model the Doppler effect in the spectrogram of the seismic records of an air-traffic event.

The methodology and application are described in the following publication:
Meng, Haoran, and Yehuda Ben‐Zion. "Characteristics of airplanes and helicopters recorded by a dense seismic array near Anza California." Journal of Geophysical Research: Solid Earth 123.6 (2018): 4783-4797 (https://doi.org/10.1029/2017JB015240).

2014_146_1_R0101.EHZ: a SAC file for the seismic record of an air-traffic event
load_sac.m: a Matlab function to read in the SAC file
Doppler.m: a Matlab function to model the Doppler effect in the spectrogram of an air-traffic event
run_doppler.m: run this Matlab code to model the Doppler effect and get parameters of the airplane
