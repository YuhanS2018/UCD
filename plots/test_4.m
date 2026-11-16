% This script reproduces Figures 12 in the manuscript.
%
% The script visualizes:
%   - Complete seismic data
%   - Observed incomplete seismic data
%   - Reconstructed seismic data
%
% Input:
%   ../result_mat/test4_result.mat
%
% Required functions:
%   seg_colormap.m
%
% Output:
%   Noisy seismic data interpolation comparison.

%% Load seismic interpolation results and normalize data
path = load('../result_mat/first_break.mat');
mask = path.mask;
D = load('../result_mat/test4_result.mat');
b = D.d;
sampling = D.sampling;
b4 = D.d_k;
b_mean = mean(b(:));
b_max = max(abs(b(:)-b_mean));
b_ = (b-b_mean)./b_max;
b4_ = (b4-b_mean)./b_max;
b4_ = b4_.*mask;
noisy_data = D.noisy_data;
b_mean = mean(b(:));
b_max = max(abs(b(:)-b_mean));
noisy_data_ = (noisy_data-b_mean)./b_max;
b_obs = sampling.*noisy_data_;
time = 0:0.004:177*0.004;
offset = -885:10:885;
scale1 = [-0.75,0.75];
%% Figure 12: Complete data, noisy observed data, and reconstructed seismic data
fig1 = figure;
imagesc(offset,time, -b_,scale1);
seg_colormap(seismic(2));
xlabel('Offset (m)','FontSize',18);
ylabel('Time (s)','FontSize',18);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
colorbar;cb = colorbar;set(cb,'YDir','reverse');
% exportgraphics(gcf,".../Figures/figure12a.eps",'Resolution',600);

fig2 = figure;
imagesc(offset,time, -b_obs,scale1);
seg_colormap(seismic(2));
xlabel('Offset (m)','FontSize',18);
ylabel('Time (s)','FontSize',18);
% set(gcf,'position',[300,300,500,500]); 
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
colorbar;cb = colorbar;set(cb,'YDir','reverse');
% exportgraphics(gcf,".../Figures/figure12b.eps",'Resolution',600);

fig3 = figure;
imagesc(offset,time, -b4_,scale1);
seg_colormap(seismic(2));
xlabel('Offset (m)','FontSize',18);
ylabel('Time (s)','FontSize',18);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
colorbar;cb = colorbar;set(cb,'YDir','reverse');
% exportgraphics(gcf,".../Figures/figure12d.eps",'Resolution',600);
