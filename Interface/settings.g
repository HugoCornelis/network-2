//genesis
//
// $Id: settings.g 1.15 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// settings.g : network configuration settings

int include_settings

if ( {include_settings} == 0 )

	include_settings = 1


//v dynamic change status

int bChangeDynamic = 0

//v randomization change status

int bChangeRandomization = 0

//v static change status

int bChangeStatic = 0



///
/// SH:	GranularLayerDelete
///
/// DE:	Delete granular layer and white matter
///
///	Will probably generate a core...
///

function GranularLayerDelete

	//- delete white matter with mossy fibers

	delete /white_matter

	reset

	//- delete granule cell layer with granule cells and Golgi cells

	delete /granule_cell_layer

	reset
end


///
/// SH:	SettingsUpdateStatus
///
/// DE:	Update status labels
///

function SettingsUpdateStatus

	//- if there was dynamic change

	if (bChangeDynamic)

		//- set label : needs total restart

		setfield /settings/config/status \
			title "Network needs total restart"

	//- else if only static change

	elif (bChangeStatic)

		//- set label : only apply needed

		setfield /settings/config/status \
			title "Parameters changed but not applied"

	//- else if randomization change

	elif (bChangeRandomization)

		//- set label : only apply needed

		setfield /settings/config/status \
			title "Randomization changed but not applied"

	else
		//- set label : no changes

		setfield /settings/config/status \
			title "No parameters changed"
	end
end


///
/// SH:	SettingsResetConfig
///
/// DE:	Reset settings widget to their previous values for config form
///

function SettingsResetConfig

	//- make settings form current

	pushe /settings/config

/*
	// set synaptic weights

	setfield mossyGolgiAMPA \
		value {weight_mossy_fiber_Golgi_cell_synapse}
	setfield granGolgiAMPA \
		value {weight_granule_cell_Golgi_cell_synapse}
	setfield golgiGranGABAA \
		value {weight_Golgi_cell_granule_cell_GABAA_synapse}
	setfield golgiGranGABAB \
		value {weight_Golgi_cell_granule_cell_GABAB_synapse}

	// remember there was no change for config settings

	setfield /settings \
		statusConfig 0
*/

	//- go back to previous current element

	pope
end


///
/// SH:	SettingsResetCellNumbers
///
/// DE:	Reset settings widgets for cellNumbers form
///

function SettingsResetCellNumbers

	//- switch to cellNumbers form

	pushe /settings/subs/cellNumbers

	//- set golgi dimensions

	setfield golgix \
		value {xlength_Golgi_cell_array}

	setfield golgiy \
		value {ylength_Golgi_cell_array}

	//- set granule dimensions

	setfield granulex \
		value {xlength_granule_cell_array}

	setfield granuley \
		value {ylength_granule_cell_array}

	//- set mossy fiber dimensions

	setfield mossyx \
		value {xnumber_mossy_fibers}

	setfield mossyy \
		value {ynumber_mossy_fibers}

	//- go to previous element

	pope
end


///
/// SH:	SettingsResetRandomization
///
/// DE:	Reset settings widget to their previous values for randomization form
///

function SettingsResetRandomization

	//- make settings form current

	pushe /settings/subs/randomization

	//- set leak conductance boundaries

	setfield Vm_init_lb \
		value {Vm_init_lb}
	setfield Vm_init_ub \
		value {Vm_init_ub}

	setfield Granule_E_leak_lb \
		value {Granule_E_leak_lb}
	setfield Granule_E_leak_ub \
		value {Granule_E_leak_ub}

	setfield Golgi_E_leak_lb \
		value {Golgi_E_leak_lb}
	setfield Golgi_E_leak_ub \
		value {Golgi_E_leak_ub}

	//- go back to previous current element

	pope
/*
**
	// remember there was no change for randomization settings

	setfield /settings \
		statusRandomization 0
*/
end


///
/// SH:	SettingsResetMisc
///
/// DE:	Reset settings widgets for misc form
///

function SettingsResetMisc

	//- switch to misc form

	pushe /settings/subs/misc

	//- set Golgi separation

	setfield golgiSeparation \
		value {Golgi_cell_separation}

	//- set Golgi cell dendritic diameter

	setfield golgiDendrDia \
		value {Golgi_cell_dendritic_diameter}

	//- set Golgi cell axon overlap

	setfield golgiAxonOverlap \
		value {Golgi_cell_axon_overlap}

	//- set mossy fiber to granule cell connection radius

	setfield mossyGranRadius \
		value {mossy_fiber_to_granule_cell_connection_radius}

	//- set parallel fiber length

	setfield parallelLength \
		value {parallel_fiber_length}

	//- set parallel fiber conduction speed

	setfield parallelSpeed \
		value {parallel_fiber_conduction_velocity}

	//- set weight and delay distributions

	setfield weightDistr \
		value {weight_distribution}

	setfield delayDistr \
		value {delay_distribution}

	//- go to previous element

	pope
