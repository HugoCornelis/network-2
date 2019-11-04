// genesis

// function makesynapse now in C-code
// used position function when creating granule cells, rmaex 27/9/96

// included stellate cells, rmaex 19/6/96


int include_gran_layer_setup

if ( {include_gran_layer_setup} == 0 )

	include_gran_layer_setup = 1


//include defaults
//include ../Gran_layer_const.g

include Granule_cell.g

include Mossy_fiber.g

include Golgi_cell.g

include Gran_layer_randomize_hines.g


//v mossy rectangle

float fMossyPosXMin =  10000.0
float fMossyPosXMax = -10000.0

float fMossyPosYMin =  10000.0
float fMossyPosYMax = -10000.0

//v Golgi rectangle

float fGolgiPosXMin =  10000.0
float fGolgiPosXMax = -10000.0

float fGolgiPosYMin =  10000.0
float fGolgiPosYMax = -10000.0

//v granule rectangle

float fGranulePosXMin =  10000.0
float fGranulePosXMax = -10000.0

float fGranulePosYMin =  10000.0
float fGranulePosYMax = -10000.0


function make_synapse (pre, post, weight, delay)
   str     pre, post
   float   weight, delay
   int     syn_num

   addmsg {pre} {post} SPIKE
   syn_num = {getfield {post} nsynapses} - 1
   setfield {post} synapse[{syn_num}].weight  {weight} \
                   synapse[{syn_num}].delay   {delay}
end

function mossy_fiber_index (i, j)
   int i, j, index

   index = {(j - 1) * xnumber_mossy_fibers + i - 1}
   return (index)
end

  
/*************************  neurons and mossy fibers   *****************/

///
/// SH:	GranularLayerSetup
///
/// DE:	Setup all granular layer neurons
///	calculates number_granule_cells
///

function GranularLayerSetup

   if ({number_mossy_fibers} < 4)
        number_mossy_fibers = 4
   end  // otherwise the synapse loops are not executed !!

// make /white_matter/mossy_fiber[0-number_mossy_fibers]

   echo "The number of mossy fibers is "{number_mossy_fibers}

   if ({{number_mossy_fibers} > 0})
      make_mossy_fiber_array {xnumber_mossy_fibers} \
                             {ynumber_mossy_fibers} \
                             {mossy_fiber_firing_rate} \
                          {mossy_fiber_refractory_period}
   end

   echo "Made "{number_mossy_fibers}" mossy fibers"

// not documented where we can find the min/max values for x and y of the 
// mossies
// get them from the first and last element...

fMossyPosXMin = {getfield /white_matter/mossy_fiber[0] x}
fMossyPosYMin = {getfield /white_matter/mossy_fiber[0] y}

fMossyPosXMax = {getfield /white_matter/mossy_fiber[{number_mossy_fibers - 1}] x}
fMossyPosYMax = {getfield /white_matter/mossy_fiber[{number_mossy_fibers - 1}] y}

// make /granule_cell_layer/Granule[0-number_granule_cells]

   if ({{number_granule_cells} > 0})
      make_granule_cell_array \
		{xlength_granule_cell_array} \
		{ylength_granule_cell_array}
   end

   echo "Made "{number_granule_cells}" granule cells"


// not documented where we can find the min/max values for x and y of the 
// granules
// get them from the first and last element...

fGranulePosXMin = {getfield /granule_cell_layer/Granule[0] x}
fGranulePosYMin = {getfield /granule_cell_layer/Granule[0] y}

fGranulePosXMax = {getfield /granule_cell_layer/Granule[{number_granule_cells - 1}] x}
fGranulePosYMax = {getfield /granule_cell_layer/Granule[{number_granule_cells - 1}] y}

// make /granule_cell_layer/Golgi[0-number_Golgi_cells]

   if ({{number_Golgi_cells} > 0})

      make_Golgi_cell_array \
		{xlength_Golgi_cell_array} \
		{ylength_Golgi_cell_array}
   end

   echo "Made "{number_Golgi_cells}" Golgi cells"

// not documented where we can find the min/max values for x and y of the 
// Golgi's 
// get them from the first and last element...

fGolgiPosXMin = {getfield /granule_cell_layer/Golgi[0] x}
fGolgiPosYMin = {getfield /granule_cell_layer/Golgi[0] y}

fGolgiPosXMax = {getfield /granule_cell_layer/Golgi[{number_Golgi_cells - 1}] x}
fGolgiPosYMax = {getfield /granule_cell_layer/Golgi[{number_Golgi_cells - 1}] y}

