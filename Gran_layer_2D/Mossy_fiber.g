// genesis (R.M. 12/12/95)

int include_mossy_fiber

if ( {include_mossy_fiber} == 0 )

	include_mossy_fiber = 1


//include defaults

float DELTA_X = 1.0
int   i

/* 

The function "make_mossy_fiber_array" creates {length} mossy fibers,
named /white_matter/mossy_fiber[0] to /white_matter/mossy_fiber
[{length} - 1].  Each mossy fiber is a randomspike object with firing
rate {mossy_fiber_firing_rate} and with absolute refractory period
{mossy_fiber_refractory_period}.


Burst are generated in the first four mossy fibers

*/

function make_mossy_fiber_array  (xlength, ylength, firing_rate, refractory_period)

	int   xlength, ylength
	float firing_rate, refractory_period


	//- create library container if non-existent

	if ( ! {exists /library})
		create neutral /library 
		disable /library
	end


	//- if no mossy fiber in the library

	if ( ! {exists /library/mossy_fiber} )

		//- create and setup library mossy fiber

		create randomspike /library/mossy_fiber
		setfield ^ \
			rate {mossy_fiber_firing_rate} \
			abs_refract {mossy_fiber_refractory_period}
		create spikegen /library/mossy_fiber/spike 
		setfield ^ \
			thresh 0.5 \
			abs_refract {mossy_fiber_refractory_period}
		addmsg /library/mossy_fiber /library/mossy_fiber/spike \
			INPUT state
	end

	//- create white matter

	if ( ! {exists /white_matter}) 
		create neutral /white_matter
	end

	//- create 2D grid with mossy fibers

	createmap /library/mossy_fiber /white_matter \
		{xlength} \
		{ylength} \
		-delta {xmossy_fiber_separation} {ymossy_fiber_separation} \
		-origin \
			{{xmossy_fiber_separation} / 2 \
				- 1.0 * {Golgi_cell_separation}} \
			{{ymossy_fiber_separation} / 2 \
				- 1.0 * {Golgi_cell_separation}}
/*
// burst generator
   create pulsegen /burst
   int number_of_bursting_mossy_fibers = 2
   setfield ^ baselevel {mossy_fiber_firing_rate} \
              delay1 {interburst_interval} \
              width1 {burst_duration}      \
              level1 {burst_intensity * mossy_fiber_firing_rate}
   for (i = 0; i < {number_of_bursting_mossy_fibers}; i = i + 1)
       addmsg /burst /white_matter/mossy_fiber[{i}] RATE output
   end
*/

/*
// burst generator
   create pulsegen /library/burst
//   int number_of_bursting_mossy_fibers = 2
   setfield ^ baselevel {mossy_fiber_firing_rate} \
              delay1 {interburst_interval} \
              width1 {burst_duration}      \
              level1 {burst_intensity * mossy_fiber_firing_rate}
   createmap /library/burst /white_matter \
             {xlength} {ylength} -delta {mossy_fiber_separation} {mossy_fiber_separation} \
                        -origin {(- {mossy_fiber_to_Golgi_cell_ratio} / 2) * {mossy_fiber_separation}}\
                                {(- {mossy_fiber_to_Golgi_cell_ratio} / 2) * {mossy_fiber_separation}}

//   for (i = 0; i < {length}; i = i + 1)
   for (i = {number_mossy_fibers / 2 - 30}; i < {number_mossy_fibers / 2 + 30}; i = i + 1)
//       setfield /white_matter/burst[{i}] delay1 {interburst_interval * {rand 0 1}}
       addmsg /white_matter/burst[{i}]  /white_matter/mossy_fiber[{i}] RATE output
   end
*/


end


end


