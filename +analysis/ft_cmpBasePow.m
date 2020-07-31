% Checks for difference from baseline
% Args:
%     - cfg
%         - cfg.baseline = [start end] ex. [-1 0]
function [p_values, misc] = ft_cmpBasePow(cfg, ft, ft_baseline)
tic

% create cfg
cfg_default = struct();
cfg_default.baseline = [-1, 0];
cfg_default.freq_ranges = [];
% combine cfg_default and input cfg
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

% store some return info
misc = struct();
misc.freq_ranges = cfg.freq_ranges;
misc.baseline = cfg.baseline;

% use ft as ft_baseline if it is not passed in
if nargin == 2
    ft_baseline = ft;
end

% size info
[~, n_labels, n_freqs, n_times] = size(ft.powspctrm);
% set if freq_ranges specified
if ~isempty(cfg.freq_ranges)
    n_freqs = size(cfg.freq_ranges, 1); 
end

% extract some data (saves memory in parfor loop)
powspctrm = ft.powspctrm;
baseline = ft_baseline.powspctrm;
freq = ft.freq;
is_baseline = ft.time >= cfg.baseline(1) & ft.time <= cfg.baseline(2);

% allocate p_values
p_values = ones(n_labels, n_freqs, n_times);

% iterate through labels and frequencies
for l = 1:n_labels
    % get data for the label (saves memory in parfor loop)
    label_pow = squeeze(powspctrm(:, l, :, :));
    label_baseline = squeeze(baseline(:, l, :, :));
    
    parfor f = 1:n_freqs
        fprintf('label: %d / %d, freq: %d / %d\n', [l, n_labels, f, n_freqs])
        
        if ~isempty(cfg.freq_ranges) % calc for freq range if specified
            selected = freq >= cfg.freq_ranges(f, 1) & freq < cfg.freq_ranges(f, 2); % select all in specified freq range
            sel_pow = label_pow(:, selected, :);
            sel_baseline = label_baseline(:, selected, is_baseline);
        else % calc for specific frequency
            sel_pow = label_pow(:, f, :);
            sel_baseline = label_baseline(:, f, is_baseline);
        end
        
        p_values(l, f, :) = ranksum_cmp(sel_pow, sel_baseline(:));
    end
end

disp('Done!')
toc
end


% compare mat (n x m x t matrix) to arr (n x 1 array) using ranksum
function p_values = ranksum_cmp(mat, arr)
n = size(mat, 3);

% allocate p_values with ones
p_values = ones(1, n);

% return if all data is nan
if all(isnan(mat), 'all')
    return
end

% iterate through second dimension of mat
for i = 1:n
    if all(isnan(mat(:, :, i)), 'all') % 1 if all nan
        p = 1;
    else % calc ranksum of column in mat and arr
        x = mat(:, :, i);
        p = ranksum(x(:), arr);
    end
    p_values(i) = p;
end
end


