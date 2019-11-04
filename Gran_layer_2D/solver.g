//genesis
//
// $Id: solver.g 1.8 Tue, 09 Oct 2001 07:59:26 -0500 hugo $
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


// solver.g : functions dealing with solve element

int include_solver

if ( {include_solver} == 0 )

	include_solver = 1


///
/// SH:	SolverGranulesConnect
///
/// DE:	Connect solvers for granule cells
///	Automatically finds out about solve array.
///	Solve array is assumed to '/granule_cell_layer/granuleSolver'
///

function SolverGranulesConnect

	int i

	//- if solve array exists

	if ( {exists /granule_cell_layer/granuleSolver} )

		//- if there are granule cells

		if ({{number_granule_cells} > 0})

			//- give diagnostics

			echo "Connecting hsolves array of granule cells"

			//- connect granule solve array

			call /granule_cell_layer/granuleSolver HSOLVE_CONNECT
		end

	//- else

	else
		//- if there are granule cells

		if ({{number_granule_cells} > 0})

			//- give diagnostics

			echo "Connecting hsolves of granule cells"

			//- loop over all granule cells

			for (i = 0; i < {number_granule_cells}; i = i + 1)

				//- connect current granule solver

				call /granule_cell_layer/Granule[{i}]/solve \
					HSOLVE_CONNECT
			end
		end
	end
end


///
/// SH:	SolverGranulesCreate
///
/// PA:	bArray:	1 if solvearray's should be created
///
/// DE:	Create solvers for granule cells
///

function SolverGranulesCreate(bArray)

int bArray

	int i

	//- if solvearray requested

	if (bArray)

		//- if there are granule cells

		if ({{number_granule_cells} > 0})

			//- create solve array

			create hsolvearray /granule_cell_layer/granuleSolver

			//- set fields for solve array

			pushe /granule_cell_layer/granuleSolver
			setfield . \
				path "../Granule[]/##[][TYPE=compartment]" \
				comptmode 1 \
				chanmode {chanmode}

			call . SETUP

			pope
		end

	//- else

	else
		//- if there are granule cells

		if ({{number_granule_cells} > 0})

			//- give diagnostics

			echo "Making hsolve of granule cells"

			//- create solver for first granule cell

			create hsolve /granule_cell_layer/Granule[0]/solve

			//- switch to solver

			ce /granule_cell_layer/Granule[0]/solve

			//- set fields for solver

			setfield . \
				path "../##[][TYPE=compartment]" \
				comptmode 1 \
				chanmode {chanmode}

			//- set method : Crank-Nicholson

			setmethod . 11

			//- setup solver

			call . SETUP

			//- switch to granule cell

			ce /granule_cell_layer/Granule[0]

			//- loop over all remaining granule cells

			for (i = {number_granule_cells}; i > 1; i = i - 1)

				//- duplicate solver for first granule cell

				call solve  DUPLICATE \ 
					/granule_cell_layer/Granule[{i-1}]/solve \
					../##[][TYPE=compartment]
			end
		end
	end
end


///
/// SH:	SolverGolgisConnect
///
/// DE:	Connect solvers for Golgi cells
///	Automatically finds out about solve array.
///	Solve array is assumed to '/granule_cell_layer/golgiSolver'
///

function SolverGolgisConnect

	int i

	//- if solve array exists

	if ( {exists /granule_cell_layer/golgiSolver} )

		//- if there are Golgi cells

		if ({{number_Golgi_cells} > 0})

			//- give diagnostics

			echo "Connecting hsolve array of Golgi cells"

			//- connect Golgi solve array

			call /granule_cell_layer/golgiSolver HSOLVE_CONNECT
		end

	//- else

	else
		//- if there are Golgi cells

		if ({{number_Golgi_cells} > 0})

			//- give diagnostics

			echo "Connecting hsolves of Golgi cells"

			//- loop over all Golgi cells

			for (i = 0; i < {number_Golgi_cells}; i = i + 1)

				//- connect current Golgi solver

				call \
					/granule_cell_layer/Golgi[{i}]/solve \
					HSOLVE_CONNECT
			end
		end
	end
end


///
/// SH:	SolverGolgisCreate
///
/// PA:	bArray:	1 if solvearray's should be created
///
/// DE:	Create solvers for Golgi cells
///

function SolverGolgisCreate(bArray)

