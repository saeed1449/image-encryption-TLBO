function bb=imagepermut(imencrypt,r,u0)
    u(1)=u0;
for n=1:256*257
    u(n+1)=u(n)*r*(1-u(n));
    M(n)=floor(mod((u(n+1)*10^5),65536));
    if M(n)==0
        M(n)=1;
    end
end
aa=(reshape(imencrypt(:,:),[],1))';
for j=numel(aa):-1:1
aa([M(j),j])=aa([j,M(j)]);
end
 bb(:,:)=reshape(aa,[],256);