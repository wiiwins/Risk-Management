// C-Exercise 17
// Jurian Kahl
// Nattawut Phanrattinon

// download distfun package
atomsInstall("distfun");

// Part a)
// Hill estimator function
function alpha = Hill_Estimator(x, k)
    y = gsort(x);
    alpha = k/sum( log(y(1:(k-1))) - log(y(k)));
endfunction

// Part b)
// Hill plot function
function Hill_Plot(x)
    y = x(x>0);
    n = length(y);
    for k = 2:n
        a(k-1) = Hill_Estimator(y, k);
    end
    plot(2:n, a');
endfunction


// part(c)
scf(0); clf();
m = 3;
N = 500;
lambda = 1;

subplot(3,1,1);
title ("t-distribution with df = 3");
xlabel("k"); ylabel("Hill estimator");
for k=1:m
    Hill_Plot(distfun_trnd(3, N, 1));
end

subplot(3,1,2);
title ("t-distribution with df = 8");
xlabel("k"); ylabel("Hill estimator");
for k=1:m
    Hill_Plot(distfun_trnd(8, N, 1));
end


subplot(3,1,3);
title ("Exponential distribution with lambda = 1");
xlabel("k"); ylabel("Hill estimator");
for k=1:m
    Hill_Plot(grand(N,1,'exp',lambda));
end

// Part d)
// VaR and ES 
function [VaR,ES]=VaR_ES_Hill(x,p,k)
   
  N = length(x);  
  alpha = Hill_Estimator (x,k);  
  y=gsort(x);
  // From section 3.2.3 Equation (3.5)
  VaR=(N/k*(1-p))^(-1/alpha)*y(k);
  // From section 3.2.4
  ES=(1-1/alpha)^(-1)*VaR;
  
endfunction

// Part e)
data = csvRead('risk1920_Exercise_17_data.dat')
scf(1); clf();
Hill_Plot(data);
title("data set");

//choose k = 40 for reasonable choice since it seems to be constant after some initial oscilations from Hill plot above
p = 0.98;
k = 40;
[VaR,ES]=VaR_ES_Hill(data,p,k)


disp ("for k=40 VaR="+string(VaR)+" ES="+string(ES));
