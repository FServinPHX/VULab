



heathArr = linspace(1000, 10000, 10); 
for i = 1:10

    maxhealth = heathArr(i); 
    magic = 2000; 
    health = linspace(1, maxhealth, 100);
    %Cure 
    % 300 / 3000 HP: (3000 - 300) * 0.15 + (3000 - 300) * 2000 / 100000 = 459 HP
    
    cure = magic*.2 +100 + (health*0); 
    %Curasa 
    %3000 / 30000 HP: (30000 - 3000) * 0.15 + (30000 - 3000) * 2000 / 100000 = 4,590 HP
    curasa  = (maxhealth - health) *0.15 +  (maxhealth - health)*  (magic / 100000 )  ;
    
    
    percentHealth = (health./ maxhealth) .*100; 
    plot( percentHealth, cure, 'k.')
    hold on
    plot(  percentHealth, curasa, 'g.')
    
    xlabel( "Current Health (%)" )
    ylabel( "Cure Restore"   )
    titleArr = join([ "Total Health =", num2str(maxhealth)  ]);
    title(titleArr)
    
    pause(.5)

end 




%%

% Generate random coefficients for a 4th order polynomial equation
a = randn(); % Coefficient for x^4
b = randn(); % Coefficient for x^3
c = randn(); % Coefficient for x^2
d = randn(); % Coefficient for x
e = randn(); % Constant term

% Define the x range
x = linspace(-10, 10, 1000); % 1000 points from -10 to 10

% Calculate the y values using the polynomial equation
y = a*x.^4 + b*x.^3 + c*x.^2 + d*x + e;

% Plot the polynomial curve
figure;
plot(x, y);
title('Random 4th Order Polynomial');
xlabel('x');
ylabel('y');
grid on;
    


