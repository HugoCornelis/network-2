//genesis
//
// $Id: control.g 1.13.1.5 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// control.g : control panel functionality

int include_control

if ( {include_control} == 0 )

	include_control = 1


//v default simulation time (msec)

float runtime = 500

//- set default output rate

int outputRate = 10



///
/// SH:	CreateRefresh
///
/// PA: path..........:	path for refresh elements
///	fnRefresh.....:	function to call at each refresh step
///
/// DE:	Create refresh elements
///	Refresh elements use clock 9
///

function CreateRefresh(path,fnRefresh)

str path
str fnRefresh

	//- give diagnostics

	echo "Creating refresh elements for "{path}

	//- create script_out element in given path

	create script_out {path}/refresh

	//- set clock for refresh element

	useclock ^ 11

	//- set command field

	setfield ^ \
		command {fnRefresh}
end


///
/// SH:	NetworkExit
///
/// DE: Exits the simulation
///

function NetworkExit

	//- set simulation status : none

	echo 0 > ../simulation.status

	//- exit genesis

	exit
end


///
/// SH:	NetworkReset
///
/// DE:	resets the simulation
///

function NetworkReset

	//- reset all

	reset
end


///
/// SH:	NetworkRun
///
/// DE:	do a run for the amount of time steps as set in the time step dialog
///

function NetworkRun

	//- force a button down click on the time dialog

	call /control/time B1DOWN

	//- retrieve time

	float time = {runtime}

	//- determine number of steps to perform

	int steps = time / 1000 / dt

	//- give an informational message

	echo Running simulation for {steps} steps

	//- do the simulation steps

	step {steps} -background
end


///
/// SH:	SetOutputRate
///
/// PA:	rate..:	new output rate
///
/// DE:	act after change in relative output rate
///	calculates clock 9, set global outputRate
///

function SetOutputRate(rate)

int rate

	//- give a diagnostic message to the user

	echo Relative output rate changed to {rate}

	//- set global variable

	outputRate = rate

	//- set output clock

	setclock 9 {dt * outputRate}
end


///
/// SH:	SetRunTime
///
/// PA:	time..:	new time in msec
///
/// DE:	act after change in run time
///	calculates clock 9, set global outputRate
///

function SetRunTime(time)

float time

	//- if given time is not negative

	if ( time > 0 )

		//- give a diagnostic message to the user

		echo Setting simulation time to {time} msec

		//- set global variable

		runtime = {time}

	//- else

	else
		//- give diagnostics

		echo "You cannot reverse time"

		//- reset the value of the widget

		setfield /control/time \
			value {runtime}
	end
end


///
/// SH:	ControlRefresh
///
/// DE:	Refresh the control panel
///	Does update for current time widget in the control panel
///

function ControlRefresh

	//- set new label

	//! with some superhacking this seems to work :
	//! added "00000" to avoid NULL string in do_cmd_args()
	//! put label values between {} to get the @ concat work...

	setfield /control/currentTime \
		label \
			{"Current time : " \
			 @ {substring {getstat -time}"00000" 0 5} \
			 @ " s"}
end


///
/// SH:	ControlPanelCreate
///
/// DE:	create the control panel with all buttons and dialogs
///

function ControlPanelCreate

	//- create form for control panel

	create xform /control [0, 470, 300, 325]
	
	//- make it the current element

	pushe /control

	//- create a label with a header

	create xlabel heading \
		-label "Simulation control"

	//- create the reset button

	create xbutton reset \
		-ygeom 0:heading \
		-wgeom 25% \
		-title "RESET" \
		-script "NetworkReset"

	//- create the run button

	create xbutton run \
		-xgeom 0:reset \
		-ygeom 0:heading \
		-wgeom 25% \
		-title "RUN" \
		-script "NetworkRun"

	//- create the stop button

	create xbutton stop \
		-xgeom 0:run \
		-ygeom 0:heading \
		-wgeom 25% \
		-title "STOP" \
		-script "echo Stopping simulation ; stop"

	//- create the quit button

	create xbutton quit \
		-xgeom 0:stop \
		-ygeom 0:heading \
		-wgeom 25% \
		-title "QUIT" \
		-script "NetworkExit"

	//- create the time dialog

	create xdialog time \
		-value {runtime} \
		-title "time (msec) : " \
		-script "SetRunTime <v>"

	//- create the time step dialog

	create xdialog outputRate \
		-value {outputRate} \
		-title "Output rate : " \
		-script "SetOutputRate <v>"

	//- create a label for displaying current time

	create xlabel currentTime \
		-label "Current time : "{getstat -time}

	//- create input button

	create xbutton input \
		-label "Input panel" \
		-script "InputShow"

	//- create output button

	create xbutton output \
		-label "Output panel" \
		-script "OutputShow"

	//- create simulation config button

	create xbutton mode \
		-label "Network configuration" \
		-script "SettingsShow"

	//- give info : number of Mossy's, Granules, Golgi's

	create xlabel mossys \
		-label "Number of mossy fibers  : "{number_mossy_fibers}

	create xlabel granules \
		-label "Number of Granule cells : "{number_granule_cells}

	create xlabel golgis \
		-label "Number  of Golgi  cells :  "{number_Golgi_cells}

	//- create information label

	create xlabel info \
		-title "Simulation information"

	//- create help button

	create xbutton help \
		-ygeom 0:info.bottom \
		-wgeom 50% \
		-title "Help" \
		-script "InfoHelp"

	//- create the credits button

	create xbutton credits \
		-xgeom 0:last.right \
		-ygeom 0:info.bottom \
		-wgeom 50% \
		-title "Credits" \
		-script "InfoCredits"

	//- show the control panel

	xshow /control

	//- create refresh funtionality for control panel

	CreateRefresh /control ControlRefresh

	//- pop previous current element from stack

	pope

end


end


