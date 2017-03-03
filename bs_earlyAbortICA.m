init_readica
%%
charLoop = 'B';
k = 1;
fp = fullfile(main_path,['VP' charLoop num2str(k)]);

mod = loadmodout12(fullfile(fp,'amica','amicaRun','history','10'));
wInv = inv(mod.W*mod.S);

p = dir(fullfile(fp,'sets','*.set'));

for x = 1:length(p)
    EEG = pop_loadset('filename',fullfile(p(x).folder,p(x).name),'loadmode','info');
    if size(EEG.chanlocs,1) == size(wInv,1)
        break
    end
end
%%
figure('Position',[1 1 1280 1024])

for ic = 1:length(mod.W)
          subplot(8,8,ic)

    topoplot(wInv(:,ic),EEG.chanlocs,'conv','on');
end

saveas(gcf,'/net/store/nbp/users/behinger/misc/blog/ica_goodbadugly/earlyAbortICA.png')