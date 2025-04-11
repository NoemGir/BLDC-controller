#!/bin/bash

ghdl -a -fsynopsys -fexplicit pwm.vhd pwm_manager.vhd BLDC_controller.vhd test_BLDC_controller.vhd
ghdl -e -fsynopsys -fexplicit test_BLDC_controller
ghdl -r -fsynopsys test_BLDC_controller --vcd=test_BLDC_controller.vcd
gtkwave test_BLDC_controller.vcd