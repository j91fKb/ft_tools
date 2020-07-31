function ft_norm = ft_normVolt(cfg, ft, ft_baseline)

cfg_default = struct();
cfg_default.baseline = [-1 0];
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

% create a copy of the data
ft_norm = ft;

% get size info
n_trials = size(ft.trial, 2);
n_times = size(ft.time{1}, 2);

% use ft for the baseline if ft_baseline not passed as an arg
if nargin == 2
    ft_baseline = ft;
end

% calculate normalized voltage
is_baseline = ft_baseline.time{1} >= cfg.baseline(1) & ft_baseline.time{1} <= cfg.baseline(2);
voltage = permute(cat(3, ft.trial{:}), [3, 1, 2]);
baseline = permute(cat(3, ft_baseline.trial{:}), [3, 1, 2]);
baseline_mean = nanmean(baseline(:, :, is_baseline), 3);
baseline_std = nanstd(baseline(:, :, is_baseline), [], 3);
correction_mean = repmat(baseline_mean, [1, 1, n_times]);
correction_std = repmat(baseline_std, [1, 1, n_times]);
norm_voltage = (voltage - correction_mean) ./ correction_std;

% update ft_norm with normalized voltage
for t = 1:n_trials
    ft_norm.trial{t} = squeeze(norm_voltage(t, :, :));
end

% add cfg information
ft_norm.norm_info.baseline = cfg.baseline;

end
