function ft_region = ft_toRegionPow(ft, label_map, region_key)

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
    ft_region{r} = ft_combineByLabel(ft_selectdata(cfg, ft_valid), region_key{region_id});
end

% combine regions
ft_region = ft_appendfreq([], ft_region{:});

end

% Average ft across labels
function ft_comb = ft_combineByLabel(ft, new_label)
ft_comb = ft;
ft_comb.label = {new_label};
ft_comb.powspctrm = nanmean(ft.powspctrm, 2);
end