function cfg = combine_cfgs(cfg1, cfg2)
cfg = cfg1;

fs = fields(cfg2);
for i = 1:size(fs, 1)
    f = fs{i};
    cfg.(f) = cfg2.(f);
end
end
