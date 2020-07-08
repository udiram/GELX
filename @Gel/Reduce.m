function Reduce(obj)
yPixVals = 1:1:size(obj.GelData,1);
yPixVals = yPixVals(yPixVals>obj.CalibData(3));
yLadderVals = log((yPixVals-obj.CalibData(3))/obj.CalibData(1))/obj.CalibData(2);
% 
%%
% xval = 1170;
obj.ShowGel();
[xval,yval] = ginput;
for k = 1:1:numel(xval)
    xvaltmp = round(xval(k));
    yvaltmp = round(yval(k));
    maxval = yPixVals(end);
    LineCutTmp = mean(obj.GelData(yvaltmp-100:yvaltmp+100,xvaltmp-100:xvaltmp+100),1);
    [~,MaxPos] = max(LineCutTmp);
    MaxPos = MaxPos + xvaltmp-100;
    LineCut = mean(obj.GelData(yPixVals(1):maxval,MaxPos-20:MaxPos+30),2);

    if isempty(obj.ReducedColumns)
        NumColums = 0;
        obj.ReducedColumns = zeros(numel(yLadderVals),3,1);
        obj.XposColumns = MaxPos;
    else
        NumColums = size(obj.ReducedColumns,3);
        Columnstmp = obj.ReducedColumns;
        obj.ReducedColumns = zeros(numel(yLadderVals),3,NumColums+1);
        obj.ReducedColumns(:,:,1:NumColums)= Columnstmp;
        XposColumnsTmp = obj.XposColumns;
        obj.XposColumns = zeros(NumColums+1,1);
        obj.XposColumns(1:NumColums,1)=XposColumnsTmp;
        obj.XposColumns(NumColums+1,1) = MaxPos;
    end
    obj.ReducedColumns(:,1,NumColums+1) = yPixVals;
    obj.ReducedColumns(:,2,NumColums+1) = yLadderVals;
    obj.ReducedColumns(:,3,NumColums+1) = LineCut;
end
% figure()
% plot(yLadderVals,LineCut,'*');
end