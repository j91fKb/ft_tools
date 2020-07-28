% Checks for difference from baseline
% Args:
%     - cfg
%         - cfg.baseline = [start end] ex. [-1 0]
function p_values = ft_cmpBaseVolt(cfg, ft, ft_baseline)
tic

cfg_default = struct();
cfg_default.baseline = [-1, 0];
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

if nargin == 2
    ft_baseline = ft;
end

voltage = permute(cat(3, ft.trial{:}), [3, 1, 2]);
baseline = permute(cat(3, ft_baseline.trial{:}), [3, 1, 2]);
time = ft_baseline.time{1};
is_baseline = time >= cfg.baseline(1) & time <= cfg.baseline(2);

[~, n_labels, n_times] = size(voltage);
p_values = zeros(n_labels, n_times);

for l = 1:n_labels
    fprintf('chan: %d / %d\n', [l, n_labels])
    
    label_volt = squeeze(voltage(:, l, :));
    label_baseline = baseline(:, l, is_baseline);
    
    p_values(l, :) = par_ranksum_cmp(label_volt, label_baseline(:));
end
disp('Done!')
toc
end


% parallelized compare mat (n x t matrix) to arr (n x 1 array) using ranksum
function p_values = par_ranksum_cmp(mat, arr)
n = size(mat, 2);
p_values = ones(1, n);

if all(isnan(mat), 'all')
    return
end

parfor i = 1:n
    if all(isnan(mat(:, i)), 'all')
        p = 1;
    else
        p = ranksum(mat(:, i), arr);
    end
    p_values(i) = p;
end
end

