clear all
clc

y1 = [0.4071,0.3797,0.3614,0.3714,0.3684,0.3924,0.4337,0.4638,0.4784,0.4818,0.5085,0.5131,...
0.5071,0.4918,0.4811,0.4704,0.5138,0.6072,0.7283,0.5783,0.5345,0.5038,0.4791,0.4578,0.4326];

Pr = repmat(y1(1:end-1),6,1);
Pr = reshape(Pr,1,[]);

x1 = binvar(144,1);
x2 = binvar(144,1);
x3 = binvar(144,1);

p = optimproblem;
x = optimvar('x',3,'Type','integer','Lowerbound',0);
p.ObjectiveSense = 'minimize';
p.Objective = Pr*x3;
p.Constraints.c1 = sum(x(3)) == 12;
p.Constraints.c2 = x - y == ui([2:end,1]) - ui;
p.Constraints.c3 = sum(x) == 1;
p.Constraints.c4 = sum(y) == 1;

values = solve(p)

