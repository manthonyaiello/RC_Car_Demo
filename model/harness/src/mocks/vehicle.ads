with NXT.Motors; use NXT.Motors;

package Vehicle is
   To_The_Right : constant NXT.Motors.Directions := Backward;
   To_The_Left  : constant NXT.Motors.Directions := Forward;

   function To_Steering_Motor_Direction (Power : Float) return NXT.Motors.Directions is
      (if Power < 0.0 then To_The_Right else To_The_Left);
end Vehicle;
