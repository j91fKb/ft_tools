% Checks if there is a difference between fts for each timepoint.
% Args:
%     - ft: 1 x n cell array where each item is an ft struct
function [p_values, misc] = ft_cmpMultPow(cfg, fts)
tic

% get config
cfg_default = struct();
cfg_default.freq_ranges = [];
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

% store some return info
misc = struct();
misc.freq_ranges = cfg.freq_ranges;

% get some size info from the data
[~, n_labels, n_freqs, n_times] = size(fts{1}.powspctrm);
if ~isempty(cfg.freq_ranges)
    n_freqs = size(cfg.freq_ranges, 1); % set if freq_ranges specified
end
n_fts = size(fts, 2);

% extract out the powspctrm and freq from each ft
powspctrms = cell(1, n_fts);
freqs = cell(1, n_fts);
for i = 1:n_fts
    powspctrms{i} = fts{i}.powspctrm;
    freqs{i} = fts{i}.freq;
end

% initialize p_values
p_values = ones(n_labels, n_freqs, n_times);

% iterate through all channels and frequencies
for l = 1:n_labels
    label_pows = cell(1, n_fts);
    for i = 1:n_fts
        label_pows{i} = squeeze(powspctrms{i}(:, l, :, :));
    end
    
    parfor f = 1:n_freqs
        fprintf('label: %d / %d, freq: %d / %d\n', [l, n_labels, f, n_freqs])
        
        % extract out data and create trial map for each label and
        % frequency
        label_data = [];
        trial_map = []; % map to which ft each row in label_data belongs to
        
        % iterate through all fts and append data
        for i = 1:n_fts
            
            if ~isempty(cfg.freq_ranges)
                selected = freqs{i} >= cfg.freq_ranges(f, 1) & freqs{i} <= cfg.freq_ranges(f, 2); % select all in specified freq range
                x = label_pows{i}(:, selected, :); % select data
                x = reshape(x, [size(x, 1) * sum(selected), n_times]);
            else
                x = squeeze(label_pows{i}(:, f, :));
            end
            
            label_data = [label_data; x];
            trial_map = [trial_map; ones(size(x, 1), 1) * i];
        end
        
        p_values(l, f, :) = kruskalwallis_cmp(label_data, trial_map);
    end
end

disp('Done!')
toc
end


% compare mat (n x t matrix) where each row is in the group specified by
% data_group_map (n x 1 array)
function p_values = kruskalwallis_cmp(mat, group_map)
n = size(mat, 2);
p_values = ones(1, n);

if all(isnan(mat), 'all')
    return
end

% iterate through 2nd dimension of mat
for i = 1:n
    if all(isnan(mat(:, i)), 'all')
        p = 1;
    else
        p = kruskalwallis(mat(:, i), group_map, 'off');
    end
    p_values(i) = p;
end
end