end


///
/// SH:	SettingsResetMossyGran
///
/// DE:	Reset settings widget to their previous values for mossyGran form
///

function SettingsResetMossyGran

	//- make settings form current

	pushe /settings/subs/mossyGran

	//- set synaptic weight, delay, probability

	setfield ampaWeight \
		value {weight_mossy_fiber_granule_cell_AMPA_synapse}

	setfield NMDAWeight \
		value {weight_mossy_fiber_granule_cell_NMDA_synapse}

	setfield delayShared \
		value {delay_mossy_fiber_granule_cell_synapse}

	setfield meanConnections \
		value {mean_mossy_fiber_granule_cell_connections}

	setfield propValue \
		title {P_mossy_fiber_to_granule_cell_synapse}

	//- go back to previous current element

	pope
/*
**
	// remember there was no change for mossy - granule synapse settings

	setfield /settings \
		statusMossyGran 0
*/
end


///
/// SH:	SettingsResetMossyGolgi
///
/// DE:	Reset settings widget to their previous values for mossyGolgi form
///

function SettingsResetMossyGolgi

	//- make settings form current

	pushe /settings/subs/mossyGolgi

	//- set synaptic weight, delay, propability

	setfield ampaWeight \
		value {weight_mossy_fiber_Golgi_cell_synapse}

	setfield delay \
		value {delay_mossy_fiber_Golgi_cell_synapse}

	setfield prop \
		value {P_mossy_fiber_to_Golgi_cell_synapse}

	//- go back to previous current element

	pope
/*
**
	// remember there was no change for mossy - granule synapse settings

	setfield /settings \
		statusMossyGolgi 0
*/
end


///
/// SH:	SettingsResetGranGolgi
///
/// DE:	Reset settings widget to their previous values for granGolgi form
///

function SettingsResetGranGolgi

	//- make settings form current

	pushe /settings/subs/granGolgi

	//- set synaptic weight, probability

	setfield ampaWeight \
		value {weight_granule_cell_Golgi_cell_synapse}

	setfield prop \
		value {P_granule_cell_to_Golgi_cell_synapse}

	//- go back to previous current element

	pope
/*
**
	// remember there was no change for mossy - granule synapse settings

	setfield /settings \
		statusGranGolgi 0
*/
end


///
/// SH:	SettingsResetGolgiGran
///
/// DE:	Reset settings widget to their previous values for golgiGran form
///

function SettingsResetGolgiGran

	//- make settings form current

	pushe /settings/subs/golgiGran

	//- set synaptic weights, delay, probability

	setfield gabaaWeight \
		value {weight_Golgi_cell_granule_cell_GABAA_synapse}

	setfield gababWeight \
		value {weight_Golgi_cell_granule_cell_GABAB_synapse}

	setfield delayShared \
		value {delay_Golgi_cell_granule_cell_synapse}

	setfield prop \
		value {P_Golgi_cell_to_granule_cell_synapse}

	//- go back to previous current element

	pope
/*
**
	// remember there was no change for mossy - granule synapse settings

	setfield /settings \
		statusGolgiGran 0
*/
end


///
/// SH:	SettingsReset
///
/// DE:	Reset settings widget to their previous values for all settings forms
///

function SettingsReset

	//- reset config internal settings

	SettingsResetConfig

	//- reset cell number settings

	SettingsResetCellNumbers

	//- reset randomization settings

	SettingsResetRandomization

	//- reset misc settings

	SettingsResetMisc

	//- reset mossyGran form settings

	SettingsResetMossyGran

	//- reset mossyGolgi form settings

	SettingsResetMossyGolgi

	//- reset granGolgi form settings

	SettingsResetGranGolgi

	//- reset golgiGran form settings

	SettingsResetGolgiGran

	//- remember : no dynamic change

	bChangeDynamic = 0

	//- remember : no randomization change

	bChangeRandomization = 0

	//- remember : no static change

	bChangeStatic = 0

	//- update status labels

	SettingsUpdateStatus
end


///
/// SH:	SettingsSetCellNumbers
///
/// DE:	Reset settings widgets for cellNumbers form
///

function SettingsSetCellNumbers

	//- hide cellNumbers form

	xhide /settings/subs/cellNumbers

	//- switch to cellNumbers form

	pushe /settings/subs/cellNumbers

	//- set golgi dimensions

	xlength_Golgi_cell_array = {getfield golgix value}

	ylength_Golgi_cell_array = {getfield golgiy value}

	//- set granule dimensions

	xlength_granule_cell_array = {getfield granulex value}

	ylength_granule_cell_array = {getfield granuley value}

	//- set mossy fiber dimensions

	xnumber_mossy_fibers = {getfield mossyx value}

	ynumber_mossy_fibers = {getfield mossyy value}

	//- go to previous element

	pope
