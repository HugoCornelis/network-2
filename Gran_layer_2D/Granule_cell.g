// genesis (R.M. 12/12/95)

int include_granule_cell

if ( {include_granule_cell} == 0 )

	include_granule_cell = 1


//include defaults


///
/// SH:	gran_reposition
///
/// DE:	Correct positions of granule cells after initial setup
///
/// NO: Copied from JDJ, modified to respect correct positions
///


function gran_reposition

	int i

	for (i = 1; i <= number_granule_cells; i = i + 1)
	   position \
		/granule_cell_layer/Granule[{i-1}] \
		R{rand -{0.003 / {xlength_granule_cell_array}} \
			{0.003 / {xlength_granule_cell_array}}} \
		R{rand -{0.0005 / {ylength_granule_cell_array}} \
			{0.0005 / {ylength_granule_cell_array}}} \
		R0		

// old height as in JDJ's sims

//           {rand 0 150e-6}
	end

end


/* 
The function "make_granule_cell_array" creates {length} granule cells,
named /granule_cell_layer/granule_cell [0] 
   to /granule_cell_layer/granule_cell [{length} - 1].
Each granule cell is a copy of the granule cell described in Gran1M0.p.
A spikegen object is added to the soma.
*/


include ../Granule_cell/Gran_const.g
include ../Granule_cell/Gran_chan_tab.g
include ../Granule_cell/Gran_synchan.g 
include ../Granule_cell/Gran_comp.g

function make_granule_cell_array(xlength,ylength)

int xlength, ylength

	int i
	str cellpath = "/Granule"

// To ensure that all subsequent elements are made in the library 
	if ( ! {exists /library/granule})

		create neutral /library/granule

		ce /library/granule

		make_Granule_chans
		make_Granule_syns
		make_Granule_comps

		// Make the prototypes of channels and compartments that can
		// be invoked in .p files 
		// MAEX 16/4/96

		setfield /library/granule/soma/GABAA normalize_weights 1
		setfield /library/granule/soma/GABAB normalize_weights 1
		setfield /library/granule/soma/mf_AMPA normalize_weights 1
		setfield /library/granule/soma/mf_NMDA normalize_weights 1

	end

	if ( ! {exists {cellpath}} )

		// read cell data from .p file

		readcell ../Granule_cell/Gran1M0.p {cellpath}

		// add a spikegen object

		create spikegen {cellpath}/soma/spike

		setfield {cellpath}/soma/spike \
			thresh -0.02 \
			abs_refract 0.005 \
			output_amp 1

		addmsg {cellpath}/soma {cellpath}/soma/spike \
			INPUT Vm
	end

	if ( ! {exists /granule_cell_layer})
		create neutral /granule_cell_layer
	end

	//- enable prototype cell

	enable {cellpath}

	//- create map

	createmap \
		{cellpath} \
		/granule_cell_layer \
		{xlength} \
		{ylength} \
		-delta \
			{{Golgi_cell_separation} \
				* {xlength_Golgi_cell_array - 0} \
				/ {xlength_granule_cell_array - 0}} \
			{{Golgi_cell_separation} \
				* {ylength_Golgi_cell_array - 0} \
				/ {ylength_granule_cell_array - 0}} \
		-origin \
			{{Golgi_cell_separation} \
				* {xlength_Golgi_cell_array - 0} \
				/ {xlength_granule_cell_array - 0} \
				/ 2} \
			{{Golgi_cell_separation} \
				* {ylength_Golgi_cell_array - 0} \
				/ {ylength_granule_cell_array - 0} \
				/ 2}
/*
			{{{xlength + 1} \
				* {Golgi_cell_separation} \
				* {xlength_Golgi_cell_array - 0} \
				/ {xlength_granule_cell_array - 0} \
				- {{xlength_Golgi_cell_array - 0} \
					* {Golgi_cell_separation}}} \
				/ 2} \
			{{{ylength + 1} \
				* {Golgi_cell_separation} \
				* {ylength_Golgi_cell_array - 0} \
				/ {ylength_granule_cell_array - 0} \
				- {{ylength_Golgi_cell_array - 0} \
					* {Golgi_cell_separation}}} \
				/ 2}

*/
/*
		-delta \
			{0.006 / {xlength}} \
			{0.001 / {ylength}} \
		-origin \
			0.001 \
			0.00075  
*/

	// reposition cells

	//gran_reposition

	//- disable prototype cell

	disable {cellpath}

// positions were previously computed in Gran_layer_setup

end   


end


