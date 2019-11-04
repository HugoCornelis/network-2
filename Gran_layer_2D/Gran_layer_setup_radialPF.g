// genesis

// function makesynapse now in C-code
// used position function when creating granule cells, rmaex 27/9/96

// included stellate cells, rmaex 19/6/96

//include defaults
//include Gran_layer_const.g


function make_synapse (pre, post, weight, delay)
   str     pre, post
   float   weight, delay
   int     syn_num

   addmsg {pre} {post} SPIKE
   syn_num = {getfield {post} nsynapses} - 1
   setfield {post} synapse[{syn_num}].weight  {weight} \
                   synapse[{syn_num}].delay   {delay}
end

function mossy_fiber_index (i, j)
   int i, j, index

   index = {(j - 1) * xnumber_mossy_fibers + i - 1}
   return (index)
end

  
/*************************  neurons and mossy fibers   *****************/

   if ({number_mossy_fibers} < 4)
        number_mossy_fibers = 4
   end  // otherwise the synapse loops are not executed !!

// make /white_matter/mossy_fiber[0-number_mossy_fibers]
   include Mossy_fiber.g
   echo the number of mossy fibers is {number_mossy_fibers}
   if ({{number_mossy_fibers} > 0})
      make_mossy_fiber_array {xnumber_mossy_fibers} \
                             {ynumber_mossy_fibers} \
                             {mossy_fiber_firing_rate} \
                          {mossy_fiber_refractory_period}
   end
   echo made  {number_mossy_fibers} mossy fibers

// make /granule_cell_layer/Granule[0-number_granule_cells]
   include Granule_cell.g
   number_granule_cells = 0
   int x1, x2, x3, x4, y1, y2, y3, y4
   int lbx_mossy_fiber, lby_mossy_fiber, uby_mossy_fiber

   for (x1 = {xnumber_mossy_fibers}; x1 >= 1; x1 = x1 - 1)
       lbx_mossy_fiber = {max 1 {x1 - mossy_fiber_to_granule_cell_connection_radius}}
       for (x2 = x1; x2 >= {lbx_mossy_fiber}; x2 = x2 - 1)
       for (x3 = x2; x3 >= {lbx_mossy_fiber}; x3 = x3 - 1)
       for (x4 = x3; x4 >= {lbx_mossy_fiber}; x4 = x4 - 1)

       for (y1 = {ynumber_mossy_fibers}; y1 >= 1; y1 = y1 - 1)
           lby_mossy_fiber = {max 1 {y1 - mossy_fiber_to_granule_cell_connection_radius}}
           uby_mossy_fiber = {min {y1 + mossy_fiber_to_granule_cell_connection_radius} {ynumber_mossy_fibers}}
           for (y2 = {uby_mossy_fiber}; \
                y2 >= {lby_mossy_fiber}; y2 = y2 - 1)
           for (y3 = {min {y2 + mossy_fiber_to_granule_cell_connection_radius} {uby_mossy_fiber}}; \
                y3 >= {max {y2 - mossy_fiber_to_granule_cell_connection_radius} {lby_mossy_fiber}}; y3 = y3 - 1)
           for (y4 = {min {min {y2 + mossy_fiber_to_granule_cell_connection_radius} \
                           {y3 + mossy_fiber_to_granule_cell_connection_radius}} {uby_mossy_fiber}}; \
                y4 >= {max {max {y2 - mossy_fiber_to_granule_cell_connection_radius} \
                           {y3 - mossy_fiber_to_granule_cell_connection_radius}} {lby_mossy_fiber}}; y4 = y4 - 1)

           if (! (((x1 == x2) && (y1 <= y2))  ||  \
                  ((x1 == x3) && (y1 <= y3))  ||  \
                  ((x1 == x4) && (y1 <= y4))  ||  \
                  ((x2 == x3) && (y2 <= y3))  ||  \
                  ((x2 == x4) && (y2 <= y4))  ||  \
                  ((x3 == x4) && (y3 <= y4))))

           number_granule_cells = {number_granule_cells + 1}
//           echo {x4} {x3} {x2} {x1} {y4} {y3} {y2} {y1}
           end

           end // y4
           end // y3
           end // y2
       end // y1
       end // x4
       end // x3
       end // x2
   end // x1

   if ({{number_granule_cells} > 0})
      make_granule_cell_array {number_granule_cells} 1
   end
   echo made {number_granule_cells} granule cells