end


///
/// SH:	SettingsSetRandomization
///
/// DE:	Reset settings widgets for randomization form
///

function SettingsSetRandomization

	//- hide cellNumbers form

	xhide /settings/subs/randomization

	//- switch to cellNumbers form

	pushe /settings/subs/randomization

	//- set leak conductance boundaries

	Vm_init_lb = {getfield Vm_init_lb value}
	Vm_init_ub = {getfield Vm_init_ub value}

	Granule_E_leak_lb = {getfield Granule_E_leak_lb value}
	Granule_E_leak_ub = {getfield Granule_E_leak_ub value}

	Golgi_E_leak_lb = {getfield Golgi_E_leak_lb value}
	Golgi_E_leak_ub = {getfield Golgi_E_leak_ub value}

	//- go to previous element

	pope
end


///
/// SH:	SettingsSetMisc
///
/// DE:	Reset settings widgets for misc form
///

function SettingsSetMisc

	//- hide misc orm

	xhide /settings/subs/misc

	//- switch to misc form

	pushe /settings/subs/misc

	//- set Golgi separation

	Golgi_cell_separation = {getfield golgiSeparation value}

	//- set Golgi cell dendritic diameter

	Golgi_cell_dendritic_diameter = {getfield golgiDendrDia value}

	//- set Golgi cell axon overlap

	Golgi_cell_axon_overlap = {getfield golgiAxonOverlap value}

	//- set mossy fiber to granule cell connection radius

	mossy_fiber_to_granule_cell_connection_radius \
		= {getfield mossyGranRadius value}

	//- set parallel fiber length

	parallel_fiber_length = {getfield parallelLength value}

	//- set parallel fiber conduction speed

	parallel_fiber_conduction_velocity = {getfield parallelSpeed value}

	//- set weight and delay distributions

	weight_distribution = {getfield weightDistr value}

	delay_distribution = {getfield delayDistr value}

	//- go to previous element

	pope
end


///
/// SH:	SettingsSetMossyGran
///
/// DE:	Reset settings widget to their previous values for mossyGran form
///

function SettingsSetMossyGran

	//- hide mossyGran form

	xhide /settings/subs/mossyGran

	//- make settings form current

	pushe /settings/subs/mossyGran

	//- set synaptic weight, delay, probability

	weight_mossy_fiber_granule_cell_AMPA_synapse \
		= {getfield ampaWeight value}

	weight_mossy_fiber_granule_cell_NMDA_synapse \
		= {getfield NMDAWeight value}

	delay_mossy_fiber_granule_cell_synapse = {getfield delayShared value}

	mean_mossy_fiber_granule_cell_connections \
		= {getfield meanConnections value}

	//! probability automatically calculated

	//P_mossy_fiber_to_granule_cell_synapse = {getfield prop value}

	//- go back to previous current element

	pope
/*
**
	// remember there was no change for mossy - granule synapse settings

	setfield /settings \
		statusMossyGran 0
*/
end


///
/// SH:	SettingsSetMossyGolgi
///
/// DE:	Reset settings widget to their previous values for mossyGolgi form
///

function SettingsSetMossyGolgi

	//- hide mossyGolgi form

	xhide /settings/subs/mossyGolgi

	//- make settings form current

	pushe /settings/subs/mossyGolgi

	//- set synaptic weight, delay, probability

	weight_mossy_fiber_Golgi_cell_synapse = {getfield ampaWeight value}

	delay_mossy_fiber_Golgi_cell_synapse = {getfield delay value}

	P_mossy_fiber_to_Golgi_cell_synapse = {getfield prop value}

	//- go back to previous current element

	pope
/*
**
	// remember there was no change for mossy - granule synapse settings

	setfield /settings \
		statusMossyGolgi 0
*/
end


///
/// SH:	SettingsSetGranGolgi
///
/// DE:	Reset settings widget to their previous values for granGolgi form
///

function SettingsSetGranGolgi

	//- hide granGolgi form

	xhide /settings/subs/granGolgi

	//- make settings form current

	pushe /settings/subs/granGolgi

	//- set synaptic weight, probability

	weight_granule_cell_Golgi_cell_synapse = {getfield ampaWeight value}

	P_granule_cell_to_Golgi_cell_synapse = {getfield prop value}

	//- go back to previous current element

	pope
/*
**
	// remember there was no change for mossy - granule synapse settings

	setfield /settings \
		statusGranGolgi 0
*/
end


///
/// SH:	SettingsSetGolgiGran
///
/// DE:	Reset settings widget to their previous values for golgiGran form
///

