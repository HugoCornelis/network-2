//genesis (rmaex 19/6/96)

//include defaults 

/* 
The function "make_Stellate_cell_array" creates {length} Stellate cells,
named /granule_cell_layer/Stellate_cell [0] 
   to /granule_cell_layer/Stellate_cell [{length} - 1].
Each Stellate cell is a copy of the Golgi cell described in Golg1M0.p.
A spikegen object is added to the soma.

*/


include ../Stellate_cell/Stel_const.g 
include ../Stellate_cell/Stel_chan.g
include ../Stellate_cell/Stel_synchan.g 
include ../Stellate_cell/Stel_comp.g 


function make_stellate_cell_array (length)

   int length
   int i
   str cellpath = "/Stellate"

// To ensure that all subsequent elements are made in the library 
   ce /library

// Make the prototypes of channels and compartments that can be invoked in .p files
   make_Golgi_chans
   make_Golgi_syns

   if (!{exists /library/interneuron})
          make_interneuron_comps
   end

   if (!{exists /molecular_layer})
          create neutral /molecular_layer
   end

// MAEX 16/4/96
   setfield /library/interneuron/soma/mf_AMPA normalize_weights 1
   setfield /library/interneuron/soma/pf_AMPA normalize_weights 1

// read cell data from .p file
   readcell ../Stellate_cell/Stel1M0.p {cellpath}

   setfield {cellpath}/soma/GABAA frequency 10

// add a spikegen object
   create spikegen {cellpath}/soma/spike
   setfield {cellpath}/soma/spike thresh 0 \
                                  abs_refract 0.002 \
                                  output_amp 1
   addmsg {cellpath}/soma {cellpath}/soma/spike INPUT Vm

   createmap {cellpath} /molecular_layer \
             {length} 1 -delta {stellate_cell_separation} 0.0 \
                        -origin {(- {stellate_cell_to_Golgi_cell_ratio} / 2) * {stellate_cell_separation}} 0.0

end   





