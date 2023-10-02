# FlowLib

This is a collection of functions that I used for calculating flow rates from signals using the transit time difference method. They're a bit messy, as they were a work in progress throughout my PhD, but it should be relatively easy to understand how they work if you need to.

## Function Descriptions

### arrival_detect

[starts, stops, envelope] = arrival_detect(volts, N_arrivals);

This is a function for detecting where the arrivals are in a signal so that you can pull them out for cross-correlation. You should crop off the driving signal first as that will mess up the algorithm. The inputs are 'volts' (the voltage trace) and 'N_arrivals' (the number of arrivals you want to pull out). The outputs are 'starts' and 'stops' which are two arrays that are 1xN_arrivals, containing the indices at which the arrivals found start and stop. The 3rd output, 'envelope', is a diagnostic tool for if the function isn't working how you want it to, see below for a description of how it works.

The function works by first taking the absolute value of the Hilbert transform of volts to get the envelope of the signal. Then, it will find the N_arrivals highest peaks in the envelope. Starting at the top of each peak, it goes down until the height of the envelope is 2.5% of the max value in that peak - it then writes these indices to the starts and stops array. There is also a filtering stage to remove noise from the envelope, which may have to be modified if your signals are very different from mine. It uses a savitizky-golay filter, which has an order and a window length. I recommend leaving te order as 3 and changing the window length until you get an envelope that is representative of your signal.

### arrival_detect2

[starts, stops, envelope] = arrival_detect2(volts, N_arrivals, thresh);

Identical to arrival_detect, only allows you to change the threshold from 2.5% to whatever percentage you like. The threshold will be the same for all arrivals detected.

### arrival_detect3

[starts, stops, envelope] = arrival_detect3(volts, N_arrivals, thresh)

In this version, the threshold is now an array of length N_arrivals so that a different threshold can be set for each arrival. They are selected in chronological order - from early time to late time.

### flow_process_SG_filt

[dts, corr_x, corr, arr1_filt, arr2_filt] = flow_process_SG_filt(upvolts, downvolts, time, N_interp, starts, stops);

This is the function which takes the upstream and downstream waveforms and calculates the transit time difference in order to get the flow rate. The inputs are:

upvolts: The upstream voltage trace, including all arrivals.

downvolts: The downstream voltage trace.

time: The corresponding time array

N_interp: The factor by which each arrival is interpolated before taking the cross-correlation

starts & stops: indices of arrival locations, from one of the functions above.

The outputs are:

dts: An array containing the transit time differences.

corr_x: the x axis of the cross correlation function. (diagnostic)

corr: the y axis of the cross-correlation function. (diagnostic)

arr1_filt & arr2_filt: The filtered arrivals. (diagnostic)

The function cycles through starts and stops pulling out the arrivals. It interpolates and filters them, then cross-correlates to determine the transit time difference.

### calc_flow_rate

Q = calc_flow_rate(dt, c_l);

Calculates the volumetric rate given a value of dt in seconds and a speed of sound in the liquid c_l. Assumes a 15mm OD pipe with 0.7mm wall thickness, a transducer incidence angle of 38 degrees, and a V configuration.
