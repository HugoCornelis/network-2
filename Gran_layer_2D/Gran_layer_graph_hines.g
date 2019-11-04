// genesis
// included stellate cells, rmaex 19/6/96

int include_gran_layer_graph_hines

if ( {include_gran_layer_graph_hines} == 0 )

	include_gran_layer_graph_hines = 1


//include defaults
//include Gran_layer_const.g

//v plotting mode for Golgi cells : 
//v	0 == vertical
//v	1 == horizontal
//v	2 == manual

int golgiPlottingMode

//v plotting mode for granule cells : 
//v	0 == vertical
//v	1 == horizontal
//v	2 == manual

int granulePlottingMode


///
/// SH:	XGraphRemovePlot
///
/// PA:	graph.:	path to graph the plot belongs to (not ending in '/')
///	plot..:	path to plot to remove (not ending in '/')
///
/// DE: Remove given plot from its graph
///

function XGraphRemovePlot(graph,plot)

str graph
str plot

	echo "Removing "{plot}" from "{graph}

	//- give diagnostics : not possible

	echo "Removing plots gives core's."
	echo "Use the 'Clear' button (if available) to remove plots"

	// remove the plot

	//delete {plot}

	// reset the graph

	//call {graph} RESET
end


///
/// SH:	XGraphToggleOverlay
///
/// PA:	widget:	name of widget to toggle overlay for
///	state.:	new state for overlay field
///
/// DE:	Toggle the overlay field for the given widget
///

function XGraphToggleOverlay(widget,state)

str widget
str state

	//- if xoverlay element exists

	if ({exists {widget}/xoverlay})

		//- delete the xoverlay element

		delete {widget}/xoverlay
	end

	//- set the overlay field for the given widget

	setfield {widget} overlay {state}
end


///
/// SH:	GraphGolgiRefresh
///
/// DE: Refresh toggle buttons according to golgiPlottingMode
///

function GraphGolgiRefresh

	//- refresh toggles

	setfield /xgraphsGolgi/graphVertical \
		state {golgiPlottingMode == 0}

	setfield /xgraphsGolgi/graphHorizontal \
		state {golgiPlottingMode == 1}

	setfield /xgraphsGolgi/graphManual \
		state {golgiPlottingMode == 2}
end


///
/// SH:	GraphGranuleRefresh
///
/// DE: Refresh toggle buttons according to golgiPlottingMode
///

function GraphGranuleRefresh

	//- refresh toggles

	setfield /xgraphsGranule/graphVertical \
		state {granulePlottingMode == 0}

	setfield /xgraphsGranule/graphHorizontal \
		state {granulePlottingMode == 1}

	setfield /xgraphsGranule/graphManual \
		state {granulePlottingMode == 2}
end


///
/// SH:	XGraphAddGolgiPlot
///
/// PA:	path..:	path to graph element (not ending in '/')
///	index.:	index in Golgi array of element to plot
///	field.:	field to plot
///
/// DE: Add plot to graph for Golgi cells
///	Finds out automatically if solve array or normal solvers are used
///	Solve array is assumed to be '/granule_cell_layer/golgiSolver'
///

function XGraphAddGolgiPlot(path,index,field)

str path
int index
str field

	//! If we create the plot ourselves we will not be able to make it 
	//! visible, so let the graph make the plot and make use of forwarding
	//! plot messages

	//- if solve array exists

	if ( {exists /granule_cell_layer/golgiSolver} )

		echo "Adding plot Golgi array ["{index}"]"

		//- setup msg from solver to plot

		addmsg \
			/granule_cell_layer/golgiSolver \
			{path} \
			PLOT vm[{index}] *{field}_{index} *black 

	//- else

	else
		//- find field in solver

		str solveField \
			= {findsolvefield \
				/granule_cell_layer/Golgi[{index}]/solve \
				soma \
				{field}}

		//- setup msg from solver to plot

		addmsg \
			/granule_cell_layer/Golgi[{index}]/solve \
			{path} \
			PLOT {solveField} *{field}_{index} *black 

	end

	//- create name for plot

	str plotName = {{path} @ "/" @ {field} @ "_" @ {index}}

	//- set script field of plot

	setfield {plotName} \
		script "XGraphRemovePlot "{path}" <w>"

	//- reset plot to make it visible

	//echo "Reset on "{plotName}

	call {plotName} RESET
