`include "uvm_macros.svh"
import uvm_pkg::*;

//typedef enum bit [1:0]   {TX, RX, FULL_DUPLEX} oprn_mode;

class base_seq_item extends uvm_sequence_item;
    
  // Các biến random
    rand logic                    rst_n;
    rand logic                    cts_n;
    rand logic [7:0]              tx_data;
    rand logic [7:0]              rx_serial_data;
    rand logic [1:0]              data_bit_num;
    rand logic                    stop_bit_num;
    rand logic                    parity_en;
    rand logic                    parity_type;
    rand logic                    start_tx;
    logic                         tx;
    logic                         rx;
    logic                         rts_n;
    logic                         rx_done;
    logic                         tx_done;
    logic [7:0]                   rx_data; 
    logic [11:0]                  tx_frame_data;
    logic                         parity_error;
    logic                         parity_bit; //For checking parity error
    //oprn_mode                     op;

  // Khai báo các object trong base sequence item
    `uvm_object_utils_begin(base_seq_item)
        `uvm_field_int(rst_n,UVM_ALL_ON)
        `uvm_field_int(cts_n,UVM_ALL_ON)
        `uvm_field_int(tx_data,UVM_ALL_ON)
        `uvm_field_int(tx_frame_data,UVM_ALL_ON)
        `uvm_field_int(rx_serial_data,UVM_ALL_ON)
        `uvm_field_int(data_bit_num,UVM_ALL_ON)
        `uvm_field_int(stop_bit_num,UVM_ALL_ON)
        `uvm_field_int(parity_en,UVM_ALL_ON)
        `uvm_field_int(parity_type,UVM_ALL_ON)
        `uvm_field_int(start_tx,UVM_ALL_ON)
        `uvm_field_int(tx,UVM_ALL_ON)
        `uvm_field_int(rx,UVM_ALL_ON)
        `uvm_field_int(rts_n,UVM_ALL_ON)
        `uvm_field_int(rx_done,UVM_ALL_ON)
        `uvm_field_int(tx_done,UVM_ALL_ON)
        `uvm_field_int(rx_data,UVM_ALL_ON)
        `uvm_field_int(parity_error,UVM_ALL_ON)
        `uvm_field_int(parity_bit,UVM_ALL_ON)
        //`uvm_field_enum(oprn_mode, op, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(input string name="UART_SEQ_ITEM");
       super.new(name);
    endfunction
       
  // constraint các data được random
  constraint cts_n_c {soft cts_n == 1;} //Default: Don`t transmit anything, override to transmit
  constraint start_tx_c {soft start_tx == 0;} //Default: Don`t transmit anything, override to transmit
  constraint rst_n_c {soft rst_n == 1;} // soft constraint to overide when ever need to reset
  // constraint oprn_mode_c
  // {
  //   if(op == TX){
  //     start_tx == 1;
  //     cts_n == 0;
  //   }
  //   else if(op == RX){
  //     start_tx == 0;
  //   }
  //   else{
  //     start_tx == 1;
  //   }
  // }
endclass : base_seq_item