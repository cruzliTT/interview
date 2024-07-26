//
// Perform a single write followed by several reads to make sure the
// register does not change value. The value is checked in the call to: 
// 		REGA.mirror(status,UVM_CHECK);
//
`include "axi_ral_base_test.sv"
class ral_reg_write_consecutive_read_seq extends uvm_reg_sequence;

   function new(string name="ral_reg_write_consecutive_read_seq");
      super.new(name);
   endfunction : new

   `uvm_object_utils(ral_reg_write_consecutive_read_seq)

   virtual task body();
      ral_sys_axi_intermediate_slave model;
      uvm_status_e status;
      bit[1023:0] data1,data2,data3,data4;

      $cast(model, this.model);

      /* Writing to the REGA using the write method of uvm_reg class. */
      `uvm_info("ral_reg_write_consecutive_read_seq","Write and read REGA", UVM_LOW);
      model.slave_block.REGA.write(status,32'h12345678);

      /* Reading from the REGA using the read method of uvm_reg class. */
      `uvm_info("ral_reg_write_consecutive_read_seq","1st read REGA", UVM_LOW);
      model.slave_block.REGA.read(status,data1);
      /* Predicting expected value for REGA using predict method of uvm_reg class. */
      void' (model.slave_block.REGA.predict(32'h1234_5678));
      /* Does the comparison between the mirror value for REGA and the predicted value. */
      model.slave_block.REGA.mirror(status,UVM_CHECK);

      /* Reading again from the same register to check if it holds the value when no write or reset operation
       performed in between. */

      /* Reading from the REGA using the read method of uvm_reg class. */
      `uvm_info("ral_reg_write_consecutive_read_seq","2nd read REGA", UVM_LOW);
      model.slave_block.REGA.read(status,data1);
      /* Predicting expected value for REGA using predict method of uvm_reg class. */
      void' (model.slave_block.REGA.predict(32'h1234_5678));
      /* Does the comparison between the mirror value for REGA and the predicted value. */
      model.slave_block.REGA.mirror(status,UVM_CHECK);

   endtask : body

endclass : ral_reg_write_consecutive_read_seq



class ral_reg_write_consecutive_read_test extends axi_ral_base_test;
  /** UVM Component Utility macro */

  `uvm_component_utils (ral_reg_write_consecutive_read_test)

  uvm_status_e status;
  ral_reg_write_consecutive_read_seq seq;
  function new (string name="ral_reg_write_consecutive_read_test", uvm_component parent);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ral_reg_write_consecutive_read_test", "is entered", UVM_LOW)
     // Create the sequence class
     seq = ral_reg_write_consecutive_read_seq::type_id::create("ral_reg_write_consecutive_read_seq",,get_full_name());

    `uvm_info("ral_reg_write_consecutive_read_test", "build - is exited", UVM_LOW)
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.get_objection().set_drain_time(this, 150);
     seq.model = env.regmodel;
     seq.start(null);
     env.regmodel.print();
  endtask : run_phase
endclass
