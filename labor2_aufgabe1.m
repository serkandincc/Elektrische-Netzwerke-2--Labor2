clc
clear
close all
format longE

R = 680;
L = 4.7 * 10^-3;
C = 4.7 * 10^-9;
Vs = -0.5i;

[w0, w1, w2] = Res(R, L, C);

f0 = w2f(w0);
f1 = w2f(w1);
f2 = w2f(w2);

Q = Qw(w0, L, R);
B = Bb(R, L);

fall = [f0, f1, f2, 2000, 6000, 12000, 20000, 40000, 60000, 80000, 100000];
fall = sort(fall);

[Vr, Vl, Vc] = V(Vs, R, L, C, fall);

[thetar, rhor] = cart2pol(real(Vr), imag(Vr));
thetar = rad2deg(thetar);

[thetac, rhoc] = cart2pol(real(Vc), imag(Vc));
thetac = rad2deg(thetac);

[thetal, rhol] = cart2pol(real(Vl), imag(Vl));
thetal = rad2deg(thetal);

x = 1:11;

hFig = figure(WindowState="maximized");
subplot(3, 1, 1);
bar(rhor*1000);
xticklabels(fall);
title("V_{R}")
xlabel("Frequenz [Hz]");
ylabel("Spannung [mV]");
ylim([0, max(rhor*1000) + 100]);
text(x,rhor*1000,num2str((rhor*1000)'),'HorizontalAlignment','center','VerticalAlignment','bottom', 'FontSize', 10);

subplot(3, 1, 2);
bar(rhoc*1000);
xticklabels(fall);
title("V_{C}")
xlabel("Frequenz [Hz]");
ylabel("Spannung [mV]");
ylim([0, max(rhoc*1000) + (1/R)*90000]);
text(x,rhoc*1000,num2str((rhoc*1000)'),'HorizontalAlignment','center','VerticalAlignment','bottom', 'FontSize', 10);

subplot(3, 1, 3);
bar(rhol*1000);
xticklabels(fall);
title("V_{L}")
xlabel("Frequenz [Hz]");
ylabel("Spannung [mV]");
ylim([0, max(rhol*1000) + (1/R)*90000]);
text(x,rhol*1000,num2str((rhol*1000)'),'HorizontalAlignment','center','VerticalAlignment','bottom', 'FontSize', 10);


function Zc = Zc(C, f)
   Zc = 1 ./ (2*pi*f*C*1i); 
end

function Zl = Zl(L, f)
    Zl = 2*pi*f*L*1i;
end

function w2f = w2f(w)
    w2f = w / (2*pi);
end

function [wo, w1, w2] = Res(R, L, C)
    wo = 1 / sqrt(L*C);
    w1 = -(R / (2*L)) + sqrt((R / (2*L))^2 + (1 / (L*C)));
    w2 = +(R / (2*L)) + sqrt((R / (2*L))^2 + (1 / (L*C)));
end

function Qw = Qw(w0, L, R)
    Qw = (w0 * L) / R;
end

function Bb = Bb(R, L)
    Bb = R / L;
end

function [Vr, Vl, Vc] = V(Vs, R, L, C, f)
    Vr = Vs * (R ./ (R + Zc(C, f) + Zl(L, f)));
    Vc = Vs * (Zc(C, f) ./ (R + Zc(C, f) + Zl(L, f)));
    Vl = Vs * (Zl(L, f) ./ (R + Zc(C, f) + Zl(L, f)));
end