function SettingsSetGolgiGran

	//- hide golgiGran form

	xhide /settings/subs/golgiGran

	//- make settings form current

	pushe /settings/subs/golgiGran

	//- set synaptic weights, delay, probability

	weight_Golgi_cell_granule_cell_GABAA_synapse \
		= {getfield gabaaWeight value}

	weight_Golgi_cell_granule_cell_GABAB_synapse \
		= {getfield gababWeight value}

	delay_Golgi_cell_granule_cell_synapse = {getfield delayShared value}

	P_Golgi_cell_to_granule_cell_synapse = {getfield prop value}

	//- go back to previous current element

	pope
/*
**
	// remember there was no change for mossy - granule synapse settings

	setfield /settings \
		statusGolgiGran 0
*/
end


///
/// SH:	SettingsSet
///
/// DE:	Configure network from settings widget values
///

function SettingsSet

	//- give diagnostics

	echo "Reconfiguring network..." -n
/*
	//- default : no dynamic change

	bChangeDynamic = 0

	//- remember new Golgi dimensions

	int new_xlength_Golgi_cell_array \
		= {getfield /settings/config/golgix value}

	int new_ylength_Golgi_cell_array \
		= {getfield /settings/config/golgiy value}

	//- remember new granule dimensions

	int new_xlength_granule_cell_array \
		= {getfield /settings/config/granulex value}

	int new_ylength_granule_cell_array \
		= {getfield /settings/config/granuley value}

	//- if dimensions changed

	if ( {new_xlength_Golgi_cell_array} != {xlength_Golgi_cell_array} \
		|| {new_ylength_Golgi_cell_array} != {ylength_Golgi_cell_array} \
		|| {new_xlength_granule_cell_array} != {xlength_granule_cell_array} \
		|| {new_ylength_granule_cell_array} != {ylength_granule_cell_array} )

		//- set Golgi dimensions

		xlength_Golgi_cell_array = {new_xlength_Golgi_cell_array}
		ylength_Golgi_cell_array = {new_ylength_Golgi_cell_array}

		//- set granule dimensions

		xlength_granule_cell_array = {new_xlength_granule_cell_array}
		ylength_granule_cell_array = {new_ylength_granule_cell_array}

		//- remember : dynamic change

		bChangeDynamic = 1
	end

	//- set new mossy - granule synapse parameters

	float new_weight_mossy_fiber_granule_cell_AMPA_synapse \
		= {getfield /settings/mossyGran/ampaWeight value}
	float new_weight_mossy_fiber_granule_cell_NMDA_synapse \
		= {getfield /settings/mossyGran/NMDAWeight value}
	float new_delay_mossy_fiber_granule_cell_synapse \
		= {getfield /settings/mossyGran/delayShared value}

	//- if mossy - granule synapses changed

	if ( {new_weight_mossy_fiber_granule_cell_AMPA_synapse != weight_mossy_fiber_granule_cell_AMPA_synapse} \
		|| {new_weight_mossy_fiber_granule_cell_NMDA_synapse != weight_mossy_fiber_granule_cell_NMDA_synapse} \
		|| {new_delay_mossy_fiber_granule_cell_synapse != delay_mossy_fiber_granule_cell_synapse} )

		//- set new mossy - granule synapses

		weight_mossy_fiber_granule_cell_AMPA_synapse \
			= new_weight_mossy_fiber_granule_cell_AMPA_synapse
		weight_mossy_fiber_granule_cell_NMDA_synapse \
			= new_weight_mossy_fiber_granule_cell_NMDA_synapse
		delay_mossy_fiber_granule_cell_synapse \
			= new_delay_mossy_fiber_granule_cell_synapse

		//- remember : dynamic change

		bChangeDynamic = 1
	end
*/

	//- if network did change

	if (bChangeDynamic)

		//- update the config file

		ConfigUpdate

		//- set simulation status : restart

		echo 1 > ../simulation.status

		//- give diagnostics : restart

		echo "done"
		echo "Restarting genesis"

		//- exit to restart

		exit
	end

	//- if static settings did change

	if (bChangeStatic)
/*
		//- set synaptic weights

		weight_mossy_fiber_granule_cell_AMPA_synapse \
			= {getfield ampa value}
		weight_mossy_fiber_granule_cell_NMDA_synapse \
			= {getfield NMDA value}
		weight_mossy_fiber_Golgi_cell_synapse \
			= {getfield mossyGolgiAMPA value}
		weight_granule_cell_Golgi_cell_synapse \
			= {getfield granGolgiAMPA value}
		weight_Golgi_cell_granule_cell_GABAA_synapse \
			= {getfield golgiGranGABAA value}
		weight_Golgi_cell_granule_cell_GABAB_synapse \
			= {getfield golgiGranGABAB value}
*/
		//- set up synapses

		GranularLayerSynapses
	end

	//- if randomization did change

	if (bChangeRandomization)

		//- do randomization

		GranularRandomizeGranules
		GranularRandomizeGolgis
	end

	//- give diagnostics : done

	echo "done"
