with NXT.Motors; use NXT.Motors;

package Simulator is
   --  This package allows simulation according to different modes.
   --  See `Mode_Type` for more information.

   type Mode_Type is (QGen, Ada, B2B);
   --  Supported simulation modes.
   --
   --  @enum QGen - run the simulation using the QGen-generated controller
   --  @enum Ada  - run the simulation using the original Ada controller
   --  @enum B2B  - run the simulation using both controllers back-to-back,
   --               allowing comparison of the results. The QGen controller
   --               will actually affect the plant.

   Encoder_Counts_Per_Degree : constant Motor_Encoder_Counts := 2;
   --  The number of encoder values reported per degree of rotation.

   procedure Simulate (Mode : Mode_Type);
   --  Run a simulation of the NXT Motor with the controller (or controllers)
   --  specified by the Mode given.
end Simulator;
