function Calibrate(obj)
    obj.ShowGel();
    [x,y] = ginput;
    if numel(x)~=5
       error('You need to click on the 5 calibration peaks: 150, 80, 25, 21 and 0'); 
    end
    x = round(x);
    y = round(y);

    for i = 1:1:numel(x)
       CropTmp = obj.GelData(y(i)-50:y(i)+50,x(i)-30:x(i)+30);
       PeakTmp = mean(CropTmp,2);
       [~,CalibPos(i)] = max(PeakTmp);
       CalibPos(i) = CalibPos(i) + (y(i)-50);
    end
    
    hold on;
    plot(x,CalibPos,'bx');
    hold off;

    Ladder = [150 80 25 21 0];
    Ladder = flip(Ladder);
    CalibPos = flip(CalibPos);

    obj.LadderPos(:,1)=Ladder';
    obj.LadderPos(:,2)=CalibPos';

    %% 
   
    dats = spec1d(obj.LadderPos(:,1),obj.LadderPos(:,2),.05*obj.LadderPos(:,2));
    [~,Fitdat] = fits(dats,'exp_bg',[obj.LadderPos(1,2) -0.02 0 ],[1 1 1]);
    
    figure()
    hold on;
    plot(obj.LadderPos(:,1),obj.LadderPos(:,2));
    plot([0:.1:150],exp_bg([0:.1:150],Fitdat.pvals));
    hold off;
    obj.CalibData = Fitdat.pvals;

end