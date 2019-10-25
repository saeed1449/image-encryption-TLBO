function cost=correlation(popu)
for j=1:1
         for i=1:256
             for k=1:255
                 popu1(i,k,j)=popu(i,k+1,j);
             end
         end
         popu1(:,256,j)=150;
         cost(j)=corr2(popu(:,:,j),popu1(:,:,j));
     end