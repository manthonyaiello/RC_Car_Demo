%% Shared Parameters
%
% These are parameters in common to all models but that will be stored in the
% model workspaces

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

%% Shared Constants
%
% The Ada controller runs at 100 Hz, so we match that in all models.
Step_Size = 0.01;