// make /molecular_layer/Stellate[0-number_stellate_cells]

/*
**
   include Stellate_cell.g
   if ({{number_stellate_cells} > 0})
      make_stellate_cell_array {number_stellate_cells}
   end
   echo made {number_stellate_cells} stellate cells
*/

end


/************************    synapses                  *****************/


///
/// SH:	GranularConnectMossysToGolgis
///
/// DE:	Connect mossy fibers with Golgi's
///

function GranularConnectMossysToGolgis

	//- make AMPA synapses from mossy fibers to all Golgi cells
	//- within a circle of radius {mossy_fiber_to_Golgi_cell_radius}
//		-statistics /Connections/GranularConnectMossysToGolgis \

	planarconnect \
		/white_matter/mossy_fiber[]/spike \
		/granule_cell_layer/Golgi[]/soma/mf_AMPA \
		-relative \
		-sourcemask \
			box -1e10 -1e10 1e10 1e10 \ // all elements connected
		-destmask \
			ellipse \
				0 \
				0 \
				{mossy_fiber_to_Golgi_cell_radius} \
				{mossy_fiber_to_Golgi_cell_radius} \
		-probability {P_mossy_fiber_to_Golgi_cell_synapse}
end


///
/// SH:	GranularSynapsesMossysToGolgis
///
/// DE:	Initialize synapses from mossy fibers to Golgi's
///

function GranularSynapsesMossysToGolgis

	//- weight

	planarweight2 \
		/white_matter/mossy_fiber[]/spike \
		/granule_cell_layer/Golgi[]/soma/mf_AMPA \
		-fixed {weight_mossy_fiber_Golgi_cell_synapse} \
		-uniform {weight_distribution}

	//- delay

	planardelay \
		/white_matter/mossy_fiber[]/spike \
		/granule_cell_layer/Golgi[]/soma/mf_AMPA \
		-fixed {delay_mossy_fiber_Golgi_cell_synapse} \
		-uniform {delay_distribution}
end



///
/// SH:	GranularLinkMossysToGranules
///
/// DE: Link mossy fibers with granules
///	set up msg's, set up synaptic weight and delay, positions granules 
///	cells
///

function GranularLinkMossysToGranules

//MAKE MOSSY FIBER TO GRANULE CELL CONNECTIONS (NB!! REMEMEBER BOTH NMDA AND AMPA NEED SAME SEED !!!)


	echo "GranularLinkMossysToGranules : " \
		x {mossy_fiber_to_granule_cell_connection_radius} \
		y {mossy_fiber_to_granule_cell_connection_radius} \
		probability {P_mossy_fiber_to_granule_cell_synapse}

	//echo "m2g"

//	if ({{weight_mossy_fiber_granule_cell_AMPA_synapse} > 0})

//			-statistics /Connections/GranularLinkMossysToGranules[0] \

	//echo "m2g wAMPA"

		randseed 1234

		planarconnect \
			/white_matter/mossy_fiber[]/spike \
			/granule_cell_layer/Granule[]/soma/mf_AMPA \
			-relative \
			-sourcemask \
				box \
					-1e10 \
					-1e10 \
					1e10 \
					1e10 \ // all elements connected
			-destmask \
				box \
					{- mossy_fiber_to_granule_cell_connection_radius} \
					{- mossy_fiber_to_granule_cell_connection_radius} \
					{mossy_fiber_to_granule_cell_connection_radius} \
					{mossy_fiber_to_granule_cell_connection_radius} \
			-probability {P_mossy_fiber_to_granule_cell_synapse}

		planarweight2 \
			/white_matter/mossy_fiber[]/spike \
			/granule_cell_layer/Granule[]/soma/mf_AMPA \
			-fixed {weight_mossy_fiber_granule_cell_AMPA_synapse} \
			-uniform {weight_distribution}

		planardelay \
			/white_matter/mossy_fiber[]/spike \
			/granule_cell_layer/Granule[]/soma/mf_AMPA \
			-fixed {delay_mossy_fiber_granule_cell_synapse} \
			-uniform {delay_distribution}
//	end  

//	if ({{weight_mossy_fiber_granule_cell_NMDA_synapse} > 0})

