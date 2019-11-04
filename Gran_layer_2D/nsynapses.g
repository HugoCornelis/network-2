// genesis

int number_of_neurons = 30 // 300 // 4662 // 30 // 855
int i, j, nsynapses
int nafferents = 0
str list = ""
// str output = "Gran_GABAA_nsynapses.dat"
 str output = "Golg_pf_AMPA_nsynapses.dat"
//  str output = "Stel_pf_AMPA_nsynapses.dat"
//  str output = "Golg_GABAA_nsynapses.dat"

for (i = 1; {i <= number_of_neurons}; i = i + 1)
//    nsynapses =  {getfield /molecular_layer/Stellate[{i - 1}]/soma/pf_AMPA nsynapses}
    nsynapses =  {getfield /granule_cell_layer/Golgi[{i - 1}]/soma/pf_AMPA nsynapses}
//    nsynapses =  {getfield /granule_cell_layer/Granule[{i - 1}]/soma/GABAA nsynapses}

    list = (list) @ {i} @ " " @ {nsynapses} @ " "
end
    echo {i} {list}  > {output} // {source_list}




