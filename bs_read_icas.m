init_readica
%%
%blind spot
icaList = struct();
charlist= char(65:90);
main_path = '/net/store/nbp/projects/EEG/blind_spot/data/';
for charLoop = charlist
    for k = 1:2
        fprintf('processing VP: %s%i\n',charLoop,k)
        fp = fullfile(main_path,['VP' charLoop num2str(k)]);
        try
            mod = loadmodout12(fullfile(fp,'amica','amicaRun'));
            wInv = inv(mod.W*mod.S);
        catch
            continue
        end
        p = dir(fullfile(fp,'sets','*.set'));
        
        for x = 1:length(p)
            EEG = pop_loadset('filename',fullfile(p(x).folder,p(x).name),'loadmode','info');
            if size(EEG.chanlocs,1) == size(wInv,1)
                break
            end
        end
        if size(EEG.chanlocs,2) ~= size(wInv,1)
            warning('found EEG and evertyhing, but it does not match')
            continue
        end
        
        icaList(end+1).wInv = wInv;
        icaList(end).W = mod.W;
        icaList(end).S = mod.S;
        icaList(end).chanlocs = EEG.chanlocs;
        icaList(end).set = p(x).name;
        icaList(end).fp = fp;
    end
end

if isempty(icaList(1).wInv)
    icaList(1) = []; %from the init
end

%%
for ica = 1:10%length(icaList)
    figure('Position',[1 1 1280 1024])
    for ic = 1:length(icaList(ica).W)
        subplot(8,8,ic)
        topoplot(icaList(ica).wInv(:,ic),icaList(ica).chanlocs,'conv','on');
        
    end
    drawnow
    title(icaList(ica).set)
end

%%
for ica = 1:10
    saveas(gcf,['/net/store/nbp/users/behinger/misc/blog/ica_goodbadugly/' num2str(ica)],'png')
    close(gcf)
end