//				-statistics /Connections/GranularLinkMossysToGranules[1] \

		//echo "m2g wNMDA"

		randseed 1234 

		planarconnect \
			/white_matter/mossy_fiber[]/spike \
			/granule_cell_layer/Granule[]/soma/mf_NMDA \
				-relative \
				-sourcemask \
					box -1e10 -1e10 1e10 1e10 \
				-destmask \
					box \
					{- mossy_fiber_to_granule_cell_connection_radius} \
					{- mossy_fiber_to_granule_cell_connection_radius} \
					{mossy_fiber_to_granule_cell_connection_radius} \
					{mossy_fiber_to_granule_cell_connection_radius} \
				-probability \
					{P_mossy_fiber_to_granule_cell_synapse}

		planarweight2 \
			/white_matter/mossy_fiber[]/spike \
			/granule_cell_layer/Granule[]/soma/mf_NMDA \
			-fixed {weight_mossy_fiber_granule_cell_NMDA_synapse} \
			-uniform {weight_distribution}

		planardelay \
			/white_matter/mossy_fiber[]/spike \
			/granule_cell_layer/Granule[]/soma/mf_NMDA \
			-fixed {delay_mossy_fiber_granule_cell_synapse} \
			-uniform {delay_distribution}
//	end  
end


///
/// SH:	GranularConnectGranulesToGolgis
///
/// DE:	Connect granules cells with Golgi's
///

function GranularConnectGranulesToGolgis

	//- make AMPA synapses from granule cells to Golgi cells

// 			-statistics /Connections/GranularConnectGranulesToGolgis \

//	if ({{weight_granule_cell_Golgi_cell_synapse} > 0})
		planarconnect \
			/granule_cell_layer/Granule[]/soma/spike \
			/granule_cell_layer/Golgi[]/soma/pf_AMPA \
			-relative \
			-sourcemask \
				box -1e10 -1e10 1e10 1e10 \
			-destmask \
				box \
					-{parallel_fiber_length / 2.0} \
					-{Golgi_cell_dendritic_diameter / 2.0} \
					{parallel_fiber_length / 2.0} \
					{Golgi_cell_dendritic_diameter / 2.0} \
			-probability {P_granule_cell_to_Golgi_cell_synapse}
//	end
end


///
/// SH:	GranularSynapsesGranulesToGolgis
///
/// DE:	Initialize synapses from granule cells to Golgi's
///

function GranularSynapsesGranulesToGolgis

//	if ({{weight_granule_cell_Golgi_cell_synapse} > 0})

		//- weight

		planarweight2 \
			/granule_cell_layer/Granule[]/soma/spike \
			/granule_cell_layer/Golgi[]/soma/pf_AMPA \
			-fixed {weight_granule_cell_Golgi_cell_synapse} \
			-uniform {weight_distribution}

		//- delay

		planardelay \
			/granule_cell_layer/Granule[]/soma/spike \
			/granule_cell_layer/Golgi[]/soma/pf_AMPA \
			-radial {parallel_fiber_conduction_velocity} \
			-uniform {delay_distribution}
//		-fixed {delay_granule_cell_Golgi_cell_synapse}
//      planardelay   /granule_cell_layer/Granule[]/soma/spike 
//                    /granule_cell_layer/Golgi[]/soma/pf_AMPA
//                   -add \ // to account for width Golgi cell dendritic tree
//                   -fixed {(Golgi_cell_separation / 2.0) / parallel_fiber_conduction_velocity}
//                   -absoluterandom
//                   -uniform {(Golgi_cell_separation / 2.0) / parallel_fiber_conduction_velocity}
//	end
end


///
/// SH:	GranularConnectGranulesToStellates
///
/// DE:	Connect granules cells with stellate cells
///

function GranularConnectGranulesToStellates

	//- make AMPA synapses from granule cells to stellate cells

// 			-statistics /Connections/GranularConnectGranulesToStellates \

//	if ({{weight_granule_cell_stellate_cell_synapse} > 0})
		planarconnect \
			/granule_cell_layer/Granule[]/soma/spike \
			/molecular_layer/Stellate[]/soma/pf_AMPA \
			-relative \
			-sourcemask \
				box -1e10 -1e10 1e10 1e10 \
			-destmask \
				box \
					-{parallel_fiber_length / 2.0} -1e10 \
					{parallel_fiber_length / 2.0}  1e10 \ 
			-probability {P_granule_cell_to_stellate_cell_synapse}
//	end
end


///
/// SH:	GranularSynapsesGranulesToStellates
///
/// DE:	Initialize synapses from granule cells to stellate cells
///

function GranularSynapsesGranulesToStellates

