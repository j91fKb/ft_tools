classdef Norm
    
    methods (Static)
        
        function pass = normVoltMatch(ft)
            cfg = struct();
            cfg.baseline = [-1 0];
            x = ft_tools.data.ft_normVolt(cfg, ft);
            ft_config = struct();
            ft_config.latency = [-1 0];
            ft_baseline = ft_selectdata(ft_config, ft);
            y = ft_tools.data.ft_normVolt(cfg, ft, ft_baseline);
            pass = all(cat(3, x.trial{:}) == cat(3, y.trial{:}), 'all');
        end
        
        function pass = normPowMatch(ft)
            cfg = struct();
            cfg.baseline = [-1 0];
            x = ft_tools.data.ft_normPow(cfg, ft);
            ft_config = struct();
            ft_config.latency = [-1 0];
            ft_baseline = ft_selectdata(ft_config, ft);
            y = ft_tools.data.ft_normPow(cfg, ft, ft_baseline);
            pass = all(x.powspctrm(~isnan(x.powspctrm)) == y.powspctrm(~isnan(y.powspctrm)), 'all');
        end
        
    end
    
end
