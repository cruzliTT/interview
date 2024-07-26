
/**
 * Abstract:
 * This file contains the RTL code for the registers described in
 * ../axi_intermediate_ral_slave.ralf
 *
 */
`include "uvm_pkg.sv"

module axi_reg_slave(svt_axi_slave_if axi_slave_if);
 /** Import UVM Package */
  import uvm_pkg::*;

  parameter int SLAVE_MEM_BASE = 'h800;
  parameter int SLAVE_MEM_SIZE = 'h100;

  logic [31:0] REGA;
  logic [15:0] REGB1, REGB2;
  logic [ 7:0] REGC1, REGC2, REGC3, REGC4;
  logic [ 3:0] REGD1, REGD2, REGD3, REGD4, REGD5, REGD6, REGD7, REGD8;
  logic [31:0] SLAVE_MEM[SLAVE_MEM_SIZE];

  // Write state machine
  typedef enum {IDLE_W, ADDR_BEFORE_DATA_W, DATA_BEFORE_ADDR_W, WRITE_W, BRESP_W} wstate_t;
  wstate_t wstate, next_wstate;
  
  bit [`SVT_AXI_MAX_ADDR_WIDTH:0] aw_reg;
  bit [`SVT_AXI_MAX_DATA_WIDTH:0] w_reg, mem[1024];
  bit [`SVT_AXI_MAX_ID_WIDTH-1:0] wid;

  // AWVALID received, check sigs, capture addr, and respond
  function void awvalid_received();
    if (axi_slave_if.awlen > 0) begin
      `uvm_fatal("awvalid_received", $sformatf("@%0t: REG SLAVE: ERROR axi_slave_if.awlen (%0d.) is not 0, unsupported", $time, axi_slave_if.awlen));
    end
    if (axi_slave_if.awlock > 0) begin
      `uvm_fatal("awvalid_received", $sformatf("@%0t: REG SLAVE: ERROR axi_slave_if.awlock (%0d.) is not 0, unsupported", $time, axi_slave_if.awlen));
    end
    // Ignore awsize, awburst, awlock, awcache, awprot, and other AXI4 only signals
    aw_reg = axi_slave_if.awaddr;
    wid = axi_slave_if.awid;
    axi_slave_if.awready <= 1;
  endfunction

  // WVALID received, capture data and respond
  function void wvalid_received();
    w_reg = axi_slave_if.wdata;
    axi_slave_if.wready <= 1;
  endfunction