// make /granule_cell_layer/Golgi[0-number_Golgi_cells]
   include Golgi_cell.g
   if ({{number_Golgi_cells} > 0})
      make_Golgi_cell_array {xlength_Golgi_cell_array} {ylength_Golgi_cell_array}
   end
   echo made {number_Golgi_cells} Golgi cells

// make /molecular_layer/Stellate[0-number_stellate_cells]
/*   include Stellate_cell.g
   if ({{number_stellate_cells} > 0})
      make_stellate_cell_array {number_stellate_cells}
   end
   echo made {number_stellate_cells} stellate cells
*/
/************************    synapses                  *****************/


int i, j, k, l, index


// make AMPA synapses from mossy fibers to all Golgi cells
// within a circle of radius {mossy_fiber_to_Golgi_cell_radius}

   if ({{weight_mossy_fiber_Golgi_cell_synapse} > 0})
      planarconnect /white_matter/mossy_fiber[]/spike \
                    /granule_cell_layer/Golgi[]/soma/mf_AMPA \
                    -relative \
                    -verbose \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask   ellipse 0 0 {mossy_fiber_to_Golgi_cell_radius} \
                                            {mossy_fiber_to_Golgi_cell_radius} \
                    -probability {P_mossy_fiber_to_Golgi_cell_synapse}
      planarweight2 /white_matter/mossy_fiber[]/spike \
                    /granule_cell_layer/Golgi[]/soma/mf_AMPA -fixed \
                   {weight_mossy_fiber_Golgi_cell_synapse} -uniform {weight_distribution}
      planardelay   /white_matter/mossy_fiber[]/spike \
                    /granule_cell_layer/Golgi[]/soma/mf_AMPA -fixed \
                   {delay_mossy_fiber_Golgi_cell_synapse} -uniform {delay_distribution}
   end  
   echo connected {number_mossy_fibers} mossy fibers to {number_Golgi_cells} \
        Golgi cells with probability {P_mossy_fiber_to_Golgi_cell_synapse}

 

// make AMPA and NMDA synapses from mossy fibers to granule cells, each granule cell
// receiving a different combination of 4 different mossy fiber inputs within a circle
// with radius {mossy_fiber_to_granule_cell_connection_radius}

float delay_factor
// int   lb_mossy_fiber = 0  // lower boundary

// int x, y, x1, x2, x3, x4, y1, y2, y3, y4  // (x,y) indices in mossy fiber grid
// int lx, ly                          // (x,y) indices in mossy fiber grid


   index = 0

   for (x1 = {xnumber_mossy_fibers}; x1 >= 1; x1 = x1 - 1)
       lbx_mossy_fiber = {max 1 {x1 - mossy_fiber_to_granule_cell_connection_radius}}
       for (x2 = x1; x2 >= {lbx_mossy_fiber}; x2 = x2 - 1)
       for (x3 = x2; x3 >= {lbx_mossy_fiber}; x3 = x3 - 1)
       for (x4 = x3; x4 >= {lbx_mossy_fiber}; x4 = x4 - 1)

       for (y1 = {ynumber_mossy_fibers}; y1 >= 1; y1 = y1 - 1)
           lby_mossy_fiber = {max 1 {y1 - mossy_fiber_to_granule_cell_connection_radius}}
           uby_mossy_fiber = {min {y1 + mossy_fiber_to_granule_cell_connection_radius} {ynumber_mossy_fibers}}
           for (y2 = {uby_mossy_fiber}; \
                y2 >= {lby_mossy_fiber}; y2 = y2 - 1)
           for (y3 = {min {y2 + mossy_fiber_to_granule_cell_connection_radius} {uby_mossy_fiber}}; \
                y3 >= {max {y2 - mossy_fiber_to_granule_cell_connection_radius} {lby_mossy_fiber}}; y3 = y3 - 1)
           for (y4 = {min {min {y2 + mossy_fiber_to_granule_cell_connection_radius} \
                           {y3 + mossy_fiber_to_granule_cell_connection_radius}} {uby_mossy_fiber}}; \
                y4 >= {max {max {y2 - mossy_fiber_to_granule_cell_connection_radius} \
                           {y3 - mossy_fiber_to_granule_cell_connection_radius}} {lby_mossy_fiber}}; y4 = y4 - 1)


           if (! (((x1 == x2) && (y1 <= y2))  ||  \
                  ((x1 == x3) && (y1 <= y3))  ||  \
                  ((x1 == x4) && (y1 <= y4))  ||  \
                  ((x2 == x3) && (y2 <= y3))  ||  \
                  ((x2 == x4) && (y2 <= y4))  ||  \
                  ((x3 == x4) && (y3 <= y4))))

