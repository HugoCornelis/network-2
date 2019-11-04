//genesis
//
// $Id: input.g 1.14.1.2 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// input.g : mossy fiber input variants

int include_input

if ( {include_input} == 0 )

	include_input = 1


// include input library

include ../InputLib/inputlib.g


/*
//v state for mossy fiber input :
//v 0 =	normal input
//v 1 =	horizontal input
//v 2 = vertical input

int mossyState = 0
*/


//v actual main input form

str inputMainForm = "/input"

//v actual index for main input form

int inputMainIndex = 0

//v number of grid cells x

int iGridx = 3

//v number of grid cells y

int iGridy = 3


///
/// SH:	InputAddMessages
///
/// PA:	source........:	input element
///	destination...:	destination elements (array without index)
///	iXBlock.......:	number of block in x
///	iYBlock.......:	number of block in y
///	iXSource......:	number of steps in x for source grid
///	iYSource......:	number of steps in y for source grid
///	iXDestination.:	number of steps in x for destination grid
///	iYDestination.:	number of steps in y for destination grid
///
/// DE:	Add input msg from source to destination elements
///	Destination elements are blocked in the given destination array
///	via the given source grid
///

function InputAddMessages(source,destination,iXBlock,iYBlock,iXSource,iYSource,iXDestination,iYDestination)

str source
str destination
int iXBlock
int iYBlock
int iXSource
int iYSource
int iXDestination
int iYDestination

	//v y loop var

	int y

	//v x loop var

	int x

	//- determine step size x

	int iXStep = 1

	//- determine step size y

	int iYStep = {iXDestination}

	//- get begin y of block

	int iYBegin = {iYBlock * iYDestination / iYSource}

	//- get begin y of block

	int iYEnd = {(iYBlock + 1) * iYDestination / iYSource}

	//- get begin y of block within array

	int iYBlockBegin = {iYBegin * iYStep}

	//- get end y of array block (one block in y)

	int iYBlockEnd = {iYEnd * iYStep}

	//- loop over y direction

	//echo "Connecting block ("{iXBlock}","{iYBlock}") in y from "{iYBlockBegin}" to "{iYBlockEnd}" with step "{iYStep}

	for (y = iYBlockBegin; y < iYBlockEnd; y = y + iYStep)

		//- get begin x of block

		int iXBegin = {iXBlock * iXDestination / iXSource}

		//- get end x of block

		int iXEnd = {(iXBlock + 1) * iXDestination / iXSource}

		//- get begin x of y step

		int iXBlockBegin = {iXBegin * iXStep}

		//- get end x of y step (width of block in x)

		int iXBlockEnd = {iXEnd * iXStep}

		//- loop over x direction

		//echo "    Connecting block ("{iXBlock}","{iYBlock}") in x from "{iXBlockBegin}" to "{iXBlockEnd}" with step "{iXStep}

		for (x = y + iXBlockBegin; x < y + iXBlockEnd; x = x + iXStep)

			//- add message from source to destination

			//echo "        Adding msg from "{source}" to destination["{x}"]"

			addmsg {source} {destination}[{x}] RATE output
		end
	end
end


///
/// SH:	InputApplyToAll
///
/// PA:	std. InputLib XODUS callback parameters
///
/// DE:	Act after click on 'Apply to all' button
///

function InputApplyToAll(widget)

