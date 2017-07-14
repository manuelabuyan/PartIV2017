% readFromLaryngograph
% Reads wave files generated by the laryngograph and seperates the speech
% (mic) waveform from the EGG waveform

function a = readFromLaryngograph()

fnames = dir('*.wav'); %find all wav files
numfids = length(fnames); %determine number of wav files
vals = cell(1,numfids);
mkdir('speech')
mkdir('EGG')
mkdir('EGGfilt')
firfilt = fir1(1000,80/8000,'high');
for K = 1:numfids
  
  [y,fs]=audioread(fnames(K).name);
  stereo = size(y);
  if(stereo(2)==2) %check for stereo - mono would indicate that the file has already been processed
      leftname = strcat('speech\',fnames(K).name);
      rightname = strcat('EGG\',fnames(K).name);
      rightnamefilt = strcat('EGGfilt\',fnames(K).name);
      audiowrite(leftname,y(:,1),fs);
      audiowrite(rightname,y(:,2),fs); 
      filtered = filter(firfilt,1,y(:,2));
      filtered_nodelay = filtered(501:length(filtered));
      filtered_nodelay(length(filtered))=0;
      audiowrite(rightnamefilt,filtered_nodelay,fs); 
  end
  
  
end

% [y,fs,nbits]=wavread(wavefile);
% 
% % y is a two columned matrix. The first column (left channel) is the speech
% % waveform. The second column (right channel) is the EGG.
% 
% leftname = strcat(wavefile,'_voice');
% rightname = strcat(wavefile,'_EGG');
% 
% wavwrite(y(:,1),fs,leftname);
% wavwrite(y(:,2),fs,rightname);
% 
% S = spectrogram(y(:,2),256,128,256,fs);
% 

