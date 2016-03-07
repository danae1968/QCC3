function [sampledColors,pie]=sampledColorMatrix(pms)
%%function that creates a sampled colormatrix for the QuantifyingCC DMTS
%%task. The function picks a random index from 1 till end of colormatrix,
%%creates steps of equally spaced indexes and adds the random index to
%%them. If the resulting index exceeds the colormatrix length mod subtracts
%%it.

%pms.numWheelColors=512;
%a=25:35;
step=42;
colormatrix=hsv(pms.numWheelColors)*255;


index1=randi(pms.numWheelColors,1);
samples=0:step:pms.numWheelColors-step;
% samples=randsample(steps,length(steps));
indices=samples+index1;
for n=1:length(indices)
    if indices(n)>pms.numWheelColors
        indices(n)=mod(indices(n),pms.numWheelColors);
    end
end
% indices=[samples1 samples2]'
sampledColors=colormatrix(indices,:);

%% Middle is the middle of all (12) pies. We sample 1 color from each smaller pie that surrounds the middle
%for the first sampling (around 0-red) it samples one color between 0-maxPie/2 or
%512-maxPie/2-512. 
% 
numPies=12;
step=round(length(colormatrix)/numPies);
middle=0:step:512;
sampledColors=zeros(length(middle)-1,3);
maxPie=20; %the degree to which it is allowed to vary?

for x=1:length(middle)-1
    if x==1
        colormatrix=[colormatrix(1:maxPie/2,:);colormatrix((length(colormatrix)-maxPie/2):end,:)];
      sampledColors(x,:)=datasample(colormatrix,1);
    else
      colormatrix=hsv(512)*255;
      sampledColors(x,:)=datasample(colormatrix((middle(x)-maxPie/2):(middle(x)+maxPie/2),:),1);
    end

end


%% check to see if colors are sampled from correct pies.

% for N=1:length(colormatrix)
%     for Y=1:length(sampledColors)
%    if sampledColors(Y,:)==colormatrix(N,:)
%        N
%    end
%     end
% end



pie.color=struct;
K=round(step/2):step:pms.numWheelColors;
pie(1).color=[colormatrix((pms.numWheelColors-step/2):pms.numWheelColors,:); colormatrix(1:step/2,:)];
for N=2:numPies
   pie(N).color=colormatrix(K(N-1):K(N),:);
end

names={'red','orange','yellow','light green','green','blue green','turquoise','cyan','blue','purple','pink','magenda'};

for i=1:length(pie)
    pie(i).name=names{i};
end
