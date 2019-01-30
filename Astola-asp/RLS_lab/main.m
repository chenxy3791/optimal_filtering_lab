%% Initialization
NrOfTrials = 10; % Number of realizations.
M = 6; % Adaptive filter length. Do not change.

ff = 1.0; % forgetting factor (lambda), use values in the range [0.998,1]

% RLS filter from Matlab DSP Toolbox
hRLS = dsp.RLSFilter('Length',M,'Method','Conventional RLS',...
    'ForgettingFactor',ff);

% Desired signal
[d, fs] = audioread('S7_Quake_III_Arena_Gameplay.wav');

% iterate over trials
% QUESTION: why do we have more than one trial?
% TASK: collect the error signals to produce a learning curve for both your
% implementation and Matlab's implementation.

e_RLS = []; %store error signals here, Matlab's DSP toolox
e_RLS_alg = []; %store error signals here, your implementation

for k=1:NrOfTrials
    
    % Input signal
    [u, fs] = audioread(['S7_Quake_III_Arena_Gameplay_IIR_', num2str(k), '.wav']);
    u = u * 2^(24-16); % Here we just scale the input data. You don't have to worry about this.
    
    % RLS using Matlab's DSP toolbox
    [y,e] = step( hRLS,u,d );
    release(hRLS);
    
    % select a proper delta value for your implementation, 
    % see http://www.cs.tut.fi/~tabus/course/AdvSP/21006Lect7.pdf, p.23
    delta = ;
    % finish the implementation of RLS_alg()
    [e,w] = RLS_alg(d,u,M,ff,delta);

    
end

% TASK: Plot the learning curves for both Matlab's DSP toolbox and your
% implementation of RLS.



















