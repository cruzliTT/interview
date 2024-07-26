
`ifndef AXI_RAL_BASE_TEST_SV
`define AXI_RAL_BASE_TEST_SV

`include "axi_intermediate_ral_env.sv"
`include "cust_svt_axi_system_configuration.sv"
`include "axi_slave_mem_response_sequence.sv"

/**
 *UVM Report Catcher to catch UVM_WARNING  [UVM/RSRC/NOREGEX] a resource with meta characters in the field name  has been created "regmodel.slave_blk"
 */
class warning_catcher extends uvm_report_catcher;

  function new(string name="warning_catcher");
   super.new(name);
  endfunction

  function action_e catch();
    string str;
    string scope;
    int err;
    scope = "/a resource with meta characters in the field name has been created/";

    str = get_message();

    err = uvm_re_match(scope, str);

    if(!err) begin
      set_verbosity(UVM_NONE);	//<-- Do not display the message if caught
      return CAUGHT;
    end
    else begin
      return THROW;		//<-- Display the message if not caught
    end
  endfunction
endclass

/** 
 * Abstract:
 * This file creates a base test, which serves as the base class for the rest
 * of the tests in this environment.  This test sets up the default behavior
 * for the rest of the tests in this environment.
 */

class axi_ral_base_test extends uvm_test;

  /** UVM Component Utility macro */
  `uvm_component_utils(axi_ral_base_test)

  /** Construct the report catcher extended class*/
  warning_catcher catcher = new();

  /** Instance of the environment */
  axi_intermediate_ral_env env;

  /** Customized configuration */
  cust_svt_axi_system_configuration cfg;

 /** Class Constructor */
  function new(string name = "axi_ral_base_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    /** Add uvm_report_cb callback */
    uvm_report_cb::add(null, catcher);

    /** Create the configuration object */
    cfg = cust_svt_axi_system_configuration::type_id::create("cfg");

    /** Set configuration in environment */
    uvm_config_db#(cust_svt_axi_system_configuration)::set(this, "env", "cfg", this.cfg);

    /** Create the environment */
    env = axi_intermediate_ral_env::type_id::create("env", this);

    /**
     * Apply the AXI Slave Memory  sequence to the slave sequencer.
     */
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.axi_system_env.slave*.sequencer.run_phase", "default_sequence", axi_slave_mem_response_sequence::type_id::get());

  endfunction : build_phase

  /** Wait till reset is completed */
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("run_phase", "Waiting for Reset...", UVM_LOW);
    //Wait for the reset to complete which is done from test_top module in top.sv
    @(test_top.reset_done);    
    `uvm_info("run_phase", "Reset Completed", UVM_LOW);
    phase.drop_objection(this);
  endtask : run_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    `SVT_XVM(root) root = `SVT_XVM(root)::get();
    `uvm_info("end_of_elaboration_phase", "Entered...", UVM_LOW)
    root.print_topology();
    `uvm_info("end_of_elaboration_phase", "Exiting...", UVM_LOW)
  endfunction: end_of_elaboration_phase

  /**
   * Calculate the pass or fail status for the test in the final phase method of the
   * test. If a UVM_FATAL, UVM_ERROR, or a UVM_WARNING message has been generated the
   * test will fail.
   */
  function void final_phase(uvm_phase phase);
    uvm_report_server svr;
    `uvm_info("final_phase", "Entered...",UVM_LOW)

    super.final_phase(phase);

    svr = uvm_report_server::get_server();

    if (svr.get_severity_count(UVM_FATAL) +
        svr.get_severity_count(UVM_ERROR) >0)
      `uvm_info("final_phase", "\nSvtTestEpilog: Failed\n", UVM_LOW)
    else
      `uvm_info("final_phase", "\nSvtTestEpilog: Passed\n", UVM_LOW)

    `uvm_info("final_phase", "Exiting...", UVM_LOW)
  endfunction: final_phase


endclass

`endif // AXI_RAL_BASE_TEST_SV
