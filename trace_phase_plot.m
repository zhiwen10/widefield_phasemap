%% upsampled trace view
points{1} = [276,96];
points{2} = [234,116];
points{3} = [258,140];
points{4} = [295,143];
points{5} = [335,103];
points{6} = [296,36];
points{7} = [247,40];
points{8} = [221,77];
figure
for i = 1:8
    subplot(8,1,i)
    point = points{i};
    meanTracePoints{i} = squeeze(traceVq1(:,point(1,1),point(1,2)));
    angle1{i} = squeeze(frameVq1(:,point(1,1),point(1,2)));
    amp{i} = abs(squeeze(ampVq2(:,point(1,1),point(1,2))));
    plot(meanTracePoints{i},'k')
    hold on; plot(amp{i},'r')
    hold on; plot(angle1{i}*30,'b')
    xticks([0 87.5 175 262.5 350 437.5 525 612.5 700])
    xticklabels({'0','0.25','0.5','0.75','1','1.25','1.5','1.75','2.0'});  
    
end
    
%% raw trace not interpolated
figure
for i = 1:8
    subplot(8,1,i)
    point = points{i};
    meanTracePointsRaw{i} = squeeze(traceTemp1(:,point(1,1),point(1,2)));
    angle1Raw{i} = squeeze(tracePhase1(:,point(1,1),point(1,2)));
    ampRaw{i} = abs(squeeze(traceHilbert1(:,point(1,1),point(1,2))));
    plot(meanTracePointsRaw{i},'k')
    hold on; plot(ampRaw{i},'r')
    hold on; plot(angle1Raw{i}*30,'b')
    xticks([0 8.75 17.5 26.25 35 43.75 52.5 61.25 70])
    xticklabels({'0','0.25','0.5','0.75','1','1.25','1.5','1.75','2.0'});      
end

%% compare phase
figure
for i = 1:8
    subplot(8,1,i)
    plot(1:0.1:71,angle1{i},'k')
    hold on; plot(angle1Raw{i},'r')
    hold on; plot(1:0.1:71,angle1{i}+1,'b')
    hold on; plot(meanTracePointsRaw{i}/50,'g')
    if i == 1
        legend('interpPhase','rawPhase','interpPhase+1','RawTrace')
    end
end