// Write to the registers
  function void reg_write( bit [`SVT_AXI_MAX_ADDR_WIDTH:0] addr,
    bit [`SVT_AXI_MAX_DATA_WIDTH:0] data);
   
    `uvm_info("reg_write", $sformatf("@%0t: REG SLAVE: reg_write(a=0x%0x, d=0x%0x)", $time, addr, data),UVM_LOW);
    case (addr) inside
      ['h0:'h0]: REGA = data;
      ['h4:'h4]: {REGB2, REGB1} = data;
      ['h8:'h8]: {REGC4, REGC3, REGC2, REGC1} = data;
      ['hC:'hC]: {REGD8, REGD7, REGD6, REGD5, REGD4, REGD3, REGD2, REGD1} = data;
      [SLAVE_MEM_BASE:SLAVE_MEM_BASE+SLAVE_MEM_SIZE-1]:SLAVE_MEM[int'(addr-SLAVE_MEM_BASE)] = data;
      default:
        begin
          `uvm_fatal("reg_write", $sformatf("@%0t: REG SLAVE: ERROR unrecognized addr", $time));
    	end
    endcase
  endfunction

   // Read from the registers
  function bit [`SVT_AXI_MAX_DATA_WIDTH:0] reg_read(bit [`SVT_AXI_MAX_ADDR_WIDTH:0] addr);
    bit [`SVT_AXI_MAX_DATA_WIDTH:0] data;
    case (addr) inside
      ['h0:'h0]: data = REGA;
      ['h4:'h4]: data = {REGB2, REGB1};
      ['h8:'h8]: data = {REGC4, REGC3, REGC2, REGC1};
      ['hC:'hC]: data = {REGD8, REGD7, REGD6, REGD5, REGD4, REGD3, REGD2, REGD1};
      [SLAVE_MEM_BASE:SLAVE_MEM_BASE+SLAVE_MEM_SIZE-1]:
   	      data = SLAVE_MEM[int'(addr-SLAVE_MEM_BASE)];
      default:
        begin
  	      `uvm_fatal("reg_read", $sformatf("@%0t: REG SLAVE: ERROR unrecognized addr)", $time));
        end
   endcase
     `uvm_info("reg_read", $sformatf("@%0t: REG SLAVE: reg_read(a=0x%0x, d=0x%0x)", $time, addr, data),UVM_LOW);
     reg_read = data;
  endfunction

  // Write address, data, and response channel state machine
  always @(posedge axi_slave_if.internal_aclk or negedge axi_slave_if.aresetn) begin
    if (!axi_slave_if.aresetn) begin
      wstate = IDLE_W;
      aw_reg = '0;
      w_reg = '0;
      axi_slave_if.awready <= 0;
      axi_slave_if.bid     <= '0;
      axi_slave_if.bvalid  <= 0;
      axi_slave_if.bresp   <= '0;
      axi_slave_if.wready  <= 0;
    end
    else begin
      next_wstate = IDLE_W;
      case (wstate)
        IDLE_W:
          begin
	      // Waiting for write address & data
          `uvm_info("always", $sformatf("@%0t: REG SLAVE: awv=%b, wv=%b", $time, axi_slave_if.awvalid, axi_slave_if.wvalid),UVM_LOW);
	      // Write address channel stuff
	      if (axi_slave_if.awvalid) begin
	        awvalid_received();
	      end
	      // Write data stuff
    	  if (axi_slave_if.wvalid) begin
    	    wvalid_received();
    	  end

    	  case ({axi_slave_if.awvalid, axi_slave_if.wvalid})
	        2'b00: // dada
	          next_wstate = IDLE_W;
	        2'b01: // data, no addr
	          next_wstate = DATA_BEFORE_ADDR_W;
	        2'b10: // addr, no data
	          next_wstate = ADDR_BEFORE_DATA_W;
	        2'b11: // addr and data
	          next_wstate = WRITE_W;
	        default: // X/Z
	          next_wstate = IDLE_W;
          endcase // case ({axi_slave_if.awvalid, axi_slave_if.wvalid})
        end // case: IDLE_W

        ADDR_BEFORE_DATA_W:
          begin
            if (axi_slave_if.wvalid) begin
              `uvm_info("always", $sformatf("@%0t: REG SLAVE: wvalid received", $time),UVM_LOW);
              wvalid_received();
              next_wstate = WRITE_W;
            end
            else
              next_wstate = ADDR_BEFORE_DATA_W;
            end

        DATA_BEFORE_ADDR_W:
          begin
            if (axi_slave_if.awvalid) begin
              `uvm_info("always", $sformatf("@%0t: REG SLAVE: awvalid received", $time),UVM_LOW);
              awvalid_received();
              next_wstate = WRITE_W;
            end
            else
              next_wstate = DATA_BEFORE_ADDR_W;
          end

        WRITE_W:
          begin
            // Have both address and data, do write
            reg_write(aw_reg, w_reg);
            // Write addr and data channels
            axi_slave_if.awready <= 0;
            axi_slave_if.wready <= 0;
            // Write response channel
            axi_slave_if.bvalid <= 1;
            axi_slave_if.bresp <= '0;
            axi_slave_if.bid <= wid;
            if (!axi_slave_if.wlast) begin
              `uvm_fatal("always", $sformatf("@%0t: REG SLAVE: wlast not asserted! Only single xfer supported", $time));
            end
              next_wstate = BRESP_W;
          end

        BRESP_W:
          begin
            if (axi_slave_if.bready) begin
              `uvm_info("always", $sformatf("@%0t: REG SLAVE: bready received", $time),UVM_LOW);
              axi_slave_if.bvalid <= 0;
              next_wstate = IDLE_W;
            end
            else
              next_wstate = BRESP_W;
            end
      endcase // case (awstate)

       // Advance state
       wstate <= #1 next_wstate;
    end
  end
 
  // Read state machine
  typedef enum {IDLE_R, READ_R, RESP_R} rstate_t;
  rstate_t rstate, next_rstate;
  bit [`SVT_AXI_MAX_ADDR_WIDTH:0] ar_reg;
  bit [`SVT_AXI_MAX_DATA_WIDTH:0] r_reg;
  bit [`SVT_AXI_MAX_ID_WIDTH-1:0] arid;
 
  // Read address and data channel state machine
  always @(posedge axi_slave_if.internal_aclk or negedge axi_slave_if.aresetn) begin
    if (!axi_slave_if.aresetn) begin
      rstate = IDLE_R;
      r_reg = '0;
      axi_slave_if.arready <= 0;
      axi_slave_if.rdata   <= '0;
      axi_slave_if.rid     <= 0;
      axi_slave_if.rlast   <= 0;
      axi_slave_if.rresp   <= '0;
      axi_slave_if.rvalid  <= 0;
    end
    else begin
 	 next_rstate = IDLE_R;
 	 case (rstate)
 	 IDLE_R:
 	   begin
 	     if (axi_slave_if.arvalid) begin
            `uvm_info("always", $sformatf("@%0t: REG SLAVE: arvalid received", $time),UVM_LOW);
 	       if (axi_slave_if.arlen > 0) begin
              `uvm_fatal("always", $sformatf("@%0t: REG SLAVE: ERROR axi_slave_if.arlen (%0d.) is not 0, unsupported", $time, axi_slave_if.arlen));
 	       end
 	       if (axi_slave_if.arlock > 0) begin
              `uvm_fatal("always", $sformatf("@%0t: REG SLAVE: ERROR axi_slave_if.arlock (%0d.) is not 0, unsupported", $time, axi_slave_if.arlock));
 	       end
 	        // Ignore axi_slave_if.arsize, arburst, arcache, arprot
 	        ar_reg = axi_slave_if.araddr;
 	        arid = axi_slave_if.arid;
 	        axi_slave_if.arready <= 1;
 	        next_rstate = READ_R;
 	     end
 	     else
 	       next_rstate = IDLE_R;
 	   end
 	 READ_R:
 	   begin
 	     axi_slave_if.rdata <= reg_read(ar_reg);
 		 axi_slave_if.arready <= 0;
 		 axi_slave_if.rvalid <= 1;
 		 axi_slave_if.rid <= arid;
 		 axi_slave_if.rlast <= 1;
 		 axi_slave_if.rresp <= '0;
 		 next_rstate = RESP_R;
 	   end
 	 RESP_R:
 	   begin
 	     if (axi_slave_if.rready) begin
            `uvm_info("always", $sformatf("@%0t: REG SLAVE: rready received", $time),UVM_LOW);
 		   axi_slave_if.rvalid <= 0;
 		   axi_slave_if.rlast <= 0;
 		   next_rstate = IDLE_R;
 		 end
 		 else
 		   next_rstate = RESP_R;
 	     end
      endcase // case (rstate)
 	   rstate <= #1 next_rstate;
      end // else: !if(!axi_slave_if.aresetn)
  end

  always @(negedge axi_slave_if.internal_aclk or negedge axi_slave_if.aresetn) begin
     if (!axi_slave_if.aresetn)
       `uvm_info("always", $sformatf("@%0t: REG SLAVE: reset asserted", $time),UVM_LOW);
  end
 
  function void print(input string prefix="");
    `uvm_info("print", $sformatf("%s--------------------------------------------------------------------------------------------------------------------------------------------------------------", prefix),UVM_LOW);
    `uvm_info("print", $sformatf("%s@%0d: %m REG SLAVE: Registers and memory contents", prefix, $time),UVM_LOW);
    `uvm_info("print", $sformatf("%s\t REGA='h%h", prefix, REGA),UVM_LOW);
    `uvm_info("print", $sformatf("%s\t REGB='h%h", prefix, {REGB2, REGB1}),UVM_LOW);
    `uvm_info("print", $sformatf("%s\t REGC='h%h", prefix, {REGC4, REGC3, REGC2, REGC1}),UVM_LOW);
    `uvm_info("print", $sformatf("%s\t REGD='h%h", prefix, {REGD8, REGD7, REGD6, REGD5, REGD4, REGD3, REGD2, REGD1}),UVM_LOW);
    `uvm_info("print", $sformatf("%s\t SLAVE_MEM [0]      [1]      [2]      [3]      [4]      [5]      [6]      [7]      [8]      [9]      [A]      [B]      [C]      [D]      [E]      [F]", prefix),UVM_LOW);
 
     // Dump whole memory
     for (int i=0; i< SLAVE_MEM_SIZE; i+=16)
       `uvm_info("print", $sformatf("%s\t [%4h] %8h %8h %8h %8h %8h %8h %8h %8h %8h %8h %8h %8h %8h %8h %8h %8h ", prefix, i+SLAVE_MEM_BASE, 
 	    SLAVE_MEM[i+0], SLAVE_MEM[i+1], SLAVE_MEM[i+2], SLAVE_MEM[i+3], SLAVE_MEM[i+4], SLAVE_MEM[i+5], SLAVE_MEM[i+6], SLAVE_MEM[i+7],
 	    SLAVE_MEM[i+8], SLAVE_MEM[i+9], SLAVE_MEM[i+10], SLAVE_MEM[i+11], SLAVE_MEM[i+12], SLAVE_MEM[i+13], SLAVE_MEM[i+14], SLAVE_MEM[i+15]),UVM_LOW);
 
     // Dump just non-X values, ie. anything touched during simulation
     foreach (SLAVE_MEM[i]) begin
 	  if (SLAVE_MEM[i] !== 'x)
         `uvm_info("print", $sformatf("\t\tSLAVE_MEM['h%0h]=%8h", i+SLAVE_MEM_BASE, SLAVE_MEM[i]),UVM_LOW);
     end
    `uvm_info("print", $sformatf("%s--------------------------------------------------------------------------------------------------------------------------------------------------------------", prefix),UVM_LOW);
  endfunction

endmodule : axi_reg_slave
