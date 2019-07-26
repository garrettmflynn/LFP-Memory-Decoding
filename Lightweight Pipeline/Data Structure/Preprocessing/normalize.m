function [norm] = normalize(LFP_Data,dataMethod,dataFormat)
if strncmp(dataMethod,'STFT',4)
switch dataFormat

%% Signal Normalization | STFT | Percent Change
   case 'Signal'
frequencyMu = mean(LFP_Data');

for channels = 1:size(LFP_Data,1)
    channelMu = mean(LFP_Data(channels,:));
    %channelSTD = std(LFP_Data(channels,:));
    LFP_Signal_PctChange(channels,:) = 100*(LFP_Data(channels,:) - channelMu)/channelMu;
end
norm = LFP_Signal_PctChange;
    %% Spectrum | STFT | MultiChannel | Percent Change
    case 'Spectrum'
            fprintf('Now Creating ZScore Data\n');
            if ndims(squeeze(LFP_Data)) == 3
                
                frequencyMu = squeeze(mean(permute(LFP_Data,[2,1,3])));
                
                % frequencySigma = squeeze(std(permute(LFP_Spectrum,[2,1,3])));
                
                for channels = 1:size(LFP_Data,3)
                    %LFP_Spectrum_ZScore(:,:,channels) = (LFP_Spectrum(:,:,channels)-frequencyMu(:,channels))./frequencySigma(:,channels);
                    
                    LFP_Spectrum_PctChange(:,:,channels) = 100*(LFP_Data(:,:,channels) - frequencyMu(:,channels))./frequencyMu(:,channels);
                end
                % LFP_Spectrum_ZScore = permute(((permute(LFP_Spectrum,[1,3,2])-frequencyMu)./frequencySigma),[1,3,2]);
                
       %% Spectrum | STFT | Single Channel | Percent Change
            else
                frequencyMu = squeeze(mean(LFP_Data'));
                
                %frequencySigma = squeeze(std(LFP_Spectrum'));
                LFP_Spectrum_PctChange = 100*(LFP_Data' - frequencyMu)./frequencyMu;
                %LFP_Spectrum_ZScore = ((LFP_Spectrum'-frequencyMu)./frequencySigma)';
            end
            
            norm = LFP_Spectrum_PctChange;
            
end       
end
end


%% Wavelet 
            % elseif strncmp(dataMethod,'Morlet',4)
            % %% Wavelet dB Change
            % if strncmpi(normMethod,'dB',2)
            % %[-10 10]
            % baseline_power = mean(LFP_Spectrum,2);
            % spectrumNorm = 10*log10( bsxfun(@rdivide,LFP_Spectrum,baseline_power));
            %
            % % elseif strncmpi(parameters.Optional.normMethod,'Percent',2)
            % % % Percent Change from ITI-Averaged Baseline [-500 500]
            % % baseline_power = squeeze(mean(LFP_Spectrum,2));
            % %
            % % for channeli = 1:size(LFP_Spectrum,3)
            % % pctchange(:,:,channeli) = 100 * (LFP_Spectrum(:,:,channeli)-baseline_power(:,channeli)) ./ (baseline_power(:,channeli));
            % % baselinediv(:,:,channeli) = LFP_Spectrum(:,:,channeli) ./ baseline_power(:,channeli)
            % % end
            %
            % %% Wavelet ZScore
            % elseif strncmpi(normMethod,'ZScore',2)
            % %  [-3.5 3.5]
            % spectrumNorm = ((LFP_Spectrum-repmat(mean(LFP_Spectrum,2),1,size(LFP_Spectrum,2))) ./ repmat(std(LFP_Spectrum,[],2),1,size(LFP_Spectrum,2)));
            % end
            %
            % normStruct.Spectrum = spectrumNorm;
            %