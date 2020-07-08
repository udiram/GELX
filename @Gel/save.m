function save(obj)
%     save('2020-0227-105206.mat','MyData');
    outputfilename = sprintf('%smat',obj.filename(1:end-3));
    save(outputfilename,'obj');
end