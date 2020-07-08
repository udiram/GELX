function ShowGel(obj)
    figure()
    imagesc(obj.GelData);
    colormap gray;
    shading flat;
    colorbar;
    set(gcf,'position',[200 50 850 700]);
    caxis([0 .5e4]);
end