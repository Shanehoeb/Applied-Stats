% Applied Statistics Coursework
clear;

%Load data set
link = "C:\Users\Shane\Desktop\Year 3\Applied Statistics\coursework_data1.txt";
data = readtable(link);
data = data{:,:};

% 1)a) The two statistical tests and 1)b) statistical test for 100 points
%Perform t-test for 10,30 and 100(b) first data points as variance is unknown
%null hypothesis : mean is no higher than q0 = 1.5s
q0 = 1.5;
mu = q0;
alpha = 0.05; % significance level
n = [10 30 100]; %number of data points for each of the tests
for k =1:numel(n)
    sigma = std(data(1:n(k)))/(n(k)^0.5);
    observation = mean(data(1:n(k)));
    tstat = (observation - mu)/ sigma;
    r = n(k)-1;
    p_value = 1-tcdf(tstat,r);
    %disp(p_value); %if value > 0, mean higher than 1.5 else cannot prove
end
%Results : 
% 10 data points : p-value of 0.1265 > 0.05, cannot reject null hypothesis
% 30 data points : p-value of 4.2398e-06 < 0.05, we can reject null
% hypothesis
% The scientists found a significant p-value using the first 30 data
% points, and therefore stopped the expirement as the null hypothesis can
% be rejected.


%1)b)
%Performing a t-test on the hundred data points, we find a p-value of
%0.6701, which is higher than the significance threshold. The null
%hypothesis can therefore not be rejected. Furthermore the mean of this
%data is 1.46s, which is lower than 1.5s. The outcome of this test
%contradicts the scientists' findings and is more precise as it uses more
%data.

%1)c) bootstrap procedure to estimate probability that scientists will find
%a significant p-value for first 30 points
boot_len = 30;
% observed sample
true_m = mu;
S = 1000;
estimates = zeros(1, S);
bootstrap_ests = zeros(1, S);

for i = 1 : S
 % bootstrap distribution
 x = datasample(data(1:boot_len), boot_len); % this is sampled with replacement from the original data
 sigma = std(x)/(numel(x)^0.5);
 observation = mean(x);
 tstat = (observation - mu)/ sigma;
 r = numel(x)-1;
 p_value = 1-tcdf(tstat,r);
 bootstrap_ests(i)= p_value;
end

% compute the boot-CI
boot_mean = mean(bootstrap_ests);
pd = makedist('Normal','mu',boot_mean,'sigma',sigma);
prob_pvalue1 = cdf(pd,alpha);


% 1)d) Must clarify question before starting
start_point = 20;
new_data = data(start_point:numel(data));
% observed sample
true_m = mu;
S = 1000;
estimates = zeros(1, S);
bootstrap_ests = zeros(1, S);
alpha = 0.05;

for i = 1 : S
    p_value = 10;
    counter = 3;
    while p_value > alpha
        if counter>numel(new_data)
            break
        else
            % bootstrap distribution
            x = datasample(new_data(1:counter), counter); % this is sampled with replacement from the original data
            sigma = std(x)/(numel(x)^0.5);
            observation = mean(x);
            tstat = (observation - mu)/ sigma;
            r = numel(x)-1;
            p_value = 1-tcdf(tstat,r);
            counter = counter + 1;
        end 
    bootstrap_ests(i)= p_value;
    end
end

boot_mean = mean(bootstrap_ests);
pd = makedist('Normal','mu',boot_mean,'sigma',sigma);
prob_pvalue2 = cdf(pd,alpha);


%1)e) Statistical malpractices



%1)f) Fitting Gamma Distribution via ML !!! TBC
params = gamfit(data);
range = -1:0.1:5;
y_gam = gampdf(range,a,b);

plot(range,y_gam,'-')
hold on 
hist = histogram(data, 'BinEdges', (0.0:0.2:6.0),'normalization', 'pdf');
















