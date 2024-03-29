//genesis
//
// $Id: info.g 1.2.1.2 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// info.g : help/credits functionality

int include_info

if ( {include_info} == 0 )

	include_info = 1


///
/// SH:	InfoHelp
///
/// DE:	Show help
///

function InfoHelp

	//- show the help form

	xshow /info/help
end


///
/// SH:	InfoHelpCreate
///
/// PA:	parent:	parent to create help form in (ending in '/')
///
/// DE:	Create help widgets
///

function InfoHelpCreate(parent)

str parent

	//- create a form for help

	create xform {parent}help \
		-xgeom 200 \
		-ygeom 0 \
		-wgeom 600 \
		-hgeom 800

	//- make created form current element

	pushe {parent}help

	//- create title label

	create xlabel heading \
		-label "Network tutorial help"

	//- create a button for closing the window

	create xbutton close \
		-ygeom 0:parent.bottom \
		-title "Close" \
		-script "xhide "{parent}"help"

	//- create text widget for help

	create xtext help \
		-ygeom 0:heading.bottom \
		-hgeom 0:close.top \
		-filename "help.txt"

	//- go to previous current element

	pope
end


///
/// SH:	InfoCredits
///
/// DE:	Show the credits
///

function InfoCredits

	//- show the credits form

	xshow /info/credits
end


///
/// SH:	InfoCreditsCreate
///
/// PA:	parent:	parent to create credits form in (ending in '/')
///
/// DE:	Create credits widgets
///

function InfoCreditsCreate(parent)

str parent

	//- create a form for the credits

	create xform {parent}credits \
		-xgeom 200 \
		-ygeom 330 \
		-wgeom 450 \
		-hgeom 200

	//- make created form current element

	pushe {parent}credits

	//- create title label

	create xlabel heading \
		-label "Genesis script credits"

	//- create a button for closing the window

	create xbutton close \
		-ygeom 0:parent.bottom \
		-title "Close" \
		-script "xhide "{parent}"credits"

	//- create text widget for credits

	create xtext credits \
		-ygeom 0:heading.bottom \
		-hgeom 0:close.top \
		-filename "credits.txt"

	//- go to previous current element

	pope
end


///
/// SH:	InfoCreate
///
/// DE:	Create help and credits widgets
///

function InfoCreate

	//- create parent element for all information

	create neutral /info

	//- create widgets for help

	InfoHelpCreate /info/

	//- create widgets for credits

	InfoCreditsCreate /info/
end


end


