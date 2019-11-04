//genesis - Cerebellar cortex tutorial genesis master script
//
// $Id: TUTORIAL.g 1.18.1.6.1.3 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Cerebellar cortex tutorial
//'
//' (C) 1998,1999 BBF-UIA
//'
//' see our site at http://www.bbf.uia.ac.be/ for more information regarding
//' the cerebellar cortex and genesis simulation software.
//'
//'
//' functional ideas ..	Reinoud Maex, reinoud@bbf.uia.ac.be
//'			Erik De Schutter, erik@bbf.uia.ac.be
//' genesis coding ....	Hugo Cornelis, hugo@bbf.uia.ac.be
//'
//' general feedback ..	Reinoud Maex, Erik De Schutter
//'
//////////////////////////////////////////////////////////////////////////////

//- give header

echo "------------------------------------------------------------------------"
echo
echo "                       Cerebellar cortex tutorial"
echo "             version " -n
// $Format: "echo \"$ProjectVersion$ ($ProjectDate$)\""$
echo "0.75 (Tue, 09 Oct 2001 14:59:26 +0200)"
echo "                            Simulation script"
echo
echo "------------------------------------------------------------------------"

//- default : array is off
//! (use this only if you have an array version of the hines solver)

int bArray = 0

//- set colorscale

xcolorscale rainbow3

//- include default definitions

include defaults.g

//- go to gran layer directory

cd Gran_layer_2D

//- include configuration

include config.g

//- setup configuration

ConfigSetup

//- include functions for solver

include solver.g

//- set clocks, this must be done before creating the hines solver

//! if we set clocks 0..7 then setting clock 9 is ignored

float dt = 2.0e-5

echo dt = {dt}

int i

for (i = 0; i <= 8; i = i + 1)

	setclock {i} {dt}

end

//- set clock for fast output elements

setclock 9 4.0e-5

//- set clock for slow output elements

setclock 10 1.0e-4

//- set clock for refresh elements

setclock 11 {dt * 239}

// switch to directory for 2D simulation

//cd Gran_layer_2D

//- include setup for granule layer

include Gran_layer_setup.g

// this must something with synapses...

//include nsynapses


// spike history output (this must be done before the hines solver is set up)
//include Gran_layer_spike_history_hines.g

//- graphics : xgraph 

include Gran_layer_graph_hines.g

//- graphics : xview  

include Gran_layer_view_hines.g

//- graphics : xaxonview

include Gran_layer_view_setup.g

// ascii file output 

// include Gran_layer_ascii_hines.g 

//- reset simulation

reset

//- set random seed

randseed 12345

// randomization of neurons' leak conductances

//include Gran_layer_randomize_hines.g

//- set random seed

randseed 12345

// loop over mossy fibers

//for (i = 0; i < {number_mossy_fibers}; i = i + 1)
//	setfield /white_matter/mossy_fiber[{i}] rate {mossy_fiber_firing_rate * (1.0 + {rand -1.0 1.0})}
//end

//echo {mossy_fibers_history_filename}

//include nsynapses

//   include mf_firing_rate.g

//step 5 -time

//   exit


//- setup granular layer

//! if we setup the granular layer after changing back to the main directory,
//! some files will not be found (includes and tabchans)

GranularLayerSetup

//- setup connections and synapses

GranularLayerLink

// switch back to original current directory

//cd ..

//- create solver for all cells in the granular layer

SolverGranularLayerCreate {bArray}

//- randomize : leak and max conductances

GranularRandomizeGranules
GranularRandomizeGolgis

//- include input script

include ../Interface/input.g

//- include output script

include ../Interface/output.g

//- include settings script

include ../Interface/settings.g

//- include GUI scripts

include ../Interface/control.g
include ../Interface/info.g

//- include debugging routines

include ../debug.g

//- create input elements

InputInit

//- create output elements

OutputInit

//- create settings elements

SettingsInit

//- create xview

XViewCreate {bArray}

//- create graph widgets

XGraphCreate

//- create all info widgets

InfoCreate

//- create the control panel

ControlPanelCreate

//- initialize GUI

reset

step

//- give some statistics

DebugGranuleInput 0

//- reset simulation and wait for user input

reset


