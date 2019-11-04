//genesis
//
// $Id: output.g 1.2 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// output.g : output variants

int include_output

if ( {include_output} == 0 )

	include_output = 1


///
/// SH:	OutputInit
///
/// DE:	Create output elements and output interface elements
///

function OutputInit

	//- create output elements

//	OutputCreate
end


///
/// SH:	OutputShow
///
/// DE:	Show output interface form
///

function OutputShow

	//- show output form

	xshow /output
end


end


