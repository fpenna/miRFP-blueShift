The MATLAB script "SNR.m" provides an estimation of the signal-to-noise ratio based on manually-drawn line profiles for the two channels (blue- and red-shifted) in a provided two-channel image.

The calculation is performed considering regions with clear filaments over which a line profile is drawn. The intensity over the line profile for both channels is the input of "SNR.m". The SNR is calculated as the ratio between the intensity at the center of the filament versus the average fluctuation of the background at the perifery. 

The main output is the matrices "sbr_blue" and "sbr_red", with values for the signal-to-background ratio (column 1) and signal-to-noise ratio (column 2) for each line profile. 

Example data:
"vim.tif", where vimentin is labelled, is provided as an example image, together with the set of line profiles as ImageJ ROIs in "vim_sted1_lineprofile.zip".