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
results = zeros(3,1);

for k =1:numel(n)
    sigma = std(data(1:n(k)))/(n(k)^0.5);
    observation = mean(data(1:n(k)));
    tstat = (observation - mu)/ sigma;
    r = n(k)-1;
    results(k) = 1-tcdf(tstat,r);
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

%1)c) 
%bootstrap procedure to estimate probability that scientists will find
%a significant p-value for first 30 points
boot_len = 30;
% observed sample
S = 1000;
bootstrap_ests = zeros(1, S);

for i = 1 : S
 % bootstrap distribution
 x = datasample(data(1:boot_len), boot_len); % this is sampled with replacement from the original data
 sigma = std(x)/(numel(x)^0.5);
 observation = mean(x);
 tstat = (observation - mu)/ sigma;
 r = numel(x)-1;
 bootstrap_ests(i)= 1-tcdf(tstat,r); %p-value estimates
end
%Fit to normal distribution
pdf = fitdist(transpose(bootstrap_ests),'Normal');

%Estimate probability that p <0.05 from bootstrap distribution means
prob_estimate1 = normcdf(alpha,pdf.mu,pdf.sigma);


% 1)d) 
%bootstrap procedure to estimate probability that scientists will find
%a significant p-value starting at 20th data point to 50th, and then adding
%a datapoint till the data runs out or a significant p-value is found
start_point = 20;
new_data = data(start_point:numel(data));
bootstrap_ests = zeros(1, S);
alpha = 0.05;

for i = 1 : S
    pvalue = 10;
    counter = 30;
    while pvalue > alpha
        if counter>numel(new_data)
            break
        else
            x = datasample(new_data(1:counter), counter); % this is sampled with replacement from the original data
            sigma = std(x)/(numel(x)^0.5);
            observation = mean(x);
            tstat = (observation - mu)/ sigma;
            r = numel(x)-1;
            pvalue = 1-tcdf(tstat,r);
            counter = counter + 1;
        end 
    bootstrap_ests(i)= pvalue;
    end
end
%Fit to normal distribution
pdf2 = fitdist(transpose(bootstrap_ests),'Normal');

%Estimate probability that p <0.05 from bootstrap distribution means
prob_estimate2 = normcdf(alpha,pdf2.mu,pdf2.sigma);


%bootstrap procedure to estimate probability that scientists will find
%a significant p-value starting at 10th data point to 40th, and then adding
%a datapoint till the data runs out or a significant p-value is found
start_point = 10;
new_data = data(start_point:numel(data));
bootstrap_ests = zeros(1, S);
alpha = 0.05;

for i = 1 : S
    pvalue = 10;
    counter = 30;
    while pvalue > alpha
        if counter>numel(new_data)
            break
        else
            x = datasample(new_data(1:counter), counter); % this is sampled with replacement from the original data
            sigma = std(x)/(numel(x)^0.5);
            observation = mean(x);
            tstat = (observation - mu)/ sigma;
            r = numel(x)-1;
            pvalue = 1-tcdf(tstat,r);
            counter = counter + 1;
        end 
    bootstrap_ests(i)= pvalue;
    end
end

%Fit to normal distribution
pdf3 = fitdist(transpose(bootstrap_ests),'Normal');

%Estimate probability that p <0.05 from bootstrap distribution means
prob_estimate3 = normcdf(alpha,pdf3.mu,pdf3.sigma);


%1)e) Statistical malpractices
% - points 20-30 of the dataset are significantly higher than the rest
% - 10 and 30 points are considered to be a small samples and therefore lack
%   accuracy
% - had originally planned to collect 100, follow protocol !



%1)f) Fitting Gamma Distribution via MLE
params = gamfit(data); %fit for parameters
range = -1:0.1:5;
a = params(1);
b = params(2);
y_gam = gampdf(range,a,b); %generate points

figure;
set(gcf, 'Position',  [100, 100, 600, 500])
hist = histogram(data,'FaceColor', [0.9100 0.4100 0.1700], 'BinEdges', (0.0:0.2:6.0),'normalization', 'pdf'); 
hold on 
%plot actual data
plot(range,y_gam,'-','LineWidth',3,'Color','b') %plot distribution points
hold on 
gamma_mean = gamstat(a,b);
line([gamma_mean,gamma_mean],[0,0.7],'Color','black','LineWidth',2,'LineStyle','--')

title('Gamma Distribution Fit to Response Time Data')
xlabel('Response Time (s)')
ylabel('Frequency')
legend({'Empirical Data','Gamma Distribution','Gamma Mean'})

%The gamma distribution seems to be a good fit qualitavely as it starts
%increasing after 0, which is representative of the dataset. This solves
%the problem of obtaining probabilities for infeasible values. Furthermore,
%the peak of the distribution is aligned with the highest frequency bins of
%the empirical data.

%The mean of the data is 1.4605s, which is lower than 1.5s and contradicts
%the scientists' hypothesis once again.














