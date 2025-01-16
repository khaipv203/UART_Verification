
`timescale 1ns / 1ns

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uart_base_item.sv"
`include "uart_base_monitor.sv"
    `include "uart_base_seqr.sv"
    `include "uart_virtual_seqr.sv"
    `include "uart_base_seq.sv"
    `include "uart_virtual_seq.sv"
    `include "uart_base_driver.sv"
    `include "uart_base_agent.sv"
    `include "uart_scoreboard.sv"
    `include "uart_env.sv"
    `include "uart_test.sv"
    `include "uart_interface.sv"
	// `include "../../hdl/uart.sv" 
module testbench;
  // declare clk signal
  bit clk;
  
  // instance base interface, map the clk signal
  uart_if vif(clk);
  
  // instance fifo_mem DUT, connect signal to base interface
  uart uart_dut 
  (
        .clk(vif.clk),
        .reset_n(vif.rst_n) ,
        .rx(vif.rx), 
        .cts_n(vif.cts_n), 
        .tx(vif.tx), 
        .rts_n(vif.rts_n),
    .tx_data(vif.tx_data),
        .data_bit_num(vif.data_bit_num),
        .stop_bit_num(vif.stop_bit_num), 
        .parity_en(vif.parity_en), 
        .parity_type (vif.parity_type),
        .start_tx(vif.start_tx), 
        .rx_data(vif.rx_data), 
        .tx_done(vif.tx_done), 
        .rx_done(vif.rx_done), 
        .parity_error(vif.parity_error)

  );
  
  // assign the internal signal of DUT module to interface
  // initial clk and do reset task
  initial begin
    clk = 1'b1;
  end 
  // gen clock
  initial forever #10 clk = ~clk;
  
  // Set virtual interface and run_test with test_name
  initial begin
    uvm_config_db#(virtual uart_if)::set(uvm_root::get(),"*","uart_if",vif);
    
    run_test("reset_test");
  end
     
  //dump wave form file
//   initial begin
//     $dumpfile("uart_dump.vcd");
//     $dumpvars(0,uart_dut);
//   end
  
endmodule