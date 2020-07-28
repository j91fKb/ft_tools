% Checks if there is a difference between fts across entire period of time.
% Args:
%     - ft: 1 x n cell array where each item is an ft struct
function [p_values, misc] = ft_cmpMultPeriodPow(cfg, fts)
tic

% get config
cfg_default = struct();
cfg_default.freq_ranges = [];
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

% store some return info
misc = struct();
misc.freq_ranges = cfg.freq_ranges;

% get some general info from the data
[~, n_labels, n_freqs, ~] = size(fts{1}.powspctrm);
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
p_values = ones(n_labels, n_freqs);

% iterate through all labels and frequencies
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
        trial_map = []; % map to which block each row in label_data belongs to
        
        % iterate through all blocks and append data
        for i = 1:n_fts
            
            if ~isempty(cfg.freq_ranges)
                selected = freqs{i} >= cfg.freq_ranges(f, 1) & freqs{i} <= cfg.freq_ranges(f, 2); % select all in specified freq range
                x = label_pows{i}(:, selected, :); % select data
            else
                x = squeeze(label_pows{i}(:, f, :));
            end
            
            label_data = [label_data; x(:)];
            trial_map = [trial_map; ones(length(x(:)), 1) * i];
        end
        
        p_values(l, f) = kruskalwallis_cmp(label_data, trial_map);
    end
    
end

disp('Done!')
toc
end

% compare arr (n x 1 array) where each row is in the group specified by
% group_map (n x 1 array)
function p_value = kruskalwallis_cmp(arr, group_map)
p_value = 1;

if all(isnan(arr), 'all')
    return
else
    p_value = kruskalwallis(arr, group_map, 'off');
end

end
