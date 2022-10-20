The ImageJ script "ChIntensityEstimation.ijm" provides an extraction of the respective channel intensities in 4D images (x, y, channel, frame), with 5 channels (blue pre, red pre, conversion, blue post, red post) and N frames representing separate images.

The extraction is performed by thresholding the individual objects in the image (such as bacteria) and measuring the mean pixel intensity inside each binary object. These results are put in a table, and the data can be exported to Origin for further analysis.

In Origin, the mean intensities for each channel post conversion are divided with the intensities in the same channel pre conversion to arrive at the channel post/pre ratios.  

Example data:
"example_miRFP709_I700.tif", where miRFP709 is expressed in bacteria and the 15 individual frames correspond to 15 different illumination powers as denoted by the titles, is provided as an example dataset.