function [respX,respY,rt,colortheta]=probecolorwheel2(numberColors,probeRectX,probeRectY,maxRT,practice,probeColorCorrect,wheelStart)
% function that gives the colorwheel for the task and the probe. Takes as
% inputs the amount of colors the wheel will show, the X Y coordinates
% of the probe rect and the maxRT possible. Colorwheel is constructed by
% two Rects. One is the wheel and the other an oval shape that masks the
% center of the wheel. The coordinates are related to each screen. The
% colors are created with arcs. The first arc start at vertical and it goes
% on clockwise until circle is completed. Arc's size is reversely analogous
% to number of colors used. Colortheta is a struct with the angle of every
% color in the wheel and the corresponding color. 

global rect %made them global so we don't have to open the screen all the time
global wPtr
% Screen('Preference','SkipSyncTests',1); 
% Screen('Preference', 'SuppressAllWarnings', 1);
% [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')));   

%coordinates in outer circle of wheel, so we can estimate radius
% wheelRadiusX=611; 
% wheelRadiusY=113;

centerX=rect(3)/2;
centerY=rect(4)/2;
ShowCursor('Arrow'); %we can change the shape of the mouse and then type ShowCursor(newcursor) %MF: wow, that's cool!!
SetMouse(rect(3)/2,rect(4)/2,wPtr);
% numberColors=64;
% probeRectX=600;
% probeRectY=500;  
% % exptOnset=1;
% maxRT=3;

                          probeColor=[0 0 0];
                          probeRect=[100 100 200 200];
                          insideRect=[rect(1) rect(2) 0.67*rect(4) 0.67*rect(4)]; %the white oval coordinates
                          outsideRect=[rect(1) rect(2) 0.9*rect(4) 0.9*rect(4)]; %the wheel coordinates
                          
                          %center all rects 
                          outsideRect=CenterRectOnPoint(outsideRect,centerX, centerY);
                          insideRect=CenterRectOnPoint(insideRect,centerX,centerY);
                          probeRect=CenterRectOnPoint(probeRect,probeRectX,probeRectY);
                          
                          %define colors
                   
                          colors=hsv(numberColors)*255; %MF: *255 brings them into RGB? DP:yes! they are between 0 and 1 in this form
                          colorangle=360/length(colors);  %convert into pi? ecs

%                           origins=0:10:360; %origin point of first colors of wheel (red)
%                           starts=randsample(origins,1);
%                           starts=datasample(origins,224);
                         
                          startangle=wheelStart:colorangle:360+wheelStart;

                          %startangle=0:colorangle:360; 
      
                          for ind=1:length(colors)
                              Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
                          end
                          
                          Screen('FillOval',wPtr,[255 255 255 ],insideRect);
                          Screen('FrameRect', wPtr, probeColor, probeRect); 
                          drawFixationCross(wPtr,rect)
                          
                          %OPTION 1:
%                           Screen('Flip',wPtr)
%                            
% %                         probeOnset=Screen('Flip',wPtr);
%                           probeOnset=GetSecs();
% %                         onset=probeOnset-exptOnset;
%                         
%                           while GetSecs-probeOnset<maxRT
%                              [~,~,buttons]=GetMouse(wPtr); %MF: check other input when go to MRI version
%                              while any(buttons) % wait for release
%                                  %these below make a picture of screen
% %                                  imageArray=Screen('GetImage',wPtr);
% %                                  r=randi(100,1);
% %                                  imwrite(imageArray,sprintf('probe%d',r),'bmp');
%                                [x,y,buttons] = GetMouse;
%                                pressTime=GetSecs();
%                                 respX=x;
%                                 respY=y;
%                                 rt=pressTime-probeOnset; %is this accurate? MF: I will check in another script; never used mouse click before
% 
%                              end
% %                              if ~ any(buttons)
% %                                  respX=0
% %                                  respY=0
% %                                  rt=200
% %                              end
%                           end
%               
                        
                          %OPTION 2:
                          probeOnset = Screen('Flip',wPtr);
                          r=randi(100);
                          imageArray=Screen('GetImage',wPtr);
                          imwrite(imageArray,sprintf('Probe%d.png',r),'png');
                          
                          while GetSecs-probeOnset<maxRT
                             [keyIsDown, secs, keyCode] = KbCheck;
                             [x,y,buttons]=GetMouse(wPtr);
                             if any(buttons>0)
                                pressTime=GetSecs();
                                respX=x;
                                respY=y;
                                rt=secs-probeOnset;
                             end
                          end
                          
WaitSecs(0.001);
HideCursor();
% clear Screen

 theta=zeros(length(colors),1);
                       for index=1:length(colors)       %MF: length(colors) and numberColors always same number? why use length here and 1 line later numberColors
                           theta(index)=(360*index)/numberColors; % MF: smart solution :) so we always go in steps of 360/numberColors.
                       end
                       
                       colortheta=struct; % MF: colortheta will be a structure with numberColors fields linking "color" to "angle" of presentation
                       for n=1:length(colors)
                           colortheta(n).color=colors(n,:); %pick color n from all colors
                           colortheta(n).theta=theta(n)+wheelStart;    %pick angle n form all angles
                       end
%% If practice=1 then they get feedback. I suppose this should be a new function?
% if respX exists means they responded
if exist('respX','var')
%%no practice, actual task
    if practice==0
          [~,~,tau,~,radius]=stdev(colortheta,probeColorCorrect,respX,respY,90); %90 for red responses around 0

    for ind=1:length(colors)
            Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
    end
