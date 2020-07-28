function ft_power = ft_calcPow(cfg, ft)

cfg_default.keeptrials = 'yes';
cfg_default.method = 'wavelet';
cfg_default.output = 'pow';
cfg_default.foi = [0:0.5:14.5, 15:1:49, 50:5:200];
cfg_default.toi = ft.time{1}(1):.05:ft.time{1}(end);
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

ft_power = ft_freqanalysis(cfg, ft);

end
