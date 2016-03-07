function [trial]=defstruct(pms,rect)
%%function that creates the trial struct for the predifined stimuli. It
%%loads the stimuli per set size and then applies the same random index to
%%all 4 set sizes. Since they are set in the same way hopefully the types
%%U,I are also sampled equally per block.

load trial.mat

rectsize=[0 0 100 100];
numrects=4;
xyindex=[0.4 0.6 0.6 0.4;0.37 0.37 0.6 0.6]'; %the locations go clockwise L->R      1  2
                                                                                  %  4  3
[~,pie]=sampledColorMatrix(pms);

locationmatrix=zeros(size(xyindex,1),size(xyindex,2));
for r=1:length(locationmatrix)
    locationmatrix(r,1)=(rect(3)*xyindex(r,1));
    locationmatrix(r,2)=(rect(4)*xyindex(r,2));
end


for i=1:pms.numBlocks
    for j=1:pms.numTrials
        trial(j,i).colors=[];
        trial(j,i).locations=[];
        trial(j,i).probeColorCorrect=[];
    end
end


for y=1:size(trial,2) 
    for x=1:size(trial,1) %numtrials (total)
        for n=1:numel(trial(x,y).colPie) %1: max number of colors per trial
            for k=trial(x,y).colPie %for each pie per trial eg k=[4 5 2 7]
                if trial(x,y).colPie(n)==k 
                    trial(x,y).colors=[trial(x,y).colors; datasample(pie(k).color,1)]; %get random color within pie
                    if k==trial(x,y).probeColNum %if this pie also probe: use same as correct DP:this is the number, not the color!
                        trial(x,y).probeColorCorrect=trial(x,y).colors(n,:);
                    end
                  
                    
                end
            end
        end
        for j=1:numel(trial(x,y).locNum) %for 1: max number of locations
            for m=trial(x,y).locNum % for each location per trial
                if trial(x,y).locNum(j)==m % if specific position of locations equals the location
                    trial(x,y).locations=[trial(x,y).locations;locationmatrix(m,:)]; %fill location with location matrix of index m
                    if m==trial(x,y).probeLocNum
                        trial(x,y).probeLoc=trial(x,y).locations(j,:);%let's walk through this together ;)
                    end
                end
            end
        end
        
        
        
    end
end
save('trialFin','trial')
end %function

                

