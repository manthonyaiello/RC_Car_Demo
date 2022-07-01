with Ada.Text_IO; use Ada.Text_IO;

with GNAT.Command_Line;
with GNAT.Strings;

with Simulator;

procedure Harness is
   Mode : Simulator.Mode_Type;
begin
   declare
      use GNAT.Command_Line;
      use GNAT.Strings;

      Config      : Command_Line_Configuration;
      Mode_String : aliased GNAT.Strings.String_Access;
   begin
      Define_Switch
        (Config      => Config,
         Output      => Mode_String'Access,
         Switch      => "-m:",
         Long_Switch => "--mode:",
         Help        => "Mode of operation, one of 'QGen', 'Ada', or 'B2B'");

      Getopt (Config);

      if Mode_String.all = "QGen" then
         Mode := Simulator.QGen;
      elsif Mode_String.all = "Ada" then
         Mode := Simulator.Ada;
      elsif Mode_String.all = "B2B" then
         Mode := Simulator.B2B;
      else
         Put_Line ("Invalid mode '" & Mode_String.all & "'.");
         Display_Help (Config);

         return;
      end if;
   end;

   Simulator.Simulate (Mode);
end Harness;
