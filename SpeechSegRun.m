%% Script use to run Speech Segmentation experiment
%  Present Movie of habituation  and a force choice task with sound
%
% 20/08/19

%%initialise experiment

%some display in the command window
clear all
fprintf('\n___________________________________________ ',1);
fprintf('\n Run Experiment Speech Segmentation \n',1);
fprintf('\n___________________________________________ \n',1);

PsychJavaTrouble %reload some Java code to avoid errors during experiments

% Set the global var for the experiment, the var where we save the participants data
Nom=[];
Nom.code=input('Participant code : ','s'); %set the var to save for each participant

% Select the strings to create the address of the sounds to play and create a pseudo-random order of the bloc

pathStimVideo='/home/perrine/Documents/ExperimentScript_forMatlab/stim_familiarization/';  %!!!!this adress is computer Specific!!!!
pathStimSound='/home/perrine/Documents/ExperimentScript_forMatlab/stim_audio_test/'; %!!!!this adress is computer Specific!!!!



startExp=0; %initialize a var to control the while loop
group=input('%%%%%%\n\nenter 1, 2, 3 or 4 to chose group order : '); %ask to enter a goup for participants


while ~startExp % loop on the value od startExp when 0 loop when 1 stop the loop
    try
        switch group %control the flow of the experiment depending on the value of group
            case 1 % if the participants is in the group 1 the following familiariztion/test trials will be played
                StimuliSet={'BananaS23min_order1.mp4','badopouW_togoutiPW_44100.wav', 'rakibouPW_dogapiW_44100.wav', 'pibadoPW_goutiraW_44100.wav', 'kiboutoW_poudogaPW_44100.wav', 1, 2, 2, 1};
                startExp=1; %change value of startExp to stop the loop
                fprintf('\n you selected 1 the participant is attributed to group 1 \n',1); %display some info on the command line window
            case 2 % if the participants is in the group 2 the following familiariztion/test trials will be played
                StimuliSet={'BananaS23min_order2.mp4', 'rakibouPW_dogapiW_44100.wav','kiboutoW_poudogaPW_44100.wav','badopouW_togoutiPW_44100.wav','pibadoPW_goutiraW_44100.wav', 2, 1, 1, 2};
                startExp=1; %change value of startExp to stop the loop
                fprintf('\n you selected 2 the participant is attributed to group 2 \n',1);
            case 3 % if the participants is in the group 3 the following familiariztion/test trials will be played
                StimuliSet={'BananaS23min_order3.mp4','goutiraW_pibadoPW_44100.wav','togoutiPW_badopouW_44100.wav','dogapiW_rakibouPW_44100.wav','poudogaPW_kiboutoW_44100.wav', 1, 2, 1, 2};
                startExp=1; %change value of startExp to stop the loop
                fprintf('\n you selected 2 the participant is attributed to group 3 \n',1);
            case 4 % if the participants is in the group 4 the following familiariztion/test trials will be played
                StimuliSet={'BananaS23min_order4.mp4','poudogaPW_kiboutoW_44100.wav','goutiraW_pibadoPW_44100.wav','togoutiPW_badopouW_44100.wav','dogapiW_rakibouPW_44100.wav',2,1,2,1};
                startExp=1; %change value of startExp to stop the loop
                fprintf('\n you selected 2 the participant is attributed to group 4 \n',1);
            otherwise % ifthe experimenters did not enter one of the authorized group ask again the question
                group=input('\n you enter a non-expected character! enter 1 for group1 or 2 for group2 etc.   \n');
        end
    catch
        group=input('\n you enter a non-expected character! enter 1 2 3 or 3 :  \n');
    end
end

Nom.Groupe=StimuliSet; %save the stimulus set in the Global var Nom. Nom is a structure


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Keyboard Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KeyBoard_basics % run the script to load my basic set of KB initialiation
leftsh=KbName('LEFTSHIFT');% set some useful key
spa=KbName('SPACE');% set some useful key
stp=KbName('ESCAPE');% set some useful key


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Experimental Blocks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set the default value to play a movie

fprintf(['%%%%%%\n\nPress any key to Start Speech Segmentation Test'],1); %display that the prog is ready to start the experiment

ListenChar;
pause

WaitSecs(3);

cmdDos='vlc --fullscreen --video-on-top  --no-video-title-show --play-and-exit ';

%show movie
system([cmdDos pathStimVideo StimuliSet{1}])

