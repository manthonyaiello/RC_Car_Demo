RC_Car_Demo/model
=================

This is the root directory for a set of Simulink models related to the LEGO RC Car.
The models are organized and managed by a Simulink project, `Steering_Subsystem.prj`.

This directory also contains an Ada simulation harness that allows back-to-back simulation of the QGen-generated steering controller and the original Ada steering controller.


# Models #

Three models have been developed:

1. NXT_Motor: a simulation model of the LEGO NXT motor suitable for exploration and control design.
   The fidelity of the simulation model has not been validated. While the model is intended for simulation only (it is *not* a software-design model), it has been developed so that it is possible to generate code from the model using QGen: this allows the NXT model to be reused in the Ada simulation harness, as described below.

2. Steering_Controller: a software-design model of a steering control solution for the RC Car.
   This model is intended for code generation and to serve as a replacement for the original steering controller in the RC Car.

3. Steering_Subsystem: a closed-loop simulation model incorporating the NXT motor, the steering controller, and simulation inputs.

Working with the models requires MATLAB Simulink.
They were developed and tested using MATLAB R2018b.

Generating code requires AdaCore's QGen code-generator for Simulink and Stateflow.
Code generation was tested using QGen 23.0w (20220726).

The design of both models - and the steering controller, in particular - demonstrates how to control the interface QGen generates by binding type definitions and parameters to defined symbols in the Ada code.
This approach is meant to be illustrative of how Simulink and QGen would be used in practice on large and complex software systems.

## Running the Simulation ##

Open MATLAB and set the current working directory to this directory.
Open the Simulink project, `Steering_Subsystem.prj`.
This will initialize your workspace with required types and open the model `Steering_Subsystem`.

`Steering_Subsystem` is the simulation model with which you will be interacting.
Click on Run button, which will run the simulation.

Once the simulation is complete (Simulink shows "Ready" in the lower-left-hand corner), open the file `Steering_Subsystem_Data_View.mldatx`.
This file opens and configures the Simulation Data Inspector.

The Simulation Data Inpsector shows `Requested_Steering_Angle` plotted against the `Achieved_Steering_Angle` in the top view, which illustrates the performance of the controller.
In the bottom view, you can see the `Steering_Power` - a signed representation of the controller output.

## Generating Code ##

***Note:** While you can use QGen to generate code anywhere you like, the Ada simulation harness assumes that code will be generated in known paths; these are given below.*

To generate code for the steering controller, run the following command at the MATLAB command prompt:

    qgen_build('Steering_Controller.slx', 'ada', '--force', '--clean', '-o', 'generated/controller')

To generate code for the NXT motor, run the following command at the MATLAB command prompt:

    qgen_build('NXT_Motor.slx', 'ada', '--force', '--clean', '-o', 'generated/motor')


# Ada Simulation Harness #

The RC Car Demo builds for an embedded target and thus a specialized configuration is required to use any artifacts produced.
This makes examination or comparison of the results of controller design difficult.
To work around this, we have developed a simulation harness in Ada that will simulate the QGen-generated steering controller and the original Ada steering controller using the QGen-generated NXT motor model.

The Ada simulation harness is contained in the `harness` directory; a `README.md` in that directory explains the design of the harness in more detail.
Here, we describe how to build and use the Ada simulation harness.

Building the Ada simulation harness requires GNAT.
The build was tested using GNAT Pro 22.2.

## Dependencies ##

Before starting the build, you will need to clone the `Robotics_with_Ada` repository from https://github.com/AdaCore/Robotics_with_Ada.
You should place the clone *next to* this repository, so your directories should look like:

    /path/to/parent/RC_Car_Demo
    /path/to/parent/Robotics_with_Ada

## Building ##

From a system command prompt, navigate to the `harness` directory and run:

    gprbuild harness.gpr

`gprbuild` will report on its progress compiling, binding and linking the project.
Some style messages may be displayed; these arise from the QGen-generated code and can be ignored safely.

## Running ##

From a system command prompt, run:

    host-obj/harness --mode B2B

This will execute the simulation, running both the QGen-generated and the original Ada steering controllers in a closed-loop with the NXT motor.
Note that, in this mode, *only* the QGen-generated controller's outputs are affecting the NXT motor; this is why the performance of the original Ada steering controller appears so poor.

You can experiment with the other modes of simulation, which are reported using:

    host-obj/harness --help
