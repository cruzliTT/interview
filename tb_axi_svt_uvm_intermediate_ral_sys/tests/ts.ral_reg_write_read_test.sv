//
// Write and read the RAL registers 
// The register value is checked with:
//		mirror(status,UVM_CHECK);
//
`include "axi_ral_base_test.sv"
class ral_reg_write_read_seq extends uvm_reg_sequence;

   function new(string name="ral_reg_write_read_seq");
      super.new(name);
   endfunction : new

   `uvm_object_utils(ral_reg_write_read_seq)

   virtual task body();
      ral_sys_axi_intermediate_slave model;
      uvm_status_e status;
      bit[1023:0] data1,data2,data3,data4;

      $cast(model, this.model);

      /* Writing to the REGA location using the write method of uvm_reg class */
      `uvm_info("ral_reg_write_read_seq","Write and read REGA", UVM_LOW);
      model.slave_block.REGA.write(status,32'haaaa_aaaa);
      /* Predicting expected value for REGA using predict method of uvm_reg class */
      void' (model.slave_block.REGA.predict(32'haaaa_aaaa));
      /* Does the comparison between the mirror value for REGA and the predicted value */
      model.slave_block.REGA.mirror(status,UVM_CHECK);

      /* Writing to the REGB location using the write method of uvm_reg class */
      `uvm_info("ral_reg_write_read_seq","Write and read REGB", UVM_LOW);
      model.slave_block.REGB.write(status,32'hbbbb_bbbb);
      /* Predicting expected value for REGB using predict method of uvm_reg class */
      void' (model.slave_block.REGB.predict(32'hbbbb_bbbb));
      /* Does the comparison between the mirror value for REGB and the predicted value */
      model.slave_block.REGB.mirror(status,UVM_CHECK);

      /* Writing to the REGC location using the write method of uvm_reg class */
      `uvm_info("ral_reg_write_read_seq","Write and read REGC", UVM_LOW);
      model.slave_block.REGC.write(status,32'hcccc_cccc);
      /* Predicting expected value for REGC using predict method of uvm_reg class */
      void' (model.slave_block.REGC.predict(32'hcccc_cccc));
      /* Does the comparison between the mirror value for REGC and the predicted value */
      model.slave_block.REGC.mirror(status,UVM_CHECK);

      /* Writing to the REGD location using the write method of uvm_reg class */
      `uvm_info("ral_reg_write_read_seq","Write and read REGD", UVM_LOW);
      model.slave_block.REGD.write(status,32'hdddd_dddd);
      /* Predicting expected value for REGD using predict method of uvm_reg class */
      void' (model.slave_block.REGD.predict(32'hdddd_dddd));
      /* Does the comparison between the mirror value for REGD and the predicted value */
      model.slave_block.REGD.mirror(status,UVM_CHECK);

   endtask : body

endclass : ral_reg_write_read_seq


class ral_reg_write_read_test extends axi_ral_base_test;
  /** UVM Component Utility macro */
  `uvm_component_utils(ral_reg_write_read_test)

   bit [1023:0]   data1,data2,data3,data4;
   uvm_status_e status;
   ral_reg_write_read_seq seq;

  function new (string name="ral_reg_write_read_test", uvm_component parent);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("ral_reg_write_read_test", "is entered", UVM_LOW)

    // Create the sequence class
     seq = ral_reg_write_read_seq::type_id::create("ral_reg_write_read_seq",,get_full_name());

    `uvm_info("ral_reg_write_read_test", "build - is exited", UVM_LOW)
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
     super.run_phase(phase);
     phase.get_objection().set_drain_time(this, 150);
     seq.model = env.regmodel;
     seq.start(null);
     env.regmodel.print();
  endtask : run_phase
endclass
