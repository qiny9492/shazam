global hashtable
global numSongs
duration = 3; % Seconds
        load('musicDB.mat');
        load('SONGID.mat');
        load('HASHTABLE.mat');
        
fingerprints=hashtable;
   
numSongs = 150;
fs=16000;
test=10;
 % Select a random segment
    
   add_noise = 1; % Optionally add noise by making this 1.
 % Signal-to-noise Ratio in dB, if noise is added.  Can be negative.
 % Select a random song 
 
     
    clip_id=ceil(numSongs*rand(1));
    if clip_id~=0
        clip=musicDB(clip_id).signal;
    end
    
   
    % Select random segment
    % Control duration
    if length(clip) > ceil(duration*fs)
        shiftRange = length(clip) - ceil(duration*fs)+1;
        shift = ceil(shiftRange*rand);
        clip = clip(shift:shift+ceil(duration*fs)-1);
    end
    
    % Add noise
    if add_noise 
        count=0;
        for k=1:test
        SNRdB=5;
        soundPower = mean(clip.^2);
        noise = randn(size(clip))*sqrt(soundPower/10^(SNRdB/10));
        noisy_song = clip + noise;
        clean_id=identify_song(clip,fingerprints);
        noisy_id=identify_song(noisy_song,fingerprints);
        
        if (clean_id==noisy_id)
            match=1;
        else
            match=0;
        end
         count=count+match;
        end
 end
 accuracy=count/test


  