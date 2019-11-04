// genesis

include Gran_layer_const.g

  str label = "NS_2D_300mf_300Go_22233gr_diadend3_mf0-80"


str mossy_fibers_history_filename   = (filename) @ "mossy_fibers_"   @ {label} @ ".history"
str Golgi_cells_history_filename    = (filename) @ "Golgi_cells_"    @ {label} @ ".history"
str Stellate_cells_history_filename = (filename) @ "Stellate_cells_" @ {label} @ ".history" 
str granule_cells_history_filename  = (filename) @ "granule_cells_"  @ {label} @ ".history"

int i
 int size_message_list


// mossy fibers

   if ({number_mossy_fibers > 0})
      echo initializing {mossy_fibers_history_filename}
      create spikehistory mossy_fibers.history
      setfield mossy_fibers.history ident_toggle 0 \ // index
                                    filename {mossy_fibers_history_filename} \
                                    initialize 1 leave_open 1 flush 1
//      size_message_list = {{getfield mossy_fibers.history allocmsgin} + \
//                                     {8 * number_mossy_fibers} + 16}
//      setfield mossy_fibers.history allocmsgin {size_message_list}
//      for (i = 0; {i < number_mossy_fibers}; i = i + 1)
          addmsg /white_matter/mossy_fiber[]/spike \
                               mossy_fibers.history SPIKESAVE
//      end
   end


// Golgi cells

   if ({number_Golgi_cells > 0})
      echo initializing {Golgi_cells_history_filename}
      create spikehistory Golgi_cells.history
      setfield Golgi_cells.history ident_toggle 0 \ // index
                                   filename {Golgi_cells_history_filename} \
                                   initialize 1 leave_open 1 flush 1
//      size_message_list = {{getfield Golgi_cells.history allocmsgin} + \
//                                     {8 * number_Golgi_cells} + 16}
//      setfield Golgi_cells.history allocmsgin {size_message_list}
//      for (i = 0; {i < number_Golgi_cells}; i = i + 1)
           addmsg /granule_cell_layer/Golgi[]/soma/spike \
                                      Golgi_cells.history SPIKESAVE
//      end
   end


// granule cells

   if ({number_granule_cells > 0})
      echo initializing {granule_cells_history_filename}
      create spikehistory granule_cells.history
      setfield granule_cells.history ident_toggle 0 \ // index
                                     filename {granule_cells_history_filename} \
                                     initialize 1 leave_open 1 flush 1
//      size_message_list = {{getfield granule_cells.history allocmsgin} + \
//                                     {8 * number_granule_cells} + 16}
//      setfield granule_cells.history allocmsgin {size_message_list}
//      for (i = 0; {i < number_granule_cells}; i = i + 1)
          addmsg /granule_cell_layer/Granule[]/soma/spike \
                                     granule_cells.history SPIKESAVE
//      end
   end


// Stellate cells

   if ({number_stellate_cells > 0})
      echo initializing {stellate_cells_history_filename}
      create spikehistory stellate_cells.history
      setfield stellate_cells.history ident_toggle 0 \ // index
                                      filename {stellate_cells_history_filename} \
                                      initialize 1 leave_open 1 flush 1
//      size_message_list = {{getfield stellate_cells.history allocmsgin} + \
//                                     {8 * number_stellate_cells} + 16}
//      setfield stellate_cells.history allocmsgin {size_message_list}
//      for (i = 0; {i < number_stellate_cells}; i = i + 1)
           addmsg /molecular_layer/Stellate[]/soma/spike \
                                   stellate_cells.history SPIKESAVE
//      end
   end
