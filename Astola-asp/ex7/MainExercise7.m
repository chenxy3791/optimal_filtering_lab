
N  = 50000;
N1 = 1000;
N2= N-N1+1;

nK = 20;
nKs = 10; % NK star, to generate data with

NrOfTrials = 256;

FPE_order = zeros(NrOfTrials, 1);
AIC_order = zeros(NrOfTrials, 1);
MDL_order = zeros(NrOfTrials, 1);
FPE_val = zeros(1, nK);
AIC_val = zeros(1, nK);
MDL_val = zeros(1, nK);

omega = pi*[0.90 0.70 0.50 0.30 0.10];
rho   =    [0.75 0.95 0.85 0.80 0.90];
npairs = length(omega);
roots_ = zeros(2*npairs,1);
roots_(1:npairs) = rho.*exp(1i*omega);
roots_(npairs+1:end) = conj(roots_(1:npairs));

a_ar = poly(roots_);
wstar = -a_ar(2:(nKs+1))'; % w star

for i=1:NrOfTrials
    
    % One realization of AR process.
    e = randn(N,1);
    y = filter(1, a_ar, e);

    % Order estimation loop.
    for k = 1:nK
        
        A = zeros( N1, k );

        % --------- EDIT HERE -------------------
        
        
        FPE_val(k) = ;
        AIC_val(k) = ;
        MDL_val(k) = ;
        
        % ---------------------------------------
    end
    
    % What is done here?
    [~,FPE_order(i)] = min( FPE_val );
    [~,AIC_order(i)] = min( AIC_val );
    [~,MDL_order(i)] = min( MDL_val );
    
end

% Plot results. What is shown? Explain the results.
figure(1);
subplot(311)
hist(FPE_order,(1:nK));
title('FPE criterion','Fontsize',12);
xlabel('order k^*','Fontsize',12);
ylabel('Trials','Fontsize',12);

subplot(312)
hist(AIC_order,(1:nK));
title('AIC criterion','Fontsize',12);
xlabel('order k^*','Fontsize',12);
ylabel('Trials','Fontsize',12);

subplot(313)
hist(MDL_order,(1:nK));
title('MDL criterion','Fontsize',12);
xlabel('order k^*','Fontsize',12);
ylabel('Trials','Fontsize',12);


