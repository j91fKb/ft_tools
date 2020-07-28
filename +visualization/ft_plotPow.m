function figs = ft_plotPow(cfg, ft)

cfg_default.n = size(ft.powspctrm, 1);
cfg_default.rows = 5;
cfg_default.cols = 5;
cfg_default.ydim = [1, inf];
cfg_default.cdim = [0, 2];
cfg_default.xlabel = 'time (seconds)';
cfg_default.ylabel = 'frequency (Hz)';
cfg_default.select = @subplot_select;
cfg_default.plot = @subplot_plot;
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

figs = ft_tools.visualization.make_subplots(cfg, ft);

end

function subplot_data = subplot_select(ft, i)
cfg = struct();
cfg.channel = ft.label(i);
subplot_data = ft_selectdata(cfg, ft);
end

function subplot_plot(cfg, ft, ~)
n_freqs = size(ft.freq, 2);
n_times = size(ft.time, 2);
x = repmat(ft.time, [n_freqs, 1]);
y = repmat(ft.freq', [1, n_times]);
z = squeeze(ft.powspctrm(1, :, :));

pcolor(x, y, z)
shading flat
set(gca, 'yscale', 'log')
colormap(bipolar)
colorbar
title(replace(ft.label{1}, '_', '-'))
if isfield(cfg, 'xdim')
    xlim(cfg.xdim)
end
if isfield(cfg, 'ydim')
    ylim(cfg.ydim)
end
if isfield(cfg, 'yticks')
    yticks(cfg.yticks)
end
if isfield(cfg, 'cdim')
    caxis(cfg.cdim)
end

end
