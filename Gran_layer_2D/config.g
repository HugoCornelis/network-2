//genesis
//
// $Id: config.g 1.19 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// config.g : network configuration file interface script

int include_config

if ( {include_config} == 0 )

	include_config = 1


//- include config constants for declaration and defaults

include Gran_layer_const.g


//o here are some extra parameters that Reinoud did not define

int mean_mossy_fiber_granule_cell_connections = 4


///
/// SH:	ConfigUpdate
///
/// DE:	Update the configuration file from the current config
///

function ConfigUpdate

	str filename = "../simulation.config"

	//- remove old config file

	sh "rm "{filename}

	//- open config file

	openfile {filename} w

	//- write header

	writefile {filename} "Cerebellar cortex simulation configuration"
	writefile {filename} "------------------------------------------"

	//- write new config values to file

	writefile {filename} \
		"int xlength_Golgi_cell_array (cells) "{xlength_Golgi_cell_array}
	writefile {filename} \
		"int ylength_Golgi_cell_array (cells) "{ylength_Golgi_cell_array}
	writefile {filename} \
		"int xlength_granule_cell_array (cells) "{xlength_granule_cell_array}
	writefile {filename} \
		"int ylength_granule_cell_array (cells) "{ylength_granule_cell_array}
/*
	writefile {filename} \
		"int mossy_fiber_to_Golgi_cell_ratio (ratio1D) "{mossy_fiber_to_Golgi_cell_ratio}
*/
	writefile {filename} \
		"int xnumber_mossy_fibers (cells) "{xnumber_mossy_fibers}
	writefile {filename} \
		"int ynumber_mossy_fibers (cells) "{ynumber_mossy_fibers}
	writefile {filename} \
		"float Golgi_cell_separation (meter) "{Golgi_cell_separation}
	writefile {filename} \
		"float Golgi_cell_dendritic_diameter (meter) "{Golgi_cell_dendritic_diameter}
/*
	writefile {filename} \
		"int stellate_cell_to_Golgi_cell_ratio (ratio1D) "{stellate_cell_to_Golgi_cell_ratio}
*/
	writefile {filename} \
		"float mossy_fiber_to_granule_cell_connection_radius (mossy_fiber_separation) "{mossy_fiber_to_granule_cell_connection_radius}
	writefile {filename} \
		"int Golgi_cell_axon_overlap (Golgi_cell_separation) "{Golgi_cell_axon_overlap}
	writefile {filename} \
		"float parallel_fiber_length (meter) "{parallel_fiber_length}
	writefile {filename} \
		"float weight_mossy_fiber_granule_cell_AMPA_synapse (relative) "{weight_mossy_fiber_granule_cell_AMPA_synapse}
	writefile {filename} \
		"float weight_mossy_fiber_granule_cell_NMDA_synapse (relative) "{weight_mossy_fiber_granule_cell_NMDA_synapse}
	writefile {filename} \
		"float weight_mossy_fiber_Golgi_cell_synapse (relative) "{weight_mossy_fiber_Golgi_cell_synapse}
	writefile {filename} \
		"float weight_granule_cell_Golgi_cell_synapse (relative) "{weight_granule_cell_Golgi_cell_synapse}
	writefile {filename} \
		"float weight_Golgi_cell_granule_cell_GABAA_synapse (relative) "{weight_Golgi_cell_granule_cell_GABAA_synapse}
	writefile {filename} \
		"float weight_Golgi_cell_granule_cell_GABAB_synapse (relative) "{weight_Golgi_cell_granule_cell_GABAB_synapse}
	writefile {filename} \
		"float delay_mossy_fiber_granule_cell_synapse (s) "{delay_mossy_fiber_granule_cell_synapse}
	writefile {filename} \
		"float delay_mossy_fiber_Golgi_cell_synapse (s) "{delay_mossy_fiber_Golgi_cell_synapse}
/*
	writefile {filename} \
		"float delay_granule_cell_Golgi_cell_synapse (s) "{delay_granule_cell_Golgi_cell_synapse}
*/
	writefile {filename} \
		"float delay_Golgi_cell_granule_cell_synapse (s) "{delay_Golgi_cell_granule_cell_synapse}
