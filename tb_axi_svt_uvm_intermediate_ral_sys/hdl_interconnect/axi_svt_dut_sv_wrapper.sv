
/** 
 * Abstract: A HDL Interconnect wrapper that connects the Verilog HDL
 * Interconnect to the SystemVerilog interface.
 */

`ifndef GUARD_AXI_SVT_DUT_SV_WRAPPER_SV
`define GUARD_AXI_SVT_DUT_SV_WRAPPER_SV

`include "axi_svt_dut.v"
`include "svt_axi_if.svi"

module axi_svt_dut_sv_wrapper (svt_axi_if axi_if);

  /** 
   * HDL Interconnect Instantiation: Example HDL Interconnect is just
   * pass-through connection. 
   */
  axi_svt_dut axi_svt_dut (
    .aclk (axi_if.master_if[0].internal_aclk) ,
    .aresetn (axi_if.master_if[0].aresetn) ,

    /**
     * write address channel 
     */
    .awvalid_m1 (axi_if.master_if[0].awvalid) ,
    .awaddr_m1 (axi_if.master_if[0].awaddr) ,
    .awlen_m1 (axi_if.master_if[0].awlen) ,
    .awsize_m1 (axi_if.master_if[0].awsize) ,
    .awburst_m1 (axi_if.master_if[0].awburst) ,
    .awlock_m1 (axi_if.master_if[0].awlock) ,
    .awcache_m1 (axi_if.master_if[0].awcache) ,
    .awprot_m1 (axi_if.master_if[0].awprot) ,
    .awid_m1 (axi_if.master_if[0].awid) ,
    .awready_m1 (axi_if.master_if[0].awready) ,

    /**
     * read address channel 
     */
    .arvalid_m1 (axi_if.master_if[0].arvalid) ,
    .araddr_m1 (axi_if.master_if[0].araddr) ,
    .arlen_m1 (axi_if.master_if[0].arlen) ,
    .arsize_m1 (axi_if.master_if[0].arsize) ,
    .arburst_m1 (axi_if.master_if[0].arburst) ,
    .arlock_m1 (axi_if.master_if[0].arlock) ,
    .arcache_m1 (axi_if.master_if[0].arcache) ,
    .arprot_m1 (axi_if.master_if[0].arprot) ,
    .arid_m1 (axi_if.master_if[0].arid) ,
    .arready_m1 (axi_if.master_if[0].arready) ,

    /**
     * read channel 
     */
    .rvalid_m1 (axi_if.master_if[0].rvalid) ,
    .rlast_m1 (axi_if.master_if[0].rlast) ,
    .rdata_m1 (axi_if.master_if[0].rdata) ,
    .rresp_m1 (axi_if.master_if[0].rresp) ,
    .rid_m1 (axi_if.master_if[0].rid) ,
    .rready_m1 (axi_if.master_if[0].rready) ,

    /**
     * write channel 
     */
    .wvalid_m1 (axi_if.master_if[0].wvalid) ,
    .wlast_m1 (axi_if.master_if[0].wlast) ,
    .wdata_m1 (axi_if.master_if[0].wdata) ,
    .wstrb_m1 (axi_if.master_if[0].wstrb) ,
    .wid_m1 (axi_if.master_if[0].wid) ,
    .wready_m1 (axi_if.master_if[0].wready) ,

    /**
     * write response channel 
     */
    .bvalid_m1 (axi_if.master_if[0].bvalid) ,
    .bresp_m1 (axi_if.master_if[0].bresp) ,
    .bid_m1 (axi_if.master_if[0].bid) ,
    .bready_m1 (axi_if.master_if[0].bready),


    /**
     * write address channel 
     */
    .awvalid_s1 (axi_if.slave_if[0].awvalid) ,
    .awaddr_s1 (axi_if.slave_if[0].awaddr) ,
    .awlen_s1 (axi_if.slave_if[0].awlen) ,
    .awsize_s1 (axi_if.slave_if[0].awsize) ,
    .awburst_s1 (axi_if.slave_if[0].awburst) ,
    .awlock_s1 (axi_if.slave_if[0].awlock) ,
    .awcache_s1 (axi_if.slave_if[0].awcache) ,
    .awprot_s1 (axi_if.slave_if[0].awprot) ,
    .awid_s1 (axi_if.slave_if[0].awid) ,
    .awready_s1 (axi_if.slave_if[0].awready) ,

    /**
     * read address channel 
     */
    .arvalid_s1 (axi_if.slave_if[0].arvalid) ,
    .araddr_s1 (axi_if.slave_if[0].araddr) ,
    .arlen_s1 (axi_if.slave_if[0].arlen) ,
    .arsize_s1 (axi_if.slave_if[0].arsize) ,
    .arburst_s1 (axi_if.slave_if[0].arburst) ,
    .arlock_s1 (axi_if.slave_if[0].arlock) ,
    .arcache_s1 (axi_if.slave_if[0].arcache) ,
    .arprot_s1 (axi_if.slave_if[0].arprot) ,
    .arid_s1 (axi_if.slave_if[0].arid) ,
    .arready_s1 (axi_if.slave_if[0].arready) ,

    /**
     * read channel 
     */
    .rvalid_s1 (axi_if.slave_if[0].rvalid) ,
    .rlast_s1 (axi_if.slave_if[0].rlast) ,
    .rdata_s1 (axi_if.slave_if[0].rdata) ,
    .rresp_s1 (axi_if.slave_if[0].rresp) ,
    .rid_s1 (axi_if.slave_if[0].rid) ,
    .rready_s1 (axi_if.slave_if[0].rready) ,

    /**
     * write channel 
     */
    .wvalid_s1 (axi_if.slave_if[0].wvalid) ,
    .wlast_s1 (axi_if.slave_if[0].wlast) ,
    .wdata_s1 (axi_if.slave_if[0].wdata) ,
    .wstrb_s1 (axi_if.slave_if[0].wstrb) ,
    .wid_s1 (axi_if.slave_if[0].wid) ,
    .wready_s1 (axi_if.slave_if[0].wready) ,

    /**
     * write response channel 
     */
    .bvalid_s1 (axi_if.slave_if[0].bvalid) ,
    .bresp_s1 (axi_if.slave_if[0].bresp) ,
    .bid_s1 (axi_if.slave_if[0].bid) ,
    .bready_s1 (axi_if.slave_if[0].bready)
    
  );

endmodule
`endif // GUARD_AXI_SVT_DUT_SV_WRAPPER_SV
