%% Seismic interpolation result visualization
%
% This script reproduces Figures 4-5 in the manuscript.
%
% The script visualizes:
%   - Complete seismic data
%   - Observed seismic data
%   - Reconstructed seismic data
%   - f-k spectra
%
% Input:
%   ../result_mat/test1_result.mat
%
% Required functions:
%   seg_colormap.m
%
% Output:
%   Seismic sections and f-k spectrum figures.

%% Load seismic interpolation results and normalize data
D = load('../result_mat/test1_result');
b = D.d;
sampling = D.sampling;
b4 = D.d_k;
b_mean = mean(b(:));
b_max = max(abs(b(:)-b_mean));
b_ = (b-b_mean)./b_max;
b4_ = (b4-b_mean)./b_max;
b_obs = sampling.*b_;
time = 0:0.004:177*0.004;
offset = -885:10:885;
scale1 = [-0.75,0.75];
%% Figure 4: Complete data, observed data, and reconstructed seismic data
fig1 = figure;
imagesc(offset,time, -b_,scale1);
seg_colormap(seismic(2));
xlabel('Offset (m)','FontSize',18);
ylabel('Time (s)','FontSize',18);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
colorbar;cb = colorbar;set(cb,'YDir','reverse');
% exportgraphics(gcf,".../Figures/figure4a.eps",'Resolution',600);

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
% exportgraphics(gcf,".../Figures/figure4b.eps",'Resolution',600);

fig3 = figure;
imagesc(offset,time, -b4_,scale1);
seg_colormap(seismic(2));
xlabel('Offset (m)','FontSize',18);
ylabel('Time (s)','FontSize',18);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
colorbar;cb = colorbar;set(cb,'YDir','reverse');
% exportgraphics(gcf,".../Figures/figure4f.eps",'Resolution',600);

%% Figure 5: f-k spectrum comparison
dt = 0.004; 
nt = size(b, 1); 
df = 1/(nt*dt); 
f = df*(-nt/2:nt/2-1); 
freq = f >= 0;
f_ = f(freq);
Lx = size(b, 2); 
kx = 2*pi*(-Lx/2:Lx/2-1)/Lx; 
kx_normalized = kx/pi; 

F1 = fft2(b_);F1 = fftshift(F1); F1_ = F1(freq, :);
F2 = fft2(b_obs);F2 = fftshift(F2); F2_ = F2(freq, :);
F6 = fft2(b4_);F6 = fftshift(F6); F6_ = F6(freq, :);

scale2 = [0,32];

fig5 = figure;
imagesc(kx_normalized, f_, abs(F1_), scale2);
colormap(jet);
xlabel('Normalized Wavenumber',fontsize=18);ylabel('Frequency (Hz)',fontsize=18);
xlim([-0.85,0.85]);ylim([0,50]); 
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
% B
% exportgraphics(gcf,".../Figures/figure5a.eps",'Resolution',600);

fig6 = figure;
imagesc(kx_normalized, f_, abs(F2_),scale2);
colormap(jet);
xlabel('Normalized Wavenumber',fontsize=18);ylabel('Frequency (Hz)',fontsize=18);
xlim([-0.85,0.85]);ylim([0,50]); 
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
% exportgraphics(gcf,".../Figures/figure5b.eps",'Resolution',600);

fig7 = figure;
imagesc(kx_normalized, f_, abs(F6_),scale2);
colormap(jet);
xlabel('Normalized Wavenumber',fontsize=18);ylabel('Frequency (Hz)',fontsize=18);
xlim([-0.85,0.85]);ylim([0,50]); 
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much 
% exportgraphics(gcf,".../Figures/figure5f.eps",'Resolution',600);