end


///
/// SH:	SettingsChangeDynamic
///
/// PA:	widget:	toggled widget
///	value.:	value in toggled widget
///
/// DE:	Remember static settings have been changed
///

function SettingsChangeDynamic(widget,value)

str widget
str value

	//- remember dynamic settings have been changed

	bChangeDynamic = 1

	//- update status information

	SettingsUpdateStatus
end


///
/// SH:	SettingsChangeStatic
///
/// PA:	widget:	toggled widget
///	value.:	value in toggled widget
///
/// DE:	Remember static settings have been changed
///

function SettingsChangeStatic(widget,value)

str widget
str value

	//- remember static settings have been changed

	bChangeStatic = 1

	//- update status information

	SettingsUpdateStatus
end


///
/// SH:	SettingsChangeRandomization
///
/// PA:	widget:	toggled widget
///	value.:	value in toggled widget
///
/// DE:	Remember randomization settings have been changed
///

function SettingsChangeRandomization(widget,value)

str widget
str value

	//- remember randomization settings have been changed

	bChangeRandomization = 1

	//- update status information

	SettingsUpdateStatus
end


///
/// SH:	SettingsCreateSubwindows
///
/// DE:	Create settings subwindows in element '/settings/subs/'
///
///	cellNumbers
///	randomization
///	misc
///	mossyGran
///	mossyGolgi
///	granGolgi
///	golgiGran
///

function SettingsCreateSubwindows

	//- create cellNumbers form

	create xform /settings/subs/cellNumbers \
		[200,200,500,180]

	//- make it current element

	pushe ^

	//- create header label

	create xlabel header1 \
		-title "Network configuration settings"

	create xlabel header2 \
		-title "Cell numbers"

	//- create widgets for Golgi cells

	create xlabel golgicells \
		-ygeom 4:header2.bottom \
		-wgeom 40% \
		-title "Number of Golgi  cells : "

