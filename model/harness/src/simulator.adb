with Ada.Text_IO; use Ada.Text_IO;

with GNAT.Formatted_String; use GNAT.Formatted_String;

with Interfaces; use Interfaces;

with Steering_Controller;
with Steering_Controller_states; use Steering_Controller_states;

with Ada_Steering_Controller; use Ada_Steering_Controller;

with NXT_Motor;
with NXT_Motor_states; use NXT_Motor_states;

package body Simulator is

   procedure Simulate (Mode : Mode_Type) is
      QGen_State : Steering_Controller_State;
      --  Internal state of the QGen-generated controller.

      Ada_State : Ada_Steering_Controller_State;
      --  Internal State of the Ada controller

      Motor_State : NXT_Motor_State;
      --  Internal state of the motor.

      Encoder_Count : Motor_Encoder_Counts;
      --  Current reading from the motor's encoder.

      Target_Angle : Integer_8;
      --  Requested steering angle - this is what the controller should track.
      --  This angle is stated in the "observer's" frame of reference, so
      --  0 is straight ahead. Negative values are to the right; positive
      --  values are to the left.

      Motor_Power : Power_Level;
      --  Motor power command output from the controller to the motor.

      Ada_Motor_Power : Power_Level := 0;
      --  Copy of the motor power generated by the Ada controller, for
      --  comparison purposes.

      QGen_Motor_Power : Power_Level := 0;
      --  Copy of the motor power generated by the QGen controller, for
      --  comparison purposes.

      Rotation_Direction : Directions;
      --  Rotation direction commant output from the controller to the motor.

      Noise : constant Long_Float := 0.0;
      --  Noise parameter for the NXT motor.

      Bias : constant Long_Float := 0.0;
      --  Bias parameter (mean for the noies) for the NXT motor.

      Steering_Offset : constant Float := 45.0;
      --  Constant stand-in for the value normally computed during harware
      --  initialization of the Steering_Control.


      function Request_Steering_Angle (Step : Integer) return Integer_8;
      --  Lookup-Table-Like steering angle request.

      function Request_Steering_Angle (Step : Integer) return Integer_8 is
        (if Step < 50 then
            0
         elsif Step in 51 .. 100 then
            43
         elsif Step in 101 .. 150 then
            -43
         else
            0);


      procedure Print_Data (Step : Integer);
      --  Print the Target_Angle and the current steering angle, computed from
      --  the Encoder_Count and Steering_Offset.

      procedure Print_Data (Step : Integer) is
         F : Formatted_String :=
            +"Step: %5d   Target Angle: %5d   Current Angle: %5d   QGen Power: %5d   Ada Power: %5d";

         Current_Angle : constant Integer := Integer (
            Float (Encoder_Count) / Float (Encoder_Counts_Per_Degree) - Steering_Offset);
      begin
         F := F & Step & Integer (Target_Angle) & Current_Angle & QGen_Motor_Power & Ada_Motor_Power;
         Put_Line (-F);
      end Print_Data;

   begin
      Encoder_Count := Motor_Encoder_Counts (Steering_Offset) * Encoder_Counts_Per_Degree;

      Ada_Steering_Controller.Configure  (Steering_Offset);
      Ada_Steering_Controller.Initialize (State => Ada_State);

      Steering_Controller.initStates
        (Steering_Offset => Steering_Offset,
         State           => QGen_State);

      NXT_Motor.initStates
        (Steering_Offset => Steering_Offset,
         State           => Motor_State);

      for Step in 0 .. 200 loop
         Target_Angle  := Request_Steering_Angle (Step);

         if Mode = Ada or Mode = B2B then
            Ada_Steering_Controller.Compute
              (Encoder_Count            => Encoder_Count,
               Requested_Steering_Angle => Target_Angle,
               Motor_Power              => Motor_Power,
               Rotation_Direction       => Rotation_Direction,
               State                    => Ada_State);

            Ada_Motor_Power := Motor_Power;
         end if;

         if Mode = QGen or Mode = B2B then
            Steering_Controller.comp
              (Encoder_Count            => Encoder_Count,
               Requested_Steering_Angle => Target_Angle,
               Motor_Power              => Motor_Power,
               Rotation_Direction       => Rotation_Direction,
               State                    => QGen_State);

            QGen_Motor_Power := Motor_Power;
         end if;

         NXT_Motor.comp
           (Rotation_Direction => Rotation_Direction,
            Motor_Power        => Motor_Power,
            Noise              => Noise,
            Bias               => Bias,
            Encoder_Count      => Encoder_Count,
            State              => Motor_State);

         --  Note: no update for the Ada steering controller.
         Steering_Controller.up (State => QGen_State);
         NXT_Motor.up           (State => Motor_State);

         Print_Data (Step);
      end loop;
   end Simulate;
end Simulator;
