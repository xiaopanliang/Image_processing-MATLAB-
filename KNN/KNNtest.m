function c = KNNtest(X,t,k)
Row_sum = size(X,1);
Col_sum = size(X,2);
Class = X(:,Col_sum);
Classtype = unique(Class);
L = length(Classtype);
N = size(t,1);
XX = X(1:Row_sum,1:(Col_sum-1));

for i = 1:N
    cnt = Classtype*0;
    dist = sum((XX-ones(Row_sum,1)*t(i,:)).^2,2);
    [d,index] = sort(dist);
    for j = 1:k
        ind = find(Classtype==Class(index(j)));
        cnt(ind) = cnt(ind)+1;
    end
    [m,ind]= max(cnt);
    c(i) = Classtype(ind);
end

        
        
        
        
        
        
        