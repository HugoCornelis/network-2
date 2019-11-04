// genesis


int include_gran_layer_randomize_hines

if ( {include_gran_layer_randomize_hines} == 0 )

	include_gran_layer_randomize_hines = 1


//   include defaults
//   include Gran_layer_const.g


float Vm_init_lb =  -0.090 // initial values membrane potential
float Vm_init_ub =  -0.05 //  0.050

float Granule_E_leak_lb = -0.070
float Granule_E_leak_ub = -0.060

float Golgi_E_leak_lb   = -0.060  // E_leak lower boundary
float Golgi_E_leak_ub   = -0.050  // E_leak upper boundary

float Stellate_E_leak_lb = Golgi_E_leak_lb
float Stellate_E_leak_ub = Golgi_E_leak_ub


///
/// SH:	GranularRandomizeGranules
///
/// DE:	Randomize granule leak and maximal conductances
///

function GranularRandomizeGranules

	int   i
	float initvm

	echo "Randomizing granule cells"

	for (i = {number_granule_cells}; i > 0; i = i - 1)

		pushe /granule_cell_layer/Granule[{i-1}]/soma
		initvm = {rand {Vm_init_lb} {Vm_init_ub}}
		setfield . initVm {initvm}
		setfield . Vm     {initvm}
		setfield . Em     {rand {Granule_E_leak_lb} {Granule_E_leak_ub}}
//		call /granule_cell_layer/Granule[{i-1}]/solve HPUT /granule_cell_layer/Granule[{i-1}]/soma
		pope

		pushe /granule_cell_layer/Granule[{i-1}]/soma/mf_AMPA
		setfield . \
			gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
//		call /granule_cell_layer/Granule[{i-1}]/solve HPUT .
		pope

		pushe /granule_cell_layer/Granule[{i-1}]/soma/mf_NMDA
		setfield . \
			gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
//		call /granule_cell_layer/Granule[{i-1}]/solve HPUT .
		pope
       
		pushe /granule_cell_layer/Granule[{i-1}]/soma/GABAA
		setfield . \
			gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
//		call /granule_cell_layer/Granule[{i-1}]/solve HPUT .
		pope

	end
end


///
/// SH:	GranularRandomizeGolgis
///
/// DE:	Randomize Golgi leak and maximal conductances
///

function GranularRandomizeGolgis

	int   i
	float initvm

	echo "Randomizing Golgi cells"

	for (i = {number_Golgi_cells}; i > 0; i = i - 1)

		pushe /granule_cell_layer/Golgi[{i-1}]/soma
		initvm = {rand {Vm_init_lb} {Vm_init_ub}}
		setfield . initVm {initvm}
		setfield . Vm     {initvm}
		setfield . Em     {rand {Golgi_E_leak_lb} {Golgi_E_leak_ub}}
//		call /granule_cell_layer/Golgi[{i-1}]/solve HPUT /granule_cell_layer/Golgi[{i-1}]/soma
		pope

		pushe /granule_cell_layer/Golgi[{i-1}]/soma/mf_AMPA
		setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
//		call /granule_cell_layer/Golgi[{i-1}]/solve HPUT .
		pope

		pushe /granule_cell_layer/Golgi[{i-1}]/soma/pf_AMPA
		setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
//		call /granule_cell_layer/Golgi[{i-1}]/solve HPUT .
		pope

		pushe /granule_cell_layer/Golgi[{i-1}]/soma/GABAA
		setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
//		call /granule_cell_layer/Golgi[{i-1}]/solve HPUT .
		pope

	end
end


///
/// SH:	GranularRandomizeStellates
///
/// DE:	Randomize stellate leak and maximal conductances
///

function GranularRandomizeStellates

	int   i
	float initvm

	echo "Randomizing stellate cells"

	for (i = {number_stellate_cells}; i > 0; i = i - 1)

		pushe /molecular_layer/Stellate[{i-1}]/soma
		initvm = {rand {Vm_init_lb} {Vm_init_ub}}
		setfield . initVm {initvm}
		setfield . Vm     {initvm}
		setfield . Em     {rand {Stellate_E_leak_lb} {Stellate_E_leak_ub}}
//		call /molecular_layer/Stellate[{i-1}]/solve HPUT /molecular_layer/Stellate[{i-1}]/soma
		pope

		pushe /molecular_layer/Stellate[{i-1}]/soma/pf_AMPA
		setfield . gmax {{getfield . gmax} * (1 + {weight_distribution} * {rand -1 1})}
//		call /molecular_layer/Stellate[{i-1}]/solve HPUT .
		pope

	end
end


end


