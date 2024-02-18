clc;clear;close all;

alfa=-1;
beta=1;
h=0.25;
N=9;
x1=alfa:0.01:beta;
x2=x1;
[~,n1]=size(x1);
[~,n2]=size(x2);
e1=beta*ones(1,N+1);
e2=beta*ones(1,N+1);


for j=1:N
    e1(j)=alfa+h*(j-1);
    e2(j)=alfa+h*(j-1);
end
f_x=zeros(n1,n2);
for k1=1:n1
    for k2=1:n2
 
       i1=min(find(e1<=x1(1,k1),1,'last'),find(e1>=x1(1,k1),1));
       i2=min(find(e2<=x2(1,k2),1,'last'),find(e2>=x2(1,k2),1));
       
       if x1(1,k1)>=e1(1,i1)&& x1(1,k1)<=.5*(e1(1,i1)+e1(1,1+i1))&& x2(1,k2)>=e2(1,i2)&& x2(1,k2)<=.5*(e2(1,i2)+e2(1,1+i2))
           p=0;
           q=0;
       elseif x1(1,k1)>=e1(1,i1)&& x1(1,k1)<=.5*(e1(1,i1)+e1(1,1+i1))&& x2(1,k2)>=0.5*(e2(1,i2)+e2(1,1+i2))&& x2(1,k2)<=e2(1,1+i2)
           p=0;
           q=1; 
       elseif x1(1,k1)>=.5*(e1(1,i1)+e1(1,1+i1))&& x1(1,k1)<=e1(1,1+i1)&& x2(1,k2)>=e2(1,i2)&& x2(1,k2)<=0.5*(e2(1,i2)+e2(1,1+i2))
           p=1;
           q=0; 
       elseif x1(1,k1)>=.5*(e1(1,i1)+e1(1,1+i1))&& x1(1,k1)<=e1(1,1+i1)&& x2(1,k2)>=0.5*(e2(1,i2)+e2(1,1+i2))&& x2(1,k2)<=e2(1,1+i2)
           p=1;
           q=1; 
       end
 
       f_x(k1,k2)=1/(3+e1(1,i1+p)+e2(1,i2+q));
    end
end
[x1,x2]=meshgrid(x1,x2);
figure1 = figure('Color',[1 1 1]);
mesh(x1,x2,transpose(f_x));
xlabel('x1');
ylabel('x2');
zlabel('f(x)');