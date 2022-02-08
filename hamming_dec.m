H = [1 0 1 0 1 0 1; 0 1 1 0 0 1 1; 0 0 0 1 1 1 1];

key = input('key: ','s');
rng(sum(double(key)));

delimitter = [key, key];

[audio, Fs] = audioread("audio_secret.wav");
audioUint8 = uint8(255 * (audio + 0.5)); 
audioBin = de2bi(audioUint8, 8);

audioDim = size(audioBin);
audioSize = audioDim(1);

i = 1:audioSize;
indexes = i(mod(i,7)==0);
indexes=indexes(randperm(length(indexes)));
indexes=indexes(1:length(indexes));

secretBin = [];

actual = 1;
for j = 1 : length(indexes)
	i = indexes(j);
	dec = double(audioBin(i:i+6));
	S_tmp = H * dec';
	S = zeros(size(S_tmp));
	S(mod(S_tmp, 2) == 0) = 0;
	S(mod(S_tmp, 2) == 1) = 1;
	secretBin = [secretBin, uint8(S')];
end

message = convertCharsToStrings( char(bin2dec(reshape(char(secretBin+'0'), 8,[]).')) );

if strfind(message, delimitter)
    message = extractBetween(message,1,strfind(message, delimitter) - 1);
    disp(message);
else
    disp('The audio contains no message or the key is invalid')
end

clear