int bArray

	int i

	//- if solvearray requested

	if (bArray)

		//- if there are Golgi cells

		if ({{number_Golgi_cells} > 0})

			//- create solve array

			create hsolvearray /granule_cell_layer/golgiSolver

			//- set fields for solve array

			pushe /granule_cell_layer/golgiSolver
			setfield . \
				path "../Golgi[]/##[][TYPE=compartment]" \
				comptmode 1 \
				chanmode {chanmode}

			call . SETUP

			pope
		end

	//- else

	else
		//- if there are Golgi cells

		if ({{number_Golgi_cells} > 0})

			//- give diagnostics

			echo "Making hsolve of Golgi cells"

			//- create solver for first Golgi cell

			create hsolve /granule_cell_layer/Golgi[0]/solve

			//- switch to solver

			ce /granule_cell_layer/Golgi[0]/solve

			//- set fields for solver

			setfield . \
				path "../##[][TYPE=compartment]" \
				comptmode 1 \
				chanmode {chanmode}

			//- set method : Crank-Nicholson

			setmethod /granule_cell_layer/Golgi[0]/solve 11

			//- setup the solver

			call /granule_cell_layer/Golgi[0]/solve SETUP

			//- switch to Golgi cell

			ce /granule_cell_layer/Golgi[0]

			//- loop over all remaining Golgi cells

			for (i = {number_Golgi_cells}; i > 1; i = i - 1)

				//- duplicate solver from first Golgi cell

				call solve  DUPLICATE \ 
					/granule_cell_layer/Golgi[{i-1}]/solve \
					/granule_cell_layer/Golgi[{i-1}]/##[][TYPE=compartment]
			end
		end
	end
end


///
/// SH:	SolverStellatesConnect
///
/// DE:	Connect solvers for stellate cells
///	Automatically finds out about solve array.
///	Solve array is assumed to '/molecular_layer/stellateSolver'
///

function SolverStellatesConnect

	int i

	//- if solve array exists

	if ( {exists /molecular_layer/stellateSolver} )

		//- if there are stellate cells

		if ({{number_stellate_cells} > 0})

			//- give diagnostics

			echo "Connecting hsolves array of stellate cells"

			//- connect stellate solve array

			call /molecular_layer/stellateSolver HSOLVE_CONNECT
		end

	//- else

	else
		//- if there are stellate cells

		if ({{number_stellate_cells} > 0})

			//- give diagnostics

			echo "Connecting hsolves of stellate cells"

			//- loop over all stellate cells

			for (i = 0; i < {number_stellate_cells}; i = i + 1)

				//- connect current stellate solver

				call \
					/molecular_layer/Stellate[{i}]/solve \
					HSOLVE_CONNECT
			end
		end
	end
end


///
/// SH:	SolverStellatesCreate
///
/// PA:	bArray:	1 if solvearray's should be created
///
/// DE:	Create solvers for Stellate cells
///

function SolverStellatesCreate(bArray)

int bArray

	int i

	//- if solvearray requested

	if (bArray)

		//- if there are stellate cells

		if ({{number_stellate_cells} > 0})

			//- create solve array

			create hsolvearray /molecular_layer/stellateSolver

			//- set fields for solve array

			pushe /molecular_layer/stellateSolver

			setfield . \
				path "../Stellate[]/##[][TYPE=compartment]" \
				comptmode 1 \
				chanmode {chanmode}

			call . SETUP

			pope
		end

	//- else

	else
		//- if there are stellate cells

		if ({{number_stellate_cells} > 0})

			//- give diagnostics

			echo "Making hsolve of stellate cells"

			//- create solver for first stellate cell

			create hsolve /molecular_layer/Stellate[0]/solve

			//- switch to solver

			ce /molecular_layer/Stellate[0]/solve

			//- set fields for solver

			setfield . \
				path "../##[][TYPE=compartment]" \
				comptmode 1 \
				chanmode {chanmode}

			//- set method : Crank-Nicholson

			setmethod /molecular_layer/Stellate[0]/solve 11

			//- setup solver

			call /molecular_layer/Stellate[0]/solve SETUP

			//- switch back to stellate cell

			ce /molecular_layer/Stellate[0]

			//- loop over all remaining stellate cells

			for (i = {number_stellate_cells}; i > 1; i = i - 1)

				//- duplicate solver from first stellate cell

				call solve  DUPLICATE \
					/molecular_layer/Stellate[{i-1}]/solve \
					/molecular_layer/Stellate[{i-1}]/##[][TYPE=compartment]
			end
		end
	end
end


///
/// SH:	SolverGranularLayerConnect
///
/// DE:	Connect all solvers for the granular layer
///	Connects solver for 
///		Granule cells via SolverGranulesConnect
///		Golgi cells via SolverGolgisConnect
///		Stellate cells via SolverStellatesConnect
///

function SolverGranularLayerConnect

	//- connect solvers for granules

	SolverGranulesConnect

	//- connect solvers for Golgis

	SolverGolgisConnect

	//- connect solvers for stellates

	SolverStellatesConnect
end


///
/// SH:	SolverGranularLayerCreate
///
/// PA:	bArray:	1 if solvearray's should be created
///
/// DE:	Create all solvers for the granular layer
///	Creates solver for 
///		Granule cells via SolverGranulesCreate
///		Golgi cells via SolverGolgisCreate
///		Stellate cells via SolverStellatesCreate
///

function SolverGranularLayerCreate(bArray)

int bArray

	//- create solvers for granules

	SolverGranulesCreate {bArray}

	//- create solvers for Golgis

	SolverGolgisCreate {bArray}

	//- create solvers for stellates

	SolverStellatesCreate {bArray}
end


end


