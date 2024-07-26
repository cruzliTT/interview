
`include "axi_ral_base_test.sv"
class reg_bit_bash_test extends axi_ral_base_test;

  /** UVM Component Utility macro */
  `uvm_component_utils (reg_bit_bash_test)
  uvm_status_e status;
  uvm_reg_bit_bash_seq seq;
  function new (string name="reg_bit_bash_test", uvm_component parent);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("reg_bit_bash_test", "is entered", UVM_LOW)
    seq = uvm_reg_bit_bash_seq::type_id::create("seq",,get_full_name());

    `uvm_info("reg_bit_bash_test", "build - is exited", UVM_LOW)
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.get_objection().set_drain_time(this, 150);
    seq.model = env.regmodel;
    seq.start(null);
    env.regmodel.print(); 
  endtask : run_phase
  
endclass
