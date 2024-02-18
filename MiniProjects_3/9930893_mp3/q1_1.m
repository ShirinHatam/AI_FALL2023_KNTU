clc; clear; close all;

alfa = -1;
beta= 1;
x1=alfa:0.01:beta;
x2=alfa:0.01:beta;

N=51;
h=0.04;

g_bar=zeros(N+N,1);
e_il=zeros(N,1);
e_i2=zeros(N,1);

[x1,x2]=meshgrid(x1,x2);

num=0;
den=0;
k=0;

for i1=1:N
    for i2=1:N
    e_i1(i1,1) = -1 + h*(i1-1);
    e_i2(i2,1) = -1 + h*(i2-1);
        if i1==1
            mu_A_x1 = trimf(x1, [-1,-1,-1+h]);
        elseif i1==N
            mu_A_x1 = trimf(x1,[1-h, 1, 1]);
        else
            mu_A_x1 = trimf(x1,[-1+h*(i1-2), -1+h*(i1-1), -1+h*(i1)]);
        end

        if i2==1
            mu_A_x2 = trimf(x2, [-1,-1,-1+h]);
        elseif i2==N
            mu_A_x2 = trimf(x2,[1-h, 1, 1]);
        else
            mu_A_x2 = trimf(x2,[-1+h*(i2-2), -1+h*(i2-1), -1+h*(i2)]);
        end


       g_bar(k+1,1) = 1./(3+e_i1(i1,1)+e_i2(i2,1));
       num = num + g_bar(k+1,1).*mu_A_x1.*mu_A_x2;
       den=den+mu_A_x1.*mu_A_x2;
       k=k+1;
    end
end

f_x = num./den;
g_x = 1./(3+x1+x2);


figure1 = figure('Color',[1 1 1]);
mesh(x1,x2,f_x);
xlabel('x1');
ylabel('x2');
zlabel('f(x)');