// C-Exercise 18
// Jurian Kahl
// Nattawut Phanrattinon

funcprot(0);

function X = GARCH11(k, m, theta, sigma1)
    //simulation for X 
    X = zeros(m,k);
    var = zeros(m,k);
    
    // starting sigma
    var(:,1) = sigma1^2
    
    // simulation Y from N~(0,1)
    Y = grand(m,k,"nor",0,1);
    // Given starting point 
    X(:,1) = sigma1*Y(:,1)
    
    // Calculate X from GARCH(1,1) model
    for i=2:k
        var(:,i) = theta(1) + theta(2)*X(:,i-1).^2+theta(3)*var(:,i-1)
        X(:,i) = sqrt(var(:,i)).*Y(:,1);
    end
endfunction

function[VaR, ES] = VaR_ES_GARCH_11_MC(k, m, l, alpha, theta, sigma1)
    
    //Refer our path from GARCH function above 
    X = GARCH11(k, m, theta, sigma1);

    // Loss 
    Loss = ones(m);
    for j = 1:m
        Loss(j) = l(X(j,:));
    end

    //Value at Risk and Expected Shortfall
    l_data_sorted = gsort (Loss, "g", "d");
    VaR = l_data_sorted( floor(m*(1-alpha)) +1 );
    ES = 1 / (floor(m*(1-alpha)) +1) * sum(l_data_sorted(1:floor(m*(1-alpha)) +1));
endfunction


// load data
data = csvRead('dax_data.csv', ';', '.','double',[],[],[],1);
s = data(:,2);

// compute log returns
x = diff(log(s));

// level Value at Risk
alpha = 0.975;

//number of simulations 
m = 200;

// 10-day-ahead period
k = 10;


// loss operator
function y=l(x)
    y=s($)*(1-exp(sum(x)));
endfunction

// parameters for GARCH(1,1)
theta = [3.2*10^(-6), 0.08426, 0.8986];
sigma1 = 0.0195;

// compute VaR and ES
[VaR, ES] = VaR_ES_GARCH_11_MC (k,m,l,alpha,theta, sigma1);

// results
disp(string(k) + "-day-ahead estimates:")
disp("VaR: " + string(VaR) + "      ES: " + string(ES))
