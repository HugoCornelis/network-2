// genesis

int include_gran_layer_view_setup

if ( {include_gran_layer_view_setup} == 0 )

	include_gran_layer_view_setup = 1


include movie.g


///
/// SH:	XAxonViewGranulesGolgis
///
/// PA:	bArray...: 1 if solvearray's are used
///	path.....: parent for all created elements (ending in '/')
///	command..: command give to setup connections
///
/// DE:	Create xaxonview for granule - Golgi connections
///	Created output elements use clock 10
///
/// NO: command is overwritten with a hardcoded copy of the intended command
///	from Gran_layer_setup.g
///

function XAxonViewGranulesGolgis(bArray,path,command)

int bArray
str path
str command

//	planarconnect \
//		/granule_cell_layer/Granule[]/soma/spike \
//		/granule_cell_layer/Golgi[]/soma/pf_AMPA \
//		-relative \
//		-verbose \
//		-sourcemask \
//			box -1e10 -1e10 1e10 1e10 \
//		-destmask \
//			box \
//				-{parallel_fiber_length / 2.0} \
//				-{Golgi_cell_dendritic_diameter / 2.0} \
//				{parallel_fiber_length / 2.0} \
//				{Golgi_cell_dendritic_diameter / 2.0} \
//		-probability {P_granule_cell_to_Golgi_cell_synapse}

	command \
		= {"planarconnect" \
		   @ " /granule_cell_layer/Granule[]/soma/spike" \
		   @ " /granule_cell_layer/Golgi[]/soma/pf_AMPA" \
		   @ " -relative" \
		   @ " -verbose" \
		   @ " -sourcemask" \
		   @ " box -1e10 -1e10 1e10 1e10" \
		   @ " -destmask" \
		   @ " box" \
		   @ " -{parallel_fiber_length / 2.0}" \
		   @ " -{Golgi_cell_dendritic_diameter / 2.0}" \
		   @ " {parallel_fiber_length / 2.0}" \
		   @ " {Golgi_cell_dendritic_diameter / 2.0}" \
		   @ " -probability {P_granule_cell_to_Golgi_cell_synapse}" }

	int i
	int xlength = {getfield /config xlength_granule_cell_array}
	int ylength = {getfield /config ylength_granule_cell_array}

	//- create xaxonview object

	create xaxonview {path}granulesGolgis

/*	setfield {path}granulesGolgis \
		xgeom 100% \
		ygeom 100% \
		source \
			{"/granule_cell_layer/" \
			 @ "Granule[0-" \
			 @ {getfield /config xlength_granule_cell_array}}
*/

	setfield {path}granulesGolgis \
		fYMin {fGranulePosYMin} \
		fYMax {fGranulePosYMax} \
		length {parallel_fiber_length / 2.0} \
		velocity {parallel_fiber_conduction_velocity} \
		source[0] \
			{"/granule_cell_layer/" \
				@ "Granule[" \
				@ "0" \
				@ "-" \
				@ {(xlength * ylength) / 4 - 1} \
				@ "]/soma/spike" } \
		source[1] \
			{"/granule_cell_layer/" \
				@ "Granule[" \
				@ {(xlength * ylength) / 4} \
				@ "-" \
				@ {2 * (xlength * ylength) / 4 - 1} \
				@ "]/soma/spike" } \
		source[2] \
			{"/granule_cell_layer/" \
				@ "Granule[" \
				@ {2 * (xlength * ylength) / 4} \
				@ "-" \
				@ {3 * (xlength * ylength) / 4 - 1} \
				@ "]/soma/spike" } \
		source[3] \
			{"/granule_cell_layer/" \
				@ "Granule[" \
				@ {3 * (xlength * ylength) / 4} \
				@ "-" \
				@ {4 * (xlength * ylength) / 4 - 1} \
				@ "]/soma/spike" }

	//- loop over selected granule cells

	for (i = 0; i < (xlength * ylength) / 4 ; i = i + 1)

		//- send SPIKE from soma to axonview

		addmsg \
			/granule_cell_layer/Granule[{i}]/soma/spike \
			{path}granulesGolgis \
			SPIKE
	end

	for (i = (xlength * ylength) / 4; i < 2 * (xlength * ylength) / 4 ; i = i + 1)

		//- send SPIKE from soma to axonview

		addmsg \
			/granule_cell_layer/Granule[{i}]/soma/spike \
			{path}granulesGolgis \
			SPIKE
	end

	for (i = 2 * (xlength * ylength) / 4; i < 3 * (xlength * ylength) / 4 ; i = i + 1)

		//- send SPIKE from soma to axonview

		addmsg \
			/granule_cell_layer/Granule[{i}]/soma/spike \
			{path}granulesGolgis \
			SPIKE
	end

	for (i = 3 * (xlength * ylength) / 4; i < 4 * (xlength * ylength) / 4 ; i = i + 1)

		//- send SPIKE from soma to axonview

		addmsg \
			/granule_cell_layer/Granule[{i}]/soma/spike \
			{path}granulesGolgis \
			SPIKE
	end


	// set colors to use for different spike sources

	setfield {path}granulesGolgis \
		ppcColor[0] red \
		ppcColor[1] green \
		ppcColor[2] blue \
		ppcColor[3] grey


	//- set clock

	useclock {path}granulesGolgis 10

	//- RESET axonview

	call {path}granulesGolgis RESET

	//- schedule the new element

	reset
