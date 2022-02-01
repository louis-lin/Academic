function idx = getMaxDispIdx(folder)
    try
        [~, dispHist] = readvars(".\" +folder+ "\Results_static\Disp.txt");
    catch 
        [~, dispHist] = readvars(".\" +folder+ "\Results_dynamic\Disp.txt");
    end
    [~ , idx] = max(abs(dispHist));
end