/*
	writefile {filename} \
		"float delay_stellate_cell_Golgi_cell_synapse (s) "{delay_stellate_cell_Golgi_cell_synapse}
*/
	writefile {filename} \
		"float parallel_fiber_conduction_velocity (m/s) "{parallel_fiber_conduction_velocity}
	writefile {filename} \
		"float weight_distribution (relative) "{weight_distribution}
	writefile {filename} \
		"float delay_distribution (relative) "{delay_distribution}
	writefile {filename} \
		"float P_mossy_fiber_to_Golgi_cell_synapse (probability) "{P_mossy_fiber_to_Golgi_cell_synapse}
	writefile {filename} \
		"float P_granule_cell_to_Golgi_cell_synapse (probability) "{P_granule_cell_to_Golgi_cell_synapse}
	writefile {filename} \
		"float P_Golgi_cell_to_granule_cell_synapse (probability) "{P_Golgi_cell_to_granule_cell_synapse}
	writefile {filename} \
		"float P_mossy_fiber_to_granule_cell_synapse (probability) "{P_mossy_fiber_to_granule_cell_synapse}
	writefile {filename} \
		"float P_stellate_cell_to_Golgi_cell_synapse (probability) "{P_stellate_cell_to_Golgi_cell_synapse}
	writefile {filename} \
		"float P_granule_cell_to_stellate_cell_synapse (probability) "{P_granule_cell_to_stellate_cell_synapse}
	writefile {filename} \
		"int mean_mossy_fiber_granule_cell_connections (connections) "{mean_mossy_fiber_granule_cell_connections}

	//- close config file

	closefile {filename}
end


///
/// SH:	ConfigRead
///
/// DE:	Setup constants from config file
///

function ConfigRead

	str filename = "../simulation.config"

	//- give diagnostics

	echo "Reading config from "{filename}

	//v read data from config file

	str argline
	str arg1
	str arg2
	str arg3

	//- open config file

	openfile {filename} r

	//- read header

	argline = {readfile {filename} -line}

	argline = {readfile {filename} -line}

	// check header

	//- obtain number of Golgi cells

	argline = {readfile {filename} -line}

	xlength_Golgi_cell_array = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	ylength_Golgi_cell_array = {getarg {arglist {argline}} -arg 4}

	//- obtain number of granule cells

	argline = {readfile {filename} -line}

	xlength_granule_cell_array = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	ylength_granule_cell_array = {getarg {arglist {argline}} -arg 4}

	//- obtain number of mossy fibers

	argline = {readfile {filename} -line}

	xnumber_mossy_fibers = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	ynumber_mossy_fibers = {getarg {arglist {argline}} -arg 4}

	//- get misc settings

	argline = {readfile {filename} -line}

	Golgi_cell_separation = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	Golgi_cell_dendritic_diameter = {getarg {arglist {argline}} -arg 4}
/*
	argline = {readfile {filename} -line}

	stellate_cell_to_Golgi_cell_ratio = {getarg {arglist {argline}} -arg 4}
*/
	argline = {readfile {filename} -line}

	mossy_fiber_to_granule_cell_connection_radius = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	Golgi_cell_axon_overlap = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	parallel_fiber_length = {getarg {arglist {argline}} -arg 4}

	//- get weights

	argline = {readfile {filename} -line}

	weight_mossy_fiber_granule_cell_AMPA_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	weight_mossy_fiber_granule_cell_NMDA_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	weight_mossy_fiber_Golgi_cell_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	weight_granule_cell_Golgi_cell_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	weight_Golgi_cell_granule_cell_GABAA_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	weight_Golgi_cell_granule_cell_GABAB_synapse = {getarg {arglist {argline}} -arg 4}

	//- get delays

	argline = {readfile {filename} -line}

	delay_mossy_fiber_granule_cell_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	delay_mossy_fiber_Golgi_cell_synapse = {getarg {arglist {argline}} -arg 4}
/*
	argline = {readfile {filename} -line}

	delay_granule_cell_Golgi_cell_synapse = {getarg {arglist {argline}} -arg 4}
*/
	argline = {readfile {filename} -line}

	delay_Golgi_cell_granule_cell_synapse = {getarg {arglist {argline}} -arg 4}

