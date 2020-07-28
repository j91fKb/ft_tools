function ft_region = ft_toRegionVolt(ft, label_map)

valid_labels_map = label_map(ismember(label_map.label, ft.label(ismember(ft.label, label_map.label(~isnan(label_map.region))))), :);
cfg = struct();
cfg.channel = valid_labels_map.label;
ft_valid = ft_selectdata(cfg, ft);

region_ids = unique(valid_labels_map.region);
n_regions = size(region_ids, 1);
ft_region = cell(1, n_regions);
for r = 1:n_regions
    region_id = region_ids(r);
    cfg = struct();
    cfg.channel = valid_labels_map.label(valid_labels_map.region == region_id);
    ft_region{r} = ft_combineByLabel(ft_selectdata(cfg, ft_valid), num2str(region_id));
end
ft_region = ft_appenddata([], ft_region{:});

end


function ft_comb = ft_combineByLabel(ft, new_label)
ft_comb = ft;
ft_comb.label = {new_label};
n_trials = size(ft.trial, 2);
for t = 1:n_trials
    ft_comb.trial{t} = nanmean(ft.trial{t}, 1);
end
end