parameters.Directories.filePath = strcat('E:\ClipArt_2');
%load(fullfile('C:\SuperUser\Xiwei Results',[parameters.Directories.dataName, '_processedData.mat']));


bands = HHData.Data.Bands.Signal_Bands;
theta = bands.Theta;
alpha = bands.Alpha;
beta = bands.Beta;
gamma_L = bands.Gamma_L;
gamma_H = bands.Gamma_H;
time = linspace(HHData.Data.Timecourse(1),HHData.Data.Timecourse(2),size(HHData.Data.Voltage.Raw,2));

for channel = [38] %1:size(HHData.RawData,1)
%% BandView for Full Sessions
standardImage({HHData.Data.Voltage.Raw((HHData.Channels.sChannels == channel),:),HHData.Data.LFP.LFP((HHData.Channels.sChannels == channel),:)},HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.SamplingFrequency, ['Signal'], channel, [],time,'mV', [-20000 20000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0);
standardImage(theta((HHData.Channels.sChannels == channel),:),HHData.Events,HHData.Data.Parameters,HHData.Data.Parameters.SamplingFrequency, ['Theta_Interval'], channel,[],time,'mV', [-4000 4000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Theta');
standardImage(alpha((HHData.Channels.sChannels == channel),:),HHData.Events,HHData.Data.Parameters,HHData.Data.Parameters.SamplingFrequency, ['Alpha_Interval'], channel,[],time,'mV', [-4000 4000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Alpha');
standardImage(beta((HHData.Channels.sChannels == channel),:),HHData.Events,HHData.Data.Parameters,HHData.Data.Parameters.SamplingFrequency, ['Beta_Interval'], channel,[],time,'mV', [-4000 4000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Beta');
standardImage(gamma_L((HHData.Channels.sChannels == channel),:),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.SamplingFrequency, ['GammaL_Interval'], channel,[],time,'mV', [-4000 4000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Gamma_L');
standardImage(gamma_H((HHData.Channels.sChannels == channel),:),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.SamplingFrequency, ['GammaH_Interval'], channel,[],time,'mV', [-4000 4000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Gamma_H');

%% BandView for Intervals
%for interval = 1:size(HHData.Intervals.Data,ndims(HHData.Intervals.Data))
% standardImage(HHData.Data.Intervals.Signal((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.SamplingFrequency, ['Signal_Interval' ,num2str(interval)], channel, interval,HHData.ML.Times(:,interval),'mV', [-40000 40000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0);
% standardImage(theta((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters,HHData.Data.Parameters.SamplingFrequency, ['Theta_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'mV', [-10000 10000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Theta');
% standardImage(alpha((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters,HHData.Data.Parameters.SamplingFrequency, ['Alpha_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'mV', [-10000 10000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Alpha');
% standardImage(beta((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters,HHData.Data.Parameters.SamplingFrequency, ['Beta_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'mV', [-10000 10000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Beta');
% standardImage(gamma_L((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.SamplingFrequency, ['GammaL_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'mV', [-10000 10000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Gamma_L');
% standardImage(gamma_H((HHData.Channels.sChannels == channel),:,interval),HHData.Events,HHData.Data.Parameters, HHData.Data.Parameters.SamplingFrequency, ['GammaH_Interval' ,num2str(interval)], channel,interval,HHData.ML.Times(:,interval),'mV', [-10000 10000], fullfile(parameters.Directories.filePath,'Signals_Band',['Channel',num2str(channel)]), 'Signal',0,'Gamma_H');
%end
end