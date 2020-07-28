function ft = createFt(cfg, raw_data, timing, labels, trial_info)

cfg_default = struct();
cfg_default.interval = [-5, 5];
cfg_default.sample_rate = 1000;
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

ft = struct();
ft.label = labels;
if nargin == 5 && ~isempty(trial_info)
    ft.trialinfo = trial_info;
end

time = cfg.interval(1):1 / cfg.sample_rate:cfg.interval(2);
n_trials = size(timing, 1);
ft.time = cell(1, n_trials);
ft.trial = cell(1, n_trials);

for t = 1:n_trials
    ft.time{t} = time;
    t1 = round((timing(t) + cfg.interval(1)) * cfg.sample_rate);
    t2 = round((timing(t) + cfg.interval(2)) * cfg.sample_rate);
    ft.trial{t} = raw_data(:, t1:t2);
end

end
