function PlotColumns(obj,ColumnID,flag,varargin)
numel(varargin)
if flag=='lin'
   figure()
   CurrentPlot = plot(obj.ReducedColumns(:,2,ColumnID),obj.ReducedColumns(:,3,ColumnID));
   xlabel('Nucleotides','Interpreter','latex');
   ylabel('Intensity','Interpreter','latex'); 
   set(CurrentPlot,'LineWidth',3,'Color',[0 0 0]);
   set(gca,'LineWidth',2,'FontSize',16);
   set(gcf,'position',[200 50 850 700]);
   box on;
    if numel(varargin)==1
        xlimits=varargin{1};   
        axis([xlimits(1) xlimits(2) min(obj.ReducedColumns(:,3,ColumnID)) 1.1*max(obj.ReducedColumns(:,3,ColumnID))]);
    else
        axis([0 max(obj.ReducedColumns(:,2,ColumnID)) min(obj.ReducedColumns(:,3,ColumnID)) 1.1*max(obj.ReducedColumns(:,3,ColumnID))]);
    end
elseif flag == 'img'
   figure()
   subplot(2,1,1);
       CropImageTmp = obj.GelData(obj.ReducedColumns(:,1,ColumnID),obj.XposColumns(ColumnID)-100:obj.XposColumns(ColumnID)+100);
       pcolorPlot = pcolor(obj.ReducedColumns(:,2,ColumnID),[1:1:201]',CropImageTmp');
       box on;
       set(gca,'layer','top')
       set(pcolorPlot,'EdgeColor','none');
       colormap jet
       if numel(varargin)==1
        xlim(varargin{1});   
       else
        xlim([0 max(obj.ReducedColumns(:,2,ColumnID))]);
       end
       set(gca,'LineWidth',2);
       xlabel('Nucleotides','Interpreter','latex');
       set(gca,'LineWidth',2,'FontSize',16);
   subplot(2,1,2);
       CurrentPlot = plot(obj.ReducedColumns(:,2,ColumnID),obj.ReducedColumns(:,3,ColumnID));
       set(CurrentPlot,'LineWidth',3,'Color',[0 0 0]);
       xlabel('Nucleotides','Interpreter','latex');
       ylabel('Intensity','Interpreter','latex'); 
       set(gca,'LineWidth',2,'FontSize',16,'YScale','log');
       set(gcf,'position',[200 50 850 700]);
       box on;
       if numel(varargin)==1
        xlimits=varargin{1};   
        axis([xlimits(1) xlimits(2) min(obj.ReducedColumns(:,3,ColumnID)) 1.1*max(obj.ReducedColumns(:,3,ColumnID))]);
       else
        axis([0 max(obj.ReducedColumns(:,2,ColumnID)) min(obj.ReducedColumns(:,3,ColumnID)) 1.1*max(obj.ReducedColumns(:,3,ColumnID))]);
       end
elseif flag == 'com'
    figure()
    hold on;
    for j = 1:1:numel(ColumnID)
        CurrentPlot(j) = plot(obj.ReducedColumns(:,2,ColumnID(j)),obj.ReducedColumns(:,3,ColumnID(j)));
    end
    hold off;
    xlabel('Nucleotides','Interpreter','latex');
    ylabel('Intensity','Interpreter','latex'); 
    set(CurrentPlot,'LineWidth',3);
    set(gca,'LineWidth',2,'FontSize',16);
    set(gcf,'position',[200 50 850 700]);
    box on;
    if numel(varargin)==1
        xlimits=varargin{1};   
        axis([xlimits(1) xlimits(2) min(obj.ReducedColumns(:,3,ColumnID(1))) 1.1*max(obj.ReducedColumns(:,3,ColumnID(1)))]);
    else
        axis([0 max(obj.ReducedColumns(:,2,ColumnID(1))) min(obj.ReducedColumns(:,3,ColumnID(1))) 1.1*max(obj.ReducedColumns(:,3,ColumnID(1)))]);
    end
elseif flag == '2dp'
   figure()
   CropImageTmp = obj.GelData(obj.ReducedColumns(:,1,ColumnID),obj.XposColumns(ColumnID)-100:obj.XposColumns(ColumnID)+100);
   pcolorPlot = pcolor(obj.ReducedColumns(:,2,ColumnID),[1:1:201]',CropImageTmp');
   box on;
   set(gca,'layer','top')
   set(pcolorPlot,'EdgeColor','none');
   colormap jet
   if numel(varargin)==1
    xlim(varargin{1});   
   else
    xlim([0 max(obj.ReducedColumns(:,2,ColumnID))]);
   end
   set(gca,'LineWidth',2);
   xlabel('Nucleotides','Interpreter','latex');
   set(gca,'LineWidth',2,'FontSize',16);
end
end
