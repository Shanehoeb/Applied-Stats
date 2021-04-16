% Applied Statistics Coursework
clear;

%Load data set
link = "C:\Users\Shane\Desktop\Year 3\Applied Statistics\coursework_data1.txt";
data = readtable(link);
data = data{:,:};

% 1)a) The two statistical tests and 1)b) statistical test for 100 points
q0 = 1.5;
mu = q0;
alpha = 0.05; % significance level
n = [10 30 100]; %number of data points for each of the tests
for k =1:numel(n)
    sigma = std(data(1:n(k)))/(n(k)^0.5);
    observation = mean(data(1:n(k)));
    tstat = (observation - mu)/ sigma;
    r = n(k)-1;
    Dm = data(1:n(k)) - q0;
    pval =1- tcdf(tstat, r);
    [h, p, ci, stats]  =ttest(Dm, mu, 'alpha', alpha, 'tail', 'right');
    critical_value = norminv(1-alpha, mu, sigma);
    disp(observation - critical_value); %if value > 0, mean higher than 1.5 else cannot prove
end


%1)c) bootstrap procedure
boot_len = 30;
% observed sample
true_m = mu;
n = boot_len;

S = 1000;
estimates = zeros(1, S);
bootstrap_ests = zeros(1, S);

for i = 1 : S
 % bootstrap distribution
 x = datasample(data(1:n), n); % this is sampled with replacement from the original data
 bootstrap_ests(i) = mean(x);
end

% compute the boot-CI
bCI = quantile(bootstrap_ests, [alpha/2 1-alpha/2]);
boot_mean = mean(bootstrap_ests);
boot_p = normpdf(bCI(2), boot_mean, sigma);



% 1)d) Must clarify question before starting
start_point = 20;
p_value = 1;
%


%1)e) Statistical malpractices

%1)f) Fitting Gamma Distribution via ML !!! TBC
params = gamfit(data);
range = -1:0.1:5;
a = params(1);
b = params(2);
y_norm = normpdf(range,a*b,sqrt(a*b^2));

y_gam = gampdf(range,a,b);

plot(range,y_gam,'-',range,y_norm,'-')

















