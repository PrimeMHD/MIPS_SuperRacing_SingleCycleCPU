onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib dmem_opt

do {wave.do}

view wave
view structure
view signals

do {dmem.udo}

run -all

quit -force
