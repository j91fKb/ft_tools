% Checks for difference from baseline
% Args:
%     - cfg
%         - cfg.baseline = [start end] ex. [-1 0]
function [p_values, misc] = ft_cmpBasePow(cfg, ft, ft_baseline)
tic

% get config
cfg_default = struct();
cfg_default.baseline = [-1, 0];
cfg_default.freq_ranges = [];
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

if nargin == 2
    ft_baseline = ft;
end

[~, n_labels, n_freqs, n_times] = size(ft.powspctrm);

if ~isempty(cfg.freq_ranges)
    n_freqs = size(cfg.freq_ranges, 1); % set if freq_ranges specified
end

% store some return info
misc = struct();
misc.freq_ranges = cfg.freq_ranges;

% extract some data (saves memory in parfor loop)
powspctrm = ft.powspctrm;
baseline = ft_baseline.powspctrm;
freq = ft.freq;
is_baseline = ft.time >= cfg.baseline(1) & ft.time <= cfg.baseline(2);

p_values = zeros(n_labels, n_freqs, n_times);

for l = 1:n_labels
    % get label data (saves memory in parfor loop)
    label_pow = squeeze(powspctrm(:, l, :, :));
    label_baseline = squeeze(baseline(:, l, :, :));
    
    parfor f = 1:n_freqs
        fprintf('label: %d / %d, freq: %d / %d\n', [l, n_labels, f, n_freqs])
        
        if ~isempty(cfg.freq_ranges)
            selected = freq >= cfg.freq_ranges(f, 1) & freq <= cfg.freq_ranges(f, 2); % select all in specified freq range
            sel_pow = squeeze(nanmean(label_pow(:, selected, :), 2));
            sel_baseline = nanmean(label_baseline(:, selected, is_baseline), 2);
        else
            sel_pow = squeeze(label_pow(:, f, :));
            sel_baseline = label_baseline(:, f, is_baseline);
        end
        
        p_values(l, f, :) = ranksum_cmp(sel_pow, sel_baseline(:));
    end
end

disp('Done!')
toc
end


% compare mat (n x t matrix) to arr (n x 1 array) using ranksum
function p_values = ranksum_cmp(mat, arr)
n = size(mat, 2);
p_values = ones(1, n);

if all(isnan(mat), 'all')
    return
end

for i = 1:n
    if all(isnan(mat(:, i)), 'all')
        p = 1;
    else
        p = ranksum(mat(:, i), arr);
    end
    p_values(i) = p;
end
end


