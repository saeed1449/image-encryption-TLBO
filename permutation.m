
function bb=permutation(imagepart,u0,r)
  u(1)=u0;
for n=1:256*256
    u(n+1)=u(n)*r*(1-u(n));
    M(n)=floor(((u(n+1)*5*(10^4))));
    if M(n)==0
         M(n)=1;
    end
end
aa=(reshape(imagepart,[],1))';
for i=numel(aa):-1:1
%j= floor(i*rand(1)+1);
aa([M(i),i])=aa([i,M(i)]);
end
 bb=reshape(aa,[],256);