//           ({rand 0 1} <= {P_mossy_fiber_to_granule_cell_connection}))

//           ({index < number_granule_cells}) && \

           i = {mossy_fiber_index {x1} {y1}}
           j = {mossy_fiber_index {x2} {y2}}
           k = {mossy_fiber_index {x3} {y3}}
           l = {mossy_fiber_index {x4} {y4}}

           position /granule_cell_layer/Granule[{index}] \
                    {{{getfield /white_matter/mossy_fiber[{i}] x} + \
                      {getfield /white_matter/mossy_fiber[{j}] x} + \
                      {getfield /white_matter/mossy_fiber[{k}] x} + \
                      {getfield /white_matter/mossy_fiber[{l}] x}} / 4.0} \
                    {{{getfield /white_matter/mossy_fiber[{i}] y} + \
                      {getfield /white_matter/mossy_fiber[{j}] y} + \
                      {getfield /white_matter/mossy_fiber[{k}] y} + \
                      {getfield /white_matter/mossy_fiber[{l}] y}} / 4.0}  0.0 


           position /granule_cell_layer/Granule[{index}]/soma \
                    {{{getfield /white_matter/mossy_fiber[{i}] x} + \
                      {getfield /white_matter/mossy_fiber[{j}] x} + \
                      {getfield /white_matter/mossy_fiber[{k}] x} + \
                      {getfield /white_matter/mossy_fiber[{l}] x}} / 4.0} \
                    {{{getfield /white_matter/mossy_fiber[{i}] y} + \
                      {getfield /white_matter/mossy_fiber[{j}] y} + \
                      {getfield /white_matter/mossy_fiber[{k}] y} + \
                      {getfield /white_matter/mossy_fiber[{l}] y}} / 4.0}  0.0 

           position /granule_cell_layer/Granule[{index}]/soma/spike \
                    {{{getfield /white_matter/mossy_fiber[{i}] x} + \
                      {getfield /white_matter/mossy_fiber[{j}] x} + \
                      {getfield /white_matter/mossy_fiber[{k}] x} + \
                      {getfield /white_matter/mossy_fiber[{l}] x}} / 4.0} \
                    {{{getfield /white_matter/mossy_fiber[{i}] y} + \
                      {getfield /white_matter/mossy_fiber[{j}] y} + \
                      {getfield /white_matter/mossy_fiber[{k}] y} + \
                      {getfield /white_matter/mossy_fiber[{l}] y}} / 4.0}  0.0 

           position /granule_cell_layer/Granule[{index}]/soma/mf_AMPA \
                    {{{getfield /white_matter/mossy_fiber[{i}] x} + \
                      {getfield /white_matter/mossy_fiber[{j}] x} + \
                      {getfield /white_matter/mossy_fiber[{k}] x} + \
                      {getfield /white_matter/mossy_fiber[{l}] x}} / 4.0} \
                    {{{getfield /white_matter/mossy_fiber[{i}] y} + \
                      {getfield /white_matter/mossy_fiber[{j}] y} + \
                      {getfield /white_matter/mossy_fiber[{k}] y} + \
                      {getfield /white_matter/mossy_fiber[{l}] y}} / 4.0}  0.0 

           position /granule_cell_layer/Granule[{index}]/soma/mf_NMDA \
                    {{{getfield /white_matter/mossy_fiber[{i}] x} + \
                      {getfield /white_matter/mossy_fiber[{j}] x} + \
                      {getfield /white_matter/mossy_fiber[{k}] x} + \
                      {getfield /white_matter/mossy_fiber[{l}] x}} / 4.0} \
                    {{{getfield /white_matter/mossy_fiber[{i}] y} + \
                      {getfield /white_matter/mossy_fiber[{j}] y} + \
                      {getfield /white_matter/mossy_fiber[{k}] y} + \
                      {getfield /white_matter/mossy_fiber[{l}] y}} / 4.0}  0.0 

           position /granule_cell_layer/Granule[{index}]/soma/GABAA \
                    {{{getfield /white_matter/mossy_fiber[{i}] x} + \
                      {getfield /white_matter/mossy_fiber[{j}] x} + \
                      {getfield /white_matter/mossy_fiber[{k}] x} + \
                      {getfield /white_matter/mossy_fiber[{l}] x}} / 4.0} \
                    {{{getfield /white_matter/mossy_fiber[{i}] y} + \
                      {getfield /white_matter/mossy_fiber[{j}] y} + \
                      {getfield /white_matter/mossy_fiber[{k}] y} + \
                      {getfield /white_matter/mossy_fiber[{l}] y}} / 4.0}  0.0 

           position /granule_cell_layer/Granule[{index}]/soma/GABAB \
                    {{{getfield /white_matter/mossy_fiber[{i}] x} + \
                      {getfield /white_matter/mossy_fiber[{j}] x} + \
                      {getfield /white_matter/mossy_fiber[{k}] x} + \
                      {getfield /white_matter/mossy_fiber[{l}] x}} / 4.0} \
                    {{{getfield /white_matter/mossy_fiber[{i}] y} + \
                      {getfield /white_matter/mossy_fiber[{j}] y} + \
                      {getfield /white_matter/mossy_fiber[{k}] y} + \
                      {getfield /white_matter/mossy_fiber[{l}] y}} / 4.0}  0.0 

           delay_factor = {1 + {delay_distribution} * {rand -1 1}}
           if ({{weight_mossy_fiber_granule_cell_AMPA_synapse > 0}})
               make_synapse /white_matter/mossy_fiber[{i}]/spike \
                           /granule_cell_layer/Granule[{index}]/soma/mf_AMPA \
                           {weight_mossy_fiber_granule_cell_AMPA_synapse  \
                                   * (1 + {weight_distribution} * {rand -1 1})} \
                           {delay_mossy_fiber_granule_cell_synapse * delay_factor}
           end
           if ({{weight_mossy_fiber_granule_cell_NMDA_synapse > 0}})
               make_synapse /white_matter/mossy_fiber[{i}]/spike \
                           /granule_cell_layer/Granule[{index}]/soma/mf_NMDA \
                           {weight_mossy_fiber_granule_cell_NMDA_synapse  \
                                   * (1 + {weight_distribution} * {rand -1 1})} \
                           {delay_mossy_fiber_granule_cell_synapse * delay_factor}
           end

           delay_factor = {1 + {delay_distribution} * {rand -1 1}}
           if ({{weight_mossy_fiber_granule_cell_AMPA_synapse > 0}})
                make_synapse /white_matter/mossy_fiber[{j}]/spike \
                            /granule_cell_layer/Granule[{index}]/soma/mf_AMPA \
                            {weight_mossy_fiber_granule_cell_AMPA_synapse  \
                                    * (1 + {weight_distribution} * {rand -1 1})} \
                            {delay_mossy_fiber_granule_cell_synapse  * delay_factor}
           end
           if ({{weight_mossy_fiber_granule_cell_NMDA_synapse > 0}})
                make_synapse /white_matter/mossy_fiber[{j}]/spike \
                            /granule_cell_layer/Granule[{index}]/soma/mf_NMDA \
                            {weight_mossy_fiber_granule_cell_NMDA_synapse  \
                                    * (1 + {weight_distribution} * {rand -1 1})} \
                            {delay_mossy_fiber_granule_cell_synapse  * delay_factor}
           end

           delay_factor = {1 + {delay_distribution} * {rand -1 1}}
           if ({{weight_mossy_fiber_granule_cell_AMPA_synapse > 0}})
                make_synapse /white_matter/mossy_fiber[{k}]/spike \
                            /granule_cell_layer/Granule[{index}]/soma/mf_AMPA \
                            {weight_mossy_fiber_granule_cell_AMPA_synapse  \
                                    * (1 + {weight_distribution} * {rand -1 1})} \
                            {delay_mossy_fiber_granule_cell_synapse * delay_factor}
           end
           if ({{weight_mossy_fiber_granule_cell_NMDA_synapse > 0}})
                make_synapse /white_matter/mossy_fiber[{k}]/spike \
                            /granule_cell_layer/Granule[{index}]/soma/mf_NMDA \
                            {weight_mossy_fiber_granule_cell_NMDA_synapse  \
                                    * (1 + {weight_distribution} * {rand -1 1})} \
                            {delay_mossy_fiber_granule_cell_synapse * delay_factor}
           end

           delay_factor = {1 + {delay_distribution} * {rand -1 1}}
           if ({{weight_mossy_fiber_granule_cell_AMPA_synapse > 0}})
                make_synapse /white_matter/mossy_fiber[{l}]/spike \
                            /granule_cell_layer/Granule[{index}]/soma/mf_AMPA \
                            {weight_mossy_fiber_granule_cell_AMPA_synapse  \
                                    * (1 + {weight_distribution} * {rand -1 1})} \
                            {delay_mossy_fiber_granule_cell_synapse * delay_factor}
                echo made AMPA synapses from mossy fibers {i} {j} {k} {l} to granule cell {index} \
                     at indices {x1} {x2} {x3} {x4} {y1} {y2} {y3} {y4}
           end
           if ({{weight_mossy_fiber_granule_cell_NMDA_synapse > 0}})
                make_synapse /white_matter/mossy_fiber[{l}]/spike \
                            /granule_cell_layer/Granule[{index}]/soma/mf_NMDA \
                            {weight_mossy_fiber_granule_cell_NMDA_synapse  \
                                    * (1 + {weight_distribution} * {rand -1 1})} \
                            {delay_mossy_fiber_granule_cell_synapse * delay_factor}
           end

           index = {index} + 1
       end // if

       end // y4
       end // y3
       end // y2
       end // y1
       end // x4
       end // x3
       end // x2
       end // x1


