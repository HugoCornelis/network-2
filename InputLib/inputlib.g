//genesis
//
// $Id: inputlib.g 1.6.1.3 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// inputlib.g : input library interface

int include_inputlib

if ( {include_inputlib} == 0 )

	include_inputlib = 1


//////////////////////////////////////////////////////////////////////////////
//o
//o input library
//o -------------
//o
//o unfinished base level overview
//o
//o provides a general interface for various input functions to neurons
//o not finished at all yet.
//o At this moment only a hardcoded funcgen element is present, so the library
//o is completely useless from practical viewpoint.
//o Probably it is better to work with a descriptor array (wel a descriptor 
//o element is better since SLI cannot effectively deal with array's)
//o that describes the fields of a functional element that can be set.
//o Depending on the field descriptions you can automatically set up an
//o x interface.
//o
//o
//o
//o </library/>input/.........:	hierarchy base for input elements
//o </library/>input/f/.......:	functional elements
//o </library/>input/x/.......:	x interface elements
//o
//////////////////////////////////////////////////////////////////////////////


// include functional elements sublib

include ../InputLib/inputlibf.g

// include x interface sublib

include ../InputLib/inputlibx.g


///
/// SH:	InputLibCopy
///
/// PA:	source:	source input element (ending in '/')
///	dest..:	dest input element (ending in '/')
///
/// DE:	Copy input element from source to dest
///	Copies only functional fields
///	Does not update any XODUS elements
///	Only works for hardcoded funcgen element
///

function InputLibCopy(source,dest)

str source
str dest

	setfield {dest}f/func \
		mode {getfield {source}f/func mode} \
		amplitude {getfield {source}f/func amplitude} \
		dc_offset {getfield {source}f/func dc_offset} \
		phase {getfield {source}f/func phase} \
		frequency {getfield {source}f/func frequency} \
		output {getfield {source}f/func output}
end


///
/// SH:	InputLibUpdate
///
/// PA:	path..:	path to input base element (ending in '/')
///
/// DE:	Update input element settings
///

function InputLibUpdate(path)

str path

	//- fill out settings from element (hardcoded funcgen)

	// get title for mode button

	int iMode = {getfield {path}f/func mode}

	// set mode widgets

	setfield {path}x/formMode/sine \
		state {iMode == 0}

	setfield {path}x/formMode/square \
		state {iMode == 1}

	setfield {path}x/formMode/triangle \
		state {iMode == 2}

	setfield {path}x/formMode/constant \
		state {iMode == 3}

	str subtitle
	str fulltitle

	if (iMode == 0)

		subtitle = "Sine"

		fulltitle = {{subtitle} \
				@ ", " \
				@ {getfield {path}f/func frequency} \
				@ " Hz, " \
				@ {getfield {path}f/func amplitude} \
				@ " Ampl."}

	elif (iMode == 1)

		subtitle = "Square"

		fulltitle = {{subtitle} \
				@ ", " \
				@ {getfield {path}f/func frequency} \
				@ " Hz, " \
				@ {getfield {path}f/func amplitude} \
				@ " Ampl."}

	elif (iMode == 2)

		subtitle = "Triangle"

		fulltitle = {{subtitle} \
				@ ", " \
				@ {getfield {path}f/func frequency} \
				@ " Hz, " \
				@ {getfield {path}f/func amplitude} \
				@ " Ampl."}

	elif (iMode == 3)

		subtitle = "Constant"

		fulltitle = {{subtitle} \
				@ " at " \
				@ {getfield {path}f/func amplitude}}

	else

		subtitle = "Buggs"

		fulltitle = {{subtitle} \
				@ ", " \
				@ {getfield {path}f/func frequency} \
				@ " Hz, " \
				@ {getfield {path}f/func amplitude} \
				@ " Ampl."}

	end

	// set global element settings

	setfield {path}x/form/mode \
		title {subtitle}

	setfield {path}x/form/amplitude \
		value {getfield {path}f/func amplitude}

	setfield {path}x/form/dc_offset \
		value {getfield {path}f/func dc_offset}

	setfield {path}x/form/phase \
		value {getfield {path}f/func phase}

	setfield {path}x/form/frequency \
		value {getfield {path}f/func frequency}

	// set global button title

	setfield {path}update \
		title {fulltitle}
end


///
/// SH:	InputLibShow
///
/// PA:	widget:	widget within input hierarchy
///
/// DE:	Show input element settings
///

function InputLibShow(widget)

str widget

	//- get base to input hierarchy

	str inputBase = {getpath {widget} -head}

	//- update input element settings

	InputLibUpdate {inputBase}

	//- show form with global element settings

	xshow {inputBase}x/form
end


///
/// SH:	InputLibCreateLibrary
///
/// PA:	path..........:	input container (ending in '/')
///	fnButtons.....:	input lib creation callback to supply user buttons
///
/// DE:	Create input library
///	Input library comes in {path}input
///

function InputLibCreateLibrary(path,fnButtons)

str path
str fnButtons

	//- if input lib does not exist yet

	if ( ! {exists {path}input} )

		//v input var

		str input

		//- check if we are actually creating a library

		//! to understand this see also function InputLibLinkElement
		//! function InputLibCreateLibrary is also used to create 
		//! actual elements

		if ( {path} == "/library/" )

			//- create library container

			create xform {path}input

			//- set input var to created container

			input = "input/"

		//- else

		else
			//- set input var to empty string

			input = ""
		end

		//- create an element to copy

		create neutral {path}{input}funcgen

		//- create button to show input settings

		create xbutton {path}{input}funcgen/update \
			-script "InputLibShow <w>"

		//- create functional elements

		InputLibfCreateLibrary {path}{input}funcgen/

		//- create x interface elements

		InputLibxCreateLibrary {path}{input}funcgen/ {fnButtons}

		//- update input element settings

		InputLibUpdate {path}{input}funcgen/
	end
end


///
/// SH:	InputLibLinkElement
///
/// PA:	lib...........:	library with input elements (ending in '/')
///	path..........:	input element to be linked (not ending in '/')
///	fnButtons.....:	input lib creation callback to supply user buttons
///
/// DE:	Create linked input library element
///	{path} must be of type funcgen to receive an AMPLITUDE msg
///	The output value can be read from the output field of {path}
///	The path must have a form in its ancestors.
///

function InputLibLinkElement(lib,path,fnButtons)

str lib
str path
str fnButtons

	// copy library element

	//! this code does not work, coz the xodus elements do not take account
	//! of there new (copied) parent form. They stay in the same form,
	//! i.e. in the form in the library.

	//copy {lib}input/funcgen {path}/input

	//! so the above comment explain why we need to ...

	//- make the library at this place

	InputLibCreateLibrary {path}/ {fnButtons}

	//- add message to set output field
/*
** this code deals with the copy command
**
	addmsg {path}/input/f/func {path} \
		AMPLITUDE output
**
** following code deals with the library hacking due to the genesis / xodus bug
** as explained above
*/

	addmsg {path}/funcgen/f/func {path} \
		AMPLITUDE output
end


end


