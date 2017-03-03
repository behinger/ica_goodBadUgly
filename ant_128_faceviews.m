init_readica
%%
%blind spot
icaList = struct();
charlist= [2:4 6 7 8 9 10]
main_path = '/net/store/nbp/projects/FaceViewEEG/Data/';
for charLoop = charlist
    %     for k = 1:2
    fprintf('processing VP: %i\n',charLoop)
    try
        
        EEG = pop_loadset('filename',['/net/store/nbp/projects/FaceViewEEG/Data/VP' num2str(charLoop),'/VP' num2str(charLoop) '_dataClean.set'],'loadmode','info');
        EEG=pop_chanedit(EEG, 'lookup','/net/store/nbp/users/behinger/projects/mof/git/lib/eeglab/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
        
        
        mod = loadmodout12(fullfile(main_path,['VP' num2str(charLoop)],'Amica'));
        wInv = inv(mod.W*mod.S);
    catch
        continue
    end
    
    if size(EEG.chanlocs,2) ~= size(wInv,1)
        continue
    end
    icaList(end+1).wInv = wInv;
    icaList(end).W = mod.W;
    icaList(end).S = mod.S;
    icaList(end).chanlocs = EEG.chanlocs;
    icaList(end).set = charLoop;
    icaList(end).fp = main_path;
    %     end
end

if isempty(icaList(1).wInv)
    icaList(1) = []; %from the init
end

%%
for ica = 7%1:length(icaList)
    
    figure('Position',[1 1 1280 1024])
    for ic = 1:64%length(icaList(ica).wInv)
        subplot(8,8,ic)
        topoplot(icaList(ica).wInv(:,ic),icaList(ica).chanlocs,'conv','on');
        
    end
    drawnow
    title(icaList(ica).set)
    
end
%%
cd /net/store/nbp/users/behinger/misc/blog/ica_goodbadugly/
for ica = 1:length(icaList)
    saveas(gcf,['/net/store/nbp/users/behinger/misc/blog/ica_goodbadugly/' num2str(ica)],'png')
    close(gcf)
end



%% Make a jumpled one (change connector 3 and 4)

ica = 1;
chanlocs = icaList(ica).chanlocs;
tmp = chanlocs(92:end);
chanlocs(92:end) = chanlocs(62:91);
chanlocs(62:91) = tmp;



figure('Position',[1 1 1280 1024])
for ic = 1:64%length(icaList(ica).wInv)
    subplot(8,8,ic)
    topoplot(icaList(ica).wInv(:,ic),chanlocs,'conv','on');
    
end

    saveas(gcf,['/net/store/nbp/users/behinger/misc/blog/ica_goodbadugly/ica_7_switchedConnector34'],'png')
