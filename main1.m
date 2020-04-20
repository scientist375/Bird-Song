%ECE 4271 Project 4
%Automobile Detection
%Lillian Anderson and Angad Daryani

%This script reads in .wav files, applies pitch and STE feature extractions,
%and trains an SVM model to differentiate between automobile and bird
%sounds. Output is written to a text file in unit milliseconds.

%Inputs:     1. wav files labeled as 'DataSet (#).wav', with a selected
%               dataset and file numbers
%            2. 'Train.wav' file for training SVM
%Outputs:    text files for each input files with timestamps and labels of
%            when the automobile sounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Edit Inputs:
DataSet = 'ASB';
fileNumber = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 17, 24];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%read in wav training file with birds and cars
[x_train, fs_train] = audioread('Train.wav');
%sound(x, fs) %play audio

%training feature extraction
n = 100;
windowLength = fs_train * 1; %1 second windows
f_ste_train = mySTE(x_train, windowLength);
f_pitch_train = myPitch(x_train, fs_train, n);

% %prep data for svm
feature1_train = f_ste_train;
feature2_train = f_pitch_train;

x_svm = [feature1_train, feature2_train];
y_svm(1:(floor(length(feature1_train)/2))) = 1; %car labeling
y_svm((floor(length(feature1_train)/2)+1):length(feature1_train)) = 0; %bird labeling
myGroup = {'car', 'bird'};

%training SVM
SVMmodel = fitcsvm(x_svm, y_svm);

%plot training results
sv = SVMmodel.SupportVectors;
figure
gscatter(x_svm(:,1),x_svm(:,2),y_svm)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('car','bird','Support Vector')
title('training svm')
ylabel('pitch')
xlabel('STE')
hold off

%prediction SVM
for k = fileNumber
    filename = sprintf('%s (%d).wav',DataSet, k);
    [x, fs] = audioread(filename);
    
    %feature extractions
    n = 100;
    windowLength = fs * 1;
    f_ste = mySTE(x, windowLength);
    f_pitch = myPitch(x, fs, n);
    
    feature1_predict = f_ste;
    feature2_predict = f_pitch;
    
    %Classification
    x_predict = [feature1_predict, feature2_predict];
    [label,score] = predict(SVMmodel,x_predict);
    %key: 0 = bird; 1 = car
    
    label_stretched = repelem(label, windowLength); %convert windows back to samples
    label_stretched(1) = 0; %force first index to car start
    label_edge = diff(label_stretched);
    ndx_car = find(abs(label_edge) == 1 ); %find start-stop times for car noise
    
    %open text file for writing
    filename_out = sprintf('%s (%d).txt',DataSet, k);
    fileID = fopen( filename_out, 'w' );
    myTimestamp = datetime('now');
    fprintf(fileID, 'Automobile Detection for ''%s (%d).wav''\nLillian Anderson and Angad Daryani\n%s\n', DataSet, k,myTimestamp);
    
    %convert start/stop indices into time in milliseconds and write to file
    if (~isempty(ndx_car))
        for j = 1:ceil((length(ndx_car)/2))%loop through indices in groups of 2
            h = j*2 -1;
            t1 = ndx_car(h)/fs*1000; %start time in milliseconds
            if (t1 < 10)%clean up rounding error
                t1 = 0;
            end
            if (~mod(length(ndx_car),2)) %if even indices
                t2 = ndx_car(h+1)/fs*1000;
            elseif (j == ceil((length(ndx_car)/2)))%if end of file is car end
                t2 = length(label_stretched)/fs*1000;
            else
                t2 = ndx_car(h+1)/fs*1000;
            end
            fprintf( fileID, '%d %d automobile\n', t1, t2); %our project is purely automobile detection
        end
    end
    
    fclose(fileID);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%feature functions

function feature = mySTE(x, windowLength)
%short term energy
feature = (sum(buffer(x.^2, windowLength)))';
end

function feature = myPitch(x, fs, n)
%average pitch per window
feature = pitch(x,fs);
blockSize = [n, 1]; %average results
meanFilterFunction = @(theBlockStructure) mean2(theBlockStructure.data(:));
feature = blockproc(feature, blockSize, meanFilterFunction);
end
