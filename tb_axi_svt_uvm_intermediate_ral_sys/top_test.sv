
/**
 * Abstract:  This file serve as a top-level test file, which just
 * pulls in the individual tests by including them.
 */
`include "ts.ral_hw_reset.sv"
`include "ts.ral_access_single_write_read_test.sv"
`include "ts.ral_access_burst_write_read_test.sv"
`include "ts.ral_reg_write_read_test.sv"
`include "ts.ral_mem_write_read_test.sv"
`include "ts.ral_reg_write_consecutive_read_test.sv"
`include "ts.reg_bit_bash_test.sv"
