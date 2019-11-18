// C-Exercise13
// Jurian Kahl
// Nattawut Phanrattinon

funcprot(0);

function [VaR, ES] = VaR_ES_historic (x_data, l, alpha)
    l_data_sorted = gsort (l(x_data), "g","d");
    n = length(l_data_sorted);
    VaR = l_data_sorted( floor(n*(1-alpha)) +1 );
    ES = 1 / (floor(n*(1-alpha)) +1) * sum(l_data_sorted(1:floor(n*(1-alpha)) +1));
endfunction

// From C-Exercise05
function v = VaR_log_normal (s, alpha)
    x = diff(log(s));
    mu = mean(x);
    sigma = sqrt(variance(x));
    q = cdfnor("X", 0, 1, alpha, 1-alpha);
    v =  s($) * ( 1 - exp(-sigma*q + mu) );
endfunction

// read data
data = csvRead('dax_data.csv', ';', '.','double',[],[],[],1);
s = data(:,2);

// compute log returns
x = [0; diff(log(s))];


alpha = [0.9,0.95];

VaR_historic = zeros(length(alpha),length(s));
ES_historic = zeros(length(alpha),length(s));
VaR_lognorm = zeros(length(alpha),length(s));

td = 248;


for j = 1:length(alpha)
    for m = (td+1) :(length(s)-1)
    
    // define loss operator 
    function y=l(x)
        y= s(m) * (1-exp(x))
    endfunction
    
    //compute VaR and ES with historical simulation 
    [VaR_historic(j,m+1), ES_historic(j,m+1)] = VaR_ES_historic (x(m-td+1:m), l, alpha(j));
    
    
     // compute VaR  log normal method
    VaR_lognorm(j,m+1) = VaR_log_normal (s(m-td:m), alpha(j));
    
    end
end


scf(0); clf(0);

// plot value at risk and compare with Exercise5
subplot(3,1,1);
plot (VaR_historic(1,td+2:$));
plot (VaR_lognorm(1,td+2:$), 'r');
title ('Value at Risk at 90%');
xlabel('trading day');
legend("Historical Simulation", "log_normal Method");

subplot(3,1,2);
plot (VaR_historic(2,td+2:$),'black');
plot (VaR_lognorm(2,td+2:$), 'r');
title ('Value at Risk at 95%');
xlabel('trading day');
legend("Historical Simulation", "log_normal Method");

// plot expected shortfall
subplot(3,1,3);
plot (ES_historic(1,td+2:$));
plot (ES_historic(2,td+2:$), 'g');
title ('Expected Shortfall');
xlabel('trading day');
legend("ES_Historical 90%", "ES_Historical 95%");

