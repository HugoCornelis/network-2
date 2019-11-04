// genesis

int number_of_neurons =  300
int i
float value
str list = ""
 str output = "mf_firing_rate.dat"
//  str output = "mf_interburstinterval.dat"

for (i = 1; {i <= number_of_neurons}; i = i + 1)
    value =  {getfield /white_matter/mossy_fiber[{i - 1}] rate}
//      value =  {getfield /white_matter/burst[{i - 1}] delay1}
    list = (list) @ {i} @ " " @ {value} @ " "
end
    echo {i} {list}  > {output} // {source_list}



