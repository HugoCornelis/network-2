//genesis
//
// $Id: makeconfig.g 1.6 Mon, 19 Mar 2001 04:16:01 -0600 hugo $
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


// makeconfig.g : automated configuration

// script to make a configuration file for the cerebellar cortex
// partially based on Maex's TEST.g scripts in Granule_cell/ and Golgi_cell/ .
// (well a big part in fact, thanks Reinoud...)

//- give header

echo "------------------------------------------------------------------------"
echo
echo "                       Cerebellar cortex tutorial"
echo "             version " -n
// $Format: "echo \"$ProjectVersion$ ($ProjectDate$)\""$
echo "0.75 (Tue, 09 Oct 2001 14:59:26 +0200)"
echo "                          Configuration script"
echo
echo "------------------------------------------------------------------------"

//- switch to Granule cell directory

cd Granule_cell

//- include default definitions

include defaults.g

//- include granule cell constants

include Gran_const.g

//- include tabchannel prototype functionality

include Gran_chan.g

// include synapse prototype functionality

//include Granule_cell/Gran_synchan.g 

// include compartment prototype functionality

//include Granule_cell/Gran_comp.g 

//- create sublibrary prototype for granule

if (! {exists /library/granule})
    create neutral /library/granule
end

//- and make it current

ce /library/granule

//- make prototype tabchans

make_Granule_chans

// make prototype synchans

//make_Granule_syns

// make prototype compartment

//make_Granule_comps

//- save tabchan data of created prototypes

call Gran_InNa	TABSAVE tabInNa37.data
call Gran_KDr	TABSAVE tabKDr37.data
call Gran_KA	TABSAVE tabKA37.data
call Gran_CaHVA TABSAVE tabCaHVA37.data
call Gran_H	TABSAVE tabH37.data
call Moczyd_KC	TABSAVE tabKCa37.data

//- give diagnostics 

echo "Created tabulated channel data for granule cell"

//- switch to Golgi cell directory

cd ../Golgi_cell

//- include Golgi cell constants

include Golg_const.g 

//- include tabchannel prototype functionality

include Golg_chan.g

// include synapse prototype functionality

//include Golgi_cell/Golg_synchan.g 

// include compartment prototype functionality

//include Golgi_cell/Golg_comp.g 

//- create sublibrary prototype for Golgi

//if (! {exists /library/Golgi})
//    create neutral /library/Golgi
//end

//- and make it current

//ce /library/Golgi

ce /library

//- make prototype tabchans

make_Golgi_chans

// make prototype synchans

//make_Golgi_syns

// make prototype compartment

//make_Golgi_comps

//- save tabchan data of created prototypes

call Gran_InNa	TABSAVE tabInNa37.data
call Gran_KDr	TABSAVE tabKDr37.data
call Gran_KA	TABSAVE tabKA37.data
call Gran_CaHVA TABSAVE tabCaHVA37.data
call Gran_H	TABSAVE tabH37.data
call Moczyd_KC	TABSAVE tabKCa37.data

//- give diagnostics 

echo "Created tabulated channel data for Golgi cell"

//- switch back to original current directory

cd ..

//- make the config file

sh "touch cerebellar.config"

//- quit genesis

quit

