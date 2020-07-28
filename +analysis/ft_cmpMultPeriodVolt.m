% Checks if there is a difference between fts across entire period of time.
% Args:
%     - ft: 1 x n cell array where each item is the ft struct
function p_values = ft_cmpMultPeriodVolt(cfg, fts)
tic

% get some general info from the data
[n_labels, ~] = size(fts{1}.trial{1});
n_fts = size(fts, 2);

% extract out the voltage from each ft
voltages = cell(1, n_fts);
for i = 1:n_fts
    voltages{i} = permute(cat(3, fts{i}.trial{:}), [3, 1, 2]);
end

% initialize p values
p_values = ones(n_labels, 1);

% iterate through all labels
for l = 1:n_labels
    fprintf('chan: %d / %d\n', [l, n_labels])
    
    % extract out data and create trial map for each label
    label_data = [];
    trial_map = []; % map to which ft each row in label_data belongs to
    
    % iterate through all fts and append data
    for i = 1:n_fts
        x = squeeze(voltages{i}(:, l, :));
        label_data = [label_data; x(:)];
        trial_map = [trial_map; ones(length(x(:)), 1) * i];
    end
    
    p_values(l) = kruskalwallis_cmp(label_data, trial_map);
end

disp('Done!')
toc
end

% compare arr (n x 1 array) where each row is in the group specified by
% group_map (n x 1 array)
function p_value = kruskalwallis_cmp(arr, group_map)
p_value = 1;

if all(isnan(arr), 'all') % return if all nan
    return
else % calc kruskalwallis
    p_value = kruskalwallis(arr, group_map, 'off');
end
end




