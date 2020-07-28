function ft_avg = ft_avgPow(ft)

ft_avg = ft;
ft_avg.powspctrm = squeeze(nanmean(ft.powspctrm, 1));
ft_avg.std = squeeze(nanstd(ft.powspctrm, [], 1));
ft_avg.count = squeeze(sum(~isnan(ft.powspctrm), 1));
ft_avg.dimord = 'chan_freq_time';

end