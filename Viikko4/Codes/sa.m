function [mu,Y,g,a]=sa(mu0,a0,M,R,mode,delta)
%Stochastic approximation to minimize the response of
%a GI/G/1 queueing model with respect to mean service time mu of customers
%
%INPUT:
%
%mu0        Initial solution
%a0         Initial step size
%M          Maximum number of iterations 
%R          Number of replications per simulation model evaluation 
%mode       Type of gradient estimate       
%           1: finite difference, independent replications
%           2: finite difference, common random numbers
%           3: infinitesimal perturbation 
%delta      Perturbation of decision variable
%
%OUTPUT:
%
%mu         Trajectory of decision variable values
%y          Simulation model responses
%g          Gradient estimates
%a          step sizes

%Queueing model parameters
n=100;      %Number of customers to simulate
lambda=1;   %Arrival rate of customers
sigma=0.1;  %Standard deviation of service time
c=2;        %Cost

mu=mu0;
k=0;        %iteration count

while k<M
    
    k=k+1; 

    %Optimization criterion at current solution
    for i=1:R
        % D is the simulation response, p the pertubations 
        [D(i) p(i)]=GG1(n,lambda,mu(k),sigma,(k-1)*R*500+(i-1)*500);
    end
    Y(k)=mean(D)+c/mu(k);
    
    %Gradient estimate
    if mode==1
        for i=1:R
            d(i)=GG1(n,lambda,mu(k)+delta,sigma,(M+k-1)*R*500+(i-1)*500);
        end
        y(k)=mean(d)+c/(mu(k)+delta);
        g(k)=(y(k)-Y(k))/delta;
        
    elseif mode==2
        for i=1:R
            d(i)=GG1(n,lambda,mu(k)+delta,sigma,(k-1)*R*500+(i-1)*500);
        end
        y(k)=mean(d)+c/(mu(k)+delta);
        g(k)=(y(k)-Y(k))/delta;
        
    elseif mode==3
        y(k)=0;
        g(k)=mean(p)-c/(mu(k)^2);
    end
        
    %Step size update
    a(k)=a0/sqrt(k);             
    
    %Take a step in the direction of the gradient
    mu(k+1)=max(0,mu(k)-g(k)*a(k));
    
    %Command line output
    disp(['k: ' num2str(k) '   mu: ' num2str(mu(k)) '   Y: ' num2str(Y(k)) '   y: ' num2str(y(k)) '   g: ' num2str(g(k)) '   a: ' num2str(a(k)) ]);

end
   