//	if ({{weight_granule_cell_stellate_cell_synapse} > 0})

		//- weight

		planarweight2 \
			/granule_cell_layer/Granule[]/soma/spike \
			/molecular_layer/Stellate[]/soma/pf_AMPA \
			-fixed {weight_granule_cell_stellate_cell_synapse} \
			-uniform {weight_distribution}

		//- delay

		planardelay \
			/granule_cell_layer/Granule[]/soma/spike \
			/molecular_layer/Stellate[]/soma/pf_AMPA \
			-radial {parallel_fiber_conduction_velocity} \
			-uniform {delay_distribution}
	// -fixed {delay_granule_cell_Golgi_cell_synapse}
//	end
end



///
/// SH:	GranularConnectGolgisToGranules
///
/// DE:	Connect Golgi cells with granule cells
///

function GranularConnectGolgisToGranules

	//- make GABA_A synapses from Golgi cells to granule cells

// 			-statistics /Connections/GranularConnectGolgisToGranules[0] \

//	if ({{weight_Golgi_cell_granule_cell_GABAA_synapse} > 0})
		planarconnect \
			/granule_cell_layer/Golgi[]/soma/spike \
			/granule_cell_layer/Granule[]/soma/GABAA \
			-relative \
			-sourcemask \
				box -1e10 -1e10 1e10 1e10 \
			-destmask \
				box \
					-{Golgi_cell_to_granule_cell_radius} \
					-{Golgi_cell_to_granule_cell_radius} \
					{Golgi_cell_to_granule_cell_radius} \
					{Golgi_cell_to_granule_cell_radius} \ 
			-probability {P_Golgi_cell_to_granule_cell_synapse}
//	end

	//- make GABA_Bsynapses from Golgi cells to granule cells

// 			-statistics /Connections/GranularConnectGolgisToGranules[1] \

//	if ({{weight_Golgi_cell_granule_cell_GABAB_synapse} > 0})
		planarconnect \
			/granule_cell_layer/Golgi[]/soma/spike \
			/granule_cell_layer/Granule[]/soma/GABAB \
			-relative \
			-sourcemask \
				box -1e10 -1e10 1e10 1e10 \
			-destmask \
				ellipse \
					0 \
					0 \
					{Golgi_cell_to_granule_cell_radius} \
					{Golgi_cell_to_granule_cell_radius} \ 
			-probability {P_Golgi_cell_to_granule_cell_synapse}
//	end
end


///
/// SH:	GranularSynapsesGolgisToGranules
///
/// DE:	Initialize synapses from Golgi cells to granule cells
///

function GranularSynapsesGolgisToGranules

//	if ({{weight_Golgi_cell_granule_cell_GABAA_synapse} > 0})

		//- weight

		planarweight2 \
			/granule_cell_layer/Golgi[]/soma/spike \
			/granule_cell_layer/Granule[]/soma/GABAA \
			-fixed {weight_Golgi_cell_granule_cell_GABAA_synapse} \
			-uniform {weight_distribution}

		//- delay

		planardelay \
			/granule_cell_layer/Golgi[]/soma/spike \
			/granule_cell_layer/Granule[]/soma/GABAA \
			-fixed {delay_Golgi_cell_granule_cell_synapse} \
			-uniform {delay_distribution}
//	end

//	if ({{weight_Golgi_cell_granule_cell_GABAB_synapse} > 0})

		//- weight

		planarweight2 \
			/granule_cell_layer/Golgi[]/soma/spike \
			/granule_cell_layer/Granule[]/soma/GABAB \
			-fixed {weight_Golgi_cell_granule_cell_GABAB_synapse} \
			-uniform {weight_distribution}

		//- delay

		planardelay \
			/granule_cell_layer/Golgi[]/soma/spike \
			/granule_cell_layer/Granule[]/soma/GABAB \
			-fixed {delay_Golgi_cell_granule_cell_synapse} \
			-uniform {delay_distribution}
//	end
end


///
/// SH:	GranularConnectStellatesToGolgis
///
/// DE:	Connect stellates cells with Golgi cells
///

function GranularConnectStellatesToGolgis

	//- make GABA_A synapses from stellate cells to Golgi cells

// 			-statistics /Connections/GranularConnectStellatesToGolgis \

//	if ({{weight_stellate_cell_Golgi_cell_synapse} > 0})
		planarconnect /molecular_layer/Stellate[]/soma/spike \
			/granule_cell_layer/Golgi[]/soma/GABAA \
			-relative \
			-sourcemask \
				box -1e10 -1e10 1e10 1e10 \
			-destmask \
				ellipse \
					0 \
					0 \
					{stellate_cell_to_Golgi_cell_radius} \
					{stellate_cell_to_Golgi_cell_radius} \
			-probability {P_stellate_cell_to_Golgi_cell_synapse}