str widget

	//- get input base

	str base = {getpath {widget} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	base = {substring {base} 0 {{strlen {base}} - 2}}

	base = {getpath {base} -head}

	str baseUnslashed = {substring {base} 0 {{strlen {base}} - 2}}

	//- give diagnostics

	echo "Applying settings from "{base}" for other buttons"

	//- loop over all input elements

	str input

	foreach input ( {el {inputMainForm}[{inputMainIndex}]/buttons/y[]/x[]/mossy/funcgen} )

		//- if input elements do not match

		if ( {baseUnslashed} != {input} )

			//- copy from source input to dest input

			InputLibCopy {base} {input}/

			//- update the dest input

			InputLibUpdate {input}/
		end
	end
end


///
/// SH:	InputCreateApplyToAll
///
/// PA:	std. InputLib creation callback parameters
///
/// DE:	Create 'Apply to all' buttons for a hardcoded funcgen input element 
///

function InputCreateApplyToAll(level)

str level

	//- if we are on the top level

	if ( {level} == "TOP" )

		//- create apply to all button

		create xbutton applyToAll \
			-title "Apply to all" \
			-script "InputApplyToAll <w>"
	end
end


///
/// SH:	InputCreate
///
/// DE:	Create input elements and input interface elements
///	Assumes already initialized input library in '/library/'
///	Creates input grid according to {iGridx} and {iGridy} and connects
///	the grid elements to '/white_matter/mossy_fiber[]'
///

function InputCreate

	//- give diagnostics

	echo "Setting up input to mossy fibers : grid ("{iGridx}","{iGridy}")"

	//- create input container

	create xform {inputMainForm}[{inputMainIndex}] \
		[300,470,600,200] \
		-title "Input panel"

	//- create header label

	create xlabel {inputMainForm}[{inputMainIndex}]/header \
		-title "Mossy fiber settings"

	//- create label and dialogs for grid settings

	create xlabel {inputMainForm}[{inputMainIndex}]/grid \
		-ygeom 3:header.bottom \
		-wgeom 50% \
		-title "Grid resolution : "

	create xdialog {inputMainForm}[{inputMainIndex}]/gridx \
		-xgeom 0:grid.right \
		-ygeom 0:header.bottom \
		-wgeom 25% \
		-title " X : " \
		-value {iGridx} \
		-script "callfunc InputSetGrid <v> "{iGridy}

	create xdialog {inputMainForm}[{inputMainIndex}]/gridy \
		-xgeom 0:gridx.right \
		-ygeom 0:header.bottom \
		-wgeom 25% \
		-title " Y : " \
		-value {iGridy} \
		-script "callfunc InputSetGrid "{iGridx}" <v>"

	//- create button to close the input panel

	create xbutton {inputMainForm}[{inputMainIndex}]/done \
		-ygeom 0:parent.bottom \
		-title "Done" \
		-script "xhide "{inputMainForm}"["{inputMainIndex}"]"

	//- create buttons container

	create xform {inputMainForm}[{inputMainIndex}]/buttons \
		-xgeom 0:parent.left \
		-ygeom 5:grid.bottom \
		-wgeom 100% \
		-hgeom 0:last.top \
		-nested

/*
	// determine step size x

	int iXStep = 1

	// determine step size y

	int iYStep = {xnumber_mossy_fibers}

	// determine number of columns in a block

	float iXBlockStep = {xnumber_mossy_fibers / iGridx}

	// determine number of rows in a block

	float iYBlockStep = {xnumber_mossy_fibers * ynumber_mossy_fibers / iGridy}
*/
	//- loop over y

	int y

	for (y = 0; y < iGridy; y = y + 1)

		//- create y container

		create xform {inputMainForm}[{inputMainIndex}]/buttons/y[{y}] \
			-ygeom {100 / iGridy * (iGridy - y - 1)}% \
			-hgeom {100 / (iGridy)}% \
			-nested

		//- loop over x

		int x

		for (x = 0; x < iGridx; x = x + 1)

			//- create x container

			create xform {inputMainForm}[{inputMainIndex}]/buttons/y[{y}]/x[{x}] \
				[{100 * x / iGridx}%,0,{100 / iGridx}%,100%] \
				-nested

			//- create input element

			create funcgen {inputMainForm}[{inputMainIndex}]/buttons/y[{y}]/x[{x}]/mossy

			setfield ^ \
				mode 3

			//- create linked input library element

			InputLibLinkElement \
				/library/ \
				{inputMainForm}[{inputMainIndex}]/buttons/y[{y}]/x[{x}]/mossy \
				InputCreateApplyToAll

			//- set default firing rate parameters

			//! these paras should be hided with a function call
			//! but getting that OO would probably be a lot of 
			//! extra work, slow and very dangerous to trigger 
			//! unneeded cores

			setfield {inputMainForm}[{inputMainIndex}]/buttons/y[{y}]/x[{x}]/mossy/funcgen/f/func \
				mode 3 \
				amplitude {mossy_fiber_firing_rate} \
				dc_offset {mossy_fiber_firing_rate} \
				phase {round {rand 0 360}} \
				frequency {round {rand 7 20}} \
				output {mossy_fiber_firing_rate}

			//- update the element

			//! seems something is wrong here : why do I need to
			//! give /mossy/funcgen as para instead of just /mossy

			InputLibUpdate {inputMainForm}[{inputMainIndex}]/buttons/y[{y}]/x[{x}]/mossy/funcgen/

			//- add msg from input element to selected mossy fibers

			InputAddMessages \
				{inputMainForm}[{inputMainIndex}]/buttons/y[{y}]/x[{x}]/mossy \
				/white_matter/mossy_fiber \
				{x} \
				{y} \
				{iGridx} \
				{iGridy} \
				{xnumber_mossy_fibers} \
				{ynumber_mossy_fibers}
		end
	end

/*
** obsolete code
**
	// disable input element

	//disable {inputMainForm}[{inputMainIndex}]

	// create element to set mossy fibers to the default rate

	create neutral {inputMainForm}[{inputMainIndex}]/mossyreset

	// set field for mossy fiber rate

	setfield ^ \
		z {mossy_fiber_firing_rate}
*/
/*
	// create three elements for horizontal mossy bars

	create neutral {inputMainForm}[{inputMainIndex}]/mossyhorz0
	create neutral {inputMainForm}[{inputMainIndex}]/mossyhorz1
	create neutral {inputMainForm}[{inputMainIndex}]/mossyhorz2

	// create three elements for vertical mossy bars

	create neutral {inputMainForm}[{inputMainIndex}]/mossyvert0
	create neutral {inputMainForm}[{inputMainIndex}]/mossyvert1
	create neutral {inputMainForm}[{inputMainIndex}]/mossyvert2

	// add messages for horizontal mossy fibers

	int i

	for (i = 0; i < 3; i = i + 1)

		// calc first mossy in the bar

		int iFirst = {i * number_mossy_fibers / 3}

		// calc last mossy in the bar

		int iLast = {iFirst + number_mossy_fibers / 3}

		// loop over mossy fibers in the bar

		str mossy

		foreach mossy \
		( {el white_matter/mossy_fiber[{iFirst}-{iLast}]} )

			// add message

			addmsg {inputMainForm}[{inputMainIndex}]/mossyhorz{i} {mossy} \
				RATE z
		end
	end

	// set default state for mossy fibers : normal input

	mossyState = 0
*/
end


///
/// SH:	InputDeleteAll
///
/// DE:	Delete all input elements
///	This function can generate core's. In fact it does not work at all...
///	DO NOT USE.
///

function InputDeleteAll

	//v element list with elements to delete

	str list

	//- loop over all input forms

	str form

	foreach form ( {el {inputMainForm}[{inputMainIndex}]/##[][TYPE=xform]} )

		//- register element in opposite order

		list = {{form} @ " " @ {list}}
	end

	//- loop over all registered elements

	str element

	foreach element ( {list} )

		//- delete the element

		delete {element}
	end

	//- delete main input form

	delete {inputMainForm}[{inputMainIndex}]
end


///
/// SH:	InputDeleteAll
///
/// PA:	source........:	source wildcard
///	destination...:	destination array
///
/// DE:	Delete all input messages to destination
///	Just deletes the first outgoing msg on the elements generated by the
///	source wildcard
///

function InputDeleteMessages(source,destination)

str source
str destination

	//- loop over the source elements

	str element

	foreach element ( {el {source}} )

		//- count outgoing msg's for the element

		int iCount = {getmsg {element} -outgoing -count}

		//- loop over the outgoing msg's

		int i

		for (i = 0; i < iCount; i = i + 1)

			//- delete outgoing msg

			deletemsg {element} 0 -outgoing
		end
	end
end


///
/// SH:	InputSetGrid
///
/// PA:	newx..:	new x grid value
///	newy..:	new y grid value
///
/// DE:	Adjust input grid to given parameters
///	For the moment the form with the previous settings is just hidden 
///	instead of deleted. Deleting forms gave more core's and frustration 
///	as satisfaction during testing.
///	Resets simulation to give new elements PROCESS actions, probably better
///	to remove this for future versions and do it a functional layer higher
///

function InputSetGrid(newx,newy)

int newx
int newy

	//- delete old messages

	InputDeleteMessages \
		{inputMainForm}[{inputMainIndex}]/buttons/y[]/x[]/mossy \
		/white_matter/mossy_fiber

	// delete old input elements

	//! this gives a core, so don't do it

	//delete {inputMainForm}[{inputMainIndex}]

	// delete old input elements

	//! this gives a core, so don't do it

	//InputDeleteAll

	//- hide previous input elements

	xhide {inputMainForm}[{inputMainIndex}]

	disable {inputMainForm}[{inputMainIndex}]

	//- set new main form index for input elements

	inputMainIndex = {inputMainIndex + 1}

	//- set new grid dimensions

	iGridx = {newx}

	iGridy = {newy}

	//- initialize input

	InputCreate

	//- reset simulation to give new element PROCESS actions

	reset

	//- show input form

	xshow {inputMainForm}[{inputMainIndex}]
end


///
/// SH:	InputInit
///
/// DE:	Create input elements and input interface elements
///

function InputInit

	//- create input library

	InputLibCreateLibrary /library/

	//- create input elements

	InputCreate

	// show input form

	//xshow {inputMainForm}[{inputMainIndex}]
end


///
/// SH:	InputShow
///
/// DE:	Show input interface form
///

function InputShow

	//- show input form

	xshow {inputMainForm}[{inputMainIndex}]
end


end


