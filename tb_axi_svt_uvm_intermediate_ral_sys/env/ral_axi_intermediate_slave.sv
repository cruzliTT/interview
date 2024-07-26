`ifndef RAL_AXI_INTERMEDIATE_SLAVE
`define RAL_AXI_INTERMEDIATE_SLAVE

//This file is the output of the ralgen utility for the specific input .ralf file. 
import uvm_pkg::*;

class ral_reg_REGA extends uvm_reg;
	rand uvm_reg_field FIELD1;

	function new(string name = "REGA");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.FIELD1 = uvm_reg_field::type_id::create("FIELD1",,get_full_name());
      this.FIELD1.configure(this, 32, 0, "RW", 0, 32'h0000_0000, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_REGA)

endclass : ral_reg_REGA


class ral_reg_REGB extends uvm_reg;
	rand uvm_reg_field FIELD1;
	rand uvm_reg_field FIELD2;

	function new(string name = "REGB");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.FIELD1 = uvm_reg_field::type_id::create("FIELD1",,get_full_name());
      this.FIELD1.configure(this, 16, 0, "RW", 0, 16'h0000, 1, 0, 1);
      this.FIELD2 = uvm_reg_field::type_id::create("FIELD2",,get_full_name());
      this.FIELD2.configure(this, 16, 16, "RW", 0, 16'h0000, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_REGB)

endclass : ral_reg_REGB


class ral_reg_REGC extends uvm_reg;
	rand uvm_reg_field FIELD1;
	rand uvm_reg_field FIELD2;
	rand uvm_reg_field FIELD3;
	rand uvm_reg_field FIELD4;

	function new(string name = "REGC");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.FIELD1 = uvm_reg_field::type_id::create("FIELD1",,get_full_name());
      this.FIELD1.configure(this, 8, 0, "RW", 0, 8'h00, 1, 0, 1);
      this.FIELD2 = uvm_reg_field::type_id::create("FIELD2",,get_full_name());
      this.FIELD2.configure(this, 8, 8, "RW", 0, 8'h00, 1, 0, 1);
      this.FIELD3 = uvm_reg_field::type_id::create("FIELD3",,get_full_name());
      this.FIELD3.configure(this, 8, 16, "RW", 0, 8'h00, 1, 0, 1);
      this.FIELD4 = uvm_reg_field::type_id::create("FIELD4",,get_full_name());
      this.FIELD4.configure(this, 8, 24, "RW", 0, 8'h00, 1, 0, 1);
   endfunction: build

	`uvm_object_utils(ral_reg_REGC)

endclass : ral_reg_REGC


class ral_reg_REGD extends uvm_reg;
	rand uvm_reg_field FIELD1;
	rand uvm_reg_field FIELD2;
	rand uvm_reg_field FIELD3;
	rand uvm_reg_field FIELD4;
	rand uvm_reg_field FIELD5;
	rand uvm_reg_field FIELD6;
	rand uvm_reg_field FIELD7;
	rand uvm_reg_field FIELD8;

	function new(string name = "REGD");
		super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
	endfunction: new
   virtual function void build();
      this.FIELD1 = uvm_reg_field::type_id::create("FIELD1",,get_full_name());
      this.FIELD1.configure(this, 4, 0, "RW", 0, 4'h0, 1, 0, 0);
      this.FIELD2 = uvm_reg_field::type_id::create("FIELD2",,get_full_name());
      this.FIELD2.configure(this, 4, 4, "RW", 0, 4'h0, 1, 0, 0);
      this.FIELD3 = uvm_reg_field::type_id::create("FIELD3",,get_full_name());
      this.FIELD3.configure(this, 4, 8, "RW", 0, 4'h0, 1, 0, 0);
      this.FIELD4 = uvm_reg_field::type_id::create("FIELD4",,get_full_name());
      this.FIELD4.configure(this, 4, 12, "RW", 0, 4'h0, 1, 0, 0);
      this.FIELD5 = uvm_reg_field::type_id::create("FIELD5",,get_full_name());
      this.FIELD5.configure(this, 4, 16, "RW", 0, 4'h0, 1, 0, 0);
      this.FIELD6 = uvm_reg_field::type_id::create("FIELD6",,get_full_name());
      this.FIELD6.configure(this, 4, 20, "RW", 0, 4'h0, 1, 0, 0);
      this.FIELD7 = uvm_reg_field::type_id::create("FIELD7",,get_full_name());
      this.FIELD7.configure(this, 4, 24, "RW", 0, 4'h0, 1, 0, 0);
      this.FIELD8 = uvm_reg_field::type_id::create("FIELD8",,get_full_name());
      this.FIELD8.configure(this, 4, 28, "RW", 0, 4'h0, 1, 0, 0);
   endfunction: build

	`uvm_object_utils(ral_reg_REGD)

endclass : ral_reg_REGD


class ral_mem_SLAVE_MEM extends uvm_mem;
   function new(string name = "SLAVE_MEM");
      super.new(name, `UVM_REG_ADDR_WIDTH'h100, 32, "RW", build_coverage(UVM_NO_COVERAGE));
   endfunction
   virtual function void build();
   endfunction: build

   `uvm_object_utils(ral_mem_SLAVE_MEM)

endclass : ral_mem_SLAVE_MEM


class ral_block_axi_intermediate_block extends uvm_reg_block;
	rand ral_reg_REGA REGA;
	rand ral_reg_REGB REGB;
	rand ral_reg_REGC REGC;
	rand ral_reg_REGD REGD;
	rand ral_mem_SLAVE_MEM SLAVE_MEM;
	rand uvm_reg_field REGA_FIELD1;
	rand uvm_reg_field REGB_FIELD1;
	rand uvm_reg_field REGB_FIELD2;
	rand uvm_reg_field REGC_FIELD1;
	rand uvm_reg_field REGC_FIELD2;
	rand uvm_reg_field REGC_FIELD3;
	rand uvm_reg_field REGC_FIELD4;
	rand uvm_reg_field REGD_FIELD1;
	rand uvm_reg_field REGD_FIELD2;
	rand uvm_reg_field REGD_FIELD3;
	rand uvm_reg_field REGD_FIELD4;
	rand uvm_reg_field REGD_FIELD5;
	rand uvm_reg_field FIELD5;
	rand uvm_reg_field REGD_FIELD6;
	rand uvm_reg_field FIELD6;
	rand uvm_reg_field REGD_FIELD7;
	rand uvm_reg_field FIELD7;
	rand uvm_reg_field REGD_FIELD8;
	rand uvm_reg_field FIELD8;

	function new(string name = "axi_intermediate_block");
		super.new(name, build_coverage(UVM_NO_COVERAGE));
	endfunction: new

   virtual function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.REGA = ral_reg_REGA::type_id::create("REGA",,get_full_name());
      this.REGA.configure(this, null, "");
      this.REGA.build();
         this.REGA.add_hdl_path('{

            '{"REGA", -1, -1}
         });
      this.default_map.add_reg(this.REGA, `UVM_REG_ADDR_WIDTH'h0, "RW", 0);
		this.REGA_FIELD1 = this.REGA.FIELD1;
      this.REGB = ral_reg_REGB::type_id::create("REGB",,get_full_name());
      this.REGB.configure(this, null, "");
      this.REGB.build();
         this.REGB.add_hdl_path('{
            '{"REGB1", 0, 16},
            '{"REGB2", 16, 16}
         });
      this.default_map.add_reg(this.REGB, `UVM_REG_ADDR_WIDTH'h4, "RW", 0);
		this.REGB_FIELD1 = this.REGB.FIELD1;
		this.REGB_FIELD2 = this.REGB.FIELD2;
      this.REGC = ral_reg_REGC::type_id::create("REGC",,get_full_name());
      this.REGC.configure(this, null, "");
      this.REGC.build();
         this.REGC.add_hdl_path('{
            '{"REGC1", 0, 8},
            '{"REGC2", 8, 8},
            '{"REGC3", 16, 8},
            '{"REGC4", 24, 8}
         });
      this.default_map.add_reg(this.REGC, `UVM_REG_ADDR_WIDTH'h8, "RW", 0);
		this.REGC_FIELD1 = this.REGC.FIELD1;
		this.REGC_FIELD2 = this.REGC.FIELD2;
		this.REGC_FIELD3 = this.REGC.FIELD3;
		this.REGC_FIELD4 = this.REGC.FIELD4;
      this.REGD = ral_reg_REGD::type_id::create("REGD",,get_full_name());
      this.REGD.configure(this, null, "");
      this.REGD.build();
         this.REGD.add_hdl_path('{
            '{"REGD1", 0, 4},
            '{"REGD2", 4, 4},
            '{"REGD3", 8, 4},
            '{"REGD4", 12, 4},
            '{"REGD5", 16, 4},
            '{"REGD6", 20, 4},
            '{"REGD7", 24, 4},
            '{"REGD8", 28, 4}
         });
      this.default_map.add_reg(this.REGD, `UVM_REG_ADDR_WIDTH'hC, "RW", 0);
		this.REGD_FIELD1 = this.REGD.FIELD1;
		this.REGD_FIELD2 = this.REGD.FIELD2;
		this.REGD_FIELD3 = this.REGD.FIELD3;
		this.REGD_FIELD4 = this.REGD.FIELD4;
		this.REGD_FIELD5 = this.REGD.FIELD5;
		this.FIELD5 = this.REGD.FIELD5;
		this.REGD_FIELD6 = this.REGD.FIELD6;
		this.FIELD6 = this.REGD.FIELD6;
		this.REGD_FIELD7 = this.REGD.FIELD7;
		this.FIELD7 = this.REGD.FIELD7;
		this.REGD_FIELD8 = this.REGD.FIELD8;
		this.FIELD8 = this.REGD.FIELD8;
      this.SLAVE_MEM = ral_mem_SLAVE_MEM::type_id::create("SLAVE_MEM",,get_full_name());
      this.SLAVE_MEM.configure(this, "SLAVE_MEM");
      this.SLAVE_MEM.build();
      this.default_map.add_mem(this.SLAVE_MEM, `UVM_REG_ADDR_WIDTH'h800, "RW", 0);
   endfunction : build

	`uvm_object_utils(ral_block_axi_intermediate_block)

endclass : ral_block_axi_intermediate_block


class ral_sys_axi_intermediate_slave extends uvm_reg_block;

   rand ral_block_axi_intermediate_block slave_block;

	function new(string name = "axi_intermediate_slave");
		super.new(name);
	endfunction: new

	function void build();
      this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);
      this.slave_block = ral_block_axi_intermediate_block::type_id::create("slave_block",,get_full_name());
      this.slave_block.configure(this, "reg_slave");
      this.slave_block.build();
      this.default_map.add_submap(this.slave_block.default_map, `UVM_REG_ADDR_WIDTH'h0);
	endfunction : build

	`uvm_object_utils(ral_sys_axi_intermediate_slave)
endclass : ral_sys_axi_intermediate_slave



`endif
