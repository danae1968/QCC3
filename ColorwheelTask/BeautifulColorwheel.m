
function [data, trial, T] = BeautifulColorwheel
% Colorhwheel
%
% This function presents the DMS task - here: part 1 of the QuantifyingCC study
% The DMS has 3 phases:
% 1) Encoding phase
% 2) Interference phase
% 3) Probe phase
%
% 1) During the encoding phase,articipants will see different setsizes (=1-4) of colored squares.
%    The task is to encode (=remember) the colors and locations.
%
% 2) During the interference phase, there are 3 conditions:
%       i) IGNORE (indicated by the letter 'N' (=Negeer in Dutch) in the centre): pps should ignore the new stimuli
%           and still remember the colors/locations presented during ENCODING.
%       ii) No Interference (indicated by a fixation cross): pps have no new input,
%           and still remember the colors/locations presented during ENCODING.
%       iii) UPDATE (indicated by the letter 'U'): pps should overwrite/forget the colors/locations of the ENCDOING,
%           but ONLY remember the latest colors/locations presented during interference phase.
%
% 3) During the probe phase: colorhweel appears and a square.
%       Participants should recall the color that was presented at that location of the square:
%       during the ENCODING (for i and ii) or during the intervening phase (for iii).
%       With a mouse click on the colorwheel, they give a response.
%
% This file calls the following (sub)functions:
%   getInfo
%   trialstruct
%   getInstructions
%   showTrial

try
    %%%%%%
 
    %% set experiment parameters
    %task
   [subNo,dataFilename,dataFilenamePrelim,practice,manipulation]=getInfo; 

    %% set experiment parameters
    %task
%     pms.practice=0;


    pms.numTrials = 20; % adaptable; important to be dividable by 2 (conditions) and multiple of 4 :)
    pms.numBlocks = 1;

    pms.numCondi = 2;  % 0 IGNORE, 2 UPDATE
    pms.numTrialsPr=16;
    pms.numBlocksPr=1;
    pms.maxSetsize=4;
    
    pms.NameTrials=24;
    
    %colors
    pms.numRectColors=512;
    pms.numWheelColors=512;
    pms.maxStdev=90;
    
    %text
    pms.textColor=[0 0 0];
    pms.wrapAt=100;
    pms.spacing=3;
    pms.subNo=subNo;
    pms.matlabVersion='R2013a';
    % timings
    pms.maxRT = 4; % max RT
    pms.encDuration = 2;    %2 seconds of encoding
    pms.delay1Duration = 2; %2 seconds of delay 1
    pms.interfDuration = 2; %2 seconds interfering stim
    pms.delay2Duration = 2; %2 seconds of delay 2
    pms.jitter = 0; % should trial duration be jittered (no: 0, yes: 1)
%     pms.reps = reps;
    
    %% display and screen
    % display parameters
    %     mon = 0; % 0 for primary monitor
    %     pms.bkgd = 200; % intensity level of background gray
    
    % bit Added to address problem with high precision timestamping related
    % to graphics card problems
    
    % Screen settings
    Screen('Preference','SkipSyncTests', 1);
    Screen('Preference', 'VBLTimestampingMode', -1);
    Screen('Preference','TextAlphaBlending',0);
    Screen('Preference', 'VisualDebugLevel',0);
    % initialize the random number generator
    randSeed = sum(100*clock);
    delete(instrfind);
    %RandStream.setGlobalStream(RandStream('mt19937ar','seed',randSeed));
    
    HideCursor;
    ListenChar(2);%2: enable listening; but keypress to matlab windows suppressed.
    Priority(1);  % level 0, 1, 2: 1 means high priority of this matlab thread
    
    % open an onscreen window
    global rect wPtr;
     [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')));
    %[wPtr,rect]=Screen('Openwindow',[0 0 800 600]); %for debug
    %[pms.wid, pms.wRect] = Screen('OpenWindow',mon,[pms.bkgd*ones(1,3), 255],[0 0 800 600],[],[],[]); %debug
    Screen('BlendFunction',wPtr,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
    %% get trialstrcutre depending on pms
    %%%%%% prepare trials
    % function to get trialstructure using pms as input

    if practice==0
         [trial]=defstruct(pms,rect);
%         load trialDef
    elseif practice==1
         [trial]= trialstruct(pms,rect,0);    
    end
    %% prepare data for easy export later
    
    % log general subject and session info
    dataHeader ='WMcolors';
    dataHeader.randSeed = randSeed;
    dataHeader.sessionTime = fix(clock);
    dataHeader.subjectID = subNo;
    dataHeader.dataName = dataFilename;
    dataHeader.logdir = cd; %adapt logdir
    dataHeader.manipulation=manipulation;
    
    % initialize data set
    data.setsize=[]; %trial(:,:).setSize;
    data.trialNum=[]; %trial(:,:).number;
    data.trialtype=[]; %trial(:,:).trialType;
    data.location =[]; %trial(:,:).locations;
    data.colors = []; %trial(:,:).colors;
    data.respCoord=[];
    data.onset=[];
    data.rt=[];
    data.probeLocation = [];
    data.stdev=[];
    data.thetaCorrect=[];
    data.respDif = [];
    
    % baseline for event onset timestamps
    exptOnset = GetSecs;
    
    %% Define Text MF: (maybe define in sep function)
    Screen('TextSize',wPtr,16);
    Screen('TextStyle',wPtr,1);
    Screen('TextFont',wPtr,'Courier New');
  %% Color vision task
  if practice==1
  colorVision(pms)
  end
    %% Experiment starts with instructions
    %%%%%%% get instructions
    % show instructions
% 
%   %for now
    if     practice==1
           getInstructions(1,pms,wPtr);
    elseif practice==0
           getInstructions(2,pms,wPtr);
    end

    
    %% Experiment starts with trials
    
    % stimOnset = Screen(wPtr,'Flip'); CHECK onsets
    % onset = stimOnset-exptOnset;
    % run begins
    
    WaitSecs(1); % initial interval (blank screen)

    %%%%%%
    % showTrial

    if practice==1
         [data, T] = showTrial2(trial, pms,practice,dataFilenamePrelim); %adapt MF
    elseif practice==0
         [data, T] = showTrial2(trial, pms,0,dataFilenamePrelim); %adapt MF
    end

        % showTrial opens colorwheel2 and stdev function
    
        
    %% Save the data
    save(dataFilename);
    %% Close-out tasks
    if practice==0
       getInstructions(4,pms,wPtr)   
    elseif practice==1
       getInstructions(3,pms,wPtr)   
    end
%    
%      getInstructions(4,pms,wPtr)
%     end
    
    clear Screen
    Screen('CloseAll');
    ShowCursor; % display mouse cursor again
    ListenChar(0); % allow keystrokes to Matlab
    Priority(0); % return Matlab's priority level to normal
    Screen('Preference','TextAlphaBlending',0);
   
catch ME
    disp(getReport(ME));
    keyboard
    
    % save data
    save(dataFilename,'data','dataHeader');
    
    
    % close-out tasks
    Screen('CloseAll'); % close screen
    ShowCursor; % display mouse cursor again
    ListenChar(0); % allow keystrokes to Matlab
    Priority(0); % return Matlab's priority level to normal
    Screen('Preference','TextAlphaBlending',0);
    
end %try-catch loop
end % main function



