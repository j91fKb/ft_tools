% Checks for difference from baseline
% Args:
%     - cfg
%         - cfg.baseline = [start end] ex. [-1 0]
function [p_values, misc] = ft_cmpBaseVolt(cfg, ft, ft_baseline)
tic

% create cfg
cfg_default = struct();
cfg_default.baseline = [-1, 0];
% combine cfg_default and input cfg
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

% store some return info
misc = struct();
misc.baseline = cfg.baseline;

% use ft as ft_baseline if it is not passed in
if nargin == 2
    ft_baseline = ft;
end

% get timing + sizing info and combine data for all trials
voltage = permute(cat(3, ft.trial{:}), [3, 1, 2]);
baseline = permute(cat(3, ft_baseline.trial{:}), [3, 1, 2]);
time = ft_baseline.time{1};
is_baseline = time >= cfg.baseline(1) & time <= cfg.baseline(2);
[~, n_labels, n_times] = size(voltage);

% allocate p_values
p_values = ones(n_labels, n_times);

% iterate through all labels
for l = 1:n_labels
    fprintf('chan: %d / %d\n', [l, n_labels])
    
    % get data for the label
    label_volt = squeeze(voltage(:, l, :));
    label_baseline = baseline(:, l, is_baseline);
    
    % calc ranksum
    p_values(l, :) = par_ranksum_cmp(label_volt, label_baseline(:));
end

disp('Done!')
toc
end


% parallelized compare mat (n x t matrix) to arr (n x 1 array) using
% ranksum method
function p_values = par_ranksum_cmp(mat, arr)
n = size(mat, 2);

% allocate p_values with ones
p_values = ones(1, n);

% return if all data is nan
if all(isnan(mat), 'all')
    return
end

% iterate through second dimension of mat
parfor i = 1:n
    if all(isnan(mat(:, i)), 'all') % 1 if all nan
        p = 1; 
    else % calc ranksum of column in mat and arr
        p = ranksum(mat(:, i), arr); 
    end
    p_values(i) = p;
end
end

