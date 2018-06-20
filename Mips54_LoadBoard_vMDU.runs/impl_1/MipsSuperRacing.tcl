proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  set_param simulator.modelsimInstallPath C:/modeltech_pe_10.4c/win32pe
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir D:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.cache/wt [current_project]
  set_property parent.project_path D:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.xpr [current_project]
  set_property ip_repo_paths d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.cache/ip [current_project]
  set_property ip_output_repo d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.cache/ip [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet D:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.runs/synth_1/MipsSuperRacing.dcp
  add_files -quiet D:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/imem/imem.dcp
  set_property netlist_only true [get_files D:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/imem/imem.dcp]
  add_files -quiet d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/dmem/dmem.dcp
  set_property netlist_only true [get_files d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/dmem/dmem.dcp]
  add_files -quiet d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp
  set_property netlist_only true [get_files d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp]
  add_files -quiet d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/gmem/gmem.dcp
  set_property netlist_only true [get_files d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/gmem/gmem.dcp]
  read_xdc -mode out_of_context -ref imem -cells U0 d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/imem/imem_ooc.xdc
  set_property processing_order EARLY [get_files d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/imem/imem_ooc.xdc]
  read_xdc -mode out_of_context -ref dmem -cells U0 d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/dmem/dmem_ooc.xdc
  set_property processing_order EARLY [get_files d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/dmem/dmem_ooc.xdc]
  read_xdc -mode out_of_context -ref clk_wiz_0 -cells inst d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc
  set_property processing_order EARLY [get_files d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]
  read_xdc -prop_thru_buffers -ref clk_wiz_0 -cells inst d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc
  set_property processing_order EARLY [get_files d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
  read_xdc -ref clk_wiz_0 -cells inst d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc
  set_property processing_order EARLY [get_files d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
  read_xdc -mode out_of_context -ref gmem -cells U0 d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/gmem/gmem_ooc.xdc
  set_property processing_order EARLY [get_files d:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/sources_1/ip/gmem/gmem_ooc.xdc]
  read_xdc D:/WeCloudSync/6.MI_PROJECTS/VIVADO_PROJECT/Mips54_App/Mips54_App/Mips54_LoadBoard_vMDU.srcs/constrs_1/imports/new/Mips54_LoadBoard.xdc
  link_design -top MipsSuperRacing -part xc7a100tcsg324-1
  write_hwdef -file MipsSuperRacing.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force MipsSuperRacing_opt.dcp
  report_drc -file MipsSuperRacing_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force MipsSuperRacing_placed.dcp
  report_io -file MipsSuperRacing_io_placed.rpt
  report_utilization -file MipsSuperRacing_utilization_placed.rpt -pb MipsSuperRacing_utilization_placed.pb
  report_control_sets -verbose -file MipsSuperRacing_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force MipsSuperRacing_routed.dcp
  report_drc -file MipsSuperRacing_drc_routed.rpt -pb MipsSuperRacing_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file MipsSuperRacing_timing_summary_routed.rpt -rpx MipsSuperRacing_timing_summary_routed.rpx
  report_power -file MipsSuperRacing_power_routed.rpt -pb MipsSuperRacing_power_summary_routed.pb -rpx MipsSuperRacing_power_routed.rpx
  report_route_status -file MipsSuperRacing_route_status.rpt -pb MipsSuperRacing_route_status.pb
  report_clock_utilization -file MipsSuperRacing_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force MipsSuperRacing.mmi }
  write_bitstream -force MipsSuperRacing.bit 
  catch { write_sysdef -hwdef MipsSuperRacing.hwdef -bitfile MipsSuperRacing.bit -meminfo MipsSuperRacing.mmi -file MipsSuperRacing.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

