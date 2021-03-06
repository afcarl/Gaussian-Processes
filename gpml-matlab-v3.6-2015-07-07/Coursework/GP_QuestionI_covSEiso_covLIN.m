load('mauna.mat')
x = trainyear;      y = trainCO2;
x_test = testyear;  y_test = testCO2;

 meanfunc = {@meanSum, {@meanLinear, @meanConst}}; 
 hyp.cov = [1.75; 0.75];
 
 hyp.mean = [1.5; 2];

 hyp.lik = log(0.1);
 
covfunc = {@covSum, {@covSEiso, @covLIN}};
likfunc = @likGauss; 

 hyp = minimize(hyp, @gp, -100, @infExact, meanfunc, covfunc, likfunc, x, y);  
 exp(hyp.lik)  
 
 nlml = gp(hyp, @infExact, meanfunc, covfunc, likfunc, x, y); 
 
 [m s1] = gp(hyp, @infExact, meanfunc, covfunc, likfunc, x, y, x_test);
  
  f = [m+2*sqrt(s1); flipdim(m-2*sqrt(s1),1)];
  fill([x_test; flipdim(x_test,1)], f, [7 7 7]/8)
  figure(1)
  hold on; plot(x_test, m); plot(x, y, '+')
  ylabel('output, y')
  xlabel('input, x')
  title('Predictive Distribution using a Gaussian Process')
  legend('GP with Squared Exponential Covariance Function')
  