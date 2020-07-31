function figs = make_subplots(cfg, data)

cfg_default = struct();
cfg_default.rows = 4;
cfg_default.cols = 4;
cfg_default.show_labels = true;
cfg_default.title = '';
cfg_default.title_position = [.4 .97 .5 .02];
cfg_default.xlabel = '';
cfg_default.xlabel_position = [.4 .03 .5 .02];
cfg_default.ylabel = '';
cfg_default.ylabel_position = [.02 .4 .5 .02];
cfg_default.position = [0 0 1500 1000];
cfg = ft_tools.utils.combine_cfgs(cfg_default, cfg);

rows = cfg.rows;
cols = cfg.cols;

sect = 0;
figs = gobjects;

for i = 1:cfg.n
    fprintf('subplot %d out of %d\n', i, cfg.n)
    
    % create a new figure
    if mod(i, rows * cols) == 1
        sect = sect + 1;
        fig = figure(sect);
        figs(sect) = fig;
        
        % set dimensions
        fig.OuterPosition = cfg.position;
        
        % set x and y axis names
        if cfg.show_labels
            annotation('textbox', 'String', replace(cfg.title, '_', '-'),...
                'Position', cfg.title_position,...
                'EdgeColor', 'none');
            annotation('textarrow', 'String', cfg.ylabel,...
                'HeadStyle','none','LineStyle', 'none',...
                'Position', cfg.ylabel_position,...
                'TextRotation', 90);
            annotation('textbox', 'String', cfg.xlabel,...
                'Position', cfg.xlabel_position,...
                'EdgeColor', 'none');
        end
    end
    
    % plot subplot
    s = mod(i, rows * cols);
    if s == 0
        s = rows * cols;
    end
    subplot(rows, cols, s)
    cfg.plot(cfg, data, i)
    
end

end




