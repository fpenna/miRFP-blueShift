clear all; 
close all;

% Parameters
pxSize = 29.3; %nm


for z = 1
    
    % Data import
    fnB = ['vim_lines_bluech.txt'];
    fnR = ['vim_lines_redch.txt'];

    llB = importdata([fnB]); llB = llB.data;
    llR = importdata([fnR]); llR = llR.data;

 
    confidence = 2.5;
    z = 1;
    k = 1;
    for i = 2:size(llB,2)
        %%
        profile = llB(1:end,i);
        profile2 = llR(1:end,i);
        
        profile = profile(profile>0);
        profile2 = profile2(profile>0);
        %profile = (profile-min(profile))./max((profile-min(profile)));
%        
        if isempty(profile) || length(profile) < length(llB(1:end,i))*0.5
            param(k,:,z) = zeros(1,10);
            k=k+1;
            continue
        else
            
            nm = [1:size(profile,1)]*pxSize; nm=nm';
            [maxima, maxId] = findpeaks(profile,'MinPeakHeight',max(profile)*0.025,'MinPeakDistance',(length(nm)-5));
            
%             try
                % Single Lorentzian fit  p = a, w, x0, y0
                ft = fittype( 'y0+(2*a/pi)*(w./(4*(x-x0).^2 + w.^2))', 'independent', 'x', 'dependent', 'y' );
                opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
                opts.Algorithm = 'Levenberg-Marquardt';%'Trust-Region';%
                opts.Display = 'Off';
                opts.Lower = [0 35 0 0];
                opts.Upper = [Inf 3000 length(profile)*pxSize Inf];
                opts.MaxIter = 1000;
                opts.Robust = 'Bisquare';
                opts.StartPoint = [max(profile)*100 pxSize*2 maxId*pxSize mean(profile)];
                % Fit model to data.
                [fitresult, gof] = fit( nm, profile, ft, opts );
                pfit = fitresult(nm);
                coeffvals = coeffvalues(fitresult);
                
                % Estimation of the bkg
                cuttedInt = round(fitresult.w*confidence/(2*pxSize));
                bkg = [profile(1:maxId-cuttedInt); profile(maxId+cuttedInt:end)];
                
                                      
                %%%%%%%%%Visualization of the fit %%%%%%%%%%%%%%%%%%%%
                h1 = figure(1);
                subplot(4,8,i-1)
                plot(nm,profile,'ob', ...
                    nm,profile2,'-r', ...
                    nm,pfit,'--k', ...
                    nm, ones(1,length(profile))*(mean(bkg)+std(bkg)), 'm', ...
                    nm, ones(1,length(profile))*(mean(bkg)-std(bkg)),'m');
                title(['#' num2str(i-1)])
                ylabel 'Counts'
                xlabel 'x(nm)'
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

                SBkgR(k) = max(profile)./ mean(bkg);
                SNoiseR(k) = (max(profile)-fitresult.y0) / (2*std(bkg));
                
                % Given the localtion of the maxima identified in the fit
                % and the outer boundary (called cuttedInt), we estimate
                % the SNR on both profiles
                
                Bmax = mean(profile(round(fitresult.x0)/pxSize-1:round(fitresult.x0)/pxSize+1));
                Rmax = mean(profile2(round(fitresult.x0)/pxSize-1:round(fitresult.x0)/pxSize+1));
                Bbkg = mean([profile(1:round(fitresult.x0)/pxSize-cuttedInt); profile(round(fitresult.x0)/pxSize+cuttedInt:end)]);
                Rbkg = mean([profile2(1:round(fitresult.x0)/pxSize-cuttedInt); profile(round(fitresult.x0)/pxSize+cuttedInt:end)]);
                
                sbr_blue(k,1) = Bmax/Bbkg;
                sbr_blue(k,2) = Bmax/std([profile(1:round(fitresult.x0)/pxSize-cuttedInt); profile(round(fitresult.x0)/pxSize+cuttedInt:end)]);
                sbr_red(k,1) = Rmax/Rbkg;
                sbr_red(k,2) = Rmax/std([profile2(1:round(fitresult.x0)/pxSize-cuttedInt); profile(round(fitresult.x0)/pxSize+cuttedInt:end)]);
                
                 xlabel(['w = ' num2str(round(fitresult.w)) ', B=' num2str(sbr_blue(k,1)) ', R=' num2str(sbr_red(k,1))]);
                
                
                k=k+1;
                
        end
    end
    
end
    