end


///
/// SH:	XAxonViewCreateGG
///
/// PA:	bArray:	1 if solvearray's are used
///	path..:	parent for all created elements (ending in '/')
///
/// DE:	Create forms and xaxonviews for golgi and granule cells
///	Created output elements use clock 10
///	Uses fGranulePos X/Y Min/Max globals to set the visible area of
///	the draw containing the axonviews
///

function XAxonViewCreateGG(bArray,path)

int bArray
str path

	//- give diagnostics

	echo "Creating axonview on granule cell - Golgi cell synapses"

	//- create form

	create xform {path}xaxonview [0,0,500,420]

	//- create heading label

	create xlabel {path}xaxonview/heading \
		-title "Golgi & Granule connections"

	//- create draw within form

	create xdraw {path}xaxonview/draw \
		-hgeom 0:parent.bottom \
		-transform z \
		-bg white

	//- set min/max fields from granule array

	setfield ^ \
		xmin {fGranulePosXMin - 0.002} \
		xmax {fGranulePosXMax + 2 * parallel_fiber_length + 0.001 } \
		ymin {fGranulePosYMin} \
		ymax {fGranulePosYMax} \
		fg white

	//- create axonview for connections

	XAxonViewGranulesGolgis {bArray} {path}xaxonview/draw/

	//- remove previous movie images

	sh "rm 2>/dev/null -f /tmp/movies/*"

	//- create movie elements

	sh "mkdir 2>/dev/null /tmp/movies"

	MovieCreateElements {path}xaxonview/ /tmp/movies/granGolgi 500 600

	MovieCreateElements {path}xaxonview/ /tmp/movies/granGolgi 800 900

	//- show form

	xshow {path}xaxonview
end


///
/// SH:	XAxonViewCreate
///
/// PA:	bArray:	1 if solvearray's are used
///
/// DE:	Create forms and xaxonviews for all connections
///	Created output elements use clock 10
///

function XAxonViewCreate(bArray)

int bArray

	//- create neutral for all axonviews

	create neutral /axonviews

	//- create for granule cell - Golgi cell connection

	//! You can switch on the view on the mossy fibers by uncommenting 
	//! the following line, xview objects have a serious speed penalty
	//! When you switch the view on from the genesis command line (by
	//! typing 'XViewCreateM'), prepare for removing cores from the 
	//! the shell command line...
	//! Best is to do first a reset, but don't expect correct results
	//! when used from the genesis command line.

	XAxonViewCreateGG {bArray} /axonviews/
end


///
/// SH:	XAxonViewDelete
///
/// DE:	Delete all xaxonviews
///

function XViewDelete

	//- delete all views

	delete /axonviews
end


end


