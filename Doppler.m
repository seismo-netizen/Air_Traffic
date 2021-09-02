function [f0, v0, l, t0] = Doppler(fnm)

[sachdr,data] = load_sac(fnm);
temp = fnm(end-7:end-4);
t1 = 60; t2 = 180;

[S,F,T] = spectrogram(data,1024,512,1024,1/sachdr.delta,'yaxis');
for i = 1:length(T)
    if T(i) > t1
        n_t1 = i; break;
    end
end
for i = n_t1:length(T)
    if T(i) > t2
        n_t2 = i; break;
    end
end
n_t1 = n_t1 - 1;
T2 = T(n_t1:n_t2);
S2 = abs(S(:,n_t1:n_t2));

h = figure; set(h, 'Visible', 'off');
subplot(2,1,1)
pcolor(T2,F,abs(S2)); shading interp; hold on;
caxis([0 4000])
box on; ylabel('Freq. (Hz)')
colormap(turbo)
xlim([t1 t2])
title('Jday 146 event 1')

for i = 1:length(T2)
    S3 = smooth(S2(:,i),10);
    [~,I] = max(S3);
    f(i) = F(I); 
end

subplot(2,1,2)
t = 0:sachdr.delta:(length(data)-1)*sachdr.delta;
plot(t,data,'-k');
xlim([min(t) max(t)])
xlabel('Time (s)')
ylabel('Seismogram')
xlim([t1 t2])
saveas(h,[temp '_sptgm'],'png');

%% curve fit
T3 = T2 - mean(T2);
% doppler_f = 'f0/(1+v0/343*v0*(x-t0)/sqrt(l^2+(v0*(x-t0)^2)))';
% f0 frequency of source
% v0 velocity of source
% t0 time offset
% l dist from source to trace
x = T3; y = f;
load ref.mat
clear I;
j = 0;
for i = 1:length(T3)
    if abs(y(i) - fitresult(T3(i))) > 10
        j = j + 1; I(j) = i;
    end
end
if exist('I','var')
    T3(I) = []; f(I) = []; clear I;
end
[xData, yData] = prepareCurveData( T3, f );
time = '(x - t0 - sqrt((x - t0)^2 - (1-v0^2/343^2)*((x - t0)^2 - l^2/343^2)))/(1-v0^2/343^2)';
fnct = ['f0/(1+v0/343*v0*' time '/sqrt(l^2+(v0*' time ')^2))'];
ft = fittype( fnct, 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [130 5300 0 110];
[fitresult, ~] = fit( xData, yData, ft, opts );

f0 = fitresult.f0;
v0 = fitresult.v0;
l = fitresult.l;
t0 = fitresult.t0 + mean(T2);

%% Plot fit with data.
h = figure; set(h, 'Visible', 'off');
h1 = plot( fitresult, xData , yData,'.k');
legend(h1, 'Freq. vs. time', 'Curve fit');
title(['f_0 = ' num2str(f0) 'Hz, v_0 = ' num2str(v0) 'm/s, l = ' num2str(l) 'm']);
% Label axes
xlabel('Time (s)')
ylabel('F (Hz)')
xlim([(t1-mean(T2)-10) (t2-mean(T2)+10)])
grid on
saveas(h,[temp '_crvfit'],'png');



