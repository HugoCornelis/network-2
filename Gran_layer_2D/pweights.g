// genesis


int i, nsynapses
float weight
str list = ""
str output = "Stel76_mf_AMPA_weights.dat"


nsynapses =  {getfield /molecular_layer/Stellate[75]/soma/pf_AMPA nsynapses}
list = {nsynapses} @ " "
    
for (i = 0; i < {nsynapses}; i = i + 1)
    weight = {getfield /molecular_layer/Stellate[75]/soma/pf_AMPA synapse[{i}].weight}
    list = (list) @ {i + 1} @ " " @ {weight} @ " "
end

echo  {list}  > {output} // {source_list}



