// genesis

int include_gran_layer_view_hines

if ( {include_gran_layer_view_hines} == 0 )

	include_gran_layer_view_hines = 1


//include defaults
//include Gran_layer_const.g


function echovalue(widget)

str widget

	echo widget : {widget}

	echo value : {getfield {widget} value}

end


///
/// SH:	XViewMakeGolgi
///
/// PA:	bArray:	1 if solvearray's are used
///	path..:	path with parent form (ending in /)
///
/// DE:	Create xview with Golgi cells
///	Created output elements use clock 9
///	Uses fGolgiPos X/Y Min/Max globals
///	Uses /granule_cell_layer/Golgi[]/soma as displayed
///	compartments (coordinates),
///	Uses /granule_cell_layer/Golgi[]/solve as displayed values
///

function XViewMakeGolgi(bArray,path)

int bArray
str path

	//- create view for Golgi cell soma's

	create xview {path}draw/golgi

	//- set fields :
	//-	transposition x,y
	//-	scale
	//-	min/max values : -80 to 50 mV
	//-	use color for display of voltage
	//-	script : to add plot

	setfield ^ \
		sizescale {{getfield /Golgi/soma dia} * 4} \
		value_min[0] -0.080 \
		value_max[0] 0.050 \
		color_val 0 \
		morph_val 1 \
		valuemode index \
		script {"XGraphPlotGolgis " \
			@ "/xgraphsGolgi/graphGolgi " \
			@ "<v> " \
			@ "Vm"}

/*
		tx {-fGolgiPosXMin} \
		ty {fGolgiPosYMin} \
*/

	//- set clock for view on granules

	useclock ^ 9

	//- give diagnostics

	echo "Setting coordinates for Golgi cells..." -n

	//- set coords from Golgi cells

	addmsg /granule_cell_layer/Golgi[]/soma {path}draw/golgi \
		COORDS x y z

	//- give diagnostics

	echo " done"

	echo "Setting display values for Golgi cells..." -n

	//- if solve array's are used

	if (bArray)

		//- loop over all Golgi cells

		int i

		for (i = 0; i < {number_Golgi_cells}; i = i + 1)

			//- add message from solve array to view

			addmsg \
				/granule_cell_layer/golgiSolver \
				{path}draw/golgi \
				VAL1 vm[{i}]
		end
	//- else

	else
		//- loop over all Golgi cells

		str golgi

		foreach golgi ( {el /granule_cell_layer/Golgi[]} )

			//- value msg from associated solver to view

			addmsg \
				{golgi}/solve \
				{path}draw/golgi \
				VAL1 {findsolvefield \
					{golgi}/solve \
					{golgi}/soma \
					Vm}
		end
	end

	//- give diagnostics

	echo " done"
end


///
/// SH:	XViewMakeGranule
///
/// PA:	bArray:	1 if solvearray's are used
///	path..:	path with parent form (ending in /)
///
/// DE:	Create xview with granule cells
///	Created output elements use clock 9
///	Uses fGolgiPos X/Y Min/Max globals
///	Uses /granule_cell_layer/Granule[]/soma as displayed
///	compartments (coordinates),
///	Uses /granule_cell_layer/Granule[]/solve as displayed values
///

function XViewMakeGranule(bArray,path)

int bArray
str path

	//- create view for granule cell soma's

	create xview {path}draw/granule

	//- set fields :
	//-	transposition x,y
	//-	scale
	//-	min/max values : -80 to 30 mV
	//-	use color for display of voltage

	setfield ^ \
		sizescale {{getfield /Granule/soma dia} * 150} \
		value_min[0] -0.080 \
		value_max[0] 0.030 \
		color_val 1 \
		morph_val 0 \
		valuemode index \
		script {"XGraphPlotGranules " \
			@ "/xgraphsGranule/graphGranule " \
			@ "<v> " \
			@ "Vm"}
/*
		tx {-fGolgiPosXMin} \
		ty {fGolgiPosYMin} \
*/
	//- set clock for view on granules

	useclock ^ 9

	//- give diagnostics

	echo "Setting coordinates for granule cells..." -n

	//- set coords from granule cells

	addmsg /granule_cell_layer/Granule[]/soma {path}draw/granule \
		COORDS x y z

	//- give diagnostics

	echo " done"

	echo "Setting display values for granule cells..." -n

	//- if solve array's are used

	if (bArray)

		//- loop over all granule cells

		int i

		for (i = 0; i < {number_granule_cells}; i = i + 1)

			//- add message from solve array to view

			addmsg \
				/granule_cell_layer/granuleSolver \
				{path}draw/granule \
				VAL1 vm[{i}]
		end

	//- else

	else
		//- loop over all granule cells

		str granule

		foreach granule ( {el /granule_cell_layer/Granule[]} )

			//- value msg from associated solver to view

			addmsg \
				{granule}/solve \
				{path}draw/granule \
				VAL1 {findsolvefield \
					{granule}/solve \
					{granule}/soma \
					Vm}
		end
	end

	//- give diagnostics

	echo " done"
end


///
/// SH:	XViewMakeMossy
///
/// PA:	path..:	path with parent form (ending in /)
///
/// DE:	Create xview with granule cells
///	Created output elements use clock 9
///	Uses fGolgiPos X/Y Min/Max globals
///	Uses /white_matter/mossy_fiber[] as displayed coordinates,
///	Uses /white_matter/mossy_fiber[]/spike as displayed values
///