//! If I arranged golgicells, golgix and golgiy's wgeom fields as 70%, 15% and
//! 15%, I got following X Error :
//!
//! X Error of failed request:  BadValue (integer parameter out of range for operation)
//!  Major opcode of failed request:  12 (X_ConfigureWindow)
//!  Value in failed request:  0x0
//!  Serial number of failed request:  4764
//!  Current serial number in output stream:  4779
//!

	create xdialog golgix \
		-xgeom 0:last.right \
		-ygeom 0:header2.bottom \
		-wgeom 30% \
		-title " X " \
		-script "SettingsChangeDynamic <w>"

	create xdialog golgiy \
		-xgeom 0:last.right \
		-ygeom 0:header2.bottom \
		-wgeom 30% \
		-title " Y " \
		-script "SettingsChangeDynamic <w>"

	//- create widgets for granule cells

	create xlabel granulecells \
		-ygeom 6:golgicells.bottom \
		-wgeom 40% \
		-title "Number of granule cells : "

	create xdialog granulex \
		-xgeom 0:last.right \
		-ygeom 3:golgicells.bottom \
		-wgeom 30% \
		-title " X " \
		-script "SettingsChangeDynamic <w>"

	create xdialog granuley \
		-xgeom 0:last.right \
		-ygeom 3:golgicells.bottom \
		-wgeom 30% \
		-title " Y " \
		-script "SettingsChangeDynamic <w>"

	//- create widgets for mossy fibers

	create xlabel mossyfibers \
		-ygeom 6:granulecells.bottom \
		-wgeom 40% \
		-title "Number of mossy fibers : "

	create xdialog mossyx \
		-xgeom 0:last.right \
		-ygeom 3:granulecells.bottom \
		-wgeom 30% \
		-title " X " \
		-script "SettingsChangeDynamic <w>"

	create xdialog mossyy \
		-xgeom 0:last.right \
		-ygeom 3:granulecells.bottom \
		-wgeom 30% \
		-title " Y " \
		-script "SettingsChangeDynamic <w>"

	//- create ok and reset buttons

	create xbutton reset \
		-xgeom 0% \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Reset" \
		-script "SettingsResetCellNumbers"

	create xbutton ok \
		-xgeom 0:last.right \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Ok" \
		-script "SettingsSetCellNumbers"

	//- go to previous element

	pope

	//- create randomization form

	create xform /settings/subs/randomization \
		[200,200,700,180]

	//- make it current element

	pushe ^

	//- create header label

	create xlabel header1 \
		-title "Network configuration settings"

	create xlabel header2 \
		-title "Randomization and initialization"

	//- create labels and dialogs for initial voltage

	create xlabel Vm_init \
		-ygeom 4:header2.bottom \
		-wgeom 40% \
		-title "Initial voltage (V) : "

	create xdialog Vm_init_lb \
		-xgeom 0:last.right \
		-ygeom 0:header2.bottom \
		-wgeom 30% \
		-title "Upper limit : " \
		-script "SettingsChangeRandomization <w>"

	create xdialog Vm_init_ub \
		-xgeom 0:last.right \
		-ygeom 0:header2.bottom \
		-wgeom 30% \
		-title "Lower limit : " \
		-script "SettingsChangeRandomization <w>"

	//- create labels and dialogs for granule leak

	create xlabel Granule_E_leak \
		-ygeom 8:Vm_init.bottom \
		-wgeom 40% \
		-title "Granule cell leak conductance (S) : "

	create xdialog Granule_E_leak_lb \
		-xgeom 0:last.right \
		-ygeom 0:Vm_init_lb \
		-wgeom 30% \
		-title "Upper limit : " \
		-script "SettingsChangeRandomization <w>"

	create xdialog Granule_E_leak_ub \
		-xgeom 0:last.right \
		-ygeom 0:Vm_init_lb \
		-wgeom 30% \
		-title "Lower limit : " \
		-script "SettingsChangeRandomization <w>"

	//- create labels and dialogs for Golgi leak

	create xlabel Golgi_E_leak \
		-ygeom 8:Granule_E_leak \
		-wgeom 40% \
		-title "Golgi cell leak conductance (S) :"

	create xdialog Golgi_E_leak_lb \
		-xgeom 0:last.right \
		-ygeom 0:Granule_E_leak_ub \
		-wgeom 30% \
		-title "Upper limit : " \
		-script "SettingsChangeRandomization <w>"

	create xdialog Golgi_E_leak_ub \
		-xgeom 0:last.right \
		-ygeom 0:Granule_E_leak_ub \
		-wgeom 30% \
		-title "Lower limit : " \
		-script "SettingsChangeRandomization <w>"

	//- create ok and reset buttons

	create xbutton reset \
		-xgeom 0% \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Reset" \
		-script "SettingsResetRandomization"

	create xbutton ok \
		-xgeom 0:last.right \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Ok" \
		-script "SettingsSetRandomization"

	//- go to previous element

	pope

	//- create misc form

	create xform /settings/subs/misc \
		[200,200,500,300]

	//- make it current element

	pushe ^

	//- create header label

	create xlabel header1 \
		-title "Network configuration settings"

	create xlabel header2 \
		-title "Miscellaneous settings"

	//- create widget for Golgi separation

	create xdialog golgiSeparation \
		-title "Golgi   cell   separation     : " \
		-script "SettingsChangeDynamic <w>"

	//- create widget for Golgi cell dendritic diameter

	create xdialog golgiDendrDia \
		-title "Golgi cell dendritic diameter : " \
		-script "SettingsChangeDynamic <w>"

	//- create widget for Golgi cell axon overlap

	create xdialog golgiAxonOverlap \
		-title "Golgi  cell  axon  overlap    : " \
		-script "SettingsChangeDynamic <w>"

	//- create widget for mossy fiber to granule cell connection radius

	create xdialog mossyGranRadius \
		-title "Mossy fiber to granule cell connection radius : " \
		-script "SettingsChangeDynamic <w>"

	//- create widget for parallel fiber length

	create xdialog parallelLength \
		-wgeom 55% \
		-title "Parallel fiber length : " \
		-script "SettingsChangeDynamic <w>"

	//- create widget for parallel fiber conduction speed

	create xdialog parallelSpeed \
		-xgeom 0:parallelLength.right \
		-ygeom 0:mossyGranRadius \
		-wgeom 45% \
		-title "Conduction speed : " \
		-script "SettingsChangeStatic <w>"

	//- create dialogs for weight and delay distributions

	create xdialog weightDistr \
		-title "Weight distribution : " \
		-script "SettingsChangeStatic <w>"

	create xdialog delayDistr \
		-title "Delay  distribution : " \
		-script "SettingsChangeStatic <w>"

	//- create ok and reset buttons

	create xbutton reset \
		-xgeom 0% \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Reset" \
		-script "SettingsResetMisc"

	create xbutton ok \
		-xgeom 0:last.right \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Ok" \
		-script "SettingsSetMisc"

	//- go to previous element

	pope

	//- create mossyGran form

	create xform /settings/subs/mossyGran \
		[200,200,500,230]

	//- make it current element

	pushe ^

	//- create header label

	create xlabel header1 \
		-title "Network configuration settings"

	create xlabel header2 \
		-title "Mossy fiber - granule cell settings"

	//- create weight and delay labels and dialogs

	create xlabel ampaLabel \
		-ygeom 4:header2.bottom \
		-wgeom 70% \
		-title "Mossy fiber to granule cell : AMPA "

	create xdialog ampaWeight \
		-xgeom 0:last.right \
		-ygeom 0:header2.bottom \
		-wgeom 30% \
		-title "Weight = " \
		-script "SettingsChangeStatic <w>"

	create xlabel NMDALabel \
		-ygeom 6:ampaLabel.bottom \
		-wgeom 70% \
		-title "Mossy fiber to granule cell : NMDA "

	create xdialog NMDAWeight \
		-xgeom 0:last.right \
		-ygeom 3:ampaLabel.bottom \
		-wgeom 30% \
		-title "Weight = " \
		-script "SettingsChangeStatic <w>"

	create xlabel delayLabel \
		-ygeom 6:NMDALabel \
		-wgeom 70% \
		-title "Mossy fiber to granule cell : "

	create xdialog delayShared \
		-xgeom 0:last.right \
		-ygeom 3:NMDALabel.bottom \
		-wgeom 30% \
		-title "Delay  = " \
		-script "SettingsChangeStatic <w>"

	create xdialog meanConnections \
		-title "Mean number of connections : " \
		-script "SettingsChangeDynamic <w>"

	create xlabel prop \
		-wgeom 80% \
		-title "Mossy fiber to granule cell connection probability : "
		//-script "SettingsChangeDynamic <w>"

	create xlabel propValue \
		-xgeom 0:last.right \
		-ygeom 0:meanConnections.bottom \
		-wgeom 20% \
		-title {P_mossy_fiber_to_granule_cell_synapse}

	//- create ok and reset buttons

	create xbutton reset \
		-xgeom 0% \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Reset" \
		-script "SettingsResetMossyGran"

	create xbutton ok \
		-xgeom 0:last.right \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Ok" \
		-script "SettingsSetMossyGran"

	//- go to previous element

	pope

	//- create mossyGolgi form

	create xform /settings/subs/mossyGolgi \
		[200,200,500,180]

	//- make it current element

	pushe ^

	//- create header label

	create xlabel header1 \
		-title "Network configuration settings"

	create xlabel header2 \
		-title "Mossy fiber - Golgi cell settings"

	//- create weight and delay labels and dialogs

	create xlabel ampaLabel \
		-ygeom 4:header2.bottom \
		-wgeom 70% \
		-title "Mossy fiber to Golgi cell : AMPA "

	create xdialog ampaWeight \
		-xgeom 0:last.right \
		-ygeom 0:header2.bottom \
		-wgeom 30% \
		-title "Weight = " \
		-script "SettingsChangeStatic <w>"

	create xlabel delayLabel \
		-ygeom 6:ampaLabel \
		-wgeom 70% \
		-title "Mossy fiber to Golgi cell : "

	create xdialog delay \
		-xgeom 0:last.right \
		-ygeom 3:ampaLabel.bottom \
		-wgeom 30% \
		-title "Delay  = " \
		-script "SettingsChangeStatic <w>"

	create xdialog prop \
		-title "Mossy fiber to Golgi cell connection probability : " \
		-script "SettingsChangeDynamic <w>"

	//- create ok and reset buttons

	create xbutton reset \
		-xgeom 0% \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Reset" \
		-script "SettingsResetMossyGolgi"

	create xbutton ok \
		-xgeom 0:last.right \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Ok" \
		-script "SettingsSetMossyGolgi"

	//- go to previous element

	pope

	//- create granGolgi form

	create xform /settings/subs/granGolgi \
		[200,200,500,150]

	//- make it current element

	pushe ^

	//- create header label

	create xlabel header1 \
		-title "Network configuration settings"

	create xlabel header2 \
		-title "Granule cell - Golgi cell settings"

	//- create weight label and dialog

	create xlabel ampaLabel \
		-ygeom 4:header2.bottom \
		-wgeom 70% \
		-title "Granule cell to Golgi cell : AMPA "

	create xdialog ampaWeight \
		-xgeom 0:last.right \
		-ygeom 0:header2.bottom \
		-wgeom 30% \
		-title "Weight = " \
		-script "SettingsChangeStatic <w>"

	create xdialog prop \
		-title "Granule cell to Golgi cell connection probability : " \
		-script "SettingsChangeDynamic <w>"

	//- create ok and reset buttons

	create xbutton reset \
		-xgeom 0% \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Reset" \
		-script "SettingsResetGranGolgi"

	create xbutton ok \
		-xgeom 0:last.right \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Ok" \
		-script "SettingsSetGranGolgi"

	//- go to previous element

	pope

	//- create mossyGolgi form

	create xform /settings/subs/golgiGran \
		[200,200,500,200]

	//- make it current element

	pushe ^

	//- create header label

	create xlabel header1 \
		-title "Network configuration settings"

	create xlabel header2 \
		-title "Golgi cell - granule cell settings"

	//- create weight and delay labels and dialogs

	create xlabel gabaaLabel \
		-ygeom 4:header2.bottom \
		-wgeom 70% \
		-title "Golgi cell to granule cell : GABA_A"

	create xdialog gabaaWeight \
		-xgeom 0:last.right \
		-ygeom 0:header2.bottom \
		-wgeom 30% \
		-title "Weight = " \
		-script "SettingsChangeStatic <w>"

	create xlabel gababLabel \
		-ygeom 6:gabaaLabel.bottom \
		-wgeom 70% \
		-title "Golgi cell to granule cell : GABA_B"

	create xdialog gababWeight \
		-xgeom 0:last.right \
		-ygeom 3:gabaaLabel.bottom \
		-wgeom 30% \
		-title "Weight = " \
		-script "SettingsChangeStatic <w>"

	create xlabel delayLabel \
		-ygeom 6:gababLabel \
		-wgeom 70% \
		-title "Golgi cell to granule cell : "

	create xdialog delayShared \
		-xgeom 0:last.right \
		-ygeom 3:gababLabel.bottom \
		-wgeom 30% \
		-title "Delay  = " \
		-script "SettingsChangeStatic <w>"

	create xdialog prop \
		-title "Mossy fiber to Golgi cell connection probability : " \
		-script "SettingsChangeDynamic <w>"

	//- create ok and reset buttons

	create xbutton reset \
		-xgeom 0% \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Reset" \
		-script "SettingsResetGolgiGran"

	create xbutton ok \
		-xgeom 0:last.right \
		-ygeom 0:parent.bottom \
		-wgeom 50% \
		-title "Ok" \
		-script "SettingsSetGolgiGran"

	//- go to previous element

	pope
