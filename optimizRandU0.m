%Iteration 100: Best Cost = 4.2058e-07best position = 3.9135     0.72219
%Iteration 100: Best Cost = 7.9965best position = 3.7951     0.42366
clc;
clear;
close all;
format long
% Cost Function
costfunction = @(x) corr_harizental(uint8(x));

I=imread('lena.jpg');%% image reading
I=rgb2gray(I);
I=imresize(I,0.5);
%I=double(I);
[a,b]=size(I);
npop=50;
MaxIt=100;
% Empty Structure for Individuals
empty_individual.position = [];
empty_individual.cost = [];
VarMinR=3.57;
VarMaxR=4;
VarMinU=0;
VarMaxU=1;
VarSize=[1,2];
%%
%key=key_select(I,npop,5);
%u0=primary_chaos(key,npop);
%% Generation initial population
pop = repmat(empty_individual, npop, 1);
BestSol.cost=inf;
tic
for i=1:npop
    pop(i).position(1)=unifrnd(VarMinR,VarMaxR);
    pop(i).position(2)=unifrnd(VarMinU,VarMaxU);
    imencrypt=imageEncrypt(I,pop(i).position(2),pop(i).position(1));
    %%
%     bb=permutation(imencrypt,pop(i).position(2),pop(i).position(1));
    u(1)=pop(i).position(2);
for n=1:256*256
    u(n+1)=u(n)*pop(i).position(1)*(1-u(n));
    M(n)=floor(mod((u(n+1)*10^5),65536));
    if M(n)==0
        M(n)=1;
    end
end
aa=(reshape(imencrypt(:,:),[],1))';
for j=numel(aa):-1:1
%j= floor(i*rand(1)+1);
aa([M(j),j])=aa([j,M(j)]);
end
 bb(:,:)=reshape(aa,[],256);
 %%
    pop(i).cost=costfunction(bb);
    if abs(pop(i).cost) < abs(BestSol.cost)
        BestSol = pop(i);
    end
end
%% TLBO Main Loop

for it=1:MaxIt
    Mean=0;
    for i=1:npop
        Mean = Mean + pop(i).position;
    end
    Mean = Mean/npop;
    % Select Teacher
    Teacher = pop(1);
    for i=2:npop
        if abs(pop(i).cost) < abs(Teacher.cost)
            Teacher = pop(i);
        end
    end
     % Teacher Phase
    for i=1:npop
        % Create Empty Solution
        newsol = empty_individual;
         % Teaching Factor
        TF = randi([1 2]);
        % Teaching (moving towards teacher)
        newsol.position = pop(i).position ...
            + rand(VarSize).*(Teacher.position - TF*Mean);
       % Clipping
        newsol.position(1) = max(newsol.position(1), VarMinR);
        newsol.position(1) = min(newsol.position(1), VarMaxR);
        newsol.position(2) = max(newsol.position(2), VarMinU);
        newsol.position(2) = min(newsol.position(2), VarMaxU);
        % Evaluation
        newencrypt= imageEncrypt(I,newsol.position(2),newsol.position(1));
        %%
%         bb=permutation(newencrypt,pop(i).position(2),pop(i).position(1));
      u(1)=newsol.position(2);
for n=1:256*256
    u(n+1)=u(n)*newsol.position(1)*(1-u(n));
    M(n)=floor(mod((u(n+1)*10^5),65536));
    if M(n)==0
        M(n)=1;
    end
end
aa=(reshape(newencrypt(:,:),[],1))';
for j=numel(aa):-1:1
%j= floor(i*rand(1)+1);
aa([M(j),j])=aa([j,M(j)]);
end
 bb(:,:)=reshape(aa,[],256);
 %%
        newsol.cost = costfunction(bb);
         % Comparision
        if abs(newsol.cost)<abs(pop(i).cost)
            pop(i) = newsol;
            if abs(pop(i).cost) < abs(BestSol.cost)
                BestSol = pop(i);
            end
        end
    end

    
    % Learner Phase
    for i=1:npop
         A = 1:npop;
        A(i)=[];
        j = A(randi(npop-1));
        Step = pop(i).position - pop(j).position;
        if abs(pop(j).cost) < abs(pop(i).cost)
            Step = -Step;
        end
         % Create Empty Solution
        newsol = empty_individual;
        
        % Teaching (moving towards teacher)
        newsol.position = pop(i).position + rand(VarSize).*Step;
         % Clipping
        newsol.position(1) = max(newsol.position(1), VarMinR);
        newsol.position(1) = min(newsol.position(1), VarMaxR);
        newsol.position(2) = max(newsol.position(2), VarMinU);
        newsol.position(2) = min(newsol.position(2), VarMaxU);
        
        % Evaluation
        newencrypt= imageEncrypt(I,newsol.position(2),newsol.position(1));
        %%
%         bb=permutation(newencrypt,pop(i).position(2),pop(i).position(1));   
      u(1)=newsol.position(2);
for n=1:256*256
    u(n+1)=u(n)*newsol.position(1)*(1-u(n));
    M(n)=floor(mod((u(n+1)*10^5),65536));
    if M(n)==0
        M(n)=1;
    end
end
aa=(reshape(newencrypt(:,:),[],1))';
for j=numel(aa):-1:1
%j= floor(i*rand(1)+1);
aa([M(j),j])=aa([j,M(j)]);
end
 bb(:,:)=reshape(aa,[],256);
 %%
        newsol.cost = costfunction(bb);
         % Comparision
        if abs(newsol.cost)<abs(pop(i).cost)
            pop(i) = newsol;
            if abs(pop(i).cost) < abs(BestSol.cost)
                BestSol = pop(i);
            end
        end
    end
    % Store Record for Current Iteration
    BestCosts(it) = BestSol.cost;
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it)) 'best position = ' num2str(BestSol.position)]);
end
toc
semilogy(abs(BestCosts),'--k');
%imshow(uint8(bb))
save('datasave.mat','BestSol')
%key=key_maker(BestSol.position);
% key1=f_d2b(BestSol.position(1));
% key2=f_d2b(BestSol.position(2));
% keymat=zeros(1,65);
% for i=1:numel(key1)
%     keymat1(i)=key1(i);
% end
    
