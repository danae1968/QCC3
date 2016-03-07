function [stdv,respDif,tau,thetaCorrect,radius]=stdev(colortheta,probeColorCorrect,respX,respY,maxStdev)
%function that finds the standard deviation between response and correct
%color. Colortheta is a struct with all colorwheel shades and corresponding
%angles in the colorwheel. respX and respY are the coordinates of the mouse
%click on the screen.%if the participant did not respond stdev is assigned
% as not a number
%%

%%%finds radius of circle based on x and y coordinates,as every response
%provides a different radius. then we can find the tau angle of the
%response. Initially tau is provided with the xx' but we need the angle
%yy', so it is converted. 
global rect
centerX=rect(3)/2;
centerY=rect(4)/2;
% maxStdev=40;          MF: how define maxStdev?

%%if they pressed on the fixation cross tau=NaN, no angle created
if respX==centerX && respY==centerY
    tau=NaN;
end

radius=sqrt((respX-centerX)^2+(respY-centerY)^2); 
                       sint=(respY-centerY)/radius; 
                       cost=(respX-centerX)/radius;
                       
                       if cost>=0 
                           tau=90-(-asind(sint)); 
                       elseif cost<0
                           tau=180+90-(asind(sint)); 
                       end
                       
                       %%finds shade in colortheta that matches the correct
                       %%color of the probe and provides the angle theta of
                       %%the correct response
                       for n=1:length(colortheta)    
                            if colortheta(n).color==probeColorCorrect
                                thetaCorrect=colortheta(n).theta;
                            end
                       end
                       
                       if thetaCorrect>360
                           thetaCorrect=thetaCorrect-360;
                       end
                                  
%                        %% Finds color chosen based on angle tau. -does not work.0.5625 is the angle that 
%                        %theta increases.
%                                 
%                        for N=1:length(colortheta)
%                            if colortheta(N).theta>=tau-0.5625/2 && colortheta(N).theta<=tau+0.5625/2
%                                colorResponded=colortheta(N).color;
%                            else
%                                colorResponded=[255 0 0];
%                            end
%                        end
                           
                       %%
                       %compares theta and tau and provides st.deviation and difference in degrees.
                       %For the cases around 0 and 360 degrees, I made this
                       %weird solution, can become more strict or lenient. if
                       %participant did not respond stdev=NaN
                       if thetaCorrect<maxStdev/2 && tau>360-maxStdev/2
                           A=[thetaCorrect (360-tau+2*thetaCorrect)]; 
                           stdv=std(A);
                           respDif=A(1,1)-A(1,2);
                        elseif thetaCorrect>360-maxStdev/2 && tau<maxStdev/2
                            A=[thetaCorrect (360+2*tau)];
                            stdv=std(A);
                            respDif=A(1,1)-A(1,2);
                        elseif respX==0 && respY==0
                           stdv=NaN;
                           respDif=NaN;
                       elseif respX==centerX && respY==centerY
%                            tau=NaN;
                           stdv=NaN;
                           respDif=NaN;
                       else
                           A=[thetaCorrect tau];
                           stdv=std(A);
                           respDif=A(1,1)-A(1,2);
                           if abs(respDif)>180
                               respDif=mod(360,abs(respDif));
                           end
                       end
                       
end
