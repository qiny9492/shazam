function [song_id]=identify_song(clip,fingerprints)

%  This function requires the global variables 'hashtable' and 'numSongs'
%  in order to work properly.

global hashtable
global numSongs
load('musicDB.mat');
load('SONGID.mat');
load('HASHTABLE.mat');
%[fingerprints] = compute_fingerprints(musicDB);


c=musicDB(22).signal;
n=24001;
clip=zeros(n,1);
for i=1:1:n
    clip(i)=c(i+8000);
end

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
        % Add matches to the lists for each individual song
        
       % for n = 1:numSongs
       %             location=find(matchID{k}==n);%find the location where n appears, and use this location to find all the offset belongs to song n in offset matrix
       %             if (~isempty(location)) % n is in matchID{k}
       %                 for m=1:1:length(location) %for each index
       %                     j=location(m);% get the index
       %                 empty=find(isempty(matches{n})==1);% find the null item in matches matrix,and this is the place we insert new items
       %                 matches{n}(empty+m-1)=offset{k}(j);% put all the offset for one song in matches matrix
       %                 end
       %             end
       %  end
    end
end
ID=cell2mat(matchID);
SET=cell2mat(offset);
hist(SET,150)
%tabulate(ID(:))
tabulate(SET(:));
[song_id,occurtimes]=mode(ID);
%offsetmost=mode(SET);
%[maxoffset,offsetTimes]=mode(SET);
%location=find(ID==song_id);
%oslocation=find(SET==offsetmost);
%for i=1:1:length(oslocation)
%IDDD(i)=ID(oslocation(i));
%oft(i)=SET(oslocation(i));
%end
%oslocation
%IDDD
%oft

% Find the counts of the mode of the time offset array for each song
% row vector
%occurValue=zeros(1,numSongs);% offset
%occurFreq=zeros(1,numSongs);

%for k = 1:numSongs
%    [occurValue,occurFreq]=mode(matches{k});
%end


%hist(occurFreq,occurValue)
%title('Histogram of offsets for each song')

% Song decision: find the most occurrences of any single offset
% or find the max occurFreq

%[maxFreq,maxIndex]=max(occurFreq);
%bestMatchID=maxIndex;
%matchOffset=occurValue(maxIndex);
%song_id=bestMatchID;

% confidence or correction of match

%if length(bestMatchID)==1
%    confidence=1;
%else
%    confidence=1/length(bestMatchID);
%end


optional_plot = 0; % turn plot on or off

if optional_plot
    figure(3)
    clf
    y = zeros(length(matches),1);
    for k = 1:length(matches)
        subplot(length(matches),1,k)
        hist(matches{k},1000)
        y(k) = max(hist(matches{k},1000));
    end
    
    for k = 1:length(matches)
        subplot(length(matches),1,k)
        axis([-inf, inf, 0, max(y)])
    end

    subplot(length(matches),1,1)
    title('Histogram of offsets for each song')
end

end




