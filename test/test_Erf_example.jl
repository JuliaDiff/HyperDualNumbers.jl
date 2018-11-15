#using SpecialFunctions

function blsprice(S0,K,r,T,sigma)
  #Black & Scholes Price for European Options
  d1=(log(S0/K)+(r+sigma*sigma*0.5)*T)/(sigma*sqrt(T));
  d2=d1-sigma*sqrt(T);
  Out=S0*normcdf(d1)-K*exp(-r*T)*normcdf(d2);
return Out;
end

function normcdf(x)
  return (1.0+erf(x/sqrt(2.0)))/2.0;
end

function normpdf(x)
  return exp(-0.5*x.^2)/sqrt(2*pi);
end

function blsdelta(S0,K,r,T,sigma)
  #Black & Scholes Delta for European Options
  d1=(log(S0/K)+(r+sigma*sigma*0.5)*T)/(sigma*sqrt(T));
  Out=normcdf(d1);
return Out;
end

function blsgamma(S0,K,r,T,sigma)
  #Black & Scholes Gamma for European Options
  d1=(log(S0/K)+(r+sigma*sigma*0.5)*T)/(sigma*sqrt(T));
  Out=normpdf(d1)/(S0*sigma*sqrt(T));
return Out;
end

# BlackScholes Formula Test Example
S0 = Hyper(100.0, 1.0, 1.0, 0)
K=80.0;T=2.0;r=0.01;sigma=0.2;
Price=blsprice(S0,K,r,T,sigma);
@test (abs(realpart(Price)-blsprice(realpart(S0),K,r,T,sigma))<1e-15)
@test (abs(eps1(Price)-blsdelta(realpart(S0),K,r,T,sigma))<1e-15)
@test (abs(eps1eps2(Price)-blsgamma(realpart(S0),K,r,T,sigma))<1e-15)
println("$(realpart(Price))   = $( blsprice(realpart(S0),K,r,T,sigma))")
println("$(eps1(Price))   = $( blsdelta(realpart(S0),K,r,T,sigma))")
println("$(eps1eps2(Price))   = $( blsgamma(realpart(S0),K,r,T,sigma))")
println("Test Erf Passed")