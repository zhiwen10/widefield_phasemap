%%
%time window to be ploted for individual trial traces
newTrialTimes = [61;197;204;299;530.5;701;719;910.5;927;973;...
    1681;1870;1873;1888.5;1902.5;2116.5;2285.5];

%DPR11
% newTrialTimes = [948.5;950.5;955;2054;2133;2856;3450.5;3474.5;3645;3901;4148];

%ZYE14
% newTrialTimes = [2094;2124.5;2160;2241;2247;2264;2272;2298;2362;2387;2428;2447;...
%    2475;2482;2496;2501;2568;2652.5;2663;2681;2720;2729;2773;2787;2815;2848;2856;...
%    2888;2904;2958;2972;2981;2994;3030;3044;3060;3238;3272;3323];

% ZYE9
% newTrialTimes = [1970;3830;2035];
%%
% for kk = 1:length(newTrialTimes)
for kk = 11
    %%
    newTrialTimes1 = newTrialTimes(kk,1);
    duration = [0 2];
    ntime = duration(1,2);
    ntrials = length(newTrialTimes1);
    fs = 1/mean(diff(t));
    eventID = 1:size(newTrialTimes1,1);
    eventID = eventID';
    [avgPeriEventV, winSamps] = eventLockedAvgSVD(U, dV, t, newTrialTimes1, eventID, duration);
    Ur = reshape(U, size(U,1)*size(U,2), size(U,3));

    %% mean trace plot
    avgPeriEventV1 = squeeze(mean(avgPeriEventV,1));
    % avgPeriEventV1 = squeeze(avgPeriEventV(183,:,:));
    meanTrace1 = Ur*avgPeriEventV1;
    meanTrace1 = double(meanTrace1);
    meanTrace = reshape(meanTrace1, size(U,1), size(U,2), size(meanTrace1,2));
    %% filter 2-8Hz
    npoints = 35*ntime+1;
    traceTemp = meanTrace1-repmat(mean(meanTrace1,2),1,npoints);
    % filter and hilbert transform work on each column
    traceTemp = traceTemp';
    [f1,f2] = butter(2, [2 8]/(fs/2), 'bandpass');
    traceTemp = filter(f1,f2,traceTemp);
    traceHilbert =hilbert(traceTemp);
    tracePhase = angle(traceHilbert);
    traceAmp = abs(traceHilbert);
    traceTemp1 = reshape(traceTemp, size(traceTemp,1),size(U,1), size(U,2));
    tracePhase1 = reshape(tracePhase,size(tracePhase,1),size(U,1), size(U,2));
    traceHilbert1 = reshape(traceHilbert,size(traceHilbert,1),size(U,1), size(U,2));
    traceAmp1 = abs(traceHilbert1);
    AmpMax = max(max(max(traceAmp1)));
    traceAmp1 = traceAmp1/AmpMax;
    %%
    figure;
    immax = max(max(max(tracePhase1)));
    immin = min(min(min(tracePhase1)));

    imH = [];
    v = VideoWriter(['phase_map_' num2str(newTrialTimes1) 's_no_interp.avi']);
    v.FrameRate=2;
    open(v);
    for i=1:npoints
        t1 = round(i/(1*35)*1000);
        A = squeeze(tracePhase1(i,:,:));
        B = squeeze(traceAmp1(i,:,:));
        if i == 1
            imH = imagesc(A);
            colorbar
            caxis([immin, immax])
            colormap(hsv);
        else
            set(imH, 'CData', A);
        end
        title(['Time: ' num2str(t1) ' ms'])
        get(imH)
        gm = B;
        set(imH, 'AlphaData', gm)
        set(gca, 'Color', 'k')
        thisFrame = getframe(gca);
        writeVideo(v, thisFrame);
    end
    close(v);            
end
