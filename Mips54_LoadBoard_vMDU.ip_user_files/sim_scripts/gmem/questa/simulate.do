onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib gmem_opt

do {wave.do}

view wave
view structure
view signals

do {gmem.udo}

run -all

quit -force
