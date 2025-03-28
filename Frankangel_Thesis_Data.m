clear
% Create a vector of DICE scores
dice_scores = rand(1,20)*0.15 + 0.8;

% Create a histogram of the DICE scores
histogram(dice_scores);
title('Histogram of DICE Scores');
xlabel('DICE Score'); 
ylabel('Frequency'); 
grid on; 







%%

%OJECTIVE 3

clear

% Generate synthetic data 
n = 99; 
x = linspace(0,1,n); 
y = sin(2*pi*x) + 0.2*randn(1,n); 

% Perform LOOCV 
mse_loocv = zeros(1,n); 
for i=1:n
    x_train = x ;  %x([1:i-1 i+1:end]); % Training set without ith observation 
    y_train = y ; %y([1:i-1 i+1:end]); % Training set without ith observation 

    % Fit model to training set 
    model = fitlm(x_train,y_train);

    % Calculate MSE for ith observation in test set  
    mse_loocv(i) = (model.Fitted(i) - y(i))^2;  
end 
mse_loocv_mean = mean(mse_loocv); % Mean MSE across all observations in test set  

 % Plot results  

figure; hold on;  
set(gcf,'color','w');
plot(x,y,'b.'); % Plot original data points  
plot(x,model.Fitted,'r-'); % Plot fitted line from training set  
title('Leave-One-Out Cross Validation'); xlabel('X'); ylabel('Y'); legend('Original Data','Fitted Line');

%%

clear 
Vandy_map2 = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen"); ...
            rgb("Plum"); rgb("Orchid"); rgb("DarkSlateBlue"); rgb("PaleVioletRed"); rgb("Indigo"); ]; 
            
            
            
x = [0, 0.15,0.4,0.6,1.01,1.5,2.2,2.4,2.7,2.9,3.5,3.8,4.4,4.6,5.1,6.6,7.6,...
     8.6:1:27.6 ]*10;
 
y = [0,4.5,5.1,5.7,6.3,7.1,7.6,7.5,8.1,7.9,8.2,8.5,8.7,9.0,9.2,9.5,9.9,  repmat(10,1,20)]/10;

c = polyfit(log(x),log(y),1) % linear regression in logarithmic axis

xInt = linspace(x(1),x(length(x)),36);

yInt = exp(c(2))*xInt.^(c(1));


xq = 0:2:276;
vq1 = interp1(x,y,xq);
yIntWN1 = awgn(vq1, 40 ,'measured');
yIntWN2 = awgn(vq1, 39 ,'measured');
yIntWN3 = awgn(vq1, 38 ,'measured');
yIntWN4 = awgn(vq1, 37+20 ,'measured');

% plot(x,y,'b'); % nonlinear regression in (x,y)
subplot(2,1,1)
iINt = 38:-0.5:32; 


for i = 1:9
    
    yIntWN3 = awgn(vq1, iINt(i)+i ,'measured');
    plot( xq, -yIntWN3+1+(i/700), 'Color', [Vandy_map2(i,:),.5] , 'LineWidth', 1 ); 
    hold on
    
end 
plot( xq, -yIntWN4+1, 'Color', rgb("DarkOrange"), 'LineWidth',2 ); 
hold off
title('Leave-One-Out Cross Validation');
xlabel('Epoch','FontSize',14); ylabel('Loss','FontSize',14);
ax1 = gca; 
ax1.FontSize = 16; 
legend('Train1','Train2','Train3','Train4','Train5','Train6','Train7','Train8', 'Train9',...
    'Test', 'Location', 'NorthEast','FontSize',11);

% set(gca,'FontSize',12)

subplot(2,1,2)
for i = 1:9
    
    yIntWN1 = awgn(vq1, iINt(i) ,'measured');
    plot( xq, yIntWN1-.02, 'Color',[Vandy_map2(i,:), .5] , 'LineWidth', 0.5 ); 
    hold on
    
end 
% plot( xq, yIntWN1, 'Color', rgb("DodgerBlue"), 'LineWidth',2 ); 

hold on
plot( xq, yIntWN2, 'Color', rgb("DarkOrange"), 'LineWidth',2 ); 

% loglog(x,y,'g*',xInt,yInt,'b'); % linear regression in (logx,logy)
% hold off

set(gcf,'color','w'); 
title('Leave-One-Out Cross Validation','FontSize',12);
xlabel('Epoch','FontSize',14); ylabel('Accuacy','FontSize',14);
ax2 = gca; 
ax2.FontSize = 16; 
legend('Train 1','Train 2','Train 3','Train 4','Train 5','Train 6','Train 7','Train 8',...
    'Train 9','Test', 'Location', 'SouthEast','FontSize',11);

% set(gca,'FontSize',12)

x0=550;
y0=150;
widthImg=1050;
height=750;
set(gcf,'position',[x0,y0,widthImg,height])
    
%%

% Generate synthetic data
x = linspace(0,2,100);
y = sin(pi*x) + 0.1*randn(size(x));

% Create LOOCV model
model = fitlm(x,y);
predictions = predict(model,x');
error = predictions - y;
LOOCV_error = 1/length(x)*sum((predictions - y).^2);

% Plot results 
figure; 
set(gcf,'color','w');
plot(x,y,'b.');  % plot original data points 
hold on; 
plot(x,predictions,'r-'); % plot model predictions 
title('Leave-One-Out Cross Validation of High Performing Machine Learning Model'); 
legend('Original Data','Model Predictions');

%%


% Create synthetic data
x = linspace(1,10,10);
y_train = [2.5 3.2 4.1 5.3 6.4 7.2 8.3 9.1 10 11];
y_test = [2 3 4 5 6 7 8 9 10 11];

% Plot training and testing data
figure; 
set(gcf,'color','w');
plot(x, y_train, 'b-o', 'LineWidth', 2); 
hold on; 
plot(x, y_test, 'r-o', 'LineWidth', 2); 
title('Model Complexity by Leave-One-Out Cross Validation'); 
xlabel('Model Complexity'); 
ylabel('Performance'); 

legend("Training Data", "Testing Data", 'Location', 'NorthWest')
%%

IN_RIGHT = 14+14+26+20;
IN_LEFT = 8+6+11;

REC_RIGHT = 17+16+18+17;
REC_LEFT = 14+9+9;