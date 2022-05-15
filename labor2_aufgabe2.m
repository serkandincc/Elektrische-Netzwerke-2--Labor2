clc
clear
close all
format longE

Rs = 100000;
R = 2200;
L = 4.7 * 10^-3;
C = 4.7 * 10^-9;
Vs = -5i;

[w0, w1, w2] = Res(R, L, C);
B = Bb(R, C);
Q = Qw(w0, R, C);

f0 = w2f(w0);
f1 = w2f(w1);
f2 = w2f(w2);

fall = [f0, f1, f2, 2000, 6000, 12000, 20000, 40000, 60000, 80000, 100000];
fall = sort(fall);

Vpl = Vp(Vs, Rs, R, L, C, fall);

[thetap, rhop] = cart2pol(real(Vpl), imag(Vpl));
thetap = rad2deg(thetap);

x = 1:11;

hFig = figure(WindowState="maximized");
bar(rhop*1000);
xticklabels(fall);
title("V_{parallel}");
xlabel("Frequenz [Hz]");
ylabel("Spannung [mV]");
text(x,rhop*1000,num2str((rhop*1000)'),'HorizontalAlignment','center','VerticalAlignment','bottom', 'FontSize', 14);

function Vp = Vp(Vs, Rs, R, L, C, f)
    Zp = (1/R) + (1./Zl(L, f)) + (1./Zc(C, f));
    Zp = 1 ./ Zp;
    Vp = Vs * (Zp ./ (Zp + Rs));
end

function Zc = Zc(C, f)
   Zc = 1 ./ (2*pi*f*C*1i); 
end

function Zl = Zl(L, f)
    Zl = 2*pi*f*L*1i;
end

function w2f = w2f(w)
    w2f = w / (2*pi);
end

function [w0, w1, w2] = Res(R, L, C)
    w0 = 1 / sqrt(L*C);
    w1 = -1/(2*R*C) + sqrt((1/(2*R*C))^2 + 1/(L*C));
    w2 = 1/(2*R*C) + sqrt((1/(2*R*C))^2 + 1/(L*C));
end

function Qw = Qw(w0, R, C)
    Qw = w0 * R * C;
end

function Bb = Bb(R, C)
    Bb = 1/(R*C);
end

