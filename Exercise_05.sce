// C-Exercise05
// Jurian Kahl
// Nattawut Phanrattinon

// (a) 
function v = VaR_log_normal (s, alpha)
    x = diff(log(s))
    mu = mean(x);
    sigma = sqrt(variance(x));
    q = cdfnor("X", 0, 1, alpha, 1-alpha);
    v =  s .* ( 1 - exp(-sigma*q + mu) );
endfunction

// (b)
// import data
data = csvRead('dax_data.csv', ';', '.','double',[],[],[],1);
s = data(:,2);

alpha = [0.9,0.95];

n = length(s);

// create vector memory
violations = zeros(length(alpha),n);
VaR = zeros(length(alpha),n);

loss = -(diff(s));
L = [0;loss];



// calculate violations
for j = 1:length(alpha)
    for i = 253:n;
        VaR(j,i) = VaR_log_normal(s(i-252:i-1), alpha(j));
        violations(j,i) = (L(i) > VaR(j,i));
    end
end

// Plot loss and VaR
plot(L(1:n), '.');    
plot(VaR(1,(1:n)),'r');
plot(VaR(2,(1:n)),'g');
legend(["loss";'VaR 90%';'VaR 95%']);
title('Loss and Value at Risk');
xlabel('Trading day');

disp("For alpha 90% the expected number of violations is "+ string((1-alpha(1))*(n-252))+" Observe violations =" +string( sum(violations(1,:))));

disp("For alpha 95% the expected number of violations is "+ string((1-alpha(2))*(n-252))+" Observe violations =" +string( sum(violations(2,:))));
