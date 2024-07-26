/**
 * Abstract:
 * Class cust_svt_axi_system_configuration is basically used to encapsulate all
 * the configuration information.  It extends system configuration and set the
 * appropriate fields like number of master/slaves, create master/slave
 * configurations etc..., which are required by System Env.
 */

`ifndef GUARD_CUST_SVT_AXI_SYSTEM_CONFIGURATION_SV
`define GUARD_CUST_SVT_AXI_SYSTEM_CONFIGURATION_SV
class cust_svt_axi_system_configuration extends svt_axi_system_configuration;
  //Utility macro
  `uvm_object_utils (cust_svt_axi_system_configuration)

  function new (string str="cust_svt_axi_system_configuration");
    super.new(str);

    /** Assign the necessary configuration parameters. This example uses single
      * master and single slave configuration.
      */
    this.num_masters = 1;
    this.num_slaves  = 1;

    /** Create port configurations */
    this.create_sub_cfgs(this.num_masters, this.num_slaves);
    this.master_cfg[0].uvm_reg_enable= 1;

    /** Enable transaction level coverage */
    this.master_cfg[0].transaction_coverage_enable = 1;
    this.slave_cfg[0].transaction_coverage_enable = 1;

    /** Enable protocol file generation for Protocol Analyzer */
    this.master_cfg[0].enable_xml_gen = 1;
    this.slave_cfg[0].enable_xml_gen = 1;

     /* The one slave is passive as there is an RTL slave */
     this.slave_cfg[0].is_active = 0;

     /* Set the AXI width in the slave to 32 bits */
      this.master_cfg[0].data_width = 32;
      this.slave_cfg[0].data_width = 32;
  endfunction
endclass
`endif // GUARD_CUST_SVT_AXI_SYSTEM_CONFIGURATION_SV
