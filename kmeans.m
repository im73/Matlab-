function [ label ctpt] = kmeans(X,k )
%KMEANS++ Summary of this function goes here
%   Detailed explanation goes here

n=size(X,1);
label=zeros(n,1);
nods=[];
nod_num=1;
next_nod=round(rand(1,1)*n);
diatance_set=zeros(n,1);
color_set=['bo';'go';'ro';'co';'ko';'yo'];
if next_nod==0
    next_nod=1;
end
nods=[nods;X(next_nod,:)];
while nod_num <k
    nod_num=nod_num+1;
    for i=1:n
        [dis index]=min(sum((nods-X(i,:)).^2,2));
        distance_set(i)=dis;
        label(i)=index;
    end
  
    rand_dis=rand(1,1)*sum(distance_set);
  
    for j=1:n
        rand_dis=rand_dis-distance_set(j);
        if rand_dis<0
            next_nod=j;
            break;
        end
    end
    nods=[nods;X(next_nod,:)];
end

new_nods=[];
while 1
    
    for i=1:n
        [dis,index]=min(sum((nods-X(i,:)).^2,2));
        label(i)=index;
    end
    
    for i=1:k
        new_nods=[new_nods;sum(X(label==i,:),1)/sum(label==i)];
    end
    
    if sum(sum((new_nods-nods).^2))==0
        break;
    end
    plot(nods(:,1), nods(:,2), color_set(k,:),'MarkerSize',15);
    plot(new_nods(:,1), new_nods(:,2), color_set(k,:),'MarkerSize',15);
    for po=1:k
        plot([nods(po,1) new_nods(po,1)], [nods(po,2) new_nods(po,2)],'-');
    end
    hold on;
    nods=new_nods;   
    new_nods=[];
end
ctpt=nods
end

