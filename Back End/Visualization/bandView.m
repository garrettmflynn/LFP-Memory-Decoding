parameters.Directories.filePath = strcat('E:\ClipArt_2');
% load(fullfile('C:\SuperUser\Xiwei Results',[parameters.Directories.dataName, '_processedData.mat']));


bands = HHData.Data.Bands.Signal_Bands;
theta = bands.Theta;
alpha = bands.Alpha;
beta = bands.Beta;
gamma_L = bands.Gamma_L;
gamma_H = bands.Gamma_H;

for channel = [38] %1:size(HHData.RawData,1)
for interval = [26,32,40] %1:size(HHData.Intervals.Data,ndims(HHData.Intervals.Data))

standardImage(HHData.Data.Intervals.Signal((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.SamplingFrequency, ['Signal_Interval' ,num2str(interval)], channel, interval,HHData.ML.Times(:,interval),'mV', [-40000 40000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0);
standardImage(theta((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters,HHData.Data.Parameters.SamplingFrequency, ['Theta_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'mV', [-10000 10000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Theta');
standardImage(alpha((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters,HHData.Data.Parameters.SamplingFrequency, ['Alpha_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'mV', [-10000 10000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Alpha');
standardImage(beta((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters,HHData.Data.Parameters.SamplingFrequency, ['Beta_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'mV', [-10000 10000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Beta');
standardImage(gamma_L((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.SamplingFrequency, ['GammaL_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'mV', [-10000 10000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Gamma_L');
standardImage(gamma_H((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.SamplingFrequency, ['GammaH_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'mV', [-10000 10000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Gamma_H');
end
end