/*
	argline = {readfile {filename} -line}

	delay_stellate_cell_Golgi_cell_synapse = {getarg {arglist {argline}} -arg 4}
*/

	//- get more misc settings

	argline = {readfile {filename} -line}

	parallel_fiber_conduction_velocity = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	weight_distribution = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	delay_distribution = {getarg {arglist {argline}} -arg 4}

	//- get connection probabilities

	argline = {readfile {filename} -line}

	P_mossy_fiber_to_Golgi_cell_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	P_granule_cell_to_Golgi_cell_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	P_Golgi_cell_to_granule_cell_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	P_mossy_fiber_to_granule_cell_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	P_stellate_cell_to_Golgi_cell_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	P_granule_cell_to_stellate_cell_synapse = {getarg {arglist {argline}} -arg 4}

	argline = {readfile {filename} -line}

	mean_mossy_fiber_granule_cell_connections = {getarg {arglist {argline}} -arg 4}

	//- create a configuration element

	create neutral /config

	//- add fields for number of Golgi cells

	addfield /config \
		xlength_Golgi_cell_array -description "(cells)"
	addfield /config \
		ylength_Golgi_cell_array -description "(cells)"
	addfield /config \
		xlength_granule_cell_array -description "(cells)"
	addfield /config \
		ylength_granule_cell_array -description "(cells)"
	addfield /config \
		Golgi_cell_separation -description "(meter)"
	addfield /config \
		Golgi_cell_dendritic_diameter -description "(meter)"
	addfield /config \
		xnumber_mossy_fibers -description "(cells)"
	addfield /config \
		ynumber_mossy_fibers -description "(cells)"
/*
	addfield /config \
		mossy_fiber_to_Golgi_cell_ratio -description "(ratio1D)"
*/
/*
	addfield /config \
		stellate_cell_to_Golgi_cell_ratio -description "(ratio1D)"
*/
	addfield /config \
		mossy_fiber_to_granule_cell_connection_radius -description "(mossy_fiber_separation)"
	addfield /config \
		Golgi_cell_axon_overlap -description "(Golgi_cell_separation)"
	addfield /config \
		parallel_fiber_length -description "(meter)"
	addfield /config \
		weight_mossy_fiber_granule_cell_AMPA_synapse -description "(relative)"
	addfield /config \
		weight_mossy_fiber_granule_cell_NMDA_synapse -description "(relative)"
	addfield /config \
		weight_mossy_fiber_Golgi_cell_synapse -description "(relative)"
	addfield /config \
		weight_granule_cell_Golgi_cell_synapse -description "(relative)"
	addfield /config \
		weight_Golgi_cell_granule_cell_GABAA_synapse -description "(relative)"
	addfield /config \
		weight_Golgi_cell_granule_cell_GABAB_synapse -description "(relative)"
	addfield /config \
		delay_mossy_fiber_granule_cell_synapse -description "(s)"
	addfield /config \
		delay_mossy_fiber_Golgi_cell_synapse -description "(s)"
/*
	addfield /config \
		delay_granule_cell_Golgi_cell_synapse -description "(s)"
*/
	addfield /config \
		delay_Golgi_cell_granule_cell_synapse -description "(s)"