end


///
/// SH:	XGraphClear
///
/// PA:	graph.:	path to graph element  (not ending in '/')
///
/// DE: Remove all plots from Golgi graph
///

function XGraphClear(graph)

str graph

	//- loop over all plots in the graph

	str plot

	foreach plot ( {el {graph}/##[][TYPE=xplot]} )

		//- remove the plot

		delete {plot}
	end

	//- reset the graph

	call {graph} RESET
end


///
/// SH:	XGraphPlotGolgis
///
/// PA:	path..:	path to graph element (not ending in '/')
///	index.:	index in Golgi array of element to plot
///	field.:	field to plot
///
/// DE: Plot Golgi cells according to golgiPlottingMode
///

function XGraphPlotGolgis(path,index,field)

str path
int index
str field

	//- for vertical mode

	if (golgiPlottingMode == 0)

		//- give diagnostics

		echo "Adding vertical plot for Golgi["{index}"]"

		//- clear Golgi graph

		XGraphClear {path}

		//- set distance for plots according to number of 
		//- Golgis along sagittal axis + some extra

		setfield {path} \
			ymax 0.05 \
			ymin {-0.1 * (ylength_Golgi_cell_array + 5)} \
			yoffset {-0.1}

		//- get first offset at this column

		int iFirst = {index % xlength_Golgi_cell_array}

		// get first index in the array

		//iFirst = {iFirst * ylength_Golgi_cell_array}

		//- get last index at this column

		int iLast = {iFirst + ylength_Golgi_cell_array * xlength_Golgi_cell_array}

		//- loop over all elements in the row

		int i

		for (i = iFirst; i < iLast; i = i + xlength_Golgi_cell_array)

			//- add plot for this Golgi

			XGraphAddGolgiPlot {path} {i} {field}
		end

	//- for horizontal mode

	elif (golgiPlottingMode == 1)

		//- give diagnostics

		echo "Adding horizontal plot for Golgi["{index}"]"

		//- clear Golgi graph

		XGraphClear {path}

		//- set distance for plots according to number of 
		//- Golgi's along parallel fiber axis + some extra

		setfield {path} \
			ymax 0.05 \
			ymin {-0.1 * (xlength_Golgi_cell_array + 5)} \
			yoffset {-0.1}

		//- get first index at this row

		int iFirst = {index / xlength_Golgi_cell_array}

		//- get array offset

		iFirst = {iFirst * xlength_Golgi_cell_array}

		//- get last index at this row

		int iLast = {iFirst + xlength_Golgi_cell_array}

		//- loop over all elements in the row

		int i

		for (i = iFirst; i < iLast; i = i + 1)

			//- add plot for this Golgi

			XGraphAddGolgiPlot {path} {i} {field}
		end

	//- for manual mode

	elif (golgiPlottingMode == 2)

		//- give diagnostics

		echo "Adding plot for Golgi["{index}"]"
/*
		//- set distance for plots according to number of 
		//- Golgi's along parallel fiber axis

		setfield {path} \
			ymax 0.05 \
			ymin {-0.1 * xlength_Golgi_cell_array} \
			yoffset {-0.1}
*/
		//- add plot for this Golgi

		XGraphAddGolgiPlot {path} {index} {field}

	//- else

	else

		//- give diagnostics : messed up

		echo "XGraphPlotGolgis : somebody messed up the code"
	end

	//- reset the graph

	call {path} RESET
end


///
/// SH:	GraphGolgisHorizontal
///
/// DE: Set Golgi plotting mode to horizontal
///

function GraphGolgisHorizontal

	//- set Golgi plotting mode

	golgiPlottingMode = 1

	//- refresh toggles

	GraphGolgiRefresh
end


///
/// SH:	GraphGolgisManual
///
/// DE: Set Golgi plotting mode to manual
///

function GraphGolgisManual

	//- set Golgi plotting mode

	golgiPlottingMode = 2

	//- refresh toggles

	GraphGolgiRefresh
end


///
/// SH:	GraphGolgisVertical
///
/// DE: Set Golgi plotting mode to vertical
///

function GraphGolgisVertical

	//- set Golgi plotting mode

	golgiPlottingMode = 0

	//- refresh toggles

	GraphGolgiRefresh
end


///
/// SH:	GraphGranulesHorizontal
///
/// DE: Set granule plotting mode to horizontal
///

function GraphGranulesHorizontal

	//- set granule plotting mode

	granulePlottingMode = 1

	//- refresh toggles

	GraphGranuleRefresh
end


///
/// SH:	GraphGranulesManual
///
/// DE: Set granule plotting mode to manual
///

function GraphGranulesManual

	//- set granule plotting mode

	granulePlottingMode = 2

	//- refresh toggles

	GraphGranuleRefresh
end


///
/// SH:	GraphGranulesVertical
///
/// DE: Set granule plotting mode to vertical
///

function GraphGranulesVertical

	//- set granule plotting mode

	granulePlottingMode = 0

	//- refresh toggles

	GraphGranuleRefresh
end


///
/// SH:	XGraphAddGranulePlot
///
/// PA:	path..:	path to graph element (not ending in '/')
///	index.:	index in Granule array of element to plot
///	field.:	field to plot
///
/// DE: Add plot to graph for Granule cells
///	Finds out automatically if solve array or normal solvers are used
///	Solve array is assumed to be '/granule_cell_layer/granuleSolver'
///

function XGraphAddGranulePlot(path,index,field)

str path
int index
str field

	//- if solve array exists

	if ( {exists /granule_cell_layer/granuleSolver} )

		echo "Adding plot granule array ["{index}"]"

		//- setup msg from solve array to plot

		addmsg /granule_cell_layer/granuleSolver \
			{path} \
			PLOT vm[{index}] *{field}_{index} *black

	//- else

	else
		//- find field in solver

		str solveField \
			= {findsolvefield \
				/granule_cell_layer/Granule[{index}]/solve \
				soma \
				{field}}

		//- setup msg from solver to plot

		addmsg /granule_cell_layer/Granule[{index}]/solve \
			{path} \
			PLOT {solveField} *{field}_{index} *black 
	end

	//- reset the plot to make it visible

	call {path}/{field}_{index} RESET
end


///
/// SH:	XGraphPlotGranules
///
/// PA:	path..:	path to graph element (not ending in '/')
///	index.:	index in granule array of element to plot
///	field.:	field to plot
///
/// DE: Plot granule cells according to granulePlottingMode
///

function XGraphPlotGranules(path,index,field)

str path
int index
str field

	//- for vertical mode

	if (granulePlottingMode == 0)

		//- give diagnostics

		echo "Adding vertical plot for granule["{index}"]"

		//- clear granule graph

		XGraphClear {path}

		//- determine step size for max 10 cells

		int iStep = {max 1 {ylength_granule_cell_array / 10}}

		//- set distance for plots according to step size
		//- + some extra

		setfield {path} \
			ymax 0.05 \
			ymin {-0.1 * (iStep + 5)} \
			yoffset {-0.1}

		//- get first offset at this column

		int iFirst = {index % xlength_granule_cell_array}

		// get first index in the array

		//iFirst = {iFirst * ylength_granule_cell_array}

		//- get last index at this column

		int iLast = {iFirst + ylength_granule_cell_array * xlength_granule_cell_array}

		//- loop over all elements in the row

		int i

		for (i = iFirst; i < iLast; i = i + iStep * xlength_granule_cell_array)

			//- add plot for this granule

			XGraphAddGranulePlot {path} {i} {field}
		end

	//- for horizontal mode

	elif (granulePlottingMode == 1)

		//- give diagnostics

		echo "Adding horizontal plot for granule["{index}"]"

		//- clear granule graph

		XGraphClear {path}

		//- determine step size for max 10 cells

		int iStep = {max 1 {xlength_granule_cell_array / 10}}

		//- set distance for plots according to step size
		//- + some extra

		setfield {path} \
			ymax 0.05 \
			ymin {-0.1 * (iStep + 5)} \
			yoffset {-0.1}

		//- get first index at this row

		int iFirst = {index / xlength_granule_cell_array}

		//- get array offset

		iFirst = {iFirst * xlength_granule_cell_array}

		//- get last index at this row

		int iLast = {iFirst + xlength_granule_cell_array}

		//- loop over all elements in the row

		int i

		for (i = iFirst; i < iLast; i = i + iStep)

			//- add plot for this granule

			XGraphAddGranulePlot {path} {i} {field}
		end

	//- for manual mode

	elif (granulePlottingMode == 2)

		//- give diagnostics

		echo "Adding plot for granule["{index}"]"
/*
		// set distance for plots according to number of 
		// granules along parallel fiber axis

		setfield {path} \
			ymax 0.05 \
			ymin {-0.1 * xlength_granule_cell_array} \
			yoffset {-0.1}
*/
		//- add plot for this granule

		XGraphAddGranulePlot {path} {index} {field}

	//- else

	else

		//- give diagnostics : messed up

		echo "XGraphPlotGranules : somebody messed up the code"
	end

	//- reset the graph

	call {path} RESET
end


///
/// SH:	XGraphGolgiCells
///
/// PA:	path..:	path with parent form (ending in '/')
///
/// DE: Create graph for the mentioned cells/fibers
///	setup made for at most 10 Golgi plots
///

function XGraphGolgiCells(path)

str path

	//- give diagnostics

	echo "Setting up Golgi cell plot..." -n

	//- set default Golgi plotting mode

	golgiPlottingMode = 1

	//- create toggles to select horizontally, vertically, or manually

	create xtoggle {path}graphHorizontal \
		-xgeom 5% \
		-ygeom 5:parent.top \
		-wgeom 30% \
		-state {golgiPlottingMode == 1} \
		-title "Horizontal row" \
		-script "GraphGolgisHorizontal"

	create xtoggle {path}graphVertical \
		-xgeom 0:last.right \
		-ygeom 5:parent.top \
		-wgeom 30% \
		-state {golgiPlottingMode == 0} \
		-title "Vertical column" \
		-script "GraphGolgisVertical"

	create xtoggle {path}graphManual \
		-xgeom 0:last.right \
		-ygeom 5:parent.top \
		-wgeom 30% \
		-state {golgiPlottingMode == 2} \
		-title "Manual select" \
		-script "GraphGolgisManual"

	//- create button for clearing graph

	create xbutton {path}clear \
		-xgeom 5% \
		-ygeom 0:parent.bottom \
		-wgeom 45% \
		-title "Clear" \
		-script "XGraphClear "{path}"/graphGolgi"

	//- add toggle for overlay

	create xtoggle {path}overlay \
		-xgeom 0:clear.right \
		-ygeom 0:parent.bottom \
		-wgeom 45% \
		-title "" \
		-script "XGraphToggleOverlay "{path}"/graphGolgi <v>"

	//- set on/off labels

	setfield {path}overlay \
		offlabel "Overlay off" \
		onlabel "Overlay on"

	//- create and init graph

	create xgraph {path}graphGolgi \
		-xgeom 5% \
		-ygeom 10:graphManual.bottom \
		-wgeom 90% \
		-hgeom 10:clear.top \
		-title "Golgi cells"

	setfield ^ \
		xmin 0 \
		xmax {time_axis_graph} \
		ymin {-0.1 * 10} \
		ymax 0.05 \
		XUnits "t (sec)" \
		yoffset -0.1

	useclock ^ 9

	//- give diagnostics

	echo " done"
end



///
/// SH:	XGraphGranuleCells
///
/// PA:	path..:	path with parent form (ending in '/')
///
/// DE: Create graph for the mentioned cells/fibers
///	setup made for at most 20 Granule cells
///

function XGraphGranuleCells(path)

str path

	//- give diagnostics

	echo "Setting up Granule cell plot..." -n

	//- set default Golgi plotting mode

	granulePlottingMode = 1

	//- create toggles to select horizontally, vertically, or manually

	create xtoggle {path}graphHorizontal \
		-xgeom 5% \
		-ygeom 5:parent.top \
		-wgeom 30% \
		-state {granulePlottingMode == 1} \
		-title "Horizontal row" \
		-script "GraphGranulesHorizontal"

	create xtoggle {path}graphVertical \
		-xgeom 0:last.right \
		-ygeom 5:parent.top \
		-wgeom 30% \
		-state {granulePlottingMode == 0} \
		-title "Vertical column" \
		-script "GraphGranulesVertical"

	create xtoggle {path}graphManual \
		-xgeom 0:last.right \
		-ygeom 5:parent.top \
		-wgeom 30% \
		-state {granulePlottingMode == 2} \
		-title "Manual select" \
		-script "GraphGranulesManual"

	//- create button for clearing graph

	create xbutton {path}clear \
		-xgeom 5% \
		-ygeom 0:parent.bottom \
		-wgeom 45% \
		-title "Clear" \
		-script "XGraphClear "{path}"/graphGranule"

	//- add toggle for overlay

	create xtoggle {path}overlay \
		-xgeom 0:clear.right \
		-ygeom 0:parent.bottom \
		-wgeom 45% \
		-title "" \
		-script "XGraphToggleOverlay "{path}"/graphGranule <v>"

	//- set on/off labels

	setfield {path}overlay \
		offlabel "Overlay off" \
		onlabel "Overlay on"

	//- create and init graph

	create xgraph {path}graphGranule \
		-xgeom 5% \
		-ygeom 10:graphManual.bottom \
		-wgeom 90% \
		-hgeom 10:clear.top \
		-title "Granule cells"

	setfield ^ \
		xmin 0 \
		xmax {time_axis_graph} \
		ymin {-0.1 * 20} \
		ymax 0.05 \
		XUnits "t (sec)" \
		yoffset -0.1

	useclock ^ 9

	//- give diagnostics

	echo " done"
end


///
/// SH:	XGraphAllMossyFibers
///
/// PA:	path..:	path with parent form (ending in '/')
///
/// DE: Create graph for the mentioned cells/fibers
///	comments created with a fast emacs macro
///

function XGraphAllMossyFibers(path)

str path

	//- give diagnostics

	echo "Setting up mossy fiber plot..." -n

	//   create xlabel {path}mossy_fibers -title "Mossy fibers" [1%, 2%, 32%, 25]

	create xgraph {path}graphAllMossy \
		[0%, 2%, 25%, 97%] \
		-title "Mossy fibers"

	setfield ^ \
		xmin 0 \
		xmax {time_axis_graph} \
		ymin 0 \
		ymax {number_mossy_fibers} \
		XUnits "t (sec)"

	useclock ^ 9

/*
** fast version to generate core's

	str mossy

	foreach mossy ( {el /white_matter/mossy_fiber[]} )

		addmsg {mossy}/spike ^ PLOTSCALE state *"mf"{i} *black 0.5 {i}
	end

** slow and robust version follows
*/

	int i

	for (i = 0; i < {number_mossy_fibers}; i = i + 1)

		addmsg /white_matter/mossy_fiber[{i}]/spike ^ \
			PLOTSCALE state *"mf"{i} *black 0.5 {i}
	end


	//- give diagnostics

	echo " done"
end


///
/// SH:	XGraphAllGolgiCells
///
/// PA:	path..:	path with parent form (ending in '/')
///
/// DE: Create graph for the mentioned cells/fibers
///	comments created with a fast emacs macro
///

function XGraphAllGolgiCells(path)

str path

	//- give diagnostics

	echo "Setting up Golgi cell plot..." -n

	//   create xlabel {path}Golgi_cells -title "Golgi cells" [34%, 2%, 32%, 25]

	create xgraph {path}graphAllGolgi \
		[25%, 2%, 25%, 97%] \
		-title "Golgi cells"

	setfield ^ \
		xmin 0 \
		xmax {time_axis_graph} \
		ymin {-0.1 * number_Golgi_cells} \
		ymax 0.05 \
		XUnits "t (sec)" \
		yoffset -0.1

	useclock ^ 9

/*
** fast version to generate core's

	str golgi

	foreach golgi ( {el /granule_cell_layer/Golgi[]} )

		str field = {findsolvefield {golgi}/solve soma Vm}

		addmsg {golgi}/solve ^ PLOT {field} *"Vm" *black
	end

** slow and robust version follows
*/

	int i

	for (i = 0; i < {number_Golgi_cells}; i = i + 1)

		str field = {findsolvefield \
				/granule_cell_layer/Golgi[{i}]/solve \
				soma \
				Vm}

		addmsg /granule_cell_layer/Golgi[{i}]/solve ^ \
			PLOT {field} *"Vm" *black 
	end

	//- give diagnostics

	echo " done"
end



///
/// SH:	XGraphAllGranuleCells
///
/// PA:	path..:	path with parent form (ending in '/')
///
/// DE: Create graph for the mentioned cells/fibers
///	comments created with a fast emacs macro
///

function XGraphAllGranuleCells(path)

str path

	//- give diagnostics

	echo "Setting up Granule cell plot..." -n

	//   create xlabel {path}granule_cells -title "Granule cells" [67%, 2%, 32%, 25]
 
	create xgraph {path}graphAllGranule \
		[50%, 2%, 25%, 97%] \
		-title "Granule cells"

	setfield ^ \
		xmin 0 \
		xmax {time_axis_graph} \
		ymin {-0.1 * number_granule_cells} \
		ymax 0.05 \
		XUnits "t (sec)" \
		yoffset -0.1

	useclock ^ 9

/*
** fast version to generate core's

	str granule

	foreach granule ( {el /granule_cell_layer/Granule[]} )

		str field = {findsolvefield {granule}/solve soma Vm}

		addmsg {granule}/solve ^ PLOT {field} *"Vm" *black
	end

** slow and robust version follows
*/

	int i

	for (i = 0; i < {number_granule_cells}; i = i + 1)

		str field = {findsolvefield \
				/granule_cell_layer/Granule[{i}]/solve \
				soma \
				Vm}

		addmsg /granule_cell_layer/Granule[{i}]/solve ^ \
			PLOT {field} *"Vm" *black 
	end

	//- give diagnostics

	echo " done"
end


///
/// SH:	XGraphAllStellateCells
///
/// PA:	path..:	path with parent form (ending in '/')
///
/// DE: Create graph for the mentioned cells/fibers
///	comments created with a fast emacs macro
///

function XGraphAllStellateCells(path)

str path

	//- give diagnostics

	echo "Setting up Stellate cell plot..." -n

	//   create xlabel {path}granule_cells -title "Granule cells" [67%, 2%, 32%, 25]
 
	create xgraph {path}graphAllStellate \
		[75%, 2%, 25%, 97%] \
		-title "Stellate cells"

	setfield ^ \
		xmin 0 \
		xmax {time_axis_graph} \
		ymin {-0.1 * number_stellate_cells} \
		ymax 0.05 \
		XUnits "t (sec)" \
		yoffset -0.1

	useclock ^ 9

/*
** fast version to generate core's

	str stellate

	foreach stellate ( {el /molecular_layer/Stellate[]} )

		str field = {findsolvefield {stellate}/solve soma Vm}

		addmsg {stellate}/solve ^ PLOT {field} *"Vm" *black
	end

** slow and robust version follows
*/

	int i

	for (i = 0; i < {number_stellate_cells}; i = i + 1)

		str field = {findsolvefield \
				/molecular_layer/Stellate[{i}]/solve \
				soma \
				Vm}

		addmsg /molecular_layer/Stellate[{i}]/solve ^ \
			PLOT {field} *"Vm" *black 
	end

	//- give diagnostics

	echo " done"
end


///
/// SH:	XGraphAllCreate
///
/// DE: Create output form and graph for all cells and all fibers
///	Use this function only if speed does not matter...
///

function XGraphAllCreate

	create xform /xgraphsAll \
		[0,0,900,420]

	useclock ^ 9

	if ({{number_mossy_fibers}  > 0})
		XGraphAllMossyFibers /xgraphsAll/
	end

	if ({{number_Golgi_cells}   > 0})
		XGraphAllGolgiCells /xgraphsAll/
	end

	if ({{number_granule_cells} > 0})
		XGraphAllGranuleCells /xgraphsAll/
	end

	if ({{number_stellate_cells} > 0})
		XGraphAllStellateCells /xgraphsAll/
	end

	xshow /xgraphsAll
end


///
/// SH:	XGraphCreate
///
/// DE: create output graph for Golgi and granule cells
///

function XGraphCreate

	//- create form for Granule cells

	create xform /xgraphsGranule \
		[500,420,400,420]

	//- set clock

	useclock ^ 9

	//- create output graph for Granule cells

	XGraphGranuleCells /xgraphsGranule/

	//- create form for Golgi cells

	create xform /xgraphsGolgi \
		[500,0,400,420]

	//- set clock

	useclock ^ 9

	//- create output graph for Golgi cells

	XGraphGolgiCells /xgraphsGolgi/

	//- show granule graph

	xshow /xgraphsGranule

	//- show Golgi graph

	xshow /xgraphsGolgi
end


end


