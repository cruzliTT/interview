//
// This test does one write/read to every register and memory
//

`include "axi_ral_base_test.sv"

class ral_access_single_write_read_seq extends uvm_reg_sequence;

   function new(string name="ral_access_single_write_read_seq");
      super.new(name);
   endfunction : new

   `uvm_object_utils(ral_access_single_write_read_seq)

   virtual task body();
      ral_sys_axi_intermediate_slave model;
      uvm_status_e status;
      bit[1023:0] exp1,exp2,exp3,exp4,exp5, addr;
      bit [1023:0] act1,act2,act3,act4,act5;
      $cast(model, this.model);

      `uvm_info("ral_access_single_write_read_seq","Write and read REGA", UVM_LOW);
      exp1 = 32'h3333_4444;
      /* Abstract level write() method to write/read register REGA */
      model.slave_block.REGA.write(status,exp1);
      model.slave_block.REGA.read(status,act1);

      `uvm_info("ral_access_single_write_read_seq","Write and read REGB", UVM_LOW);
      exp2 = 32'hd0d1_d2d3;
      /* Abstract level write() method to write / read register REGB  */
      model.slave_block.write_reg_by_name(status,"REGB",exp2);
      model.slave_block.read_reg_by_name(status,"REGB",act2);

      `uvm_info("ral_access_single_write_read_seq","Write and read REGC", UVM_LOW);
      exp3 = 32'he4e5_e6e7;
      /* Abstract level write() method to write/read register REGC  */
      model.slave_block.REGC.write(status,exp3);
      model.slave_block.REGC.read(status,act3);

      `uvm_info("ral_access_single_write_read_seq","Write and read REGD", UVM_LOW);
      exp4 = 32'hf0f1_f2f3;
      /* Abstract level write() method to write/read register REGD  */
      model.slave_block.write_reg_by_name(status,"REGD",exp4);
      model.slave_block.read_reg_by_name(status,"REGD",act4);

      `uvm_info("ral_access_single_write_read_seq","Write and read mem[40]", UVM_LOW);
      addr = 40; // buss addr = 'h82A = 'h800 + 'h2A
      exp5 = 'h42;
      model.slave_block.SLAVE_MEM.write(status, addr, exp5);
      model.slave_block.SLAVE_MEM.read(status, addr, act5);

      model.print();

      /* Comparison between the expected and the actual value for the REGA */
      if(exp1 != act1)
	`uvm_error("SINGLE_WRITE_READ_TEST", $sformatf("Register A value 32'h%0h, read from location 0x0000 does not match the expected value 32'h%0h", act1, exp1));

      /* Comparison between the expected and the actual value for the REGB */
      if(exp2 != act2)
	`uvm_error("SINGLE_WRITE_READ_TEST", $sformatf("Register B value 32'h%0h, read from location 0x0004 does not match the expected value 32'h%0h", act2, exp2));

      /* Comparison between the expected and the actual value for the REGC */
      if(exp3 != act3)
	`uvm_error("SINGLE_WRITE_READ_TEST", $sformatf("Register C value 32'h%0h, read from location 0x0008 does not match the expected value 32'h%0h", act3, exp3));

      /* Comparison between the expected and the actual value for the REGD */
      if(exp4 != act4)
	`uvm_error("SINGLE_WRITE_READ_TEST", $sformatf("Register D value 32'h%0h, read from location 0x000c does not match the expected value 32'h%0h", act4, exp4));

      /* Comparison between the expected and the actual value for the memory */
      if(exp5 != act5)
	`uvm_error("SINGLE_WRITE_READ_TEST", $sformatf("Memory[%0d] = 32'h%0h, does not match the expected value 32'h%0h", addr, act5, exp5));


   endtask : body

endclass : ral_access_single_write_read_seq


class ral_access_single_write_read_test extends axi_ral_base_test;

   /**
   * Utility macro
   */
  `uvm_component_utils (ral_access_single_write_read_test)
  ral_access_single_write_read_seq seq;

  function new (string name="ral_access_single_write_read_test", uvm_component parent);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("ral_access_single_write_read_test", "Entering...", UVM_LOW)
     // Create the sequence class
     seq = ral_access_single_write_read_seq::type_id::create("ral_access_single_write_read_seq",,get_full_name());

     // Set the slave to inactive
     uvm_config_db#(int)::set(this, "env.axi_system_env.slave[0]", "is_active", 0);

    `uvm_info("ral_access_single_write_read_test", "Exiting...", UVM_LOW)
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.get_objection().set_drain_time(this, 150);
    seq.model = env.regmodel;
    seq.start(null);
    env.regmodel.print();
  endtask : run_phase


   virtual function void report_phase(uvm_phase phase);
      `uvm_info("report_phase", "Entering... printing AXI VIP slave memory", UVM_LOW);
      env.axi_system_env.slave[0].axi_slave_mem.print();
      `uvm_info("report_phase", "Exiting...", UVM_LOW);
   endfunction : report_phase

endclass
