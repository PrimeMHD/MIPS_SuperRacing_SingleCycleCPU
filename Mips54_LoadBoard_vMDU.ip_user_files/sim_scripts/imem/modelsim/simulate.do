onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -L dist_mem_gen_v8_0_10 -lib xil_defaultlib xil_defaultlib.imem xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {imem.udo}

run -all

quit -force
