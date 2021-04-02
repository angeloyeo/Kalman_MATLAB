function [pos, vel, alt] = RadarPF(z, dt)
%
%
persistent x
persistent firstRun
persistent pt wt
persistent Npt


if isempty(firstRun)
  x = [0 90 1100]';  
  
  Npt = 1000;
  
  pt(1, :) = x(1) + 0.1*x(1)*randn(1, Npt);
  pt(2, :) = x(2) + 0.1*x(2)*randn(1, Npt);
  pt(3, :) = x(3) + 0.1*x(3)*randn(1, Npt);
  wt       = ones(1, Npt) * 1/Npt;
  
  firstRun = 1;  
end


for k = 1:Npt
  pt(:, k) = fx(pt(:, k), dt) + randn(3, 1);
end


for k = 1:Npt
  wt(k) = wt(k)*normpdf(z, hx(pt(:,k)), 10);
end
wt = wt / sum(wt);


x = pt * wt';
pos = x(1);
vel = x(2);
alt = x(3);

wtc       = cumsum(wt);
rpt       = rand(Npt, 1);
[~, ind1] = sort([rpt; wtc']);
ind       = find(ind1 <= Npt) - [0:Npt-1]';
pt        = pt(:, ind);
wt        = ones(1, Npt) * 1/Npt;


%------------------------------
function xp = fx(x, dt)
%
%
A = eye(3) + dt*[ 0 1 0;
                  0 0 0;
                  0 0 0 ];  

xp = A*x;


%------------------------------
function zp = hx(xhat)
%
%
x1 = xhat(1);
x3 = xhat(3);

zp = sqrt(x1^2 + x3^2);