function XViewMakeMossy(path)

str path

	//- create view for mossy fibers

	create xview {path}draw/mossy

	//- set fields :
	//-	transposition x,y
	//-	scale
	//-	min/max values : -80 to 30 mV
	//-	use color for display of voltage

	setfield ^ \
		sizescale {0.003} \
		value_min[0] 20 \
		value_max[0] 70 \
		color_val 1 \
		morph_val 0 \
		valuemode index \
		script "echo mossy fiber : <v>"
/*
		tx {-fGolgiPosXMin} \
		ty {fGolgiPosYMin} \
*/
/*
** copied from granules
**
		script {"XGraphAddGranulePlot " \
			@ "/xgraphsGranule/graphGranule " \
			@ "<v> " \
			@ "Vm"}
*/

/*
** these are for message with state field instead of rate field
**
		value_min[0] 0.5 \
		value_max[0] 0.501 \
*/

	//- set clock for view on mossy fibers

	useclock ^ 9

	//- give diagnostics

	echo "Setting coordinates for mossy fibers..." -n

	//- set coords from mossy fibers

	addmsg /white_matter/mossy_fiber[] {path}draw/mossy \
		COORDS x y z

	//- give diagnostics

	echo " done"

	echo "Setting display values for mossy fibers..." -n

	//- loop over all mossy fibers

	str mossy

	foreach mossy ( {el /white_matter/mossy_fiber[]} )

		//- value msg from randomspike to view

		addmsg {mossy} {path}draw/mossy \
			VAL1 rate
	end

	//- give diagnostics

	echo " done"
end


///
/// SH:	XViewCreateGG
///
/// PA:	bArray:	1 if solvearray's are used
///	path..:	parent for all created elements (ending in '/')
///
/// DE:	Create forms and xviews for golgi and granule cells
///	Created output elements use clock 9
///	Uses fGranulePos X/Y Min/Max globals to set the visible area of
///	the draw containing the views
///

function XViewCreateGG(bArray,path)

int bArray
str path

	//- give diagnostics

	echo "Creating view on granule cells and Golgi cells"

	//- create form

	create xform {path}xview [0,0,500,420]

	//- create heading label

	create xlabel {path}xview/heading \
		-title "Golgi & Granule output"

	//- create draw within form

	create xdraw {path}xview/draw \
		-hgeom 0:parent.bottom \
		-transform z \
		-bg white

	//- set min/max fields from granule array

	setfield ^ \
		xmin {fGranulePosXMin - 0.0002} \
		xmax {fGranulePosXMax + 0.0002} \
		ymin {fGranulePosYMin - 0.0001} \
		ymax {fGranulePosYMax + 0.0001}

	//- create view for granule cells

	XViewMakeGranule {bArray} {path}xview/

	//- create view for Golgi cells

	XViewMakeGolgi {bArray} {path}xview/

	//- show form

	xshow {path}xview
end


///
/// SH:	XViewCreateM
///
/// PA:	bArray:	1 if solvearray's are used
///	path..:	parent for all created elements (ending in '/')
///
/// DE:	Create forms and xviews for mossy fibers
///	Created output elements use clock 9
///	Uses fGranulePos X/Y Min/Max globals to set the visible area of
///	the draw containing the views
///

function XViewCreateM(bArray,path)

int bArray
str path

	//- give diagnostics

	echo "Creating view on mossy fibers"

	//- create form for mossy fibers

	create xform {path}xviewMossy [0,0,500,420]

	//- create heading label

	create xlabel {path}xviewMossy/heading \
		-title "Mossy fiber activity"

	//- create draw within form

	create xdraw {path}xviewMossy/draw \
		-hgeom 0:parent.bottom \
		-transform z \
		-bg white

	//- set min/max fields from granule array

	setfield ^ \
		xmin {fGranulePosXMin - 0.0002} \
		xmax {fGranulePosXMax + 0.0002} \
		ymin {fGranulePosYMin - 0.0001} \
		ymax {fGranulePosYMax + 0.0001}

	//- create view for mossy fibers

	XViewMakeMossy {path}xviewMossy/

	//- show form

	xshow {path}xviewMossy
end


///
/// SH:	XViewCreate
///
/// PA:	bArray:	1 if solvearray's are used
///
/// DE:	Create forms and xviews for golgi and granule cells, mossy fibers
///	Created output elements use clock 9
///

function XViewCreate(bArray)

int bArray

	//- create neutral for all views

	create neutral /views

	//- create for Mossy fibers

	//! You can switch on the view on the mossy fibers by uncommenting 
	//! the following line, xview objects have a serious speed penalty
	//! When you switch the view on from the genesis command line (by
	//! typing 'XViewCreateM'), prepare for removing cores from the 
	//! the shell command line...
	//! Best is to do first a reset, but don't expect correct results
	//! when used from the genesis command line.

	XViewCreateM {bArray} /views/

	//- create for Granule cells and Golgi cells

	XViewCreateGG {bArray} /views/
end


///
/// SH:	XViewDelete
///
/// DE:	Delete xviews for golgi and granule cells, mossy fibers
///

function XViewDelete

	//- delete all views

	delete /views
end


end