/*
	addfield /config \
		delay_stellate_cell_Golgi_cell_synapse -description "(s)"
*/
	addfield /config \
		parallel_fiber_conduction_velocity -description "(m/s)"
	addfield /config \
		weight_distribution -description "(relative)"
	addfield /config \
		delay_distribution -description "(relative)"
	addfield /config \
		P_mossy_fiber_to_Golgi_cell_synapse -description "(probability)"
	addfield /config \
		P_granule_cell_to_Golgi_cell_synapse -description "(probability)"
	addfield /config \
		P_Golgi_cell_to_granule_cell_synapse -description "(probability)"
	addfield /config \
		P_mossy_fiber_to_granule_cell_synapse -description "(probability)"
	addfield /config \
		P_stellate_cell_to_Golgi_cell_synapse -description "(probability)"
	addfield /config \
		P_granule_cell_to_stellate_cell_synapse -description "(probability)"
	addfield /config \
		mean_mossy_fiber_granule_cell_connections -description "(connections)"

	//- set the config values

	setfield /config \
		xlength_Golgi_cell_array {xlength_Golgi_cell_array} \
		ylength_Golgi_cell_array {ylength_Golgi_cell_array} \
		xlength_granule_cell_array {xlength_granule_cell_array} \
		ylength_granule_cell_array {ylength_granule_cell_array} \
		Golgi_cell_separation {Golgi_cell_separation} \
		Golgi_cell_dendritic_diameter {Golgi_cell_dendritic_diameter} \
		xnumber_mossy_fibers {xnumber_mossy_fibers} \
		ynumber_mossy_fibers {ynumber_mossy_fibers} \
		mossy_fiber_to_granule_cell_connection_radius {mossy_fiber_to_granule_cell_connection_radius} \
		Golgi_cell_axon_overlap {Golgi_cell_axon_overlap} \
		parallel_fiber_length {parallel_fiber_length} \
		weight_mossy_fiber_granule_cell_AMPA_synapse {weight_mossy_fiber_granule_cell_AMPA_synapse} \
		weight_mossy_fiber_granule_cell_NMDA_synapse {weight_mossy_fiber_granule_cell_NMDA_synapse} \
		weight_mossy_fiber_Golgi_cell_synapse {weight_mossy_fiber_Golgi_cell_synapse} \
		weight_granule_cell_Golgi_cell_synapse {weight_granule_cell_Golgi_cell_synapse} \
		weight_Golgi_cell_granule_cell_GABAA_synapse {weight_Golgi_cell_granule_cell_GABAA_synapse} \
		weight_Golgi_cell_granule_cell_GABAB_synapse {weight_Golgi_cell_granule_cell_GABAB_synapse} \
		delay_mossy_fiber_granule_cell_synapse {delay_mossy_fiber_granule_cell_synapse} \
		delay_mossy_fiber_Golgi_cell_synapse {delay_mossy_fiber_Golgi_cell_synapse} \
		delay_Golgi_cell_granule_cell_synapse {delay_Golgi_cell_granule_cell_synapse} \
		parallel_fiber_conduction_velocity {parallel_fiber_conduction_velocity} \
		weight_distribution {weight_distribution} \
		delay_distribution {delay_distribution} \
		P_mossy_fiber_to_Golgi_cell_synapse {P_mossy_fiber_to_Golgi_cell_synapse} \
		P_granule_cell_to_Golgi_cell_synapse {P_granule_cell_to_Golgi_cell_synapse} \
		P_Golgi_cell_to_granule_cell_synapse {P_Golgi_cell_to_granule_cell_synapse} \
		P_mossy_fiber_to_granule_cell_synapse {P_mossy_fiber_to_granule_cell_synapse} \
		P_stellate_cell_to_Golgi_cell_synapse {P_stellate_cell_to_Golgi_cell_synapse} \
		P_granule_cell_to_stellate_cell_synapse {P_granule_cell_to_stellate_cell_synapse} \
		mean_mossy_fiber_granule_cell_connections {mean_mossy_fiber_granule_cell_connections}


/*		mossy_fiber_to_Golgi_cell_ratio {mossy_fiber_to_Golgi_cell_ratio} \
*/
//		delay_granule_cell_Golgi_cell_synapse {delay_granule_cell_Golgi_cell_synapse} \
//		stellate_cell_to_Golgi_cell_ratio {stellate_cell_to_Golgi_cell_ratio} \
//		delay_stellate_cell_Golgi_cell_synapse {delay_stellate_cell_Golgi_cell_synapse} \

end


///
/// SH:	ConfigRecalc
///
/// DE:	Recalculate configuration dependent globals from registered config
///

function ConfigRecalc

	//- calculate number of Golgi cells

	number_Golgi_cells = {{getfield /config xlength_Golgi_cell_array} \
				* {getfield /config ylength_Golgi_cell_array}}

	//- calculate number of granule cells

	number_granule_cells = {{getfield /config xlength_granule_cell_array} \
				* {getfield /config ylength_granule_cell_array}}

	//- calculate number of mossy fibers (x/y/total)
/*
	xnumber_mossy_fibers = {xlength_Golgi_cell_array \
				* mossy_fiber_to_Golgi_cell_ratio}
	ynumber_mossy_fibers = {ylength_Golgi_cell_array \
				* mossy_fiber_to_Golgi_cell_ratio}
*/
	number_mossy_fibers = {xnumber_mossy_fibers * ynumber_mossy_fibers}

	xmossy_fiber_to_Golgi_cell_ratio \
		= {{xnumber_mossy_fibers @ ".0"} / {{2 + xlength_Golgi_cell_array} @ ".0"}}
	ymossy_fiber_to_Golgi_cell_ratio \
		= {{ynumber_mossy_fibers @ ".0"} / {{2 + ylength_Golgi_cell_array} @ ".0"}}

