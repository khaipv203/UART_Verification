// `include "uvm_macros.svh"
// import uvm_pkg::*;
    
    interface uart_if (input bit clk);
    logic                    rst_n;
    logic                    cts_n;
    logic [7:0]              rx_serial_data;
    logic [7:0]              tx_data;
    logic [1:0]              data_bit_num;
    logic                    stop_bit_num;
    logic                    parity_en;
    logic                    parity_type;
    logic                    start_tx;
    logic                    tx;
    logic                    rx;
    logic                    rts_n;
    logic                    rx_done;
    logic                    tx_done;
    logic [7:0]              rx_data;
    logic                    parity_error;
    logic                    parity_bit; //Virtual interface for checking parity error


    //Define assertion
    /*
    assert (condition) 
    else   error_process
    */
    endinterface
    