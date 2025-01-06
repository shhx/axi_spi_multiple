# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "N_SENSORS"
  ipgui::add_param $IPINST -name "N_CHIP_SELECTS"
  ipgui::add_param $IPINST -name "CS_WAIT_CYCLES"
  ipgui::add_param $IPINST -name "MAX_NUMBER_READS"
  ipgui::add_param $IPINST -name "STREAM_WIDTH" -widget comboBox

}

proc update_PARAM_VALUE.ADDR_W { PARAM_VALUE.ADDR_W } {
	# Procedure called to update ADDR_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_W { PARAM_VALUE.ADDR_W } {
	# Procedure called to validate ADDR_W
	return true
}

proc update_PARAM_VALUE.CS_WAIT_CYCLES { PARAM_VALUE.CS_WAIT_CYCLES } {
	# Procedure called to update CS_WAIT_CYCLES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CS_WAIT_CYCLES { PARAM_VALUE.CS_WAIT_CYCLES } {
	# Procedure called to validate CS_WAIT_CYCLES
	return true
}

proc update_PARAM_VALUE.DATA_W { PARAM_VALUE.DATA_W } {
	# Procedure called to update DATA_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_W { PARAM_VALUE.DATA_W } {
	# Procedure called to validate DATA_W
	return true
}

proc update_PARAM_VALUE.MAX_NUMBER_READS { PARAM_VALUE.MAX_NUMBER_READS } {
	# Procedure called to update MAX_NUMBER_READS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_NUMBER_READS { PARAM_VALUE.MAX_NUMBER_READS } {
	# Procedure called to validate MAX_NUMBER_READS
	return true
}

proc update_PARAM_VALUE.N_CHIP_SELECTS { PARAM_VALUE.N_CHIP_SELECTS } {
	# Procedure called to update N_CHIP_SELECTS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_CHIP_SELECTS { PARAM_VALUE.N_CHIP_SELECTS } {
	# Procedure called to validate N_CHIP_SELECTS
	return true
}

proc update_PARAM_VALUE.N_SENSORS { PARAM_VALUE.N_SENSORS } {
	# Procedure called to update N_SENSORS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_SENSORS { PARAM_VALUE.N_SENSORS } {
	# Procedure called to validate N_SENSORS
	return true
}

proc update_PARAM_VALUE.STRB_W { PARAM_VALUE.STRB_W } {
	# Procedure called to update STRB_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STRB_W { PARAM_VALUE.STRB_W } {
	# Procedure called to validate STRB_W
	return true
}

proc update_PARAM_VALUE.STREAM_WIDTH { PARAM_VALUE.STREAM_WIDTH } {
	# Procedure called to update STREAM_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STREAM_WIDTH { PARAM_VALUE.STREAM_WIDTH } {
	# Procedure called to validate STREAM_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.ADDR_W { MODELPARAM_VALUE.ADDR_W PARAM_VALUE.ADDR_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_W}] ${MODELPARAM_VALUE.ADDR_W}
}

proc update_MODELPARAM_VALUE.DATA_W { MODELPARAM_VALUE.DATA_W PARAM_VALUE.DATA_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_W}] ${MODELPARAM_VALUE.DATA_W}
}

proc update_MODELPARAM_VALUE.STRB_W { MODELPARAM_VALUE.STRB_W PARAM_VALUE.STRB_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STRB_W}] ${MODELPARAM_VALUE.STRB_W}
}

proc update_MODELPARAM_VALUE.N_SENSORS { MODELPARAM_VALUE.N_SENSORS PARAM_VALUE.N_SENSORS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_SENSORS}] ${MODELPARAM_VALUE.N_SENSORS}
}

proc update_MODELPARAM_VALUE.N_CHIP_SELECTS { MODELPARAM_VALUE.N_CHIP_SELECTS PARAM_VALUE.N_CHIP_SELECTS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_CHIP_SELECTS}] ${MODELPARAM_VALUE.N_CHIP_SELECTS}
}

proc update_MODELPARAM_VALUE.CS_WAIT_CYCLES { MODELPARAM_VALUE.CS_WAIT_CYCLES PARAM_VALUE.CS_WAIT_CYCLES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CS_WAIT_CYCLES}] ${MODELPARAM_VALUE.CS_WAIT_CYCLES}
}

proc update_MODELPARAM_VALUE.MAX_NUMBER_READS { MODELPARAM_VALUE.MAX_NUMBER_READS PARAM_VALUE.MAX_NUMBER_READS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_NUMBER_READS}] ${MODELPARAM_VALUE.MAX_NUMBER_READS}
}

proc update_MODELPARAM_VALUE.STREAM_WIDTH { MODELPARAM_VALUE.STREAM_WIDTH PARAM_VALUE.STREAM_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STREAM_WIDTH}] ${MODELPARAM_VALUE.STREAM_WIDTH}
}
