
/**
 * Abstract:
 * This file defines the class 'axi_intermediate_ral_env' which is extended from
 * uvm_env base class.  It implements the build phase to construct
 * the structural elements of this environment.
 * axi_intermediate_ral_env instantiates the System ENV.  System ENV in turn
 * instantiates Master and Slave agents.
 */

`ifndef GUARD_AXI_INTERMEDIATE_RAL_ENV_SV
`define GUARD_AXI_INTERMEDIATE_RAL_ENV_SV

`include "ral_axi_intermediate_slave.sv"
`include "cust_svt_axi_system_configuration.sv"
`include "axi_uvm_scoreboard.sv"

// UVM Environment class with RAL extensions
class axi_intermediate_ral_env extends uvm_env;

  /** AXI System ENV */
  svt_axi_system_env axi_system_env;

  /** AXI System Configuration */
  cust_svt_axi_system_configuration cfg;

  /** Master/Slave Scoreboard */
  axi_uvm_scoreboard axi_scoreboard;

  // Declare RAL model.
  ral_sys_axi_intermediate_slave regmodel;

  // HDL path to RAL register model
  string hdl_path;

  /** UVM Component Utility macro */
  `uvm_component_utils_begin(axi_intermediate_ral_env)
     `uvm_field_string(hdl_path, UVM_DEFAULT)
  `uvm_component_utils_end

  /** Class Constructor */
  function new (string name="axi_svt_intermediate_ral_env", uvm_component parent=null);
    super.new (name, parent);
  endfunction

  /** Build the AXI System ENV */
  virtual function void build_phase(uvm_phase phase);
    `uvm_info("build_phase", "Entered...",UVM_LOW)
    super.build_phase(phase);
    /**
     * Check if the configuration is passed to the environment.
     * If not then create a default configuration.
     */
    if (!uvm_config_db#(cust_svt_axi_system_configuration)::get(this, "", "cfg", cfg)) begin
      cfg = cust_svt_axi_system_configuration::type_id::create("cfg");
    end
    /** Apply the configuration to the System ENV */
    uvm_config_db#(svt_axi_system_configuration)::set(this, "axi_system_env", "cfg", cfg);

     /** For the backdoor HDL path to the RTL slave registers */
     if (!uvm_config_db#(string)::get(this, "", "hdl_path", hdl_path))
       hdl_path = "test_top";

    /* Create the system ENV */
    axi_system_env = svt_axi_system_env::type_id::create("axi_system_env", this);
    /* Create the scoreboard */
    axi_scoreboard = axi_uvm_scoreboard::type_id::create("axi_scoreboard", this);
    /** Check if regmodel is passed to env if not then create and lock it. */
    if(regmodel == null) begin
      regmodel = ral_sys_axi_intermediate_slave::type_id::create("regmodel");
      regmodel.build();
      regmodel.set_hdl_path_root(hdl_path);
      `uvm_info("build_phase", "Reg Model created", UVM_LOW)
      regmodel.lock_model();
    end
    uvm_config_db#(uvm_reg_block)::set(this,"axi_system_env.master[0]", "axi_regmodel", regmodel);
    `uvm_info("build_phase", "Exiting...", UVM_LOW)
  endfunction : build_phase
  
  // Connect master & slave agent analysis ports to scoreboard 
  function void connect_phase(uvm_phase phase);
    `uvm_info("connect_phase", "Entered...",UVM_LOW)
    /**
     * Connect the master and slave agent's analysis ports with
     * item_observed_before_export and item_observed_after_export ports of the
     * scoreboard.
     */
    axi_system_env.master[0].monitor.item_observed_port.connect(axi_scoreboard.item_observed_initiated_export);
    axi_system_env.slave[0].monitor.item_observed_port.connect(axi_scoreboard.item_observed_response_export);
    `uvm_info("connect_phase", "Exiting...", UVM_LOW)
  endfunction : connect_phase

   // Reset the register model
   task reset_phase(uvm_phase phase);
      phase.raise_objection(this, "Resetting regmodel");
      regmodel.reset();
      phase.drop_objection(this);
   endtask
endclass
`endif // GUARD_AXI_INTERMEDIATE_RAL_ENV_SV
