% =========================================================================
% Programmatic Simulink: Cruise Control with Auto-Tuned PID (R2017a)
% =========================================================================
clear; clc;

modelName = 'Auto_Cruise_Control_Tuned';

if bdIsLoaded(modelName)
    close_system(modelName, 0);
end

new_system(modelName);
open_system(modelName);

% 1. Auto-Tuning PID using MATLAB Control System Toolbox
disp('Performing PID Auto-Tuning...');
s = tf('s');
plant_tf = 1 / (1000*s + 50);          % Vehicle physical model (m=1000, b=50)
[C_pi, info] = pidtune(plant_tf, 'PI'); % Find the best PI values

P_opt = C_pi.Kp; % Get optimal Proportional value
I_opt = C_pi.Ki; % Get optimal Integral value

fprintf('Auto-Tuning Result -> P: %.2f | I: %.2f\n', P_opt, I_opt);

% 2. Spawn Simulink Blocks
add_block('simulink/Sources/Step', [modelName, '/Target_Speed']);
add_block('simulink/Sources/Step', [modelName, '/Hill_Disturbance']); 
add_block('simulink/Math Operations/Sum', [modelName, '/Error_Calc']);
add_block('simulink/Math Operations/Sum', [modelName, '/Force_Sum']); 
add_block('simulink/Continuous/PID Controller', [modelName, '/PID_Controller']);
add_block('simulink/Continuous/Transfer Fcn', [modelName, '/Vehicle_Dynamics']);
add_block('simulink/Signal Routing/Mux', [modelName, '/Mux']);
add_block('simulink/Sinks/Scope', [modelName, '/Speed_Monitor']);

% 3. Set Positions
set_param([modelName, '/Target_Speed'], 'Position', [40, 100, 70, 130]);
set_param([modelName, '/Error_Calc'], 'Position', [130, 105, 150, 125], 'Inputs', '|+|-');
set_param([modelName, '/PID_Controller'], 'Position', [200, 97, 240, 133]);
set_param([modelName, '/Hill_Disturbance'], 'Position', [240, 180, 270, 210]);
set_param([modelName, '/Force_Sum'], 'Position', [300, 105, 320, 125], 'Inputs', '|+|-');
set_param([modelName, '/Vehicle_Dynamics'], 'Position', [370, 97, 460, 133]);
set_param([modelName, '/Mux'], 'Position', [520, 96, 525, 134], 'Inputs', '2');
set_param([modelName, '/Speed_Monitor'], 'Position', [570, 100, 600, 130]);

% 4. Configure Parameters with Auto-Tuning Results
set_param([modelName, '/Target_Speed'], 'Time', '5', 'Before', '0', 'After', '20'); 
set_param([modelName, '/Hill_Disturbance'], 'Time', '30', 'Before', '0', 'After', '2000'); 
set_param([modelName, '/Vehicle_Dynamics'], 'Numerator', '[1]', 'Denominator', '[1000 50]');

% Insert automatic tuned P and I values into the PID block
set_param([modelName, '/PID_Controller'], 'P', num2str(P_opt), 'I', num2str(I_opt), 'D', '0');

% 5. Wiring
add_line(modelName, 'Target_Speed/1', 'Error_Calc/1', 'autorouting', 'on');
add_line(modelName, 'Error_Calc/1', 'PID_Controller/1', 'autorouting', 'on');
add_line(modelName, 'Vehicle_Dynamics/1', 'Error_Calc/2', 'autorouting', 'on'); 

add_line(modelName, 'PID_Controller/1', 'Force_Sum/1', 'autorouting', 'on');
add_line(modelName, 'Hill_Disturbance/1', 'Force_Sum/2', 'autorouting', 'on');
add_line(modelName, 'Force_Sum/1', 'Vehicle_Dynamics/1', 'autorouting', 'on');

add_line(modelName, 'Target_Speed/1', 'Mux/1', 'autorouting', 'on');
add_line(modelName, 'Vehicle_Dynamics/1', 'Mux/2', 'autorouting', 'on');
add_line(modelName, 'Mux/1', 'Speed_Monitor/1', 'autorouting', 'on');

% 6. Execute Simulation
set_param(modelName, 'StopTime', '60'); 
sim(modelName);
open_system([modelName, '/Speed_Monitor']);
