init_readica
%%
%blind spot
icaList = struct();
charlist= [3 4 5 7 8];
main_path = '/net/store/nbp/projects/mof/';
for charLoop = charlist
%     for k = 1:2
        fprintf('processing VP: %i\n',charLoop)
        
        try
            mod = loadmodout12(fullfile(main_path,'amica',num2str(charLoop),'amica_run_1'));
            wInv = inv(mod.W*mod.S);
        catch
            continue
        end
        
        try
        EEG = pop_loadset('filename',fullfile(main_path,'set',num2str(charLoop),'Filtfir_badChannel_refav_epoch_events_trialClean_notraining.set'),'loadmode','info');
        catch
            try
                EEG = pop_loadset('filename',fullfile(main_path,'set',num2str(charLoop),'Filtfir_firstAmp_badChannel_refav_epoch_events_trialClean_notraining.set'),'loadmode','info');
            catch
                EEG = pop_loadset('filename',fullfile(main_path,'set',num2str(charLoop),'Filtfir_badChannel_refav_refav_epoch_events_trialClean_notraining.set'),'loadmode','info');
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
%     end
end

if isempty(icaList(1).wInv)
    icaList(1) = []; %from the init
end

%%
for ica = 1:length(icaList)
    figure('Position',[1 1 1280 1024])
    for ic = 1:length(icaList(ica).W)
        subplot(8,8,ic)
        topoplot(icaList(ica).wInv(:,ic),icaList(ica).chanlocs,'conv','on');
        
    end
    drawnow
    title(icaList(ica).set)
end

for ica = 1:length(icaList)
    saveas(gcf,['/net/store/nbp/users/behinger/misc/blog/ica_goodbadugly/ant_64_' num2str(ica)],'png')
    close(gcf)
end

