function getInstructions(level,pms,wPtr)
%%%This function provides the insturctions for the
%%%Quantifying cognitive control experiment. As inputs it receives level (1=memory, 2=discounting), 
%%encTime is the time they have to memorize squares during encoding and
%%maxRT the time they have to respond using the colorwheel. 


% % Priority(1); %Give matlab/PTB processes high priority
HideCursor;
% level=1;
% encTime=2;
% maxRT=4;
% % open an onscreen window
% Screen('Preference','SkipSyncTests',1);
% Screen('Preference', 'SuppressAllWarnings', 1);
% [wPtr]=Screen('Openwindow',max(Screen('Screens')));

%% Centering

%screenWidth = rect(3);
%screenHeight = rect(4);
%screenCenterX = screenWidth/2;
%screenCenterY = screenHeight/2;

 %% Define which text style to use for instructions
  
%         Screen('TextSize',wPtr, 32);            %determine size of text
%         Screen('TextFont',wPtr, 'Helvetica');   %Which font has the text
%         Screen('TextStyle',wPtr, 1); 
% wid = 10;
textCol = [0 0 0];
wrptx = 50;
spacing = 3;
Screen('TextSize',wPtr,26);
Screen('TextStyle',wPtr,1);
Screen('TextFont',wPtr,'Times New Roman');
   
%% Show first instructions with Screen('DrawText',wPtr,text,x,y,color)
         %Add text that should appear
 
 if level == 1
     
        Instruction{1} = 'Welcome to our experiment.\n Press any key to start...'; 
        Instruction{2} = 'The first part is a memory task.\n The task has 3 phases that keep repeating each other.';
        Instruction{3} =sprintf('Phase 1: you will see a colored square on the screen.\n The square will be shown for %d seconds.',pms.encDuration); 
        Instruction{4} = 'You need to memorize the color and the location of the square.';
        imageEnc=importdata('Encoding1');
        Instruction{5}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 1: memorize color and location.';
        Instruction{6} = 'Phase 2: you will see another square at the same location.\n\n The new square will be accompanied by a letter in the middle of the screen.'; 
        Instruction{7} = 'The letter is very important because it tells you what to do next.\n\n If the letter is N, you need to neglect the new square\n and still keep in memory the one from phase 1.';
        imageNeg=importdata('InterNeglect1');
        Instruction{8}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2: Neglect this square.';
        Instruction{9} = 'But if the letter is U, you need to remember ONLY the new square presented in phase 2.'; 
        imageUpd=importdata('InterUpdate1');
        Instruction{10}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2: Update this square to your memory.' ;
        Instruction{11} = sprintf('Phase 3: you see a colorwheel and a square without color.\n\n Within %d seconds you need to indicate with a mouse click on the wheel, which color you needed to remember.',pms.maxRT); 
        imageProbe=importdata('probe');
        Instruction{12}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n Click on the correct color!';
        Instruction{13}='Please try to always look at the screen.';
        Instruction{14} ='Summary: \n\n Phase 1:\n You always remember the color and location of the square.\n\n Phase 2:\n If the letter in the centre is N:\n you NEGLECT the new color in phase 2.\n If the letter in the centre is U:\n you UPDATE your memory with ONLY the new square.\n\n Phase 3: On the colorwheel you indicate which color you needed to remember.';
        Instruction{15} = 'We start with one square being presented at a time, but increase it up to 4.\n When multiple colors are presented, try to memorize all colors and the according locations.\n\n The location of the square presented in the centre of the colorwheel indicates which color you need to recall.';
        Instruction{16}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 1 with 4 colors';
        imageE4=importdata('Encsz4.png');
        Instruction{17}='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Phase 2 with 4 colors';
        imageU4=importdata('InterUsz4.png');
        Instruction{18}='\n\n\n\n\n\n\n\n Of all 4 colors you need to indicate only the probed color';
        Instruction{19} = 'Is everything clear?\n\n It is very important that you understand this part well and we realize that it might be confusing in the beginning.\n Please make contact with the researchers, they will start the practice when all questions are addressed..';
%         Instruction{12}='This is the end of the memory task!';
       % we ll need level 2 for the discounting part :-)
 elseif level == 2

        Instruction{1} = 'You finished the practice.\n\n You may now proceed with the actual task.'; 
        Instruction{2}='We split the task in 3 blocks. \n\n After every block you can take a break and communicate with the researchers';
        Instruction{3}='Good luck with the memory task!';
 
 elseif level ==3
%      
        Instruction{1}='End of practice!';
%         Instruction{2}='You will see one colored square and you simply have to name its color';
%         Instruction{3}='Do not think too much to reply\n\n Your answer will be presented on the screen only after you press enter';
%  
 elseif level==4
    
        Instruction{1}='This was the end of the memory task! \n\n Please contact the researchers.';
        
 end
 
 for i = 1:length(Instruction)
     if level==1
 
    % Exceptions for figures;
     if i == 5
         Screen('PutImage', wPtr, imageEnc)
         DrawFormattedText(wPtr,Instruction{5},'center','center',textCol,wrptx);
         Screen('flip',wPtr);
          KbWait();
     elseif i == 8
         Screen('PutImage', wPtr, imageNeg)
         DrawFormattedText(wPtr,Instruction{8},'center','center',textCol,wrptx);
%          Screen('flip',wPtr);
%           KbWait();
     elseif i == 10
         Screen('PutImage', wPtr,imageUpd)
         DrawFormattedText(wPtr,Instruction{10},'center','center',textCol,wrptx);
%          Screen('flip',wPtr);
%           KbWait();
     elseif i == 12
         Screen('PutImage', wPtr, imageProbe)
         DrawFormattedText(wPtr,Instruction{12},'center','center',textCol,wrptx);
%          Screen('flip',wPtr);
%           KbWait();
     elseif i==16
         Screen('PutImage', wPtr, imageE4)
         DrawFormattedText(wPtr,Instruction{16},'center','center',textCol,wrptx);
     elseif i==17
         Screen('PutImage', wPtr, imageU4)
         DrawFormattedText(wPtr,Instruction{17},'center','center',textCol,wrptx);
     elseif i==18
         Screen('PutImage', wPtr, imageProbe)
         DrawFormattedText(wPtr,Instruction{18},'center','center',textCol,wrptx);

     else
          DrawFormattedText(wPtr,Instruction{i},'center','center',textCol,wrptx);
     end
     end
     
     if level==2 || level==3 || level==4
         DrawFormattedText(wPtr,Instruction{i},'center','center',textCol,wrptx);
     end
     
      Screen('flip',wPtr);
      if level==1 && i==length(Instruction)
         GetClicks()
      else  
          KbWait()
      end
      
     
     Screen('flip',wPtr); %Flip: show the written commands
     
     %record the keyboard click
     responded = 0;
     while responded == 0
         [keyIsDown] = KbCheck;
         if keyIsDown==1
             WaitSecs(1);
             responded = 1;
         end
     end
 end
%  clear Screen
 end

                             
       
%                 %Wacht op het indrukken van de muis toets voordat het verder gaat
%    
%                 
%                 % collect response, checking both mouse and keyboard
% responded = 0;
% while responded==0
%  
%     if ~isempty(mouseresp) % check mouse
%         [x, y, buttons] = GetMouse(wid);
%         secs = GetSecs;
%         if (any(buttons))
%             responseMatches = any(ismember(num2str(find(buttons)),mouseresp));
%             if strcmp(mouseresp,'any') || responseMatches
%                 responded = 1;
%                 resp = num2str(find(buttons));
%                 rt = secs - onset_stamp;
%             end
%         end
%     end
%     WaitSecs(.001);
% end


