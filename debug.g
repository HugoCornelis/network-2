//genesis
//
// $Id: debug.g 1.7 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// debug.g : debugging routines

int include_debug

if ( {include_debug} == 0 )

	include_debug = 1


///
/// SH:	DebugGranuleInput
///
/// PA:	verbose.: 1 : verbosity on (detailed output)
///		  0 : verbosity off (only totals)
///
/// DE:	Give stats about connection mossy - granule
///

function DebugGranuleInput(iVerbose)

int iVerbose

	//v total of incoming, outgoing, synapses

	int iTotalIn = 0
	int iTotalOut = 0
	int iTotalSynapses = 0

	//- give header

	echo "Granule cell input statistics :"
	echo "==============================="

	//- loop over granule cells

	int i

	for (i = 0; i < {number_granule_cells}; i = i + 1)

		//- count incoming msg's

		int iCountIn \
			= {getmsg \
				/granule_cell_layer/Granule[{i}]/soma/mf_AMPA \
				-incoming \
				-count}

		//- count outgoing msg's

		int iCountOut \
			= {getmsg \
				/granule_cell_layer/Granule[{i}]/soma/mf_AMPA \
				-outgoing \
				-count}

		//- count synapses

		int iSynapses \
			= {getfield \
				/granule_cell_layer/Granule[{i}]/soma/mf_AMPA \
				nsynapses}

		iTotalIn = {iTotalIn} + {iCountIn}
		iTotalOut = {iTotalOut} + {iCountOut}
		iTotalSynapses = {iTotalSynapses} + {iSynapses}

		//- if verbose

		if ( {iVerbose} == 1 )

			//- echo count

			echo {i}" : in("{iCountIn}"), out("{iCountOut}"), syn's("{iSynapses}")"
		end
	end

	//- echo totals

	echo "Totals : in("{iTotalIn}"), out("{iTotalOut}"), syn's("{iTotalSynapses}")"
end


///
/// SH:	DebugMossyOutput
///
/// PA:	verbose.: 1 : verbosity on (detailed output)
///		  0 : verbosity off (only totals)
///
/// DE:	Give stats about connection mossy - granule
///

function DebugMossyOutput(iVerbose)

int iVerbose

	//v total of incoming, outgoing, synapses

	int iTotalIn = 0
	int iTotalOut = 0
	int iTotalSynapses = 0

	//- give header

	echo "Mossy fiber output statistics :"
	echo "==============================="

	//- loop over mossy fibers

	int i

	for (i = 0; i < {number_mossy_fibers}; i = i + 1)

		//- count incoming msg's

		int iCountIn \
			= {getmsg \
				/white_matter/mossy_fiber[{i}] \
				-incoming \
				-count}

		//- count outgoing msg's

		int iCountOut \
			= {getmsg \
				/white_matter/mossy_fiber[{i}]/spike \
				-outgoing \
				-count}

		iTotalIn = {iTotalIn} + {iCountIn}
		iTotalOut = {iTotalOut} + {iCountOut}

		//- if verbose

		if ( {iVerbose} == 1 )

			//- echo count

			echo {i}" : in("{iCountIn}"), out("{iCountOut}")"
		end
	end

	//- echo totals

	echo "Totals : in("{iTotalIn}"), out("{iTotalOut}")"
end


end


