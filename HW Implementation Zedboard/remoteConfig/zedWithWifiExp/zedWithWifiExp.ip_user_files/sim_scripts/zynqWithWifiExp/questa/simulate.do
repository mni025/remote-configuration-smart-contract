onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib zynqWithWifiExp_opt

do {wave.do}

view wave
view structure
view signals

do {zynqWithWifiExp.udo}

run -all

quit -force
