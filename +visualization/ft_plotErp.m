function figs = ft_plotErp(cfg, data)

cfg_default.n = size(data.ft.label, 1);
cfg_default.rows = 5;
cfg_default.cols = 5;
cfg_default.xlabel = 'time (seconds)';
cfg_default.ylabel = 'voltage (zscore)';
cfg_default.plot = @subplot_plot;
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

figs = ft_tools.visualization.make_subplots(cfg, data);

end


function subplot_plot(cfg, ft, i)
var = sqrt(ft.var(i, :)) ./ sqrt(ft.dof(i, :));
shadedErrorBar(ft.time, ft.avg(i, :), var, 'lineprops', {'-b'});

title(replace(ft.label{i}, '_', '-'))
if isfield(cfg, 'xdim')
    xlim(cfg.xdim)
end
if isfield(cfg, 'ydim')
    ylim(cfg.ydim)
end
end




