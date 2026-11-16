%% Training loss curves
%
% This script reproduces the training loss in Figure 3 of the manuscript.
%
% Input:
%   ../record_data/
%   - test*_train_loss.npy
%
% Output:
%   - Training loss curves
%
% Required functions:
%   - npy-matlab 
%   - cbrewer2 
% 
addpath('npy-matlab')  
addpath('cbrewer2')
savepath
camp1 = cbrewer2('qual', 'Set2', 8); 
camp2 = cbrewer2('seq', 'YlGnBu', 50); 

color1 = camp1(2, :);  
color2 = camp1(1, :);
color3 = camp2(40, :);

%% Figure 3
loss1 = readNPY('../record_data/test1_train_loss.npy');
loss2= readNPY('../record_data/test2_train_loss.npy');
loss3 = readNPY('../record_data/test3_train_loss.npy');

loss1 = loss1 / loss1(1);
loss2 = loss2 / loss2(1);
loss3 = loss3 / loss3(1);

epoch = 1:length(loss1);
figure;
plot(epoch,loss1,'Color',color1,'Linewidth',2);
ylabel('Loss','FontSize',15);
xlabel('Epoch','FontSize',15);
hold on;
plot(epoch,loss2,'Color',color2,'Linewidth',2);
hold on;
plot(epoch,loss3,'Color',color3,'Linewidth',2);
legend({'Irregular 50%', 'Irregular 66.7%', 'Regular 50%',}, 'Location', 'northeast','FontSize',16);
ylim([0,0.5]);
set(gcf,'renderer','Painters'); 
set(gca,'LooseInset',max(get(gca, 'TightInset'),0)); 
set(gca,'OuterPosition',[0,0,0.995,0.995]);
% exportgraphics(gcf,"/./figure3.eps",'Resolution',600);