// make AMPA synapses from granule cells to Golgi cells

   if ({{weight_granule_cell_Golgi_cell_synapse} > 0})
      planarconnect /granule_cell_layer/Granule[]/soma/spike \
                    /granule_cell_layer/Golgi[]/soma/pf_AMPA \
                    -relative \
                    -verbose \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask   ellipse 0.0 0.0 {Golgi_cell_separation * 5}  {Golgi_cell_separation * 5} \
                    -probability {P_granule_cell_to_Golgi_cell_synapse}
      planarweight2 /granule_cell_layer/Granule[]/soma/spike \
                   /granule_cell_layer/Golgi[]/soma/pf_AMPA \
                   -fixed {weight_granule_cell_Golgi_cell_synapse} -uniform {weight_distribution}
      planardelay   /granule_cell_layer/Granule[]/soma/spike \ 
                    /granule_cell_layer/Golgi[]/soma/pf_AMPA \ // -fixed {delay_granule_cell_Golgi_cell_synapse} \
                   -radial {parallel_fiber_conduction_velocity} -uniform {delay_distribution}
//      planardelay   /granule_cell_layer/Granule[]/soma/spike \ 
//                    /granule_cell_layer/Golgi[]/soma/pf_AMPA \ 
//                   -add \ // to account for width Golgi cell dendritic tree
//                   -fixed {(Golgi_cell_separation / 2.0) / parallel_fiber_conduction_velocity} \
//                   -absoluterandom \
//                   -uniform {(Golgi_cell_separation / 2.0) / parallel_fiber_conduction_velocity}
   end
   echo connected {number_granule_cells} granule cells to {number_Golgi_cells} \
        Golgi cells with probability {P_granule_cell_to_Golgi_cell_synapse}

