

TOOLCMD : iverilog -o ./iverilog/sim.out -g2012

compile: clean
	$(TOOLCMD)  ./rtl/LFSR.sv ./tbench/LFSR_tb.sv

simulate : clean compile
	vvp ./iverilog/sim.out

build: clean
	touch synth.ys
	echo "read -sv ./rtl/LFSR.sv" > synthy.ys
	#synthesis script 

synth: build
	yosys synth.ys

clean:
	rm -rf sim.o synth.ys synth.v
