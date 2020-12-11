%%
% add path for dependencies 
githubDir = 'C:\Users\Steinmetz lab\Documents\MATLAB\widefield_DIY';

addpath(genpath(fullfile(githubDir, 'phase'))) % cortex-lab/widefield
%%
%ZYE_0012\2020-10-16\5
% % %time window to be ploted for individual trial traces
% % newTrialTimes(1,1) = 61;
% % newTrialTimes(2,1) = 197;
% % newTrialTimes(3,1) = 204;
% % newTrialTimes(4,1) = 299;
% % newTrialTimes(5,1) = 530.5;
% % newTrialTimes(6,1) = 701;
% % newTrialTimes(7,1) = 719;
% % newTrialTimes(8,1) = 910.5;
% % newTrialTimes(9,1) = 927;
% % newTrialTimes(10,1) = 973;
% % newTrialTimes(11,1) = 1681;
% % newTrialTimes(12,1) = 1870;
% % newTrialTimes(13,1) = 1873;
% % newTrialTimes(14,1) = 1888.5;
% % newTrialTimes(15,1) = 1902.5;
% % newTrialTimes(16,1) = 2116.5;
% % newTrialTimes(17,1) = 2285.5;

%DPR_0011\2020-10-28\2
% newTrialTimes = [948.5;950.5;955;2054;2133;2856;3450.5;3474.5;3645;3901;4148];

%ZYE_0014\2020-10-28\1
% newTrialTimes = [2094;2124.5;2160;2241;2247;2264;2272;2298;2362;2387;2428;2447;...
%    2475;2482;2496;2501;2568;2652.5;2663;2681;2720;2729;2773;2787;2815;2848;2856;...
%    2888;2904;2958;2972;2981;2994;3030;3044;3060;3238;3272;3323];

% DPR_0011\2020-11-06\1
% newTrialTimes = [4654;5868;6296;4688];

%ZYE_0012\2020-12-03\1
newTrialTimes = [6075;7160.5];
%%
k = 1;
% for kk = 1:length(newTrialTimes)
for kk =2
    %%
    newTrialTimes1 = newTrialTimes(kk,1);
    duration = [0 2];
    ntime = 2;
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
    immax = max(max(max(tracePhase1)));
    immin = min(min(min(tracePhase1)));
    for i=1:npoints
%     for i=58
        figure
        imH = [];
        t1 = round(i/(1*35)*1000);
        A = squeeze(tracePhase1(i,:,:));
        B = squeeze(traceAmp1(i,:,:));
        imH = imagesc(A)     
        caxis([immin, immax])
        colormap(hsv);
        axis off;
%         get(imH)
%         gm = B;
%         set(imH, 'AlphaData', gm)
%         set(gca, 'Color', 'k')
%         savefig(imH,['raw/frame_' num2str(i)])
%         imwrite(A,['raw1/raw_' num2str(i) '.tif']) 
        saveas(gcf,['raw2/frame_' num2str(i) '.jpg'])
        
%         imH2 = figure
%         Gmag3 = phase_gradient(A);        
%         [a,b] = find(Gmag3(:)>=2);
%         [inda,indb] = ind2sub(size(Gmag3),a);
%         imH = imagesc(Gmag3)
%         colormap('hot')
%         axis off;
%         get(imH)
%         gm = B;
%         set(imH, 'AlphaData', gm)
%         set(gca, 'Color', 'k')
%         savefig(imH2,['gradient/gradient_' num2str(i)]);
%         imwrite(Gmag3,['gradient1/gradient_' num2str(i) '.tif'])
%         saveas(gcf,['gradient2/gradient_' num2str(i) '.jpg'])
        
%         subplot(2,1,2)
%         Gmag4 = imgaussfilt(Gmag3,1);
%         imagesc(Gmag4)
%         colormap('hot')
%         colorbar
%         hold on
%         scatter(indb,inda,'k.')
%         xlim([1 512])
%         ylim([1 512])
%         ax = gca;
%         ax.YDir = 'reverse'
%         savefig(['frame_' num2str(i)])
%         inda1{k} = inda;
%         indb1{k} = indb;
        k = k+1;
    end   

end

%%
inda2 = cat(1,inda1{:});
indb2 = cat(1,indb1{:});
ind3 = [inda2,indb2];
ind4 = unique(ind3,'rows');
%%
figure; 
imH = imagesc(A)
caxis([immin, immax])
colormap(hsv);
colorbar
hold on
scatter(ind4(:,2),ind4(:,1),'k.')
xlim([1 512])
ylim([1 512])
ax = gca;
ax.YDir = 'reverse'

figure
imagesc(Gmag3)
colormap(hot);
colorbar
    
% %%
% % %V1
% % point_v1 = [487,438];
% % %PM
% % point_pm = [454,375];
% % %RSP
% % point_rsp = [410,308];
% % %SS
% % point_ss = [241,492];
% points = {point_v1,point_pm,point_rsp,point_ss};
% point_name = {'v1','pm','rsp','ss'};
% 
% figure
% for i = 1:4
%     subplot(8,1,2*i-1)
%     point = points{i};
%     meanTracePoints{i} = squeeze(traceTemp1(:,point(1,1),point(1,2)));
%     angle1{i} = squeeze(tracePhase1(:,point(1,1),point(1,2)));
%     amp{i} = abs(squeeze(traceHilbert1(:,point(1,1),point(1,2))));
%     plot(meanTracePoints{i},'k')
%     text(35,10,point_name{i})
%     hold on; plot(amp{i})
%     xticks([0 8.75 17.5 26.25 35])
%     xticklabels({'0','0.25','0.5','0.75','1'});  
%     subplot(8,1,2*i)
%     plot(angle1{i},'b')
%     xticks([0 8.75 17.5 26.25 35])
%     xticklabels({'0','0.25','0.5','0.75','1'});   
% end
%     
% %%
% points{1} = [276,96];
% points{2} = [234,116];
% points{3} = [258,140];
% points{4} = [295,143];
% points{5} = [335,103];
% points{6} = [296,36];
% points{7} = [247,40];
% points{8} = [221,77];
% figure
% for i = 1:8
%     subplot(8,1,i)
%     point = points{i};
%     meanTracePointsRaw{i} = squeeze(traceTemp1(:,point(1,1),point(1,2)));
%     angle1Raw{i} = squeeze(tracePhase1(:,point(1,1),point(1,2)));
%     ampRaw{i} = abs(squeeze(traceHilbert1(:,point(1,1),point(1,2))));
%     plot(meanTracePointsRaw{i},'k')
%     hold on; plot(ampRaw{i},'r')
%     hold on; plot(angle1Raw{i}*30,'b')
%     xticks([0 8.75 17.5 26.25 35])
%     xticklabels({'0','0.25','0.5','0.75','1'});   
%     
% end
%     
% 
% %% pspectrum over example trial
% t_exp = 1:35*ntime+1;
% fr = 35;
% pxx = bandpower(traceTemp,fr,[3,8]);
% [colormap1] = cbrewer('seq', 'Reds', 64);
% pxx1 = reshape(pxx,size(U,1),size(U,2));
% powermax = max(max(pxx1));
% figure
% set(gcf, 'Position',  [100, 100, 1920, 370])
% imagesc(pxx1)
% colormap(colormap1);
% colorbar
% caxis([0 powermax])
