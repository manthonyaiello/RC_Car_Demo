%% Steerting Controller Constants
%
% These are local constants that drive the steering controller.

% PID Gains. Found through trial and error. Basically, the system works best
% with P control and I and D disabled. This is because the quantization error
% in steering power / encoder is masking the steady-state error that integral
% control masks. Also, we run the motor to full power (thus saturating our
% control output) fairly easily - which causes significant integrator windup
% and overshoot, if we're not careful.
Kp = 10.0;
Ki = 0.001; % cannot be zero because of how the controller is designed
Kd = 0;

% Bounds on the saturation for power level.
Power_Level_Max = 100;
Power_Level_Min = -100;

%% Imported Types

% Directions enumeration type.
Simulink.defineIntEnumType('Directions', ...
    {'Forward', 'Backward'}, ...
    [0; 1], ...
    'DefaultValue', 'Forward', ...
    'DataScope', 'Imported', ...
    'AddClassNameToEnumNames', false, ...
    'Description', 'QGen.AdaSpecFile:nxt-motors.ads');

% Power_Level type %
Power_Level = Simulink.AliasType;
Power_Level.BaseType = 'uint8';
Power_Level.Description = ...
    ['QGen.AdaSpecFile:nxt-motors.ads ', ...
     'QGen.ValueRange:[0, 100] '];

% Motor_Encoder_Counts type %
Motor_Encoder_Counts = Simulink.AliasType;
Motor_Encoder_Counts.BaseType = 'int32';
Motor_Encoder_Counts.Description = 'QGen.AdaSpecFile:nxt-motors.ads';


%% Imported Parameters

% PARAMETER To_The_Left %
To_The_Left = Simulink.Parameter;
To_The_Left.DataType = 'Enum: Directions';
To_The_Left.Description = 'Mapping of leftward steering to motor direction.';
To_The_Left.RTWInfo.StorageClass = 'Custom';
To_The_Left.RTWInfo.Alias = '';
To_The_Left.RTWInfo.Alignment = -1;
To_The_Left.RTWInfo.CustomStorageClass = 'ImportFromFile';
To_The_Left.RTWInfo.CustomAttributes.HeaderFile = 'vehicle.ads';
To_The_Left.RTWInfo.CustomAttributes.ConcurrentAccess = 0;
To_The_Left.Value = Directions.Forward;
% PARAMETER To_The_Left %

% PARAMETER To_The_Right %
To_The_Right = Simulink.Parameter;
To_The_Right.DataType = 'Enum: Directions';
To_The_Right.Description = 'Mapping of rightward steering to motor direction.';
To_The_Right.RTWInfo.StorageClass = 'Custom';
To_The_Right.RTWInfo.Alias = '';
To_The_Right.RTWInfo.Alignment = -1;
To_The_Right.RTWInfo.CustomStorageClass = 'ImportFromFile';
To_The_Right.RTWInfo.CustomAttributes.HeaderFile = 'vehicle.ads';
To_The_Right.RTWInfo.CustomAttributes.ConcurrentAccess = 0;
To_The_Right.Value = Directions.Backward;
% PARAMETER To_The_Right %

% PARAMETER Encoder_Counts_Per_Degree %
Encoder_Counts_Per_Degree = Simulink.Parameter;
Encoder_Counts_Per_Degree.DataType = 'Motor_Encoder_Counts';
Encoder_Counts_Per_Degree.Description = 'Number of encoder values per degree of rotation.';
Encoder_Counts_Per_Degree.RTWInfo.StorageClass = 'Custom';
Encoder_Counts_Per_Degree.RTWInfo.Alias = '';
Encoder_Counts_Per_Degree.RTWInfo.Alignment = -1;
Encoder_Counts_Per_Degree.RTWInfo.CustomStorageClass = 'ImportFromFile';
Encoder_Counts_Per_Degree.RTWInfo.CustomAttributes.HeaderFile = 'simulator.ads';
Encoder_Counts_Per_Degree.RTWInfo.CustomAttributes.ConcurrentAccess = 0;
Encoder_Counts_Per_Degree.Value = 2;
% PARAMETER Encoder_Counts_Per_Degree %

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
Steering_Offset.Value = 45.0;
% PARAMETER Steering_Offset %


%% Simulation Parameters

% The Ada controller runs at 100 Hz.
Step_Size = 0.01;
