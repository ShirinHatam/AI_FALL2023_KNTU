clc;
clear;
close all;
%% Initializing
M=4; %Number of membership functions 
num_train = 100; % Number of training data points
total_data_points = 500;
learning_rate = 0.01; % A constant stepsize
 
% Preallocation
x_bar=zeros (num_train, M);
g_bar=zeros (num_train, M);
sigma=zeros (num_train, M); 
y=zeros(total_data_points, 1);
u=zeros(total_data_points, 1);
x=zeros(total_data_points, 1);
y_hat=zeros(total_data_points, 1);
f_hat=zeros(total_data_points, 1);
z=zeros(total_data_points, 1);
g_u=zeros(total_data_points, 1);
error = zeros(total_data_points, 1);

rng(53); % Set the random seed
u(1)=-1+2*rand;
y(1)=0;
g_u(1)=0.6*sin(pi*u(1))+0.3*sin(3*pi*u(1))+0.1*sin(5*pi*u(1));
f_hat(1)=g_u(1);
 
 
%% Based on the 1st step of fuzzy system design
u_min=-1;
u_max=1;
h=(u_max-u_min)/(M-1);
for k=1:M
    x_bar(1, k)=-1+h*(k-1);
    u(1,k) =x_bar(1, k);
    g_bar(1,k)=0.6*sin(pi*u(1,k))+0.3*sin(3*pi*u(1,k))+0.1*sin(5*pi*u(1,k));
end
 
sigma(1,1:M) = (max(u(1,:))-min(u(1,:)))/M;
 
x_bar(2,:)=x_bar(1, :);
g_bar(2,:)=g_bar(1, :);
sigma(2, :)=sigma(1,:);
x_bar_initial=x_bar(1, :);
sigma_initial=sigma(1, :);
y_bar_initial=g_bar(1,:);
 
%% %% Fuzzy System Training
for q=2:num_train
    b=0;
    a=0;
    x(q)=-1+2*rand;
    u(q)=x(q);
    g_u(q)=0.6*sin(pi*u(q))+0.3*sin(3*pi*u(q))+0.1*sin(5*pi*u(q));
    
    % Calculate output of the identified model
    for l=1:M
        z(l)=exp(-((x(q)-x_bar(q,l))/sigma(q, l))^2);
        b=b+z(l);
        a=a+g_bar(q, l)*z(l);
    end
 
    f_hat(q) = a/b;
    % Update identified model output
    y(q+1) = 0.3*y(q)+0.6*y(q-1)+g_u(q);
    % Update identified model output
    y_hat(q+1) = 0.3*y(q)+0.6*y(q-1)+f_hat(q);
 
    % Update fuzzy sets parameters using recursive least squares
    for l=1:M
        g_bar(q+1,l)=g_bar(q,l)-learning_rate*(f_hat(q)-g_u(q))*z(l)/b;
        x_bar(q+1,l)=x_bar(q,l)-learning_rate*((f_hat(q)-g_u(q))/b)*(g_bar(q,l)-f_hat(q))*z(l)*2*(x(q)-x_bar(q,l))/(sigma(q,l)^2);
        sigma (q+1,l)=sigma(q, l)-learning_rate*((f_hat(q)-g_u(q))/b)*(g_bar(q,l)-f_hat(q))*z(l)*2*(x(l)-x_bar(q,l))^2/(sigma(q,l)^3);
    end
    % Calculate error for visualization
    error(q) = g_u(q) - f_hat(q);
end
 
x_bar_final=x_bar(num_train,:);
sigma_final=sigma(num_train,:);
g_bar_final=g_bar(num_train,:);

%% Test the Identified Model

for q=num_train:total_data_points
    b=0;
    a=0;
    x(q)=sin(2*q*pi/200);
    u(q)=x(q);
 
    g_u(q)=0.6*sin(pi*u(q))+0.3*sin(3*pi*u(q))+0.1*sin(5*pi*u(q));
    
    % Calculate output of the identified model
    for l=1: M
        z(l) = exp(-((x(q)-x_bar(num_train,l))/sigma(num_train, l))^2);
        b = b+z(l);
        a = a+g_bar(num_train, l)*z(l);
    end
     f_hat(q) = a/b;
     y(q+1) = 0.3*y(q)+0.6*y(q-1)+g_u(q);
     y_hat(q+1) = 0.3*y(q)+0.6*y(q-1)+f_hat(q);
     % Calculate error for visualization
     error(q) = g_u(q) - f_hat(q);
end
 
%% Plots and Figures
figure1=figure('Color', [1 1 1]);
subplot(2, 1, 1);
plot(1:total_data_points+1, y, 'b', 1:total_data_points+1, y_hat, 'r:', 'Linewidth', 2); 
legend('Desired Output', 'Identified Model Output');
title('Plant Output vs. Identified Model Output');
xlabel('Data Points');
ylabel('Output');
axis([0 701 -5 5]);
grid on
 
subplot(2, 1, 2);
plot(1:total_data_points, error, 'k', 'LineWidth', 2);
title('Error between Desired and Identified Model Output');
xlabel('Data Points');
ylabel('Error');

figure2=figure('Color', [1 1 1]);
subplot(2, 1, 1);
xp=-2:0.001:2;
for l=1:M
    miu_x=exp(-((xp-x_bar(1, l))./(sigma (1,l))).^2);
    plot(xp, miu_x, 'Linewidth', 2);
    hold on
end
title('Initial Membership Functions');
xlabel('Input');
ylabel('Membership Value');
legend('MF 1', 'MF 2', 'MF 3', 'MF 4');
axis([-1 1 0 1]);
 
subplot(2, 1, 2);
for l=1:M
    miu_x=exp(-((xp-x_bar(num_train, l))./ (sigma (num_train, l))).^2);
    plot (xp, miu_x, 'Linewidth', 2);
    hold on
end
 
title('Final Membership Functions');
xlabel('Input');
ylabel('Membership Value');
legend('MF 1', 'MF 2', 'MF 3', 'MF 4');
axis ([-1 1 0 1]);
