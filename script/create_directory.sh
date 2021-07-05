#!/bin/bash

BASENAME=$1
mkdir -p $BASENAME/rtl \
         $BASENAME/tbench \
         $BASENAME/verilator \
	 $BASENAME/iverilog
	
