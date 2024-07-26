//=======================================================================
// COPYRIGHT (C) 2017 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//
//-----------------------------------------------------------------------

/**
 * Abstract:
 * Top-level SystemVerilog testbench.
 * It instantites the interface and interconnect wrapper.  Clock generation
 * is also  done in the same file.  It includes each test file and initiates
 * the UVM phase manager by calling run_test().
 */
`timescale 1 ns/1 ps

`include "uvm_pkg.sv"

/** Include the AXI SVT UVM package */
`include "svt_axi.uvm.pkg"

`include "svt_axi_if.svi"
`include "axi_svt_dut_sv_wrapper.sv"
`include "axi_reg_slave.sv"

module test_top;

  /** Parameter defines the clock frequency */
  parameter simulation_cycle = 50;

  /** Signal to generate the clock */
  bit SystemClock;

  /** Signal to generate the reset */
  bit SystemReset;

  /** Event to notify Reset Completion */
  event reset_done;

  /** Import UVM Package */
  import uvm_pkg::*;

  /** Import the SVT UVM Package */
  import svt_uvm_pkg::*;

  /** Import the AXI VIP */
  import svt_axi_uvm_pkg::*;

  /** Include all test files */
  `include "top_test.sv"

  /** VIP Interface instance representing the AXI system */
  svt_axi_if axi_if();
  assign axi_if.common_aclk = SystemClock;

  assign axi_if.master_if[0].aresetn = SystemReset;
  assign axi_if.slave_if[0].aresetn = SystemReset;

  /** Interconnect wrapper */
  // -----------------------------------------------------------------------------
  axi_svt_dut_sv_wrapper dut_wrapper (axi_if);

   /**
    RAL RTL model
    */
   axi_reg_slave reg_slave(axi_if.slave_if[0]);

  /**
   * Optionally dump the sim variable for waveform display
   */
`ifdef WAVES
  initial begin
    string wave_str = `WAVES;
    if (!wave_str.compare("vcd"))
      $dumpvars;
    else
      /**
       * The vcdplus format is much more compact, but it is only available in VCS
       * and VCS-MX. Testbenches which are run in other Verilog environments must
       * at a minimum comment out or remove the following line. They may wish to
       * replace this entire block with a simple '$dumpvars' call.
       */
      $vcdpluson;
  end
`endif

  /** Testbench 'System' Clock Generator */
  initial begin
    SystemClock = 0 ;
    forever begin
      #(simulation_cycle/2)
        SystemClock = ~SystemClock ;
    end
  end

  /** Testbench Reset Generator */
  initial begin
    SystemReset <= 1'b1;

    repeat(10) @(posedge SystemClock);
    SystemReset <= 1'b0;

    repeat(10) @(posedge SystemClock);
    SystemReset <= 1'b1;

    repeat(5) @ (posedge SystemClock);

    /** Trigger reset_done event */
    -> reset_done; //this will be used in ral_bas_test to wait till reset is completed
  end

  initial begin
    /**
     * Provide the AXI SV interface to the AXI System ENV. This step
     * establishes the connection between the AXI System ENV and the HDL
     * Interconnect wrapper, through the AXI interface.
    */
    uvm_config_db#(svt_axi_vif)::set(uvm_root::get(), "uvm_test_top.env.axi_system_env", "vif", axi_if);

    /** Start the UVM tests */
    run_test();
  end

   initial $timeformat(-9,0,"ns", 0);

endmodule
