//
// This test does four pairs of write/read to REGA, with different values each time
//
`include "axi_ral_base_test.sv"

class ral_access_burst_write_read_seq extends uvm_reg_sequence;

   function new(string name="ral_access_burst_write_read_seq");
      super.new(name);
   endfunction : new

   `uvm_object_utils(ral_access_burst_write_read_seq)

   virtual task body();
      ral_sys_axi_intermediate_slave model;
      uvm_status_e status;
      bit [`UVM_REG_DATA_WIDTH - 1:0] exp_data[];
      bit [`UVM_REG_DATA_WIDTH - 1:0] act_data[];

      exp_data = new[4];
      act_data = new[4];
      exp_data[0] = 32'haaaa_aaaa;
      exp_data[1] = 32'hbbbb_bbbb;
      exp_data[2] = 32'hcccc_cccc;
      exp_data[3] = 32'hdddd_dddd;

      $cast(model, this.model);
      model.update(status);

      /* Performing the INCR4 burst write transaction on REGA. */

      for(int i = 0; i < 4; i++) begin
	 model.slave_block.REGA.write(status, exp_data[i]);
	 /* Performing the INCR4 burst read transaction on REGA. */
	 model.slave_block.REGA.read(status, act_data[i]);

	 /* Does the comparison between the expected and the actual value for all the elements of the burst transfer. */
	 if(exp_data[i] != act_data[i])
           `uvm_error("ral_access_burst_write_read_seq", $sformatf("Register read value 64'h%0h does not match the expected value 32'h%0h" , act_data[i] , exp_data[i]));
      end

      model.print();
   endtask : body

endclass : ral_access_burst_write_read_seq


class ral_access_burst_write_read_test extends axi_ral_base_test;

  /** UVM Component Utility macro */
  `uvm_component_utils(ral_access_burst_write_read_test)

  ral_access_burst_write_read_seq seq;
  function new (string name="ral_access_burst_write_read_test", uvm_component parent);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);

    `uvm_info("ral_access_burst_write_read_test", "is entered", UVM_LOW)
     // Create the sequence class
     seq = ral_access_burst_write_read_seq::type_id::create("ral_access_burst_write_read_seq",,get_full_name());

    `uvm_info("ral_access_burst_write_read_test", "build - is exited", UVM_LOW)
  endfunction : build_phase

   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.get_objection().set_drain_time(this, 150); 
      seq.model = env.regmodel;
      seq.start(null);
      env.regmodel.print();
   endtask : run_phase

endclass

