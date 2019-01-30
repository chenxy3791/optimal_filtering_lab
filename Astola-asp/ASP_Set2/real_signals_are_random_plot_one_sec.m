disp('Entering real_signals_are_random_plot_one_sec()...');
figure(1); clf;

subplot(211);
plot(Ya);
xlabel('Discrete time t');
ylabel('y(t)');

subplot(212);
plot(Ya);
xlabel('Discrete time t');
ylabel('y(t)');
set(gca,'Xlim',[1 6000]);

