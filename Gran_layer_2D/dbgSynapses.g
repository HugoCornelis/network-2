//genesis
//
// $Id: dbgSynapses.g 1.5 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// dbgSynapses.g : synapse debugging functions

int include_dbgSynapses

if ( {include_dbgSynapses} == 0 )

	include_dbgSynapses = 1


///
/// SH:	OutputNumberOfSynapses
///
/// PA:	output........:	output file
///	iNeurons......:	number of neurons
///	source........:	source neurons
///	channel.......:	synaptic channel
///
/// DE:	Output number of synapses of the given neurons
///

function OutputNumberOfSynapses(output,iNeurons,source,channel)

str output
int iNeurons
str source
str channel

	int i, nsynapses
	str list = ""

	//- loop over given number of neurons

	for (i = 0; i < {iNeurons}; i = i + 1)

		//- get number of synapses for current neuron

		nsynapses \
			= {getfield \
				{source}[{i}]/{channel} \
				nsynapses}

		//- append to output list

		list = (list) @ {i} @ " " @ {nsynapses} @ " "
	end

	//- write output to file

	echo {i} {list}  > {output}
end


///
/// SH:	OutputSynapticDelays
///
/// PA:	output:	output file
///	source:	source synaptic channel
///
/// DE:	Output synaptic delays of the given channel
///

function OutputSynapticDelays(output,source)

str output
str source

	//- get number of synapses

	int nsynapses = {getfield {source} nsynapses}

	//- initialize output list with number of synapses

	str list = {nsynapses} @ " "
    
	//- loop over all synapses

	for (i = 0; i < {nsynapses}; i = i + 1)

		//- get delay

		str delay = {getfield {source} synapse[{i}].delay}

		//- append to output list

		list = (list) @ {i + 1} @ " " @ {delay} @ " "
	end

	//- write output to file

	echo  {list}  > {output}
end


///
/// SH:	OutputSynapticWeights
///
/// PA:	output:	output file
///	source:	source synaptic channel
///
/// DE:	Output synaptic weights of the given channel
///

function OutputSynapticWeights(output,source)

str output
str source

	//- get number of synapses

	int nsynapses = {getfield {source} nsynapses}

	//- initialize output list with number of synapses

	str list = {nsynapses} @ " "
    
	//- loop over all synapses

	for (i = 0; i < {nsynapses}; i = i + 1)

		str weight = {getfield {source} synapse[{i}].weight}

		//- append to output list

		list = (list) @ {i + 1} @ " " @ {weight} @ " "
	end

	//- write output to file

	echo  {list}  > {output}
end


end


