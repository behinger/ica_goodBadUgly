% Load an uncleaned set with an accompanying ICA
% we want to show the weirdness of this :)
icaList = struct();
charlist= [2];
main_path = '/net/store/nbp/projects/wtp/';

fprintf('processing VP: %i\n',charLoop)


mod = loadmodout12(fullfile(main_path,'amica','2','amica_run_1'));



EEG = pop_loadset('filename',fullfile(main_path,'set','2','Filtfir.set'));
rej_channel = {'BIP1','BIP2','BIP3','BIP4','AUX1','AUX2','AUX3','AUX4'};
EEG = pop_select( EEG,'nochannel',rej_channel);
EEG.icasphere = mod.S;
EEG.icaweights = mod.W;
EEG = eeg_checkset(EEG)



pop_prop(EEG,0,[8 9],'spectopo_options',{'freqrange',[1 70]})
saveas(gcf,'/net/store/nbp/users/behinger/misc/blog/ica_goodbadugly/uncleaned_component9.png')
close(gcf)
saveas(gcf,'/net/store/nbp/users/behinger/misc/blog/ica_goodbadugly/uncleaned_component8.png')
close(gcf)