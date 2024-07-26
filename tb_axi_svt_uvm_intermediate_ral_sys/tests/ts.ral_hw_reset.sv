//
// This test runs the built-in UVM reset test
// That test checks the reset value for every register
// The reset values in axi_intermediate_ral_slave.ralf are all 0
// This works out well as the registers are mapped to
// slave[0].axi_slave_mem which has a default value of 0

`include "axi_ral_base_test.sv"

class ral_hw_reset extends axi_ral_base_test;

  /** UVM Component Utility macro */
  `uvm_component_utils (ral_hw_reset)

  uvm_status_e status;
  uvm_reg_hw_reset_seq seq;

  function new (string name="ral_hw_reset", uvm_component parent);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ral_hw_reset", "is entered", UVM_LOW)
    seq = uvm_reg_hw_reset_seq::type_id::create("seq",,get_full_name());

    `uvm_info("ral_hw_reset", "build - is exited", UVM_LOW)
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.get_objection().set_drain_time(this, 150);
    seq.model = env.regmodel;

    // Call start method to start built-in sequences.
    seq.start(null);
    env.regmodel.print();
  endtask : run_phase

endclass
