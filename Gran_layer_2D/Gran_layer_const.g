/* This constants file for the two-dimensional granular layer is essentially
   the same as that for the one-dimensional layer. The only new variables to
   be initialized are :
     "xlength_Golgi_cell_array", 
     "ylength_Golgi_cell_array" : the number of Golgi cells along
  	the length (PF) and width (sagittal) axes  of a 2D rectangular layer;

     "Golgi_cell_dendritic_diameter" :

   The variable "mossy_fiber_to_Golgi_cell_ratio" still is the ratio along ONE dimension,
   and "mossy_fiber_to_granule_cell_connection_radius" now means that a mossy fiber will
   form combinatorial quadruplets to connect to granule cells with all other mossy fibers
   not further away than "mossy_fiber_to_granule_cell_connection_radius" along the X- and Y-axis.

   Again, the cell numbers must be consistent, particularly the number of granule cells,
   which is recomputed in the  Gran_layer_setup.g script.  Every include statement referring to  
   this Gran_layer_const.g script however will reinitialize  "number_granule_cells" with the value
   given below and, when different from the computed value, will potentially lead to execution errors !
*/


int include_gran_layer_cont

if ( {include_gran_layer_cont} == 0 )

	include_gran_layer_cont = 1



// file name for ascii output
//   str filename = "/bbf/molensloot/reinoud/genesis/Gran_layer_1D_Stellate/"
//   str filename = "/bbf/haddock/reinoud/genesis/Gran_layer_1D_NS96/"
//   str filename = "/bbf/syldavie/reinoud/genesis/Gran_layer_1D_NS96/"
   str filename = "./results/"

// chanmode for hsolver
   int  chanmode = 3

// seeding the random generator for cell-repositioning
   randseed 9012


// cell numbers
   int  number_mossy_fibers =  60 // 300 // 1200 // 500 // will be overwritten below
   int  number_granule_cells =  232 // 261 // 22233 // 12905 // 1121 // 22065 // will be overwritten in Gran_layer_setup.g
   int  number_Golgi_cells =   60 // 300 // 125 // fixed
   int  number_stellate_cells = 0 // 150

// topographics : describes distances along the parallel-fiber axis (x) as well as 
//                  along sagittal axis (y)

      int xlength_granule_cell_array = 18
      int ylength_granule_cell_array = 3

      int number_granule_cells = {{xlength_granule_cell_array} \
					* {ylength_granule_cell_array}}
     
      int xlength_Golgi_cell_array = 10 // 30
      int ylength_Golgi_cell_array = 3 // 10 // 5

      number_Golgi_cells = {xlength_Golgi_cell_array * ylength_Golgi_cell_array}

   // separation between adjacent Golgi cells
      float Golgi_cell_separation  =  300e-6   // meter

   // diameter Golgi cell dendritic tree
      float Golgi_cell_dendritic_diameter = {2.0 * Golgi_cell_separation} // meter

   // ratio of number of mossy fibers over number of Golgi cells IN ONE DIMENSION : an uneven number
      float   xmossy_fiber_to_Golgi_cell_ratio =   3 // 1
      float   ymossy_fiber_to_Golgi_cell_ratio =   3 // 1
      int   xnumber_mossy_fibers = {xlength_Golgi_cell_array * xmossy_fiber_to_Golgi_cell_ratio}
      int   ynumber_mossy_fibers = {ylength_Golgi_cell_array * ymossy_fiber_to_Golgi_cell_ratio}
             number_mossy_fibers = {xnumber_mossy_fibers * ynumber_mossy_fibers}

   // ratio of number of stellate cells over number of Golgi cells IN ONE DIMENSION : an uneven number
      int   stellate_cell_to_Golgi_cell_ratio = 0 // 5
            number_stellate_cells = {number_Golgi_cells} * {stellate_cell_to_Golgi_cell_ratio} \
                                                         * {stellate_cell_to_Golgi_cell_ratio}

   // separation between adjacent mossy fibers
      float xmossy_fiber_separation = {Golgi_cell_separation} / {xmossy_fiber_to_Golgi_cell_ratio} // meter
      float ymossy_fiber_separation = {Golgi_cell_separation} / {ymossy_fiber_to_Golgi_cell_ratio} // meter

   // separation between adjacent stellate cells
      float stellate_cell_separation = {Golgi_cell_separation} / {stellate_cell_to_Golgi_cell_ratio} // meter

