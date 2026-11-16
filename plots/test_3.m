% This script reproduces Figures 10-11 in the manuscript.
%
% The script visualizes:
%   - Complete seismic data
%   - Observed incomplete seismic data
%   - Reconstructed seismic data
%   - Single-trace comparison
%
% Input:
%   ../result_mat/test3_result.mat
%
% Required functions:
%   seg_colormap.m
%
% Output:
%   Seismic interpolation result and Single-trace comparison.
% 
%% Load seismic data and normalize amplitudes
D = load('../result_mat/test3_result.mat');
s4 = D.d_k;
s = D.d;
s_mean = mean(s(:));
s_max = max(abs(s(:)-s_mean));
s_ = (s-s_mean)./s_max;
s4_ = (s4-s_mean)./s_max;
samp1 = D.sampling;
s_obs = samp1.*s_;
time = 0:0.004:511*0.004;
offset = 0:50:511;

%% Figure 10: Complete, observed and reconstructed seismic data;
scale = [-0.8,0.8];
fig1 = figure;
imagesc(offset,time, s_,scale);
seg_colormap(seismic(2));
xlabel('Trace Number',fontsize=18);ylabel('Time (s)',fontsize=18);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
colorbar;
% exportgraphics(gcf,".../Figures/figure10a.eps",'Resolution',600);

fig2 = figure;
imagesc(offset,time, s_obs,scale);
seg_colormap(seismic(2));
xlabel('Trace Number',fontsize=18);ylabel('Time (s)',fontsize=18);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
colorbar;
% exportgraphics(gcf,".../Figures/figure10b.eps",'Resolution',600);

fig3 = figure;
imagesc(offset,time, s4_,scale);
seg_colormap(seismic(2));
xlabel('Trace Number',fontsize=18);ylabel('Time (s)',fontsize=18);
% set(gcf,'position',[300,300,560,560]); % Adjust figure size and position
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
colorbar;
% exportgraphics(gcf,".../Figures/figure10f.eps",'Resolution',600);

%% Figure 11: Single-trace comparison
col_index = 234;
sampling_interval = 0.004;
num_samples = 400;
time = (0:num_samples-1) * sampling_interval;

COMPLETE_COLOR = [0 0 0]; 
RECON_COLOR = [1 0 0];       

fig4 = figure('Units','Pixels','Position',[100,100,1200,150]);
plot(time, s(1:400, col_index), 'Color',COMPLETE_COLOR, 'LineWidth', 2); hold on;
plot(time, s4(1:400, col_index),'Color',RECON_COLOR, 'LineWidth', 2);
xlim([0, 1.6]); ylim([0.1, 0.9]);
legend({'Complete', 'UCDNet'}, 'Location','southeast','FontSize',10);
xlabel('Time (s)','fontsize',15);
ylabel('Amplitude','fontsize',15);

set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995])
% exportgraphics(gcf,".../Figures/figure11.eps",'Resolution',600);

