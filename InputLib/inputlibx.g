//genesis
//
// $Id: inputlibx.g 1.5.1.2 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// inputlibx.g : input library x interface elements

int include_inputlibx

if ( {include_inputlibx} == 0 )

	include_inputlibx = 1



///
/// SH:	XInputModeDone
///
/// PA:	widget: done button in mode form
///
/// DE:	Act after selecting new mode is done
///	hides the form for selecting a new mode
///

function XInputModeDone(widget)

str widget

	//- get path for form widget

	str form = {getpath {widget} -head}

	//- cut off trailing slash

	form = {substring {form} 0 {{strlen {form}} - 2}}

	//- hide the form

	xhide {form}
end


///
/// SH:	XInputModeSet
///
/// PA:	widget: toggled mode widget
///	value.:	value to set in mode field
///
/// DE:	Act after select of new mode
///

function XInputModeSet(widget,value)

str widget
int value

	//- get input base

	str base = {getpath {widget} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	//- set mode field

	setfield {base}f/func \
		mode {value}

	//- update input element settings

	callfunc InputLibUpdate {base}
end


///
/// SH:	XInputTopAmplitude
///
/// PA:	widget: amplitude dialog widget
///	value.:	value in dialog widget
///
/// DE:	Act after change in widget for amplitude field
///

function XInputTopAmplitude(widget,value)

str widget
int value

	//- get input base

	str base = {getpath {widget} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	//- set amplitude field

	setfield {base}f/func \
		amplitude {value}

	//- update input element settings

	callfunc InputLibUpdate {base}
end


///
/// SH:	XInputTopDC_Offset
///
/// PA:	widget:	dc_offset dialog widget
///	value.:	value in dialog widget
///
/// DE:	Act after change in widget for dc_offset field
///

function XInputTopDC_Offset(widget,value)

str widget
int value

	//- get input base

	str base = {getpath {widget} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	//- set dc_offset field

	setfield {base}f/func \
		dc_offset {value}

	//- update input element settings

	callfunc InputLibUpdate {base}
end


///
/// SH:	XInputTopPhase
///
/// PA:	widget:	phase dialog widget
///	value.:	value in dialog widget
///
/// DE:	Act after change in widget for phase field
///

function XInputTopPhase(widget,value)

str widget
int value

	//- get input base

	str base = {getpath {widget} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	//- set phase field

	setfield {base}f/func \
		phase {value}

	//- update input element settings

	callfunc InputLibUpdate {base}
end


///
/// SH:	XInputTopFrequency
///
/// PA:	widget:	frequency dialog widget
///	value.:	value in dialog widget
///
/// DE:	Act after change in widget for frequency field
///

function XInputTopFrequency(widget,value)

str widget
int value

	//- get input base

	str base = {getpath {widget} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	//- set frequency field

	setfield {base}f/func \
		frequency {value}

	//- update input element settings

	callfunc InputLibUpdate {base}
end


///
/// SH:	XInputTopDone
///
/// PA:	widget:	widget path with xinput top level to hide
///
/// DE:	Hide top level form for given xinput widget
///

function XInputTopDone(widget)

str widget

	//- get input base

	str base = {getpath {widget} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	//- end any pending forms for mode

	XInputModeDone {base}x/formMode/done

	//- get path for form widget

	str form = {getpath {widget} -head}

	//- cut off trailing slash

	form = {substring {form} 0 {{strlen {form}} - 2}}

	//- hide the form

	xhide {form}
end


///
/// SH:	XInputTopMode
///
/// PA:	widget:	widget path with xinput top level
///
/// DE:	Handle click on mode button
///	Show mode form for an xinput widget
///

function XInputTopMode(widget)

str widget

	//- get input base

	str base = {getpath {widget} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	//- get path for form widget

	str form = {getpath {widget} -head}

	//- cut off trailing slash

	form = {substring {form} 0 {{strlen {form}} - 2}}

	//- show mode form

	xshow {form}Mode

	//- update input element settings

	callfunc InputLibUpdate {base}
end


///
/// SH:	InputLibxCreateLibrary
///
/// PA:	path..........:	input container (ending in '/')
///	fnButtons.....:	input lib creation callback to supply user buttons
///
/// DE:	Create xinput library
///	XInput library comes in {path}x
///
///	Top level
///
///	Create {path}x/form			{xform}
///	Create {path}x/form/mode		{xbutton}
///	Create {path}x/form/amplitude		{xdialog}
///	Create {path}x/form/dc_offset		{xdialog}
///	Create {path}x/form/phase		{xdialog}
///	Create {path}x/form/frequency		{xdialog}
///
///	mode level
///
///	Create {path}x/formMode			{form}
///	Create {path}x/formMode/sine		{xbutton}
///	Create {path}x/formMode/square		{xbutton}
///	Create {path}x/formMode/triangle	{xbutton}
///	Create {path}x/formMode/constant	{xbutton}
///
///	After creation of the top level widgets, {fnButtons} is called
///	with argument TOP and current element the top level form.
///

function InputLibxCreateLibrary(path,fnButtons)

str path
str fnButtons

	//{
	//1 container
	//2 top level
	//3 mode level
	//}

	//1 container

	//- create library container for x interface elements

	create neutral {path}x

	//2 top level

	//- create form

	//! the geometry provides a place for the 'Apply to all button'
	//! (i.e. the height)
	//! since genesis is not able to calculate the height for a single
	//! widget, there is no means for dynamically calculating the height
	//! of a window when dynamically creating widgets

	create xform {path}x/form \
		-xgeom 0 \
		-wgeom 300 \
		-hgeom 230

	//- make it the current element

	pushe {path}x/form

	//- create header label

	create xlabel header \
		-title "Input function settings"

	//- create mode button

	create xbutton mode \
		-script "XInputTopMode <w>"

	//- create amplitude dialog

	create xdialog amplitude \
		-title "Amplitude : " \
		-script "XInputTopAmplitude <w> <v>"

	//- create offset dialog

	create xdialog dc_offset \
		-title "Offset    : " \
		-script "XInputTopDC_Offset <w> <v>"

	//- create phase dialog

	create xdialog phase \
		-title "Phase     : " \
		-script "XInputTopPhase <w> <v>"

	//- create frequency dialog

	create xdialog frequency \
		-title "Frequency : " \
		-script "XInputTopFrequency <w> <v>"

	//- if there are user supplied buttons

	if ( {fnButtons} != "" )

		//- add user buttons

		callfunc {fnButtons} TOP
	end

	//- create done button

	create xbutton done \
		-script "XInputTopDone <w>"

	// go back to previous current element

	pope

	//3 mode level

	//- create form

	create xform {path}x/formMode \
		-wgeom 165 \
		-hgeom 165

	// make it current element

	pushe {path}x/formMode

	//- create header label

	create xlabel {path}x/formMode/header \
		-title "Change mode"

	//- create sine button

	create xtoggle {path}x/formMode/sine \
		-script "XInputModeSet <w> 0"

	//- create square button

	create xtoggle {path}x/formMode/square \
		-script "XInputModeSet <w> 1"

	//- create triangle button

	create xtoggle {path}x/formMode/triangle \
		-script "XInputModeSet <w> 2"

	//- create constant button

	create xtoggle {path}x/formMode/constant \
		-script "XInputModeSet <w> 3"

	//- if there are user supplied buttons

	if ( {fnButtons} != "" )

		//- add user buttons

		callfunc {fnButtons} MODE
	end

	//- create done button

	create xbutton {path}x/formMode/done \
		-script "XInputModeDone <w>"

	//- go back to previous current element

	pope
end


end


