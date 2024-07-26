
/**
 *
 *
 * Abstract: 
 * This file defines a scoreboard class that axi_intermediate_ral_env uses for
 * comparing the data coming out of the analysis ports of the Master & Slave
 * agents. This class defines the following:
 *
 * The scoreboard contains two analysis ports - item_observed_initiated_export
 * and item_observed_response_export. item_observed_initiated_export is
 * connected to the master agent's analysis port, and
 * item_observed_response_export is connected to slave agent's analysis port.
 * The connection is done in the axi_intermediate_ral_env.  The analysis ports call
 * write_response and write_initiated tasks.  write_response and write_initiated
 * tasks store the transactions in the response_xact_list and
 * initiated_xact_list respectively.
 *
 * At the negedge of the clock the list are sorted. The sorting is required
 * because READ and WRITE transactions may complete at the same time. After
 * sorting, the transactions are compared via  compare_xact() task and then the
 * queue is flushed via flush_queue() task.
 */

`ifndef GUARD_AXI_UVM_SCOREBOARD
`define GUARD_AXI_UVM_SCOREBOARD

/** Macro that define two analysis ports with unique suffixes */
`uvm_analysis_imp_decl(_initiated)
`uvm_analysis_imp_decl(_response)

class cust_comparer extends uvm_comparer;
  //uvm_object_utils (cust_comparer)
     
  `ifndef SVT_UVM_1800_2_2017_OR_HIGHER
    function new();
      show_max = 100;
      check_type = 0;
      sev = UVM_ERROR;
      policy = UVM_DEEP;
      abstract = 0;
      physical = 1;
  `else
    function new(string name="");
      super.new(name);
      set_show_max (100);
      set_check_type (0);
      set_severity(UVM_ERROR);
      set_recursion_policy(UVM_DEEP);
  `endif
    endfunction
  `ifdef SVT_UVM_1800_2_2017_OR_HIGHER
    // Needed due to a bug in 1800.2 2017.  The check_type property is current reset back
    // to 1 when the comparer flush() routine executes.  The uvm_object class calls the
    // flush() routine prior to doing the compare, so there's no way to control this.
    function void flush();
      super.flush();
      set_check_type(0);

    endfunction
  `endif
endclass : cust_comparer
 
class axi_uvm_scoreboard extends uvm_scoreboard;

  /** Analysis port connected to the AXI Master Agent */
  uvm_analysis_imp_initiated#(svt_axi_transaction, axi_uvm_scoreboard) item_observed_initiated_export;

  /** Analysis port conneted to the AXI Slave Agent */
  uvm_analysis_imp_response#(svt_axi_transaction, axi_uvm_scoreboard) item_observed_response_export;

  /** Queue to store the write request from the Master */
  svt_axi_transaction initiated_xact_queue[$];

  /** Queue to store the write response from the Slave */
  svt_axi_transaction response_xact_queue[$];

  /** Event used to indicate that there are finished transactions which were not processed by compare_xact() */
  event non_empty_xact_queue;

  /** Customized UVM comparer policy class */
  cust_comparer axi_comparer;

 /** UVM Component Utility macro */
 `uvm_component_utils(axi_uvm_scoreboard)
 

  /** Class Constructor */
  function new (string name = "axi_uvm_scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new


  /** Flush the transaction queues after the compare */
  virtual function void flush_queue();
    initiated_xact_queue.delete();
    response_xact_queue.delete();
  endfunction


  /**
   * Build Phase
   * - Construct the analysis ports
   * - Customize the compare policy
   */
  virtual function void build_phase(uvm_phase phase);
    `uvm_info("build_phase", "Entered...", UVM_LOW)

    super.build_phase(phase);

    /** Construct the analysis ports */
    item_observed_initiated_export = new("item_observed_initiated_export", this);
    item_observed_response_export = new("item_observed_response_export", this);

    /** Customize the compare policy */
    axi_comparer = new();

    `uvm_info("build_phase", "Exiting...", UVM_LOW)
  endfunction


  /**
   * Run Phase
   * - Compares the received transactions ad the negedge of the clock
   */
  virtual task run_phase(uvm_phase phase);
    `uvm_info("run_phase", "Entered...", UVM_LOW)

    forever begin

      // To avoid waking up at every clock, watch for some indication that there is
      // something to wake up for
      if (initiated_xact_queue.size() == 0 || response_xact_queue.size() == 0)
        @(non_empty_xact_queue);
     
      // Compare the lists at negedge of the SystemClock
      @(negedge SystemClock);
      compare_xact();
    end 

    `uvm_info("run_phase", "Exiting...", UVM_LOW)
  endtask


  /** This method is called by item_observed_initiated_export */ 
  virtual function void write_initiated(input svt_axi_transaction xact);
    svt_axi_transaction init_xact;

    if (!$cast(init_xact, xact.clone())) begin
      `uvm_fatal("write_initiated", "Unable to $cast the received transaction to svt_axi_transaction");
    end
   
    `uvm_info("write_initiated", $sformatf("xact:\n%s", init_xact.sprint()), UVM_FULL)
    initiated_xact_queue.push_back(init_xact);
    -> non_empty_xact_queue;
  endfunction


  /** This method is called by item_observed_response_export */
  virtual function void write_response(input svt_axi_transaction xact);
    svt_axi_transaction  resp_xact;

    if (!$cast(resp_xact, xact.clone())) begin
      `uvm_fatal("write_initiated", "Unable to $cast the received transaction to svt_axi_transaction");
    end
   
    `uvm_info("write_response", $sformatf("xact:\n%s", resp_xact.sprint()), UVM_FULL)
      response_xact_queue.push_back(resp_xact);
    -> non_empty_xact_queue;
  endfunction


  /** Compares the elements from the queue */
  virtual function void compare_xact();
    bit val;

    /** Sort the transactions initiated comparing */
    `uvm_info("compare_xact_sort", "Sorting both the lists with object_id", UVM_FULL);
    initiated_xact_queue.sort() with (item.object_id);
    response_xact_queue.sort() with (item.object_id);

    if (initiated_xact_queue.size() != response_xact_queue.size()) begin
      `uvm_error("compare_xact", $sformatf("Size Mismatch. initiated_xact_queue size = %0d , response_xact_queue size = %0d",initiated_xact_queue.size(),response_xact_queue.size()));
    end
    else begin

      /** Compare each transaction and issue error on mis-match */
      foreach (initiated_xact_queue[i]) begin
        `ifdef SVT_UVM_1800_2_2017_OR_HIGHER
          initiated_xact_queue[i].kind = `SVT_DATA_TYPE::RELEVANT;
        `endif
        `uvm_info("compare_xact", $sformatf("Comparing transactions with object_id %0d  - %0d\n", initiated_xact_queue[i].object_id, response_xact_queue[i].object_id), UVM_LOW);
        if (initiated_xact_queue[i].compare(response_xact_queue[i], axi_comparer)) begin
          `uvm_info("compare_xact_local", " Comparator Match", UVM_LOW);
        end
        else begin
          `uvm_error("compare_xact_local", "comparator mismatch");
        end
      end
    end

    flush_queue();
  endfunction

endclass: axi_uvm_scoreboard

`endif // GUARD_AXI_UVM_SCOREBOARD
