function [tf,loc] = ismember_rows(data1,data2)
%
%   [tf,loc] = sl.cellstr.ismember_rows(data1,data2)
%

n_rows_1 = size(data1,1);

all_data = [data1; data2];

[~,~,I]  = epworks.RNEL.uniqueRowsCA(all_data);

[tf,loc] = ismember(I(1:n_rows_1),I(n_rows_1+1:end));

end