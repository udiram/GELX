function CorrectOrientation(obj)
% This function corrects the orientation of the 2D data in a Blade object 
% The function request to select the positon of the first two Bragg peaks.
% It fits the peak position linearly and determines the rotation angle. 
% Multiple Bragg peaks can be selected to reduce the noice.
%  ---
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca)


obj.Plot2Ddata('p')
[x,y]        = ginput;
x= round(x);
y= round(y);
maxpos_qpar = zeros(1,numel(x)+1);
maxpos_qz = zeros(1,numel(x)+1);
maxpos_qpar(1) = obj.Origin(1);
maxpos_qz(1) = obj.Origin(2);


for i = 1:1:numel(x)
    CropDataTmp = obj.Data2D(y(i)-20:y(i)+20,x(i)-20:x(i)+20);
    [maxval, maxpos] = max(CropDataTmp);
    [~, maxpos_qpar(i+1)] = max(maxval);
    maxpos_qz(i+1) = maxpos(maxpos_qpar(i+1));
    hold on;
    plot(maxpos_qpar(i+1),maxpos_qz(i+1),'*r');
    hold off;
    maxpos_qz(i+1) = maxpos_qz(i+1) + y(i)-20;
    maxpos_qpar(i+1) = maxpos_qpar(i+1) + x(i)-20;
end

%%
close all 
figure()
plot(maxpos_qpar,maxpos_qz,'*r');
hold on;
data = spec1d(maxpos_qpar,maxpos_qz,0.01*maxpos_qz);
  [~,LinFitData]=fits(data,'strline',[17 -6.18e6],[1 1]);
  plot(maxpos_qpar,strline(maxpos_qpar,LinFitData.pvals));
hold off;

RotAngle = acotd(LinFitData.pvals(1));

%%
obj.Data2D = imrotate(obj.Data2D,-RotAngle,'nearest','crop');

%%
[maxval,maxpos] = max(obj.Data2D(1:10,:));
[~,xpos] = max(maxval);
ypos = maxpos(xpos);
obj.Plot2Ddata()
obj.Origin = [xpos,ypos];
obj.qpar = obj.qpar - obj.qpar(obj.Origin(1));
obj.qz = obj.qz - obj.qz(obj.Origin(2));

obj.xMetric = obj.xMetric - obj.xMetric(obj.Origin(1));
obj.yMetric = obj.yMetric - obj.yMetric(obj.Origin(2));

obj.ThetaChi = obj.ThetaChi - obj.ThetaChi(obj.Origin(1));
obj.Theta2Theta = obj.Theta2Theta - obj.Theta2Theta(obj.Origin(2));

obj.Plot2Ddata()

end