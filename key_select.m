function outcome = key_select(imagepart,n,keylong)
a=keylong;
key=zeros(n,a);
% binkey=zeros(n,a,4);

    for j=1:n
%      bin=zeros(a,8);  
     key(j,1:a)=imagepart(j,1:a);
%      bin=dec2bin(key(j,:,i),8);
%      binkey(j,:,i)=[bin(1,:) bin(2,:) bin(3,:) bin(4,:) bin(5,:)];
    end
    outcome=key;