// PARAMETERS //

numImg = 15
////////////////

// open the file in the folder
run("Set Measurements...", "mean redirect=None decimal=3");
run("Close All");
path = File.openDialog("First file");
dir = File.getParent(path);
name = File.getName(path);
run("Bio-Formats", "open=["+path+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
rename("spectrum");

meanR_pre = newArray(numImg);
meanR_post = newArray(numImg);
meanB_pre = newArray(numImg);
meanB_post = newArray(numImg);
stdR_pre = newArray(numImg);
stdR_post = newArray(numImg);
stdB_pre = newArray(numImg);
stdB_post = newArray(numImg);

run("Set Measurements...", "mean redirect=None decimal=3");

for(r=1;r<=numImg;r++) {
//	r = 1;
	selectWindow("spectrum");
	run("Duplicate...", "duplicate channels=1 frames="+r);
	rename("b1");
	selectWindow("spectrum");
	run("Duplicate...", "duplicate channels=2 frames="+r);
	rename("r1");
	selectWindow("spectrum");
	run("Duplicate...", "duplicate channels=4 frames="+r);
	rename("b2");
	selectWindow("spectrum");
	run("Duplicate...", "duplicate channels=5 frames="+r);
	rename("r2");

// identify only the bacteria
	selectWindow("r1");
	run("Duplicate...", "title=thresh");	
	// method 1 
	run("Gaussian Blur...", "sigma=1");
	setThreshold(90, 255);
	run("Convert to Mask");
	run("Erode");
	run("Dilate");
	run("Dilate");
	run("Analyze Particles...", "size=50-Infinity pixel circularity=0.00-100.00 display clear add");
	
	selectWindow("r1");
	roiManager("Deselect");
	roiManager("multi-measure measure_all");
	N = nResults;
	mm = newArray(N);
	for (i = 0; i < N; i++) {
	mm[i] = getResult("Mean", i);
	}
	Array.getStatistics(mm, min, max, mean, std);
	meanR_pre[r-1] = mean;
	stdR_pre[r-1] = std/sqrt(N);
	run("Clear Results");
		
	selectWindow("r2");
	roiManager("Deselect");
	roiManager("multi-measure measure_all");
	N = nResults;
	mm = newArray(N);
	for (i = 0; i < N; i++) {
	mm[i] = getResult("Mean", i);
	}
	Array.getStatistics(mm, min, max, mean, std);
	meanR_post[r-1] = mean;
	stdR_post[r-1] = std/sqrt(N);
	run("Clear Results");

	selectWindow("b1");
	roiManager("Deselect");
	roiManager("multi-measure measure_all");
	N = nResults;
	mm = newArray(N);
	for (i = 0; i < N; i++) {
	mm[i] = getResult("Mean", i);
	}
	Array.getStatistics(mm, min, max, mean, std);
	meanB_pre[r-1] = mean;
	stdB_pre[r-1] = std/sqrt(N);
	run("Clear Results");
	
	selectWindow("b2");
	roiManager("Deselect");
	roiManager("multi-measure measure_all");
	N = nResults;
	mm = newArray(N);
	for (i = 0; i < N; i++) {
	mm[i] = getResult("Mean", i);
	}
	Array.getStatistics(mm, min, max, mean, std);
	meanB_post[r-1] = mean;
	stdB_post[r-1] = std/sqrt(N);
	run("Clear Results");
	
	close("r1");
	close("r2");
	close("b1");
	close("b2");
	close("thresh");
	close("thresh Laplacian");
	roiManager("Deselect");
	roiManager("Delete");	
}

resultsTable = "Channel ratio";
Table.create(resultsTable);
Table.setColumn("Pre red", meanR_pre, resultsTable);
Table.setColumn("Pre red:std", stdR_pre, resultsTable);
Table.setColumn("Post red", meanR_post, resultsTable);
Table.setColumn("Post red:std", stdR_post, resultsTable);
Table.setColumn("Pre blu", meanB_pre, resultsTable);
Table.setColumn("Pre blu:std", stdB_pre, resultsTable);
Table.setColumn("Post blu", meanB_post, resultsTable);
Table.setColumn("Post blu:std", stdB_post, resultsTable);
	




