function [song_id]=identify_song(clip,fingerprints)

%  This function requires the global variables 'hashtable' and 'numSongs'
%  in order to work properly.

global hashtable
global numSongs
load('musicDB.mat');
load('SONGID.mat');
load('HASHTABLE.mat');


hashTableSize = size(hashtable,1);
numSongs=150;

% Find peak pairs from the clip
clipPeaks = fingerprint(clip);
clipTuples = convert_to_pairs(clipPeaks);

% Construct the cell of matches
matches = cell(numSongs,1);
matchID=cell(1,length(clipTuples));
matchTime=cell(1,length(clipTuples));
offset=cell(1,length(clipTuples));
for k = 1:size(clipTuples, 1)
    % CALCULATE HASH
    clipHash = simple_hash(clipTuples(k,3),clipTuples(k,4), clipTuples(k,2)-clipTuples(k,1), hashTableSize);
    % If an entry exists with this hash, find the song(s) with matching peak pairs
    if (~isempty(hashtable{clipHash, 1}))
        matchID{k} = hashtable{clipHash, 1}; % row vector of collisions
        matchTime{k} = hashtable{clipHash, 2}; %vector times t1 where the matches occurred in database
        
        % Calculate the time difference between clip pair and song pair
        offset{k}=matchTime{k}-clipTuples(k,1); %row vector,timing offsets=matchtime-t1, or the difference between 
        %t1 for the song and t1 for the clip should be same for all correct
        %match.
        
        
    
    end
end
ID=cell2mat(matchID);
SET=cell2mat(offset);
[song_id,occurtimes]=mode(ID);
%hist(SET,150)



end




