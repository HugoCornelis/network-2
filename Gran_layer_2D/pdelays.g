// genesis


int i, nsynapses
float delay
str list = ""
str output = "Golg0SynDelays2.0.30"


nsynapses =  {getfield /granule_cell_layer/Golgi[0]/soma/pf_AMPA nsynapses}
list = {nsynapses} @ " "
    
for (i = 0; i < {nsynapses}; i = i + 1)
    delay = {getfield /granule_cell_layer/Golgi[0]/soma/pf_AMPA synapse[{i}].delay}
    list = (list) @ {i + 1} @ " " @ {delay} @ " "
end

echo  {list}  > {output} // {source_list}