// make AMPA synapses from granule cells to stellate cells

   if ({{weight_granule_cell_stellate_cell_synapse} > 0})
      planarconnect /granule_cell_layer/Granule[]/soma/spike \
                    /molecular_layer/Stellate[]/soma/pf_AMPA \
                    -relative \
                    -verbose \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask   box -{parallel_fiber_length / 2.0} -1e10 \
                                     {parallel_fiber_length / 2.0}  1e10 \ 
                    -probability {P_granule_cell_to_stellate_cell_synapse}
      planarweight2 /granule_cell_layer/Granule[]/soma/spike \
                    /molecular_layer/Stellate[]/soma/pf_AMPA \
                    -fixed {weight_granule_cell_stellate_cell_synapse} -uniform {weight_distribution}
      planardelay   /granule_cell_layer/Granule[]/soma/spike \ 
                    /molecular_layer/Stellate[]/soma/pf_AMPA \ // -fixed {delay_granule_cell_Golgi_cell_synapse} \
                    -radial {parallel_fiber_conduction_velocity} -uniform {delay_distribution}
   end
   echo connected {number_granule_cells} granule cells to {number_stellate_cells} \
        stellate cells with probability {P_granule_cell_to_stellate_cell_synapse}



// make GABA_A synapses from Golgi cells to granule cells

   if ({{weight_Golgi_cell_granule_cell_GABAA_synapse} > 0})
      planarconnect /granule_cell_layer/Golgi[]/soma/spike \
                    /granule_cell_layer/Granule[]/soma/GABAA \
                    -relative \
                    -verbose \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask  box -{Golgi_cell_to_granule_cell_radius}  -{Golgi_cell_to_granule_cell_radius} \
                                    {Golgi_cell_to_granule_cell_radius}  {Golgi_cell_to_granule_cell_radius} \ 
                    -probability {P_Golgi_cell_to_granule_cell_synapse}
      planarweight2 /granule_cell_layer/Golgi[]/soma/spike \
                   /granule_cell_layer/Granule[]/soma/GABAA \
                   -fixed {weight_Golgi_cell_granule_cell_GABAA_synapse} -uniform {weight_distribution}
      planardelay /granule_cell_layer/Golgi[]/soma/spike \
                   /granule_cell_layer/Granule[]/soma/GABAA \
                   -fixed {delay_Golgi_cell_granule_cell_synapse} -uniform {delay_distribution}
   end
   if ({{weight_Golgi_cell_granule_cell_GABAB_synapse} > 0})
      planarconnect /granule_cell_layer/Golgi[]/soma/spike \
                    /granule_cell_layer/Granule[]/soma/GABAB \
                    -relative \
                    -verbose \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask ellipse 0 0 {Golgi_cell_to_granule_cell_radius} \
                                           {Golgi_cell_to_granule_cell_radius} \ 
                    -probability {P_Golgi_cell_to_granule_cell_synapse}
      planarweight2 /granule_cell_layer/Golgi[]/soma/spike \
                   /granule_cell_layer/Granule[]/soma/GABAB \
                   -fixed {weight_Golgi_cell_granule_cell_GABAB_synapse} -uniform {weight_distribution}
      planardelay /granule_cell_layer/Golgi[]/soma/spike \
                   /granule_cell_layer/Granule[]/soma/GABAB \
                   -fixed {delay_Golgi_cell_granule_cell_synapse} -uniform {delay_distribution}
   end



   echo connected {number_Golgi_cells} Golgi cells to {number_granule_cells} \
        granule cells with probability {P_Golgi_cell_to_granule_cell_synapse}


