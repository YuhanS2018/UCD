% This script reproduces Figures 6-9 in the manuscript.
%
% The script visualizes:
%   - Complete seismic data
%   - Observed seismic data
%   - Residual results
%   - Zoomed-in views
%   - f-k spectrum comparison
%
% Input:
%   ../result_mat/test_2.mat
%
% Required functions:
%   seg_colormap.m
%
% Output:
%   Seismic sections and f-k spectrum figures.

%% Load seismic data and normalize amplitudes
V4 = load('../result_mat/test2_result.mat');

b = V4.d;
b4 = V4.d_k;
b_mean = mean(b(:));
b_max = max(abs(b(:)-b_mean));
sampling = V4.sampling;
b_ = (b-b_mean)./b_max;
b4_ = (b4-b_mean)./b_max;
b_obs = sampling.*b_;
%% Figure 6: Comparison of complete, observed, and reconstructed seismic data
time = 0:0.008:200*0.008;
offset = -2000:20:2000;
scale_1 = [-0.6,0.6];
fig1 = figure;
imagesc(offset,time, -b_,scale_1);
seg_colormap(seismic(2));
xlabel('Offset (m)','FontSize',18);
ylabel('Time (s)','FontSize',18);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]);
colorbar;cb = colorbar;set(cb,'YDir','reverse');
% exportgraphics(gcf,"/../figure6a.eps",'Resolution',600);
 
fig2 = figure;
imagesc(offset,time, -b_obs,scale_1);
seg_colormap(seismic(2));
xlabel('Offset (m)','FontSize',18);
ylabel('Time (s)','FontSize',18);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
colorbar;cb = colorbar;set(cb,'YDir','reverse');
% exportgraphics(gcf,"/../figure6b.eps",'Resolution',600);

fig3 = figure;
imagesc(offset,time, -b4_,scale_1);
seg_colormap(seismic(2));
xlabel('Offset (m)','FontSize',18);
ylabel('Time (s)','FontSize',18);
% set(gcf,'position',[300,300,560,560]);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
colorbar;cb = colorbar;set(cb,'YDir','reverse');
% exportgraphics(gcf,"/../figure6f.eps",'Resolution',600);

%%  Figure 7: Residual results
scale2 = [-0.4,0.4];
fig4 = figure;
imagesc(offset,time, -(b4-b),scale2);
seg_colormap(seismic(2));
xlabel('Offset (m)','FontSize',18);
ylabel('Time (s)','FontSize',18);
% set(gcf,'position',[300,300,560,560]);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
colorbar;cb = colorbar;set(cb,'YDir','reverse');
% exportgraphics(gcf,"/../figure7d.eps",'Resolution',600);

%% Figure 8: Zoomed-in views of seismic data
scale3 = [-0.3,0.3];
rec = [0.310714285714286 0.421428571428572 0.342857142857143 0.3];
ax = gca;
ax_pos = get(ax, 'Position');  
nrow = size(b_,1);
ncol = size(b_,2);
col_start = round(rec(1) * ncol);
col_end   = round((rec(1)+rec(3)) * ncol);

row_start = round((1 - rec(2) - rec(4)) * nrow);
row_end   = round((1 - rec(2)) * nrow);
region_time = time(row_start:row_end);
region_offset = offset(col_start:col_end);

fig7 = figure;
region_l = b_(row_start:row_end, col_start:col_end);
imagesc(region_offset,region_time,-region_l,scale3);
seg_colormap(seismic(2));
xlabel('Offset','FontSize',11);
ylabel('Time (s)','FontSize',11);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.99,0.99]) %Adjust white space to avoid reduce too much
set(gcf,'position',[300,300,450,300]);
colorbar;
% exportgraphics(gcf,".../Figures/figure8f.eps",'Resolution',600);
fig8 = figure;
region_l = b_obs(row_start:row_end, col_start:col_end);
imagesc(region_offset,region_time,-region_l,scale3);
seg_colormap(seismic(2));
xlabel('Offset','FontSize',11);
ylabel('Time (s)','FontSize',11);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.99,0.99]) %Adjust white space to avoid reduce too much
set(gcf,'position',[300,300,450,300]);
colorbar;
% exportgraphics(gcf,".../Figures/figure8f.eps",'Resolution',600);
fig9 = figure;
region_l = b4_(row_start:row_end, col_start:col_end);
imagesc(region_offset,region_time,-region_l,scale3);
seg_colormap(seismic(2));
xlabel('Offset','FontSize',11);
ylabel('Time (s)','FontSize',11);
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.99,0.99]) %Adjust white space to avoid reduce too much
set(gcf,'position',[300,300,450,300]);
colorbar;
% exportgraphics(gcf,".../Figures/figure8f.eps",'Resolution',600);

%% Figure 9: f-k spectrum comparison
scale4 = [0,65];
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

fig10 = figure;
imagesc(kx_normalized, f_, abs(F1_),scale4);
colormap(jet); 
xlabel('Normalized Wavenumber',fontsize=14);ylabel('Frequency (Hz)',fontsize=14);
xlim([-1,1]);ylim([0,80]); 
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
% exportgraphics(gcf,".../Figures/figure9a.eps",'Resolution',600);

fig11 = figure;
imagesc(kx_normalized, f_, abs(F2_), scale4);
colormap(jet); 
xlabel('Normalized Wavenumber',fontsize=14);ylabel('Frequency (Hz)',fontsize=14);
xlim([-1,1]);ylim([0,80]); 
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
% exportgraphics(gcf,".../Figures/figure9b.eps",'Resolution',600);

fig12 = figure;
imagesc(kx_normalized, f_, abs(F6_),scale4);
colormap(jet); 
xlabel('Normalized Wavenumber',fontsize=14);ylabel('Frequency (Hz)',fontsize=14);
xlim([-1,1]);ylim([0,80]); 
set(gcf,'renderer','Painters'); % output as prienter
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); %Auto reduce whitespace
set(gca,'OuterPosition',[0,0,0.995,0.995]) %Adjust white space to avoid reduce too much
% exportgraphics(gcf,".../Figures/figure9f.eps",'Resolution',600);