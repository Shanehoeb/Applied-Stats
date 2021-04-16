clear;
%Load data set
link = "C:\Users\Shane\Desktop\Year 3\Applied Statistics\coursework_data2.txt";
data = importdata(link);
years = data.data(1,:);
avg_sug_year = data.data(2,:);


% 2)a) plot raw data, fit linear model till 1960 and another from 1960 till
% end then plot models on raw data
data_table = table(transpose(years),transpose(avg_sug_year),'VariableNames',{'year','sug'});

index = find(years == 1960);
data_1960 = data_table(1:index,:);
data_2016 = data_table(index:numel(data_table(:,1)),:);

model_1 = fitlm(data_1960,'sug~year');
model_2 = fitlm(data_2016,'sug~year');

% check model fit:
figure;
plot(years,avg_sug_year,".") %plot raw data
hold on
xx = [1800 1960];
yy = [model_1.Coefficients{1,1}+1800*model_1.Coefficients{2,1} model_1.Coefficients{1,1}+1960*model_1.Coefficients{2,1}];
plot(xx,yy,'k','LineWidth',2)
xxx = [1960 2016];
yyy = [model_2.Coefficients{1,1}+1960*model_2.Coefficients{2,1} model_2.Coefficients{1,1}+2016*model_2.Coefficients{2,1}];
plot(xxx,yyy,'k','LineWidth',2)
xlabel('years') % x-axis label
ylabel('sugar consumption') % y-axis label
hold




%2)b) Interpret results from models

%2)c) 
% - Model checking using residual plots and improve either model, if necessary
% - Explain for each residual plot if it is in line with model assumptions
% - Use model selection techniques to verify that any changes you make are
% an improvement(2 figures)

%Model 1 Residual plots
figure;
subplot(2,2,1)
plotResiduals(model_1)
% plot to check normality
subplot(2,2,2)
plotResiduals(model_1,'probability')
% residuals versus fitted values (check for homoscedasticity)
subplot(2,2,3)
plotResiduals(model_1,'fitted')
% auto-correlation (via lagged residuals)
subplot(2,2,4)
plotResiduals(model_1,'lagged') % want no trend in this!

figure;
%Model 2 Residual plots
subplot(2,2,1)
plotResiduals(model_2)
% plot to check normality
subplot(2,2,2)
plotResiduals(model_2,'probability')
% residuals versus fitted values (check for homoscedasticity)
subplot(2,2,3)
plotResiduals(model_2,'fitted')
% auto-correlation (via lagged residuals)
subplot(2,2,4)
plotResiduals(model_2,'lagged') % want no trend in this!

%2)d) Use model till 1960 to predict when cristillased sugar was first consumed
%model is in form y = ax+b, to find the date at which we predict the
%consumption of cristallised sugar started, we want the value of x for
%which the y value is 0, -b/a.
sug_begin = round(-model_1.Coefficients{1,1}/model_1.Coefficients{2,1});
%the model suggests that the consuption of cristallised sugar in Britain
%started in 1822.

%2)e) Explain why we dont obtain 12th century as a results (which is truth)

%due to consumption of sugar drastically increasing after 1850 --
%industrial revolution?


%3)a) Fit a single Linear Model to the entire data set that captures the same trends as the two
%models in question 2(a)(without improvements) + add TREND variable then
%subtract this to data.