end


///
/// SH:	SettingsInit
///
/// DE:	Create settings elements and settings interface elements
///

function SettingsInit

	//- give diagnostics

	echo "Initializing network setup interface"

	//- create neutral container

	create neutral /settings

/*
** obsolete
**
	//- add field for config status

	addfield ^ \
		statusConfig -description "Configuration status"

	//- add field for mossy - granule status

	addfield ^ \
		statusMossyGran -description "Mossy - granule synapse status"
*/

	//- create settings form

	create xform /settings/config \
		[310,500,420,270]

	//- make it current element

	pushe ^

	//- create header label

	create xlabel header1 \
		-title "Network configuration settings"

	//- create button for number of cells

	create xbutton cellNumbers \
		-title "Cell numbers" \
		-script "xshow /settings/subs/cellNumbers"

	//- create button for randomization

	create xbutton randomization \
		-title "Randomization and initialization" \
		-script "xshow /settings/subs/randomization"

	//- create button for mossy fiber to granule cell connection

	create xbutton mossyGran \
		-title "Mossy fiber - Granule cell synapses" \
		-script "xshow /settings/subs/mossyGran"

	//- create button for mossy fiber to Golgi cell connection

	create xbutton mossyGolgi \
		-title "Mossy fiber - Golgi cell synapses" \
		-script "xshow /settings/subs/mossyGolgi"

	//- create button for granule cell to Golgi cell connection

	create xbutton granGolgi \
		-title "Granule cell - Golgi cell synapses" \
		-script "xshow /settings/subs/granGolgi"

	//- create button for Golgi cell to granule cell connection

	create xbutton golgiGran \
		-title "Golgi cell - granule cell synapses" \
		-script "xshow /settings/subs/golgiGran"

	//- create button for miscellaneous settings

	create xbutton misc \
		-title "Miscellaneous settings" \
		-script "xshow /settings/subs/misc"

	//- create ok, cancel and reset buttons

	create xbutton cancel \
		-xgeom 0% \
		-ygeom 0:parent.bottom \
		-wgeom 33% \
		-title "Cancel" \
		-script "xhide /settings/config"

	create xbutton reset \
		-xgeom 0:last.right \
		-ygeom 0:parent.bottom \
		-wgeom 34% \
		-title "Reset all" \
		-script "SettingsReset"

	create xbutton apply \
		-xgeom 0:last.right \
		-ygeom 0:parent.bottom \
		-wgeom 33% \
		-title "Apply" \
		-script "SettingsSet"

	//- create status info widgets

	create xlabel statusInfo \
		-xgeom 0% \
		-ygeom 0:cancel.top \
		-wgeom 33% \
		-title "Status : "

	create xlabel status \
		-xgeom 0:statusInfo.right \
		-ygeom 0:cancel.top \
		-wgeom 67% \
		-title "No information available"

	//- pop to previous element

	pope

	//- create neutral for subwindows

	create neutral /settings/subs

	//- create subwindows

	SettingsCreateSubwindows
end


///
/// SH:	SettingsShow
///
/// DE:	Show settings interface form
///

function SettingsShow

	//- reset settings widgets to their previous values

	//! if any subforms are still visible, they will get an update for
	//! their widget values, this is in fact not really what we want.

	SettingsReset

	//- show input form

	xshow /settings/config
end


end