/*
   // 4 mossy fibers can converge onto a single granule cell only when they fall
   // within a circle with the following radius, the position of the created 
   // granule cell will be the midpoint of the 4 afferent mossy fibers 
      float mossy_fiber_to_granule_cell_connection_radius =  1 // 2 // 3 // in {mossy_fiber_separation} units
*/

      float mossy_fiber_to_granule_cell_connection_radius = {max {xmossy_fiber_separation} {ymossy_fiber_separation}}

   // probability that a granule cell is created for a combination of 4 valid mossy fiber positions
      float P_mossy_fiber_to_granule_cell_connection = 1.0   // probability

   // radius for mossy fiber to Golgi cell connections
      float mossy_fiber_to_Golgi_cell_radius = {Golgi_cell_separation} / 2.0    // meter

   // overlap of Golgi cell axons : integer
      int Golgi_cell_axon_overlap = 1 // 3

   // radius for Golgi cell to granule cell connections 
      float Golgi_cell_to_granule_cell_radius  =  \
                       {Golgi_cell_separation} * {Golgi_cell_axon_overlap} / 2.0  // meter

/*
   // radius for stellate cell to Golgi cell connections
      float stellate_cell_to_Golgi_cell_radius = {Golgi_cell_separation} / 2.0    // meter
*/

   // length parallel fiber
      float parallel_fiber_length = 5.0e-3   // meter

// mossy fiber input
   float mossy_fiber_firing_rate = 40          // sec^-1
   float mossy_fiber_refractory_period = 0.005 // sec
   float interburst_interval = 0.5              // sec
   float burst_duration      = 0.5           // sec
   float burst_intensity     = 1.0              // multiplied by mossy_fiber_firing_rate 


// synaptic probabilities
   float P_mossy_fiber_to_Golgi_cell_synapse      =  1.0 // probability 
   float P_granule_cell_to_Golgi_cell_synapse     =  0.7 // 0.2 // 0.005 // 0.01 // probability
   float P_Golgi_cell_to_granule_cell_synapse     =  1.0 // probability
   float P_mossy_fiber_to_granule_cell_synapse    =  1.0 // {4.0 / number_mossy_fibers} // probability
   float P_stellate_cell_to_Golgi_cell_synapse    =  1.0 // probability
   float P_granule_cell_to_stellate_cell_synapse  =  0.1 // probability


// synaptic weights : the normalization is now done in RECALC of synchan !!!!

   float weight_mossy_fiber_granule_cell_AMPA_synapse = 6.0 
   float weight_mossy_fiber_granule_cell_NMDA_synapse = 4.0 
   float weight_mossy_fiber_Golgi_cell_synapse   = 0.0 // 12.0 // 6.0
   float weight_granule_cell_Golgi_cell_synapse  =  45.0 // 18.0 // 15  // 6.0
/*
   float weight_granule_cell_stellate_cell_synapse \
		= {weight_granule_cell_Golgi_cell_synapse \
			* P_granule_cell_to_stellate_cell_synapse \
			/ P_granule_cell_to_Golgi_cell_synapse}
*/
   float weight_Golgi_cell_granule_cell_GABAA_synapse  =  45.0 // 30.0 // 45.0 
   float weight_Golgi_cell_granule_cell_GABAB_synapse  = 0.0 
/*
   float weight_stellate_cell_Golgi_cell_synapse \
		= {weight_Golgi_cell_granule_cell_GABAA_synapse / 2}
*/

// synaptic delays
   float delay_mossy_fiber_granule_cell_synapse =  0.0
   float delay_mossy_fiber_Golgi_cell_synapse   =  0.0
   float delay_granule_cell_Golgi_cell_synapse  =  0.0
   float delay_Golgi_cell_granule_cell_synapse  =  0.0
/*
   float delay_stellate_cell_Golgi_cell_synapse =  0.0
*/
   float parallel_fiber_conduction_velocity = 0.5  // m/s

float time_axis_graph = 0.5 // 1.0

float weight_distribution  = 0.15
float delay_distribution  = 0.0


end


