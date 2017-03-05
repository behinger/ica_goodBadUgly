init_readica
%%
%blind spot
icaList = struct();
charlist= [2];
main_path = '/net/store/nbp/projects/wtp/';
for charLoop = charlist
    for k = 1%:2
        fprintf('processing VP: %i\n',charLoop)
        
        try
            mod = loadmodout12(fullfile(main_path,'amica',num2str(charLoop),['amica_run_' num2str(k)]));
            wInv = inv(mod.W*mod.S);
        catch
            continue
        end
        
        if k == 1%uncleaned
            EEG = pop_loadset('filename',fullfile(main_path,'set',num2str(charLoop),'Filtfir.set'),'loadmode','info');
            rej_channel = {'BIP1','BIP2','BIP3','BIP4','AUX1','AUX2','AUX3','AUX4'};
            EEG = pop_select( EEG,'nochannel',rej_channel);

        else
        EEG = pop_loadset('filename',fullfile(main_path,'set',num2str(charLoop),'Filtfir_badChannel_contClean_refav.set'),'loadmode','info');
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
for ica = 1:length(icaList)
    figure('Position',[1 1 1280 1024])
    for ic = 1:length(icaList(ica).W)
        subplot(8,8,ic)
        topoplot(icaList(ica).wInv(:,ic),icaList(ica).chanlocs,'conv','off');
        
    end
    drawnow
    title(icaList(ica).set)
end
%%
for ica = 1:length(icaList)
    saveas(gcf,['/net/store/nbp/users/behinger/misc/blog/ica_goodbadugly/ant64_' num2str(ica)],'png')
    close(gcf)
end

