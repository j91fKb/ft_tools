% Checks if there is a difference between fts for each timepoint.
% Args:
%     - ft: 1 x n cell array where each item is an ft struct
function p_values = ft_cmpMultVolt(fts)
tic

% get some size info from the data
[n_labels, n_times] = size(fts{1}.trial{1});
n_fts = size(fts, 2);

% extract out the voltage from each ft
voltages = cell(1, n_fts);
for i = 1:n_fts
    voltages{i} = permute(cat(3, fts{i}.trial{:}), [3, 1, 2]);
end

% create a map of trials to which ft
trial_map = [];
for i = 1:n_fts
    trial_map = [trial_map; ones(size(voltages{i}, 1), 1) * i];
end

% initialize p values
p_values = ones(n_labels, n_times);

% iterate through all labels
for l = 1:n_labels
    fprintf('chan: %d / %d\n', [l, n_labels])
    
    % extract out data for each label
    label_data = [];
    for i = 1:n_fts
        label_data = [label_data; squeeze(voltages{i}(:, l, :))];
    end
    
    p_values(l, :) = par_kruskalwallis_cmp(label_data, trial_map);
end

disp('Done!')
toc
end

% compare mat (n x t matrix) where each row is in the group specified by
% data_group_map (n x 1 array)
function p_values = par_kruskalwallis_cmp(mat, group_map)
n = size(mat, 2);
p_values = ones(1, n);

if all(isnan(mat), 'all')
    return
end

% iterate through 2nd dimension of mat
parfor i = 1:n
    if all(isnan(mat(:, i)), 'all')
        p = 1;
    else
        p = kruskalwallis(mat(:, i), group_map, 'off');
    end
    p_values(i) = p;
end
end




