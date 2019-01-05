function [found_label] = KNN(inx, data, labels, k)

[datarow,datacoloum] = size(data);
subtract = repmat(inx,[1,datacoloum]) - data;
A = subtract.^2;
B = sum(A);
dis_data = sqrt(B);
[C,D] = sort(dis_data,'ascend');
len = min(k,length(C));
ind = D(1,1:len);
label = labels(1,ind);
found_label = mode(label);

end