// genesis

int number_of_neurons =  855
int i
float Vm, E_leak
str list = ""
str output = "Gran_init.dat"
// str output = "Golg_init.dat"

for (i = 1; {i <= number_of_neurons}; i = i + 1)
    Vm =     {getfield /granule_cell_layer/Granule[{i - 1}]/soma Vm}
    E_leak = {getfield /granule_cell_layer/Granule[{i - 1}]/soma Em}
    list = (list) @ {i} @ " " @ {Vm} @ " " @ {E_leak} @ " "
    echo {i} {list}  > {output} // {source_list}
end


