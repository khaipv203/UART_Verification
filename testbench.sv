// Code your testbench here
// or browse Examples
`timescale 1ns / 1ns
module uart_tb_top;
  //import package from uvm
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
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
  initial begin
    $dumpfile("uart_dump.vcd");
    $dumpvars(0,uart_dut);
  end
  
endmodule: fifo_tb_top