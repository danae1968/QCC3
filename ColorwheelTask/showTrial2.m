function [data,T] = showTrial2(trial,pms,practice,dataFilenamePrelim)
%function that shows stimuli and collects responses

global wPtr rect
if practice==1
    pms.numTrials=pms.numTrialsPr;
    pms.numBlocks=pms.numBlocksPr;
end
load starts
Screen('TextSize',wPtr,16);
Screen('TextStyle',wPtr,1);
Screen('TextFont',wPtr,'Courier New');

stimOnset = Screen(wPtr,'Flip');
% onset = stimOnset-exptOnset;
%% All in 1 function (as you say above): MF: showTrial
target='U';
non_target='N';
T_color=[0 0 0];
N_color=[0 0 0];
evt = [];
responded = [];
rectOne=[0 0 100 100];
data=struct();
%load starts


%% loop around trials and blocks for stimulus presentation
for p=1:pms.numBlocks
    for g=1:pms.numTrials
        for phase = 1:5
            if phase == 1
                switch trial(g,p).type
                    case {0 2}
                        phaselabel='encoding';
                        switch trial(g,p).setSize  %switch between set sizes
                            case 1                 % setsize 1
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                colorEnc=trial(g,p).colors(1,:);
                                allrects=rectOne;
                            case 2                 % setsize 2
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo=CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                allrects=[rectOne',rectTwo'];
                                colorEnc=(trial(g,p).colors((1:2),:))';
                            case 3                 % setsize 3
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo=CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                rectThree=CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                allrects=[rectOne',rectTwo',rectThree'];
                                colorEnc=(trial(g,p).colors((1:3),:))';
                            case 4                 % setsize 4
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo=CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                rectThree=CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                rectFour=CenterRectOnPoint(rectOne,trial(g,p).locations(4,1),trial(g,p).locations(4,2));
                                allrects=[rectOne',rectTwo',rectThree',rectFour'];
                                colorEnc=(trial(g,p).colors((1:4),:))';
                                trial(g,p).colorEnc=colorEnc;
                        end
                        
                        Screen('FillRect',wPtr,colorEnc,allrects);
                        drawFixationCross(wPtr,rect)
                        T.encoding_on(g,p) = GetSecs;
                        Screen('Flip',wPtr);
                        
                        imageArray=Screen('GetImage',wPtr);
                        imwrite(imageArray,sprintf('Encoding%d%d.png',g,p),'png');

                        WaitSecs(2.0);   % MF: this is good for now: later we might want to easily adapt these timings (when defining all parameters)
                        T.encoding_off(g,p) = GetSecs; %DP it's already more general in the BeautifulColors2 version  % MF: Great!
                        
                end
                
            elseif phase == 2                                                                                                %first delay period
                
                phaselabel ='delay 1';
                drawFixationCross(wPtr,rect)
                Screen('Flip',wPtr);
                        imageArray=Screen('GetImage',wPtr);
                        imwrite(imageArray,sprintf('Delay%d%d.png',g,p),'png');
                T.delay1_on(g,p) = GetSecs;
                WaitSecs(2);                % MF: same here:  % MF: this is good for now: later we might want to easily adapt these timings (when defining all parameters)
                %             WaitSecs(pms.delay1Duration);
                T.delay1_off(g,p) = GetSecs;
                
            elseif phase == 3
                Screen('Textsize', wPtr, 34);
                Screen('Textfont', wPtr, 'Times New Roman');
                              
                switch trial(g,p).type
                             
                    case 0 %ignore
                        phaselabel = 'ignore';
                        %                         Screen('BlendFunction', w, GL_SRC_ALPHA, ...
                        %                                                 GL_ONE_MINUS_SRC_ALPHA);
                        
                        switch trial(g,p).setSize
                            case 1
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                colorInt=trial(g,p).colors(2,:);
                                allrects=rectOne;
                            case 2
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo=CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                allrects=[rectOne',rectTwo'];
                                colorInt=(trial(g,p).colors((3:4),:))';
                            case 3
                                
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo=CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                rectThree=CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                allrects=[rectOne',rectTwo',rectThree'];
                                colorInt=(trial(g,p).colors((4:6),:))';
                                
                            case 4
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo=CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                rectThree=CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                rectFour=CenterRectOnPoint(rectOne,trial(g,p).locations(4,1),trial(g,p).locations(4,2));
                                allrects=[rectOne',rectTwo',rectThree',rectFour'];
                                colorInt=(trial(g,p).colors((5:8),:))';
                        end
                        
                        Screen('FillRect',wPtr,colorInt,allrects);
                        DrawFormattedText(wPtr, non_target, 'center', 'center', N_color);
                        %                            drawFixationCross(wPtr,rect,10,[0 0 0],3)
                        T.I_ignore_on(g,p) = GetSecs;
                        Screen('Flip',wPtr);
                                                    imageArray=Screen('GetImage',wPtr);
                                                    imwrite(imageArray,sprintf('InterN%d%d.png',g,p),'png');
                        WaitSecs(2);
                        T.I_ignore_off(g,p) = GetSecs;
                        %                         [VBLTimestamp startrt]=Screen('Flip', w);

                    case 2
                        phaselabel = 'update';
                        %                         Screen('BlendFunction', w, GL_SRC_ALPHA, ...
                        %                                             GL_ONE_MINUS_SRC_ALPHA);
                        
                        switch trial(g,p).setSize
                            case 1
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                colorInt=trial(g,p).colors(2,:);
                                allrects=rectOne;
                            case 2
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo=CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                allrects=[rectOne',rectTwo'];
                                colorInt=(trial(g,p).colors((3:4),:))';
                            case 3
    
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo=CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                rectThree=CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                allrects=[rectOne',rectTwo',rectThree'];
                                colorInt=(trial(g,p).colors((4:6),:))';
                                
                            case 4
                                rectOne=CenterRectOnPoint(rectOne,trial(g,p).locations(1,1),trial(g,p).locations(1,2));
                                rectTwo=CenterRectOnPoint(rectOne,trial(g,p).locations(2,1),trial(g,p).locations(2,2));
                                rectThree=CenterRectOnPoint(rectOne,trial(g,p).locations(3,1),trial(g,p).locations(3,2));
                                rectFour=CenterRectOnPoint(rectOne,trial(g,p).locations(4,1),trial(g,p).locations(4,2));
                                allrects=[rectOne',rectTwo',rectThree',rectFour'];
                                colorInt=(trial(g,p).colors((5:8),:))';
                                trial(g,p).colorInt=colorInt;
                        end
                        
                        Screen('FillRect',wPtr,colorInt,allrects);
                        DrawFormattedText(wPtr, target, 'center', 'center', T_color);
                        %                            drawFixationCross(wPtr,rect,10,[0 0 0],3)
                        T.I_update_on(g,p) = GetSecs;
                        Screen('Flip',wPtr);
                                                    imageArray=Screen('GetImage',wPtr);
                                                    imwrite(imageArray,sprintf('InterU%d%d.png',g,p),'png');
                        WaitSecs(2);

                        T.I_update_off(g,p) = GetSecs;
                        
                        %
                        %                         [VBLTimestamp startrt]=Screen('Flip', w);
                        
                end % TYPETRIAL
                
            elseif phase == 4

                 phaselabel = 'delay 2';
                 T.delay2_on(g,p) = GetSecs; 
                 drawFixationCross(wPtr,rect)
                 Screen('Flip',wPtr);
%                  WaitSecs(J.delay2(trial,whatcondition));
                 T.delay2_off(g,p) = GetSecs; 
                 %half the update trials have a delay as large as the
                 %ignore/noInter trials to control for time issues

                 if practice==1
                     WaitSecs(2)
                 elseif practice==0
                 switch trial(g,p).type
                     case 0
                         WaitSecs(2)
                     case 2                         
                         WaitSecs(6) 
                 end
                 end 
            
                 
                            
            elseif phase == 5  %old version
                phaselabel = 'probe';
                
                if practice==1
                locationsrect=trial(g,p).locations;
                index2=randi(trial(g,p).setSize,1);
                probeRectXY=locationsrect(index2,:);
                probeRectX=probeRectXY(1,1);
                probeRectY=probeRectXY(1,2);

                
                switch trial(g,p).type
                    case {0 1}   %for IG and NInt
                        probeColorCorrect=trial(g,p).colors(index2,:);

                    case {2 22}      %for Update
                        index3=index2+trial(g,p).setSize;
                        probeColorCorrect=trial(g,p).colors(index3,:); %MF: explain these steps (what is index 2 and 3 referring to)
                end
                elseif practice==0
probeRectX=trial(g,p).locations(1,1);
probeRectY=trial(g,p).locations(1,2);
                
switch trial(g,p).type
    case 0
        probeColorCorrect=trial(g,p).colors(1,:);
    case 2
        probeColorCorrect=trial(g,p).colors((trial(g,p).setSize+1),:);
end

                end

wheelStart=starts(g,p);

                if practice==1
                     [respX,respY,rt,colortheta]=probecolorwheel2(pms.numWheelColors,probeRectX,probeRectY,pms.maxRT,1,probeColorCorrect,wheelStart);
                elseif practice==0
                     [respX,respY,rt,colortheta]=probecolorwheel2(pms.numWheelColors,probeRectX,probeRectY,pms.maxRT,0,probeColorCorrect,wheelStart);
                end
                [stdv,respDif,tau,thetaCorrect]=stdev(colortheta,probeColorCorrect,respX,respY,pms.maxStdev);
               
               if practice==0
               if g==pms.numTrials && p<pms.numBlocks
                    DrawFormattedText(wPtr,sprintf('End of block %d, press any key to continue',p ),'center','center',[0 0 0]);
                    Screen('Flip',wPtr)
                    save(dataFilenamePrelim)
                    KbWait();
               end
               end
               
                data(g,p).respCoord(1,1)= respX; %saving response coordinates in struct where 1,1 is x and 1,2 y
                data(g,p).respCoord(1,2)=respY;
                data(g,p).rt=rt;
                data(g,p).probeLocation=[probeRectX probeRectY];
                data(g,p).probeColorCorrect=probeColorCorrect;
                data(g,p).stdev=stdv;
                data(g,p).respDif=respDif;
                data(g,p).thetaCorrect=thetaCorrect;
                data(g,p).tau=tau;
                
                %add additional things to data
                data(g,p).setsize = trial(g,p).setSize;
%                 data(g,p).trialNum=trial(g,p).number;
                data(g,p).type=trial(g,p).type;
                data(g,p).location =trial(g,p).locations;
                data(g,p).colors = trial(g,p).colors;
                %data(g,p).interTime=trial(g,p).interTime;

                %                                         elseif phase==6
                %                                    phaselabel='feedback';
                % %                                    probecolorwheel2(numWheelColors,probeRectX,probeRectY,colorResponded,2)
                %                                     Screen('DrawLine', wPtr, [0 0 0], fromH, fromV, toH, toV, penWidth)
                
            end %if phase ==1
        end % for phase 1:5
    end% for p=1:numBlocks
end  % for g=1:numTrials

end