/*
	mossy_fiber_to_Golgi_cell_ratio \
		= {min \
			{mossy_fiber_to_Golgi_cell_ratio} \
			{{ynumber_mossy_fibers @ ".0"} / {ylength_Golgi_cell_array @ ".0"}}}
*/
/*
	// calculate number of stellate cells from Golgi's and ratios

	number_stellate_cells = {{number_Golgi_cells} \
					* {stellate_cell_to_Golgi_cell_ratio} \
					* {stellate_cell_to_Golgi_cell_ratio}}
*/

	//- separation between adjacent mossy fibers

	xmossy_fiber_separation = {Golgi_cell_separation} / {xmossy_fiber_to_Golgi_cell_ratio} // meter
	ymossy_fiber_separation = {Golgi_cell_separation} / {ymossy_fiber_to_Golgi_cell_ratio} // meter

/*
	// separation between adjacent stellate cells

	stellate_cell_separation = {Golgi_cell_separation} / {stellate_cell_to_Golgi_cell_ratio} // meter
*/

	float xgranule_cell_separation \
		= {{Golgi_cell_separation} \
			* {xlength_Golgi_cell_array - 0} \
			/ {xlength_granule_cell_array - 0}}
	float ygranule_cell_separation \
		= {{Golgi_cell_separation} \
			* {ylength_Golgi_cell_array - 0} \
			/ {ylength_granule_cell_array - 0}}

	mossy_fiber_to_granule_cell_connection_radius \
		= {max {1.65 * xmossy_fiber_separation} {1.65 * ymossy_fiber_separation}}
/*
	mossy_fiber_to_granule_cell_connection_radius \
		= {max \
			{mossy_fiber_to_granule_cell_connection_radius} \
			{1 * xgranule_cell_separation}}
	mossy_fiber_to_granule_cell_connection_radius \
		= {max \
			{mossy_fiber_to_granule_cell_connection_radius} \
			{1 * ygranule_cell_separation}}
*/

	//- calculate # granules contacted by one mossy fiber

	float target_granules \
		= {{2 * mossy_fiber_to_granule_cell_connection_radius * 2 * mossy_fiber_to_granule_cell_connection_radius} \
			/ {xgranule_cell_separation * ygranule_cell_separation}}

	//- calculate # mossy fibers that can give input to one granule cell

	float source_mossys \
		= {{2 * mossy_fiber_to_granule_cell_connection_radius * 2 * mossy_fiber_to_granule_cell_connection_radius} \
			/ {xmossy_fiber_separation * ymossy_fiber_separation}}

	echo "# target granules for one mossy fiber : "{target_granules}
	echo "# source mossies for one granule cell : "{source_mossys}

	//- calculate connection probability based on connection numbers

	//! this assumes that for each source element and each candidate 
	//! destination element, a random number is generated and compared
	//! to this probability to decide if a connection should be 
	//! established.
	//! (So if the generated random number are uniform, the connection
	//! statistic will be binomial, the current genesis2.1 PlanarConnect()
	//! implementation obeys this rule.)

	P_mossy_fiber_to_granule_cell_synapse = {min 1 {mean_mossy_fiber_granule_cell_connections / source_mossys}}

	//- radius for mossy fiber to Golgi cell connections

	mossy_fiber_to_Golgi_cell_radius = {Golgi_cell_separation} / 2.0    // meter

	//- radius for Golgi cell to granule cell connections 

	Golgi_cell_to_granule_cell_radius =  \
                       {Golgi_cell_separation} \
			* {Golgi_cell_axon_overlap} \
			/ 2.0  // meter

/*
	// radius for stellate cell to Golgi cell connections

	stellate_cell_to_Golgi_cell_radius = {Golgi_cell_separation} / 2.0    // meter
*/

end


///
/// SH:	ConfigSetup
///
/// DE:	Setup constants and dependent globals from config file
///

function ConfigSetup

	//- read and setup config

	ConfigRead

	//- setup dependent globals

	ConfigRecalc
end


end


