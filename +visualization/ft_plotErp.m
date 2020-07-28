function figs = ft_plotErp(cfg, ft)

cfg_default.n = size(ft.avg, 1);
cfg_default.rows = 5;
cfg_default.cols = 5;
cfg_default.xlabel = 'time (seconds)';
cfg_default.ylabel = 'voltage (mV)';
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
var = sqrt(ft.var(1, :)) ./ sqrt(ft.dof(1, :));
shadedErrorBar(ft.time, ft.avg, var, 'lineprops', {'-b'});

title(replace(ft.label{1}, '_', '-'))
if isfield(cfg, 'xdim')
    xlim(cfg.xdim)
end
if isfield(cfg, 'ydim')
    ylim(cfg.ydim)
end
end




