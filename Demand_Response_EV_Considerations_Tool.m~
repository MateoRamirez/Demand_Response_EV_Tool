%*************************************************************************%%%%%%%%%%%%%%%Comments%%%%%%%%%%%%%%%%
%                               PRESENTATION

%Author: Mateo RAMÍREZ
%Abstract: Demand response tool with electric vehicles considerations. The
%tool is able of calculating cost of home appliances with no optimazation 
%and then compare with optimized cost.
%*************************************************************************%
%
%*************************************************************************%
%Clear Variables, Screens and Loop
%*************************************************************************%
clearvars
clc
clear
close all
%*************************************************************************%
%
%*************************************************************************%
%Import Data from User
%*************************************************************************%
kwh = uiimport('-file');
Energy_Cost_kwh = kwh(1).Energy_Cost_kwh;
pr = Energy_Cost_kwh(2,:);
%*************************************************************************%
%
%*************************************************************************%
%Pop-Up window User Data Input
%*************************************************************************%
prompt={
'Project Name:','Project Location:',...                                     %Project Information
'Time per Cycle:'...                                                        %Times per cycle
'Uninterruptible Load 1:','____Power Demand [W]:',...
'____Operation Time ON [0 - 24 hr]:','____Operation Time OFF [0 - 24 hr]:'
};
dlg_title='Demand Response Calculation Tool';                               %Pop-up title 
num_lines = [1,50];                                                         %Pop-up width
defaultans={'','','10','','','',''};                                           
answer=inputdlg(prompt,dlg_title,num_lines,defaultans);                     %Pop-up set up
p_n = (answer{1});                                                          %Project Name Input                                                  
p_l = (answer{2});                                                          %Project Location Input
tc = str2double(answer{3});                                                 %Time cycle
ul_n_1 = (answer{4});
ul_1_p = str2double(answer{5});
ul_1_ont = str2double(answer{6}); 
ul_1_offt = str2double(answer{7});
%*************************************************************************%
%
%*************************************************************************%
%Price Array Reshape
%*************************************************************************%
int = 60/tc;                                                                %Intervals per hour
pr_tc = repmat(pr(1:end),int,1);                                          %Copies the price int number of times
pr_tc = reshape(pr_tc,1,[]);                                                %Reshapes from matrix to array size 24 hr * int
%*************************************************************************%
%+Uninterruptible Loads
%*************************************************************************%
ul_1_offint_1 = ul_1_ont * int;                                             %Time interval OFF
ul_1_onint = ul_1_offt - ul_1_ont;                                          %Time interval ON
ul_1_offint_2 = (24 * int) - ul_1_offint_1 - ul_1_onint;                    %Time interval OFF
ul_1_p = ul_1_p / 1000;                                                     %Power in kW
%*************************************************************************%
%Objective Function
%*************************************************************************%
cost_ul = sum(pr_tc.*([zeros(1,ul_1_offint_1),ones(1,ul_1_onint),...
    zeros(1,ul_1_offint_2)]*ul_1_p))/int;