// make GABA_A synapses from stellate cells to Golgi cells

   if ({{weight_stellate_cell_Golgi_cell_synapse} > 0})
      planarconnect /molecular_layer/Stellate[]/soma/spike \
                    /granule_cell_layer/Golgi[]/soma/GABAA \
                    -relative \
                    -verbose \
                    -sourcemask box -1e10 -1e10 1e10 1e10 \ // all elements connected
                    -destmask  ellipse 0 0 {stellate_cell_to_Golgi_cell_radius} \
                                           {stellate_cell_to_Golgi_cell_radius} \ 
                    -probability {P_stellate_cell_to_Golgi_cell_synapse}

      planarweight2 /molecular_layer/Stellate[]/soma/spike \
                    /granule_cell_layer/Golgi[]/soma/GABAA \
                    -fixed {weight_stellate_cell_Golgi_cell_synapse} -uniform {weight_distribution}
      planardelay   /molecular_layer/Stellate[]/soma/spike \
                    /granule_cell_layer/Golgi[]/soma/GABAA \
                    -fixed {delay_stellate_cell_Golgi_cell_synapse} -uniform {delay_distribution}
   end

   echo connected {number_stellate_cells} stellate cells to {number_Golgi_cells} \
        Golgi cells with probability {P_stellate_cell_to_Golgi_cell_synapse}


