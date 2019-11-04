// genesis

int include_movie

if ( {include_movie} == 0 )

	include_movie = 1


int movie_static = 0


///
/// SH:	GIFMake
///
/// PA:	xwID....: window ID to create gif file for
///	label...: label to prepend to the file name
///	iBegin..: first step
///	iEnd....: last step
///
/// DE:	Dump gif for window xwID, unique for ({label},{time})
///	
///

function GIFMake(xwID,label,iBegin,iEnd)

str xwID
str label
int iBegin
int iEnd

	//- get actual step

	str actual = {getstat -step}

	if (actual >= iBegin && actual < iEnd)

/*
		// dump gif file

		xwd -silent -id {xwID} \
		| xwdtopnm \
		| ppmtogif >{label}.{actual}.gif
*/

		xdump /axonviews/xaxonview {label}.{actual}.ppm
	end
end


///
/// SH:	MovieCreateElements
///
/// PA:	path...: parent xform for created elements (ending in '/')
///	label..: prefix label for filenames
///	iBegin.: first step
///	iEnd...: last step
///
/// DE:	Create elements for creating a movie of the given xform
///	Created elements use clock 10
///

function MovieCreateElements(path,label,iBegin,iEnd)

str path
str label
int iBegin
int iEnd

	//- give diagnostics

	echo "Creating movie elements for "{path}" with label "{label}

	//- create script out

	create script_out {path}_movie{movie_static}

	//- increment movie element count

	movie_static = {movie_static} + 1

	//- set clock

	useclock ^ 10

	//- set command to create an image at every time step

/*
** failure of lexical analyzer with this one
**
	setfield ^ \
		command {"xwd -silent -id " \
			 @ {getfield {path} xwID} \
			 @ " | xwdtopnm | ppmtogif >" \
			 @ {label} \
			 @ ".{getstat -time}" \
			 @ ".gif"}
*/

	setfield ^ \
		command {"GIFMake " \
			 @ {getfield {path} xwID} \
			 @ " " \
			 @ {label} \
			 @ " " \
			 @ {iBegin} \
			 @ " " \
			 @ {iEnd}}

//	create script_out {path}sched

//	useclock ^ 10

//	setfield ^ command "echo Scheduled at {getstat -time}"

	//- schedule elements

	//call {path}_movie RESET

	reset

end


end


