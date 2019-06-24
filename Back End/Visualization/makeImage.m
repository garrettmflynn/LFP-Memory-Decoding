function [] = makeImage(time,freq,powerMatrix,saveDir,Z_SCORE)

if nargin < 3
    error("Not enough input arguments. Must include time vector, frequency vector, and power matrix.");
end
if nargin <5
    Z_SCORE = 0;
end

specImage = figure('visible','on');
surf(time, freq,powerMatrix,'EdgeColor','none');
axis xy; axis tight; colormap(jet); view(0,90);
hcb2=colorbar;
if Z_SCORE
caxis([-5,5]);
else
caxis([0 2000]);
end

hold on;


if nargin >= 4
    saveas(specImage,saveDir);
end
end