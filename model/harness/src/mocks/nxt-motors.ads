package NXT.Motors is
   type Directions is (Forward, Backward);
   subtype Power_Level is Integer range 0 .. 100;
   type Motor_Encoder_Counts is range -(2 ** 31) .. +(2 ** 31 - 1);

   Encoder_Counts_Per_Revolution : constant := 720;
   --  Thus 1/2 degree resolution
end NXT.Motors;