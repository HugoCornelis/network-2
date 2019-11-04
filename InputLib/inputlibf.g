//genesis
//
// $Id: inputlibf.g 1.5 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// inputlibf.g : input library functional elements

int include_inputlibf

if ( {include_inputlibf} == 0 )

	include_inputlibf = 1



///
/// SH:	InputLibfCreateLibrary
///
/// PA:	path..:	input container (normally ending in '/')
///
/// DE:	Create input library functional elements
///	Input library comes in {path}input
///
///	Create {path}/f/func			{funcgen}
///			mode		[3]
///			amplitude       [45]
///			dc_offset       [45]
///			phase           [0]
///			frequency       [10]
///

function InputLibfCreateLibrary(path)

str path

	//- create library container for functional elements

	create neutral {path}f

	//- create a prototype function generator

	create funcgen {path}f/func

	//- set default values

	//! I explicitly set the (first) output value also

	setfield ^ \
		mode 3 \
		amplitude 45 \
		dc_offset 45 \
		phase 0 \
		frequency 10 \
		output 45
end


end


