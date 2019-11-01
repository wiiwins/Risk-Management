// C-Exercise 01
// Nattawut Phanrattinon
// Jurian Kahl

// (a) Import data 
data = csvRead('dax_data.csv', ';', '.','double',[],[],[],1);
ts = data(:,2);
// Plot time series data
plot(ts);
title('Daily Closing Prices'); xlabel('number of observation'); ylabel('DAX closing prices');

// (b) Compute daily log returns
x=diff(log(ts));
scf;,clf;
// Plot daily log returns
plot(x);
title('DAX daily Log Returns'); ylabel('log returns');


//  (c)  Plot histogram of the log returns using 30 intervals
scf;clf;
histplot(30,x);
title ('Histogram Of DAX daily Log Returns'); xlabel('log returns');


//  (d) Compute mu and sigma
mu = mean(x);
sigma = sqrt(variance(x));

//  (e) Plot density of a normal distribution using mu & sigma from (d)
x_density = min(x):0.007:max(x)
plot(x_density,1/(sqrt(2*%pi)*sigma)*exp(-((x_density-mu)/sigma)^2/2))

