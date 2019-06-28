% this example script demonstrates how to save data in .nex file

% start new nex file data
nexFile = nexCreateFileData(40000);

% add continuous variable
% digitizing frequency 1000 Hz
Fs = 1000;
% time interval from 1 to 5
t= 1:1/Fs:5;
% sin with frequency 2 Hz
contValues = sin(2*pi*t*2);
% specify start time (t(1)), digitizing frequency (Fs), data (x2) and name
nexFile = nexAddContinuous(nexFile, t(1), Fs, contValues, 'sin2Hz');

% add continuous variable with 2 fragments: 
firstFagmentValues = cos(2*pi*t*2);
secondFagmentValues = sin(2*pi*t*2);

% start of first fragment at 1.5 seconds
% start of second fragment at 10 seconds
fragmentTimestamps = [1.5; 10];

% index of the first element in the first fragment is 1
% index of the first element in the second fragment is 
% 1 + length(firstFagmentValues)
fragmentIndexes = [ 1; 1+length(firstFagmentValues)];
% merge data for all fragments into one vector
allValues = [firstFagmentValues, secondFagmentValues];
nexFile = nexAddContinuousWithMultipleFragments(nexFile, fragmentTimestamps, fragmentIndexes, Fs, allValues, 'twoFragments');

% add neuron spike train
neuronTs = [0.5 0.9 2.1 2.3 2.5]';
nexFile = nexAddNeuron(nexFile, neuronTs, 'neuron1');

% add event spike train
eventTs = [10 20 30 40]';
nexFile = nexAddEvent(nexFile, eventTs, 'event1');

% add interval variable
intStarts = [5 10];
intEnds = [6 12];
nexFile = nexAddInterval(nexFile, intStarts, intEnds, 'interval1');

% add  waveforms
% waveform timestamps
waveTs = [1 2]';
% 2 waveforms (columns), 5 data points each
waves = [-10 0 10 20 30; -15 0 15 25 15]';
nexFile = nexAddWaveform(nexFile, 40000, waveTs, waves, 'wave1');

% save nex file in user's documents
userDir= getenv('USERPROFILE');

nexFilePath = strcat(userDir, '\My Documents\test1.nex');
writeNexFile(nexFile, nexFilePath );

% save .nex5 file also
nex5FilePath = strcat(userDir, '\My Documents\test1.nex5');
writeNex5File(nexFile, nex5FilePath);


% ------------- OPTIONAL NEX FILE VERIFICATION -----------------------------------

% verify that we can open file in NeuroExplorer
nex = actxserver('NeuroExplorer.Application');
doc = nex.OpenDocument(nexFilePath);

% make sure that all variables are in the file
nexCont = doc.Variable('sin2Hz');
nexCont2 = doc.Variable('twoFragments');
nexNeuron = doc.Variable('neuron1');
nexEvent = doc.Variable('event1');
nexInt = doc.Variable('interval1');
nexWave = doc.Variable('wave1');
% get all the neuron timestamps
nexNeuronTimestamps = nexNeuron.Timestamps()'

% note that continuous values differ in .nex file
% the reason for this is that the values are stored as 2-byte integers
% in .nex file, so their resolution is of the order of 1.e-05
% get all the values and timestamps
contValuesFromNex = nexCont.ContinuousValues();
contTimestamps = nexCont.Timestamps();
disp ([ 'max difference: ', num2str(max(abs(contValuesFromNex-contValues)))])
plot(contTimestamps, contValues);

% close NeuroExplorer
nex.delete;