%%  Init Haardware Screen + Sound
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Screen Init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try % long code that can trigger erros
    ordi=Screen('Computer');
    %READ the presentation screen size
    scr=Screen('Screens');
    
    PresScreen=0; %by default there is only one monitor
    resol=[50 50 700 500]; % small window for debug
    ScreenWidth=700;
    ScreenHeight=500;
    if size(scr,2)==1 %CHECK if a second monitor is connected
        PresScreen=0;%SET the first (tobii) monitor as presentation screen
        %resol=Screen('Rect',PresScreen); % fulscreen
        ScreenResolution=Screen('Resolution', PresScreen); %READ screen resolution
        ScreenWidth=ScreenResolution(1).width;
        ScreenHeight=ScreenResolution(1).height;
    end
    
    
    % preferences PTB
    priorityLevel=MaxPriority(scr,'WaitBlanking');
    Screen('Preference', 'VisualDebugLevel', 1); % vire fenetre 'welcome'
    %ListenChar(2); %elimine entrees clavier sur fenetre
    
    % some usefull colors
    white = WhiteIndex(scr); %255
    black = BlackIndex(scr); %0
    
    
    %%%%%%  black screen
    Screen('Preference', 'SkipSyncTests', 2);
    Screen('Preference','SuppressAllWarnings',0);
    [windowBG,rect]=Screen('OpenWindow', PresScreen,black);
   % [windowBG,rect]=Screen('OpenWindow',PresScreen, black,resol);%when debugging open inly a small window to be able to stop experiment easily
    [centerx, centery]=RectCenter(rect); %find the center of our black window
    Screen('Flip',windowBG);
    
catch %what the program should do if it encounters an error
    Screen('CloseAll')
    display('!!!!!!!!!!!  Problem initialisation Screen !!!!!!!!!!!')
end
HideCursor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Init sound Card %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pahandle=Init_SoundCard;

%% Trials = reponse recording
%%%%%%%%%%%%%%%%
Nom.data=[]; %create field data in Nom = where we will record the response of the subject

WaitSecs(0.5)

try % long code that can trigger erros
    for sound=1:4 % we will loop on the 4 trials
        
        
        if sound==1 % remind the task before the 1s trial
            DrawFormattedText(windowBG,'The Test will start in 2 secs you will hear 2 sounds \n select the one you think was present during the video','center',white);
            Screen('Flip',windowBG);
            WaitSecs(4);
        end
        %remind each loop what are the keys for answering
        DrawFormattedText(windowBG,'left shift for first sound / right shift for second','center',white);
        Screen('Flip',windowBG);
        WaitSecs(2);
         
        
        %******************************************************************
        %******************************************************************
        %% Trial sound presentation + keyboardresponse
        %******************************************************************
        
        %Set the sound to play
        
        
        [y, freq] = audioread([pathStimSound StimuliSet{1+sound}]);%load in matlab the sound file, the sound file in loaded in the form of a vector
        wavedata =y';% PTB need a line vector to play sound my system requiert mono sound to play the sound correctly but in stereo system we will write wavedata =[y y]';
        PsychPortAudio('FillBuffer', pahandle, wavedata); %load the sound in the buffer of ptb
        
        DrawFormattedText(windowBG,'+', centerx, centery, white); %display a central fixation
        Screen('Flip',windowBG);
        
        PsychPortAudio('Start', pahandle,1, 0, 1); %play the sound
        
        
        tic %start a chrono
        tStartpres=toc; %save the time of sound
        
        %get the answer of the subject
        mark=0;marktime=0; %create the var of answer
        rep=1; %index to control loop while
        
        
        
        while 5+tStartpres > toc & rep %loop on the value of rep and the time the subject can answer
            [keyIsDown, secs, keyCode]=KbCheck;
            if keyIsDown==1 & keyCode(leftsh)==1 %first sound selected
                mark=1
                marktime=toc -tStartpres;
                rep=0
                
            elseif keyIsDown==1 & keyCode(rghtsh)==1 %second sound selected
                mark=2
                marktime=toc-tStartpres;
                rep=0
            end
            
        end
        Nom.data=[Nom.data ;[mark marktime]]; %put in Nom.data the response
        WaitSecs(2.5) %wait before next trial
    end
    
    DrawFormattedText(windowBG,'Experience is over\n Thanks for your participation','center',white);
    Screen('Flip',windowBG);
    WaitSecs(2.5)
    
catch e %e is a matlab variable, an Exception struct % If the above section threw an error, I still save the data! and display the source of the error
    fprintf(1,'Experiment close due to an error. The identifier was:\n%s',e.identifier); %display in command window the error message
    fprintf(1,'There was an error! The message was:\n%s',e.message);
    
    
end
%% save DATA
timestamp=num2str(GetSecs); %create a string with the time stamp
save([Nom.code timestamp(1:5) '.mat'],'Nom')

%%Close all device of PTB
PsychPortAudio('Close')
Screen('CloseAll');
ShowCursor;
ListenChar(0)

%% inform end exp
fprintf(['%%%%%%\n\nExperiement is over! \n Press any keys to clear all variable created \n'],1);
pause
clear

