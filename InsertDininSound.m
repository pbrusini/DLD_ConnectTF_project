%pathText='/media/sdb/Data_RhythmProject/stimuli/2Hz_ba/';
%pathSound='/media/sdb/Data_RhythmProject/stimuli/2Hz_ba/';

pathText='/media/sdb/Data_RhythmProject/stimuli/120BPM/'
pathSound='/media/sdb/Data_RhythmProject/stimuli/120BPM/'

ListText=dir([pathText '*.TextGrid']);

for i=1:length(ListText)
    i
    % get the time in textgrid
    grid=loadtxt([pathText ListText(i).name]);
    listTimeDin=[];
    
    for g=1:length(grid)
        %if strcmp('mark', grid{g,1}) 
        if strcmp('text', grid{g,1}) && strcmp('"sounding"', grid{g,3}) %check where you want your din
            listTimeDin=[  listTimeDin grid{g-1,3}]; %listTimeDin=[  listTimeDin grid{g-2,3}];
        end
    end
    
    
    name=ListText(i).name(1:length(ListText(i).name)-9);
    
    % load the sound
    load('din.mat');
    din=din(1:50);
    [ss, Fs] = audioread([pathSound name '.wav']);
    listTimeDin=listTimeDin*Fs;
    ss=[ss(:,1) zeros(length(ss),1)]; % ss become stereo with nothing on the rigth part
    for j=1:length(listTimeDin)
        ss(int64(listTimeDin(j)):int64(listTimeDin(j))+49, 2)=din(1:50,1)*100000000000000000000000000000000000000000000000;
        
     
    end
    audiowrite([name 'Din.wav'],ss, Fs);
end

   