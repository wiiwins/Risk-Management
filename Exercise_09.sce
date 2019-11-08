// C-Exercise 9
// Jurain Kahl
// Nattawut Phanrattinon

// Part (a)
funcprot(0);

function y=phi(x)
    y = exp(-0.5*x^2)/sqrt(2*pi);
endfunction

function [VaR, ES]=VaR_ES_var_covar(x_data, c, w, alpha)
    mu = mean(x_data, "r");
    sigma = cov(x_data);
    z = cdfnor('X', 0, 1, alpha, 1-alpha);
    // Compute estimate VaR and ES from (2.2) and (2.3)
    VaR = -(c + w'*mu') + sqrt(w'*sigma*w)*z;
    ES = -(c + w'*mu') + sqrt(w'*sigma*w)/(1-alpha)*phi(z);
endfunction

// Part (b)
// import data to scilab
BMW = csvRead('BMW.csv', ';', ',', 'double', [], [], [], 1);
CON = csvRead('Continental.csv', ';', ',', 'double', [], [], [], 1);
SAP = csvRead('SAP.csv', ';', ',', 'double', [], [], [], 1);
SI = csvRead('Siemens.csv', ';', ',', 'double', [], [], [], 1);
VW = csvRead('Volkswagen.csv', ';', ',', 'double', [], [], [], 1);

// s is closing price value of 5 stocks in each column
s = [BMW(:,5),CON(:,5),SAP(:,5),SI(:,5),VW(:,5)];

// reverses the value ordering to make us calculated easiler
s = flipdim(s,1);

//compute logarithm return for each row
x = [zeros(1,5); diff(log(s),1,'r')];
