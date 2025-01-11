// `include "uvm_macros.svh"
// import uvm_pkg::*;
class tx_driver extends uvm_driver#(base_seq_item);
  // register driver with factory
  `uvm_component_utils(tx_driver)

  // decalre virtual interface
  virtual uart_if vif;
  base_seq_item seq;

  // constructor
  function new(input string name="TX_DRIVER", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // config virtual interface
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),{"Starting Build phase for ",get_type_name()}, UVM_LOW)
    if(!uvm_config_db#(virtual uart_if)::get(this,"","uart_if",vif))
      `uvm_fatal(get_type_name(),"TX_DRIVER VIF Configuration failure!")
  endfunction

  // run phase to get sequence item and drive it to VIF
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_full_name(),{"Starting TX_DRIVER Run phase for ",get_type_name()}, UVM_LOW)
    forever begin
      // get sequence item from sequencer port
      seq_item_port.get_next_item(seq);
      // drive seq item to VIF
      drive();
      // send response to sequencer to indicate that its OK to send next sequence item
      seq_item_port.item_done();
    end
  endtask

  // task drive sequence item to VIF
  task drive();
    `uvm_info(get_type_name(),$sformatf("TX_DRIVER write item: %s",seq.sprint()),UVM_MEDIUM)
    // if no reset, send item at negedge clk
    if(seq.rst_n) begin
      @(negedge vif.clk)
      vif.rst_n         = seq.rst_n;
      vif.cts_n         = seq.cts_n;
      vif.tx_data       = seq.tx_data;
      vif.data_bit_num  = seq.data_bit_num;
      vif.stop_bit_num  = seq.stop_bit_num;
      vif.parity_en     = seq.parity_en;
      vif.parity_type   = seq.parity_type;
      vif.start_tx      = seq.start_tx;
    end
    // else if reset, send rst_n signal immediatelly
    else begin
      vif.rst_n = seq.rst_n;
    end
  endtask

endclass


class rx_driver extends uvm_driver#(base_seq_item);
  //register driver1 with factory
    `uvm_component_utils(rx_driver)
    localparam cnt_clk = 50000000/(115200*16);
  // declare handle 
    virtual uart_if vif;
    base_seq_item seq;
  // constructor
    function new(input string name="rx_driver", uvm_component parent=null);
      super.new(name,parent);
    endfunction

  // config VIF in side build_phase
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_full_name(),{"Starting Build phase for ",get_type_name()}, UVM_LOW)
      if(!uvm_config_db#(virtual uart_if)::get(this,"","uart_if",vif))
        `uvm_fatal(get_type_name(),"RX_DRIVER VIF Configuration failure!")
    endfunction

  // get item sequence from port, drive to VIF, and trigger item done
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_full_name(),{"Starting RX_DRIVER Run phase for ",get_type_name()}, UVM_LOW)
        forever begin
            // get sequence item from sequencer port
            seq_item_port.get_next_item(seq);
            // drive seq item to VIF
            drive();
            // send response to sequencer to indicate that its OK to send next sequence item
            @(posedge vif.tx_done)
            seq_item_port.item_done();
        end
    endtask

  // task drive sequence item to VIF
    task drive();
        //`uvm_info(get_type_name(),$sformatf("RX_DRIVER read item: %s",req_item.sprint()),UVM_MEDIUM)
        // if no reset, send item at negedge clk
        if (seq.rst_n) begin
            @(negedge vif.clk)
                vif.rst_n = seq.rst_n;
                vif.data_bit_num  = seq.data_bit_num;
                vif.stop_bit_num  = seq.stop_bit_num;
                vif.parity_en     = seq.parity_en;
                vif.parity_type   = seq.parity_type;
                vif.rx            = 1'b0; //Send start bit
            case(seq.data_bit_num)
                2'b00: send_5_bit();
                2'b01: send_6_bit();
                2'b10: send_7_bit();
                2'b11: send_8_bit();
                default: send_8_bit();
            endcase
            if(vif.parity_en) begin
                send_parity(seq.parity_type, seq.data_bit_num);
            end
            send_stop_bit(seq.stop_bit_num);
        end
    // else if reset, send rst_n signal immediatelly
        else begin
            vif.rst_n = seq.rst_n;
        end
    endtask
    
    task send_8_bit();
      for(int i = 0; i < 8; i=i+1) begin
            repeat (cnt_clk) @(posedge vif.clk);
            vif.rx = seq.rx_serial_data[i]; 
        end
    endtask

    task send_7_bit();
      for(int i = 0; i < 7; i=i+1) begin
            repeat (cnt_clk) @(posedge vif.clk);
            vif.rx = seq.rx_serial_data[i]; 
        end
    endtask

    task send_6_bit();
      for(int i = 0; i < 6; i=i+1) begin
            repeat (cnt_clk) @(posedge vif.clk);
            vif.rx = seq.rx_serial_data[i]; 
        end
    endtask
    
    task send_5_bit();
      for(int i = 0; i < 5; i=i+1) begin
            repeat (cnt_clk) @(posedge vif.clk);
            vif.rx = seq.rx_serial_data[i]; 
        end
    endtask

    task send_stop_bit(logic stop_bit_num);
        if(stop_bit_num) begin      
            repeat (cnt_clk) @(posedge vif.clk);
            vif.rx = 1'b1;
        end
        else begin
          for(int i = 0; i < 2; i=i+1) begin
                repeat (cnt_clk) @(posedge vif.clk);
                vif.rx = 1'b1; 
            end
        end 
    endtask

    task send_parity(logic parity_type, logic [1:0] data_bit_num);
        repeat (cnt_clk) @(posedge vif.clk);
        case({parity_type, data_bit_num})
            3'b000: begin
              vif.rx = ~^(seq.rx_serial_data[4:0]); //Odd parity, 5 bit data
              vif.parity_bit = ~^(seq.rx_serial_data[4:0]);
            end 
            3'b001: begin
              vif.rx = ~^(seq.rx_serial_data[5:0]); //Odd parity, 6 bit data
              vif.parity_bit = ~^(seq.rx_serial_data[5:0]);
            end 
            3'b010: begin
              vif.rx = ~^(seq.rx_serial_data[6:0]); //Odd parity, 7 bit data
              vif.parity_bit = ~^(seq.rx_serial_data[6:0]);
            end
            3'b011: begin
              vif.rx = ~^(seq.rx_serial_data[7:0]); //Odd parity, 8 bit data
              vif.parity_bit = ~^(seq.rx_serial_data[7:0]);
            end
            
            3'b100: begin
              vif.rx = ^(seq.rx_serial_data[4:0]); //Even parity, 5 bit data
              vif.parity_bit = ^(seq.rx_serial_data[4:0]);
            end
            
            3'b101: begin
              vif.rx = ^(seq.rx_serial_data[5:0]); //Even parity, 6 bit data
              vif.parity_bit = ^(seq.rx_serial_data[5:0]); 
            end
            
            3'b110: begin
              vif.rx = ^(seq.rx_serial_data[6:0]); //Even parity, 7 bit data
              vif.parity_bit = ^(seq.rx_serial_data[6:0]); 
            end
            3'b111: begin
              vif.rx = ^(seq.rx_serial_data[7:0]); //Even parity, 8 bit data
              vif.parity_bit = ^(seq.rx_serial_data[7:0]); 
            end
            default: begin 
              vif.rx = ^(seq.rx_serial_data[7:0]); //Even parity, 8 bit data
              vif.parity_bit = ^(seq.rx_serial_data[7:0]); 
            end
            //Enough ????
        endcase    
    endtask
endclass