%           Screen('DrawLine', wPtr, [0 0 0], centerX, centerY, respX, respY,2)
          if ~isnan('tau')
              if radius>abs(insideRect(1)-insideRect(3))/2
                  Screen('FillArc',wPtr,[0 0 0],outsideRect,tau-0.2,0.2);
                  Screen('FillOval',wPtr,[255 255 255],insideRect);
                  Screen('FrameRect', wPtr, probeColor, probeRect);
                  drawFixationCross(wPtr,rect)
                  Screen('Flip',wPtr)
                  WaitSecs(2);
          
              elseif radius<abs(insideRect(1)-insideRect(3))/2
                  Screen('FillOval',wPtr,[255 255 255 ],insideRect);
                  Screen('FrameRect', wPtr, probeColor, probeRect);
                  Screen('TextSize',wPtr,15);
                  DrawFormattedText(wPtr, 'Please click on the colorwheel!', 'center', 'center', [0 0 0]);
                  Screen('Flip',wPtr)
                  WaitSecs(2); 
              end
              
          elseif isnan('tau') %tau is NaN when they click on the fixation cross %for MF; this doesn't work; doublecheck

              Screen('FillOval',wPtr,[255 255 255 ],insideRect);
              Screen('FrameRect', wPtr, probeColor, probeRect);
              Screen('TextSize',wPtr,15);
              DrawFormattedText(wPtr, 'Please click on the colorwheel!', 'center', 'center', [0 0 0]);
              Screen('Flip',wPtr)
              WaitSecs(2);
          end
   %practice
    elseif practice==1
        [~,respDif,tau,thetaCorrect,radius]=stdev(colortheta,probeColorCorrect,respX,respY,90);
        for ind=1:length(colors)
            Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
        end

          if ~isnan('tau')
                 if radius>abs(insideRect(1)-insideRect(3))/2
          Screen('FillArc',wPtr,[0 0 0],outsideRect,tau-0.2,0.2);
%           Screen('FillArc',wPtr,[0 0 0],outsideRect,thetaCorrect-0.2,0.2);
          Screen('FillOval',wPtr,[255 255 255 ],insideRect);
          Screen('FrameRect', wPtr, probeColor, probeRect);
          drawFixationCross(wPtr,rect)
          Screen('Flip',wPtr);
          WaitSecs(1);
          for ind=1:length(colors)
            Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
          end
          Screen('FillArc',wPtr,[0 0 0],outsideRect,tau-0.2,0.2);
          Screen('FillArc',wPtr,[0 0 0],outsideRect,thetaCorrect-0.2,0.2);
          Screen('FillOval',wPtr,[255 255 255 ],insideRect);
          Screen('FrameRect', wPtr, probeColor, probeRect);
          
          %feedback if they are +-10 degrees from target
             if abs(respDif) <=10
                 Screen('TextSize',wPtr,15);
                 message=sprintf('Good Job! you deviated only %d degrees',abs(round(respDif)));
            DrawFormattedText(wPtr, message, 'center', 'center', [0 0 0]);
             else
          %otherwise no feedback
          drawFixationCross(wPtr,rect)
             end
             Screen('Flip',wPtr)
             WaitSecs(2);
             
                      elseif radius<abs(insideRect(1)-insideRect(3))/2
                  Screen('FillOval',wPtr,[255 255 255 ],insideRect);
                  Screen('FrameRect', wPtr, probeColor, probeRect);
                  Screen('TextSize',wPtr,15);
                  DrawFormattedText(wPtr, 'Please click on the colorwheel!', 'center', 'center', [0 0 0]);
                  Screen('Flip',wPtr)
                  WaitSecs(2); 
                 end
          elseif isnan('tau') %tau is NaN when they click on the fixation cross
              Screen('FillOval',wPtr,[255 255 255 ],insideRect);
              Screen('FrameRect', wPtr, probeColor, probeRect);
              Screen('TextSize',wPtr,15);
              DrawFormattedText(wPtr, 'Please click on the colorwheel!', 'center', 'center', [0 0 0]);
              Screen('Flip',wPtr)
              WaitSecs(2);
          end
    end
          
elseif ~exist('respX','var')
      %%if the participant did not respond respX does not exist, so it is set to 0
%and rt to 200.Also,they get feedback that they did not respond on time
    respX=0;
    respY=0;
    rt=200;
  
    for ind=1:length(colors)
            Screen('FillArc',wPtr,colors(ind,:),outsideRect,startangle(ind),colorangle);
    end
          Screen('FillOval',wPtr,[255 255 255 ],insideRect);
          Screen('FrameRect', wPtr, probeColor, probeRect);
          Screen('TextSize',wPtr,15);
          DrawFormattedText(wPtr, 'Please respond faster', 'center', 'center', [0 0 0]);
          Screen('Flip',wPtr)
          WaitSecs(2);
   
end
%                           responded=[];
%                           while isempty(responded) && (GetSecs-probeOnset)<maxRT
%                             [KeyIsDown,secs,~]=KbCheck(1);
%                             [clicks,x,y,whichButton] = GetClicks(wPtr);
%                             if clicks>=1;
%                                 responded=1;
% %                                 respTimeStamp=GetSecs; is this better
% %                                 than secs?
%                                         respX=x;
%                                         respY=y;
%                                         rt=secs-probeOnset;
%                             elseif clicks==0;
%                                 responded=0;
%                               respX=0;
%                               respY=0;
%                               rt=0;
%                               break
%                             end
                            
%      clear Screen                 
%     
end
              
                        


      




