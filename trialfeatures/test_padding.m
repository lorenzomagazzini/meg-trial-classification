
% %low-level padding
% paddata = data;
% padlength       = 2* ceil( abs(data.time{1}(end)-data.time{1}(1)) ) * data.fsample;
% prepadlength    = padlength/2;
% postpadlength   = padlength/2;
% padtype         = 'mirror';
% for i = 1:length(data.trial)
%     dat = ft_preproc_padding(data.trial{i}, padtype, prepadlength, postpadlength);
%     tim = linspace(data.time{i}(1)-(padlength/data.fsample)/2, data.time{i}(end)+(padlength/data.fsample)/2, size(dat,2));
%     paddata.trial{i} = dat;
%     paddata.time{i} = tim;
% end
% paddata = rmfield(paddata,'sampleinfo')

% %trim down
% cfg = [];
% cfg.latency = [data.time{1}(1) data.time{1}(end)];
% data_lp = ft_selectdata(cfg, data_lp)
