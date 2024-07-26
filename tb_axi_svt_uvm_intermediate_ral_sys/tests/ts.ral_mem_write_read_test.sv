//
// This test writes and reads all the values in the SLAVE_MEM
// checking if the values are correct

`include "axi_ral_base_test.sv"
class ral_mem_write_read_seq extends uvm_reg_sequence;

   function new(string name="ral_mem_write_read_seq");
      super.new(name);
   endfunction : new

   `uvm_object_utils(ral_mem_write_read_seq)

   virtual task body();
      ral_sys_axi_intermediate_slave model;
      uvm_status_e status;
      bit[7:0] act_data;
      reg [31:0] addr;

      $cast(model, this.model);

      /* Assigning the initial address location of the SLAVE_MEM memory to addr field. */
      addr = 32'h800;

      `uvm_info("ral_mem_write_read_test", $sformatf("Write/Read test to %0d. locations in SLAVE_MEM", model.slave_block.SLAVE_MEM.get_size()), UVM_LOW);

      /* Writing some value to all the locations of the memory block. */
      for(int i = 0; i < model.slave_block.SLAVE_MEM.get_size() ; i++)  begin
	 model.slave_block.SLAVE_MEM.write(status, i , i);
      end

      /* Read from each of the location of memory and compare it with the value pre-written to that location. */
      for(int i = 0; i < model.slave_block.SLAVE_MEM.get_size(); i++)  begin
	 model.slave_block.SLAVE_MEM.read(status, i , act_data);

	 if(i != act_data)
           `uvm_error("ral_mem_write_read_test" , $sformatf("Register read value 8'h%0h at location 32'h%0h does not does not match the expected value	8'h%0h" , act_data , addr , i));
         addr = addr + 1;
      end

   endtask : body

endclass : ral_mem_write_read_seq


class ral_mem_write_read_test extends axi_ral_base_test;
  /** UVM Component Utility macro */
  `uvm_component_utils (ral_mem_write_read_test)

 ral_mem_write_read_seq seq;

  function new (string name="ral_mem_write_read_test", uvm_component parent);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("ral_mem_write_read_test", "is entered", UVM_LOW)
     // Create the sequence class
     seq = ral_mem_write_read_seq::type_id::create("ral_mem_write_read_seq",,get_full_name());

    `uvm_info("ral_mem_write_read_test", "build - is exited", UVM_LOW)

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
