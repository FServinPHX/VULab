       
function [significance_matrix] = t_test_between_data_sets(x,x_sd,y,y_sd,num_subjects)
significance_matrix=[];
for i = 1:length(x)
    Amean =x(i); 
    Asd=x_sd(i);    
    for j = 1:length(y)
        
        Bmean=y(j); 
        Bsd=y_sd(j);
        N = num_subjects;
        v = 2*N-2;
        tval = (Amean-Bmean) / sqrt((Asd^2+Bsd^2)/N);       % Calculate Paried T-Statistic
        tdist2T = @(t,v) (1-betainc(v/(v+t^2),v/2,0.5));    % 2-tailed t-distribution
        tdist1T = @(t,v) 1-(1-tdist2T(t,v))/2;              % 1-tailed t-distribution
        tprob = 1-[tdist2T(tval,v)  tdist1T(tval,v)];
        significance_matrix = [significance_matrix; Amean, Asd...
            Bmean, Bsd, tprob]; 
        %all_probs = [all_probs];
    end 
end 