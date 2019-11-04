//genesis (R.M. 13/12/95)

int include_golgi_cell

if ( {include_golgi_cell} == 0 )

	include_golgi_cell = 1


//include defaults 

/* 
The function "make_Golgi_cell_array" creates {length} Golgi cells,
named /granule_cell_layer/Golgi_cell [0] 
   to /granule_cell_layer/Golgi_cell [{length} - 1].
Each Golgi cell is a copy of the Golgi cell described in Golg1M0.p.
A spikegen object is added to the soma.

*/


include ../Golgi_cell/Golg_const.g 
include ../Golgi_cell/Golg_chan_tab.g
include ../Golgi_cell/Golg_synchan.g 
include ../Golgi_cell/Golg_comp.g 


function make_Golgi_cell_array(xlength,ylength)

int xlength
int ylength

	int i
	str cellpath = "/Golgi"

	// To ensure that all subsequent elements are made in the library 

	ce /library

	// Make the prototypes of channels and compartments that can be 
	// invoked in .p files

	//! this is a hacked way to test existence of the Golgi prototypes

	//- if interneuron/soma lib element does not exist

	if ( ! {exists /library/interneuron/soma} )

		make_Golgi_chans
		make_Golgi_syns

		//! this one makes interneuron/soma

		make_Golgi_comps

		// MAEX 16/4/96

		setfield /library/interneuron/soma/mf_AMPA normalize_weights 1
		setfield /library/interneuron/soma/pf_AMPA normalize_weights 1
		setfield /library/interneuron/soma/GABAA   normalize_weights 1
	end

	if (!{exists /granule_cell_layer})
		create neutral /granule_cell_layer
	end

	//- if Golgi cell does not exist

	if ( ! {exists {cellpath}} )

		//- read cell data from .p file

		readcell ../Golgi_cell/Golg1M0.p {cellpath}

		//- add a spikegen object

		create spikegen {cellpath}/soma/spike
		setfield {cellpath}/soma/spike \
			thresh 0 \
			abs_refract 0.002 \
			output_amp 1

		addmsg {cellpath}/soma {cellpath}/soma/spike \
			INPUT Vm
	end

	//- enable prototype cell

	enable {cellpath}

	//- create 2D Golgi map

	createmap {cellpath} /granule_cell_layer \
		{xlength} \
		{ylength} \
		-delta {Golgi_cell_separation} {Golgi_cell_separation} \
		-origin {Golgi_cell_separation / 2} {Golgi_cell_separation / 2}
/*
		-origin {{xlength - 1} * Golgi_cell_separation / 2} \
			{{ylength - 1} * Golgi_cell_separation / 2}

*/
	//- disable prototype cell

	disable {cellpath}
end   


end