//	end
end


///
/// SH:	GranularConnectStellatesToGolgis
///
/// DE:	Initialize synapses from stellate cells to Golgi cells
///

function GranularSynapsesStellatesToGolgis

	//- make GABA_A synapses from stellate cells to Golgi cells

//	if ({{weight_stellate_cell_Golgi_cell_synapse} > 0})

		//- weight

		planarweight2 /molecular_layer/Stellate[]/soma/spike \
			/granule_cell_layer/Golgi[]/soma/GABAA \
			-fixed {weight_stellate_cell_Golgi_cell_synapse} \
			-uniform {weight_distribution}

		//- delay

		planardelay /molecular_layer/Stellate[]/soma/spike \
			/granule_cell_layer/Golgi[]/soma/GABAA \
			-fixed {delay_stellate_cell_Golgi_cell_synapse} \
			-uniform {delay_distribution}
//	end
end


///
/// SH:	GranularLayerLink
///
/// DE:	Link all granular layer neurons
///

function GranularLayerLink

	create neutral /Connections

	//- connect mossy fibers with Golgi cells

	GranularConnectMossysToGolgis

	//- initialize synapses

	GranularSynapsesMossysToGolgis

	//- give diagnostics

	echo "Connected "{number_mossy_fibers} \
		"mossy fibers to "{number_Golgi_cells} \
		"Golgi cells with probability" \
		{P_mossy_fiber_to_Golgi_cell_synapse}
	echo "Fixed weight is "{weight_mossy_fiber_Golgi_cell_synapse}"," \
		"fixed delay is "{delay_mossy_fiber_Golgi_cell_synapse}

/*
	// connect mossy fibers with granule cells

	GranularConnectMossysToGranules

	// initialize synapses

	GranularSynapsesMossysToGranules
*/

	//- link mossy's with granules

	GranularLinkMossysToGranules

	//- connect granule cells with Golgi cells

	GranularConnectGranulesToGolgis

	//- initialize synapses

	GranularSynapsesGranulesToGolgis

	//- give diagnostics

	echo "Connected "{number_granule_cells} \
		"granule cells to "{number_Golgi_cells} \
		"Golgi cells with probability" \
		{P_granule_cell_to_Golgi_cell_synapse}
	echo "Fixed weight is "{weight_granule_cell_Golgi_cell_synapse}"," \
		"conduction velocity is "{parallel_fiber_conduction_velocity}

/*
	// connect granules with stellates

	GranularConnectGranulesToStellates

	// initialize synapses

	GranularSynapsesGranulesToStellates

	// give diagnostics

	echo "Connected "{number_granule_cells} \
		"granule cells to "{number_stellate_cells} \
		"stellate cells with probability" \
		{P_granule_cell_to_stellate_cell_synapse}
	    echo "Fixed weight is" \
		{weight_granule_cell_stellate_cell_synapse}"," \
		"conduction velocity is "{parallel_fiber_conduction_velocity}
*/

	//- connect Golgi cells with granule cells

	GranularConnectGolgisToGranules

	//- initialize synapses

	GranularSynapsesGolgisToGranules

	//- give diagnostics

	echo \
		"Connected "{number_Golgi_cells} \
		"Golgi cells to "{number_granule_cells} \
		"granule cells with probability" \
		{P_Golgi_cell_to_granule_cell_synapse}
	echo \
		"Fixed GABAA weight is" \
		{weight_Golgi_cell_granule_cell_GABAA_synapse}"," \
		"Fixed delay is" \
		{delay_Golgi_cell_granule_cell_synapse}

	echo \
		"Connected "{number_Golgi_cells} \
		"Golgi cells to "{number_granule_cells} \
		"granule cells with probability" \
		{P_Golgi_cell_to_granule_cell_synapse}
	echo \
		"Fixed GABAB weight is" \
		{weight_Golgi_cell_granule_cell_GABAB_synapse}"," \
		"fixed delay is" \
		{delay_Golgi_cell_granule_cell_synapse}

