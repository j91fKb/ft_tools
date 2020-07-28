function ft_norm = ft_normPow(cfg, ft, ft_baseline)

cfg_default = struct();
cfg_default.baseline = [-1 0];
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

% create a copy of the data
ft_norm = ft;

% get size info
[n_trials, ~, ~, n_times] = size(ft.powspctrm);

% use ft for the baseline if ft_baseline not passed as an arg
if nargin == 2
    ft_baseline = ft;
end

% calculate correction
is_baseline = ft_baseline.time >= cfg.baseline(1) & ft_baseline.time <= cfg.baseline(2);
correction = repmat(nanmean(ft_baseline.powspctrm(:, :, :, is_baseline), [1 4]), ...
    [n_trials, 1, 1, n_times]);

% calculated normalized power and update ft_norm
ft_norm.powspctrm = ft.powspctrm ./ correction;

% add cfg information
ft_norm.norm_info.baseline = cfg.baseline;

end
