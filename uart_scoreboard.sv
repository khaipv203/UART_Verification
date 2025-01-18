// `include "uvm_macros.svh"
// import uvm_pkg::*;
class uart_scoreboard extends uvm_scoreboard;
  
  // register with factory
  `uvm_component_utils(uart_scoreboard)
  
  // declare tag monitor write and read for analysis import
  `uvm_analysis_imp_decl(_tx_mon)
  `uvm_analysis_imp_decl(_rx_mon)
  
  function new(string name = "", uvm_component parent);
    super.new(name,parent);
  endfunction : new
  
  // declare handle for ap
  uvm_analysis_imp_tx_mon #(base_seq_item, uart_scoreboard) tx2sb_port;
  uvm_analysis_imp_rx_mon #(base_seq_item, uart_scoreboard) rx2sb_port;

  // instance port in build phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    tx2sb_port = new("tx2sb_port",this);
    rx2sb_port = new("rx2sb_port",this);
    
  endfunction
  
  // overwrite write function with tag monitor write
  virtual function void write_tx_mon(input base_seq_item tx_seq);

    logic[11:0] golden_data_frame; 
    `uvm_info(get_type_name(),"Receive Seq From Monitor Write to Scoreboard",UVM_MEDIUM)
    `uvm_info(get_type_name(),$sformatf("Receive write seq: %s",tx_seq.sprint()),UVM_MEDIUM)
    if(tx_seq.rst_n) begin
      golden_data_frame = 'b0;
      golden_data_frame[0] = 0;
        case (tx_seq.data_bit_num)
          2'b00: begin
            golden_data_frame[5:1] = tx_seq.tx_data[4:0];
            if(tx_seq.parity_en) begin
              if(tx_seq.parity_type) golden_data_frame[6] = ^(tx_seq.tx_data[4:0]);
              else golden_data_frame[6] = ~^(tx_seq.tx_data[4:0]);
              if(tx_seq.stop_bit_num) golden_data_frame[7] = 1'b1;
              else golden_data_frame[8:7] = 2'b11;
            end
            else begin
              if(tx_seq.stop_bit_num) golden_data_frame[6] = 1'b1;
              else golden_data_frame[7:6] = 2'b11;
            end
          end 
          2'b01: begin
            golden_data_frame[6:1] = tx_seq.tx_data[5:0];
            if(tx_seq.parity_en) begin
              if(tx_seq.parity_type) golden_data_frame[7] = ^(tx_seq.tx_data[5:0]);
              else golden_data_frame[7] = ~^(tx_seq.tx_data[5:0]);
              if(tx_seq.stop_bit_num) golden_data_frame[8] = 1'b1;
              else golden_data_frame[9:8] = 2'b11;
            end
            else begin
              if(tx_seq.stop_bit_num) golden_data_frame[7] = 1'b1;
              else golden_data_frame[8:7] = 2'b11;
            end
          end
          2'b10: begin
            golden_data_frame[7:1] = tx_seq.tx_data[6:0];
            if(tx_seq.parity_en) begin
              if(tx_seq.parity_type) golden_data_frame[8] = ^(tx_seq.tx_data[6:0]);
              else golden_data_frame[8] = ~^(tx_seq.tx_data[6:0]);
              if(tx_seq.stop_bit_num) golden_data_frame[9] = 1'b1;
              else golden_data_frame[10:9] = 2'b11;
            end
            else begin
              if(tx_seq.stop_bit_num) golden_data_frame[8] = 1'b1;
              else golden_data_frame[9:8] = 2'b11;
            end
          end
          2'b01: begin
            golden_data_frame[8:1] = tx_seq.tx_data[7:0];
            if(tx_seq.parity_en) begin
              if(tx_seq.parity_type) golden_data_frame[9] = ^(tx_seq.tx_data[7:0]);
              else golden_data_frame[9] = ~^(tx_seq.tx_data[7:0]);
              if(tx_seq.stop_bit_num) golden_data_frame[10] = 1'b1;
              else golden_data_frame[11:10] = 2'b11;
            end
            else begin
              if(tx_seq.stop_bit_num) golden_data_frame[9] = 1'b1;
              else golden_data_frame[10:9] = 2'b11;
            end
          end          
        endcase
        if(golden_data_frame == tx_seq.tx_frame_data) 
          `uvm_info(get_type_name(),$sformatf("TX SEQUENCE PASS"),UVM_LOW)
        else
          `uvm_error(get_type_name(),$sformatf("TX ERROR: GOLDEN=%0B, DUT=%0B", golden_data_frame, tx_seq.tx_frame_data))
      end
    else begin
      //Reset value maybe wrong
      if(tx_seq.tx_done == 1 && tx_seq.tx == 1) begin
      `uvm_info(get_type_name(),$sformatf("RESET TX SEQUENCE PASS"),UVM_LOW)
      end
      else begin
        `uvm_error(get_type_name(),$sformatf("RESET TX ERROR TX=0x%0h, TX_DONE=0x%0h", tx_seq.tx, tx_seq.tx_done))
      end
    end
  endfunction
  
  // overwrite write function with tag monitor read
  virtual function void write_rx_mon (input base_seq_item rx_seq);
    logic [7:0] gd_rx_data;
    logic gd_parity_error;
    `uvm_info(get_type_name(),"Receive Seq From Monitor Write to Scoreboard",UVM_MEDIUM)
    `uvm_info(get_type_name(),$sformatf("Receive write seq: %s",rx_seq.sprint()),UVM_MEDIUM)
    if(rx_seq.rst_n) begin
      gd_rx_data = 'b0;
      gd_parity_error = 'b0;
      case (rx_seq.data_bit_num)
          2'b00: begin
            gd_rx_data[4:0] = rx_seq.rx_serial_data[4:0];
            if(rx_seq.parity_en) begin
              gd_parity_error = (rx_seq.parity_type) ? (^(rx_seq.rx_serial_data[4:0] != rx_seq.parity_bit)) : (~^(rx_seq.rx_serial_data[4:0] != rx_seq.parity_bit));
            end
          end 
          2'b01: begin
            gd_rx_data[5:0] = rx_seq.rx_serial_data[5:0];
            if(rx_seq.parity_en) begin
              gd_parity_error = (rx_seq.parity_type) ? (^(rx_seq.rx_serial_data[5:0] != rx_seq.parity_bit)) : (~^(rx_seq.rx_serial_data[5:0] != rx_seq.parity_bit));
            end
          end
          2'b10: begin
            gd_rx_data[6:0] = rx_seq.rx_serial_data[6:0];
            if(rx_seq.parity_en) begin
              gd_parity_error = (rx_seq.parity_type) ? (^(rx_seq.rx_serial_data[6:0] != rx_seq.parity_bit)) : (~^(rx_seq.rx_serial_data[6:0] != rx_seq.parity_bit));
            end
          end
          2'b01: begin
            gd_rx_data[7:0] = rx_seq.rx_serial_data[7:0];
            if(rx_seq.parity_en) begin
              gd_parity_error = (rx_seq.parity_type) ? (^(rx_seq.rx_serial_data[7:0] != rx_seq.parity_bit)) : (~^(rx_seq.rx_serial_data[7:0] != rx_seq.parity_bit));
            end
          end          
        endcase
        if(gd_rx_data == rx_seq.rx_data && gd_parity_error == rx_seq.parity_error) `uvm_info(get_type_name(),$sformatf("RX SEQUENCE PASS"),UVM_LOW)
        else `uvm_error(get_type_name(),$sformatf("RESET RX ERROR RX_DATA=%0b, GD_DATA=%0b, PARITY_ERROR=%0b, GD_PARITY_ERROR=%0b", rx_seq.rx_data, gd_rx_data, rx_seq.parity_error, gd_parity_error))
    end
    // else begin
    //   //Reset value maybe wrong
    //   if(rx_seq.rx_data == 'b0 && rx_seq.rx_done == 1 && rx_seq.rts_n == 1 && rx_seq.parity_error == 'b0) begin
    //   `uvm_info(get_type_name(),$sformatf("RESET RX SEQUENCE PASS"),UVM_LOW)
    //   end
    //   else begin
    //     `uvm_error(get_type_name(),$sformatf("RESET RX ERROR RX_DATA=0x%0h, RX_DONE=0x%0h, RTS_N=0x%0h, PARITY_ERROR=0x%0h", rx_seq.rx_data, rx_seq.rx_done, rx_seq.rts_n, rx_seq.parity_error))
    //   end
    // end
  endfunction
  

  
endclass