// C-Exercise 7
// Jurain Kahl
// Nattawut Phanrattinon

function test_binomial(v,p0,beta)
  [p,q]=cdfbin('PQ',sum(v),length(v),p0,1-p0);
  if p<=beta
    return 1;
  else 
    return 0;
end


//  From C-Exercise 5
function v = VaR_log_normal (s, alpha)
    x = diff(log(s))
    mu = mean(x);
    sigma = sqrt(variance(x));
    q = cdfnor("X", 0, 1, alpha, 1-alpha);
    v =  s .* ( 1 - exp(-sigma*q + mu) );
endfunction

data = csvRead('dax_data.csv', ';', '.','double',[],[],[],1);
s = data(:,2);

alpha = [0.9,0.95];

n = length(s);

violations = zeros(length(alpha),n);
VaR = zeros(length(alpha),n);

loss = -(diff(s));
L = [0;loss];

for j = 1:length(alpha)
    for i = 253:n;
        VaR(j,i) = VaR_log_normal(s(i-252:i-1), alpha(j));
        violations(j,i) = (L(i) > VaR(j,i));
    end
end


// Testing Hypothesis
beta = 0.05
for i = 1:length(alpha)
  test_binomial(violations(i,:),1-alpha(i),beta)
end