/*
	// connect stellates with Golgis

	GranularConnectStellatesToGolgis

	// initialize synapses

	GranularSynapsesStellatesToGolgis

	// give diagnostics

	echo \
		"Connected "{number_stellate_cells} \
		"stellate cells to "{number_Golgi_cells} \
		"Golgi cells with probability" \
		{P_stellate_cell_to_Golgi_cell_synapse}

	echo "Fixed weight is "{weight_stellate_cell_Golgi_cell_synapse}"," \
		"fixed delay is "{delay_stellate_cell_Golgi_cell_synapse}
*/
end


///
/// SH:	GranularLayerSynapses
///
/// DE:	Setup all synapses for all neurons except synapses from mossy to grans
///

function GranularLayerSynapses

	//- initialize synapses

	GranularSynapsesMossysToGolgis

	//- give diagnostics

	echo "Initialized synapses from "{number_mossy_fibers} \
		"mossy fibers to "{number_Golgi_cells} \
		"Golgi cells with probability" \
		{P_mossy_fiber_to_Golgi_cell_synapse}
	echo "Fixed weight is "{weight_mossy_fiber_Golgi_cell_synapse}"," \
		"fixed delay is "{delay_mossy_fiber_Golgi_cell_synapse}

/*
	// connect mossy fibers with granule cells

	GranularConnectMossysToGranules

	// initialize synapses

	GranularSynapsesMossysToGranules

	// link mossy's with granules

	GranularLinkMossysToGranules
*/

	//- initialize synapses

	GranularSynapsesGranulesToGolgis

	//- give diagnostics

	echo "Initialized synapses from "{number_granule_cells} \
		"granule cells to "{number_Golgi_cells} \
		"Golgi cells with probability" \
		{P_granule_cell_to_Golgi_cell_synapse}
	echo "Fixed weight is "{weight_granule_cell_Golgi_cell_synapse}"," \
		"conduction velocity is "{parallel_fiber_conduction_velocity}

/*
	// initialize synapses

	GranularSynapsesGranulesToStellates

	//- give diagnostics

	echo "Initialized synapses from "{number_granule_cells} \
		"granule cells to "{number_stellate_cells} \
		"stellate cells with probability" \
		{P_granule_cell_to_stellate_cell_synapse}
	    echo "Fixed weight is" \
		{weight_granule_cell_stellate_cell_synapse}"," \
		"conduction velocity is "{parallel_fiber_conduction_velocity}
*/

	//- initialize synapses

	GranularSynapsesGolgisToGranules

	//- give diagnostics

	echo \
		"Initialized synapses from "{number_Golgi_cells} \
		"Golgi cells to "{number_granule_cells} \
		"granule cells with probability" \
		{P_Golgi_cell_to_granule_cell_synapse}
	echo \
		"Fixed GABAA weight is" \
		{weight_Golgi_cell_granule_cell_GABAA_synapse} \
		"," \
		"Fixed delay is" \
		{delay_Golgi_cell_granule_cell_synapse}

	echo \
		"Initialized synapses from "{number_Golgi_cells} \
		"Golgi cells to "{number_granule_cells} \
		"granule cells with probability" \
		{P_Golgi_cell_to_granule_cell_synapse}
	echo \
		"Fixed GABAB weight is" \
		{weight_Golgi_cell_granule_cell_GABAB_synapse} \
		"," \
		"fixed delay is" \
		{delay_Golgi_cell_granule_cell_synapse}

/*
	// initialize synapses

	GranularSynapsesStellatesToGolgis

	// give diagnostics

	echo \
		"Initialized synapses from "{number_stellate_cells} \
		"stellate cells to "{number_Golgi_cells} \
		"Golgi cells with probability" \
		{P_stellate_cell_to_Golgi_cell_synapse}

	echo "Fixed weight is "{weight_stellate_cell_Golgi_cell_synapse}"," \
		"fixed delay is "{delay_stellate_cell_Golgi_cell_synapse}
*/
end


///
/// SH:	GranularShowDimensions
///
/// DE:	Show min/max coordinates of different neurons/fibers
///

function GranularShowDimensions

	//- show mossy rectangle

	echo "Mossy rectangle : ("{fMossyPosXMin}","{fMossyPosXMax}","{fMossyPosYMin}","{fMossyPosYMax}")"

	//- show granule rectangle

	echo "Granu rectangle : ("{fGranulePosXMin}","{fGranulePosXMax}","{fGranulePosYMin}","{fGranulePosYMax}")"

	//- show Golgi rectangle

	echo "Golgi rectangle : ("{fGolgiPosXMin}","{fGolgiPosXMax}","{fGolgiPosYMin}","{fGolgiPosYMax}")"

end


end


