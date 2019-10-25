function outcome=imageEncrypt(imagepart,u0,r)
 newvalue=zeros(256,256);
    uik=u0;
  for i=1:256
      for j=1:256
              uik=r*uik*(1-uik);
              newvalue(i,j)=bitxor(round(uik*255),(imagepart(i,j)));
      end
  end
 % newvalue = permutation(newvalue,u0,r);
    outcome=newvalue;