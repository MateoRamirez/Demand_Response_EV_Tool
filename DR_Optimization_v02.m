%***************************************************************%
%                          PRESENTATION

%Author: Mateo RAMÍREZ
%Abstract:
%***************************************************************%
%Clear Variables, Screens and Loop
%***************************************************************%
clearvars
clc
clear
close all
%***************************************************************%
%Import Data from User
%***************************************************************%
kwh             = uiimport('-file');
Energy_Cost_kwh = kwh(1).Energy_Cost_kwh;
pr              = Energy_Cost_kwh(2,:);
%***************************************************************%
%Pop-Up window User Data Input
%***************************************************************%
prompt = {
'Project Name:','Project Location:',...                                    
'Time per Cycle [min]:'...                                                 
'Uninterruptible Load Name_1:','Power Demand [W]:',...
'Operation Time ON [0 - 24 hr]:','Operation Time OFF [0 - 24 hr]:'
};
%Pop-up set up
%Pop-up title
dlg_title = 'Demand Response Calculation Tool';                             
%Pop-up width
num_lines = [1,50];
%Pop-up Defaults
defaultans  = {'SIP','Suzhou','10','WN','500','12','14'};
answer      = inputdlg(prompt,dlg_title,num_lines,defaultans);                  
%Project Name Input
p_n = cellstr(answer{1});                                                                                                           
%Project Location Input
p_l = cellstr(answer{2});                                                         
%Time cycle
tc          = str2double(answer{3});                                                
ul_n_1      = cellstr(answer{4});
ul_1_p      = str2double(answer{5});
ul_1_ont    = str2double(answer{6}); 
ul_1_offt   = str2double(answer{7});
%***************************************************************%
%Price Array Reshape
%***************************************************************%
%Intervals per hour
int = 60/tc;                                                                
%Copies the price int number of times
pr_tc = repmat(pr(1:end),int,1);                                            
%Reshapes from matrix to array size 24 hr * int
pr_tc = reshape(pr_tc,1,[]);                                                
%***************************************************************%
%Loads
%***************************************************************%
%Wtih No Optimization
%***************************************************************%
%Time interval OFF
ul_1_offint_1 = ul_1_ont * int;                                             
%Time interval ON
ul_1_onint = ul_1_offt - ul_1_ont;                                          
%Time interval OFF
ul_1_offint_2 = (24 * int) - ul_1_offint_1 - ul_1_onint;                    
%Power in kW
ul_1_p = ul_1_p / 1000;                                                     
%***************************************************************%
%Objective Function
cost_ul = sum(pr_tc.*([zeros(1,ul_1_offint_1),...
    ones(1,ul_1_onint),zeros(1,ul_1_offint_2)]*ul_1_p))/int;
%***************************************************************%
%With Optimization
%***************************************************************%
%Count the number of elements in the array
npr_tc = numel(pr_tc);
%Start Optimization problem (OP)
p = optimproblem;
%Define the Variables
x = optimvar('x',npr_tc,'Type','integer','Lowerbound',0,...
    'Upperbound',1);
y = optimvar('y',npr_tc,'Type','integer','Lowerbound',0,...
    'Upperbound',1);
z = optimvar('z',npr_tc,'Type','integer','Lowerbound',0,...
    'Upperbound',1);
%Define the Objective Sense of the OP
p.ObjectiveSense = 'minimize';
%Define the Objective Function of the OP
z_array = zeros(1,npr_tc);
p.Objective = pr_tc*x + z_array*y + z_array*z;
%Define the Constrains of the OP
p.Constraints.c1 = sum(x) == 12;
p.Constraints.c2 = sum(y) == 1;
p.Constraints.c3 = sum(z) == 1;
p.Constraints.c4 = [];
for i=2:length(pr_tc)
    p.Constraints.c4 = [p.Constraints.c4;y(i) - z(i) == x(i) - x(i-1)]
end
%Solve the OP
values = solve(p);
%***************************************************************%
%Plotting
%***************************************************************%
%Hours per Day
t = 1:1:24;
%Font size for plotting titles
fontSize = 14;
figure;
%***************************************************************%
%%Printing Project Information
Initial_Data    = {'Project Name';'Project Location'};
Data            = [p_n;p_l];
T               = table(Data,'RowNames',Initial_Data);
% Get the table in string form.
TString = evalc('disp(T)');
% Use TeX Markup for bold formatting and underscores.
TString = strrep(TString,'<strong>','\bf');
TString = strrep(TString,'</strong>','\rm');
TString = strrep(TString,'_','\_');
% Get a fixed-width font.
FixedWidth = get(0,'FixedWidthFontName');
% Output the table using the annotation command.
annotation(gcf,'Textbox','String',TString,'Interpreter','Tex',...
    'FontName',FixedWidth,'Units','Normalized','Position',...
    [0 0 1 1]);
%***************************************************************%
%%Plotting Stairs Graph Price $/kWh
subplot(3, 3, 1.2);
stairs(t,pr);
axis([1,24,0.2,1])
caption = sprintf('Electricity Price per Hour');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Time [Hours]');
ylabel('Price [$/kWh]');
set(gca,'XTick',1:1:24)