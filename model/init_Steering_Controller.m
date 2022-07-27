%% Steering Controller Constants
%
% These are local constants that drive the steering controller.

% PID Gains. Found through trial and error. Basically, the system works best
% with P control and I and D disabled. This is because the quantization error
% in steering power / encoder is masking the steady-state error that integral
% control masks. Also, we run the motor to full power (thus saturating our
% control output) fairly easily - which causes significant integrator windup
% and overshoot, if we're not careful.
Kp = 10.0;
Ki = 0.001;  % cannot be zero because of how the controller is designed
Kd = 0;

% Bounds on the saturation for power level.
Power_Level_Max =  100;
Power_Level_Min = -100;

%% Parameters

% PARAMETER Steering_Offset %
% This value is computed in the original Ada code by driving the motor to the
% right limit (backwards - decreasing encoder values), zeroing the encoder,
% driving the motor to the left limit (forward - increasing encoder values),
% and dividing the result by two. This thus represents the value of the encoder
% when the steering angle is zero and also represents the ±largest angle that
% can be achieved.
Steering_Offset = Simulink.Parameter;
Steering_Offset.DataType = 'single';
Steering_Offset.Description = 'The angle at which the vehicle is steering straight ahead.';
Steering_Offset.RTWInfo.StorageClass = 'Custom';
Steering_Offset.RTWInfo.Alias = '';
Steering_Offset.RTWInfo.Alignment = -1;
Steering_Offset.RTWInfo.CustomStorageClass = 'ImportFromFile';
Steering_Offset.RTWInfo.CustomAttributes.HeaderFile = 'simulator.ads';
Steering_Offset.RTWInfo.CustomAttributes.ConcurrentAccess = 0;
Steering_Offset.Value = 15.0;  % Needed to make Simulink happy.

set_param('Steering_Controller','ParameterArgumentNames','Steering_Offset');
% PARAMETER Steering_Offset %

%% Shared Parameters

init_shared_parameters
