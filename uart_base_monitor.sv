`include "uvm_macros.svh"
import uvm_pkg::*;

class tx_monitor extends uvm_monitor;

localparam cnt_clk = 50000000/(115200*16);
  // register with factory
  `uvm_component_utils(base_monitor)

  // declare virtual interface handle
  virtual uart_if vif;
  
  // count for write sequence that monitor receive
  int write_cnt;

  // declare analysis port co commu with scoreboard
  uvm_analysis_port#(base_seq_item) tx_mon_analysis_port;

  /////////////////////////////////////////
  //  DECLARE COVERGROUP AND COVERPOINT  //
  /////////////////////////////////////////
  /*


    ......


  */
  // instance port and covergroup in constructor
  function new(input string name="tx_monitor", uvm_component parent=null);
    super.new(name, parent);
    tx_mon_analysis_port = new("tx_mon_analysis_port", this);
    // data_in_covergroup = new;
    // wr_covergroup = new;
    // status_covergroup = new;
    // cross_covergroup = new;
  endfunction

  // config VIF in build phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(),{"Starting Build phase for ",get_type_name()}, UVM_MEDIUM)
        if(!uvm_config_db#(virtual uart_if)::get(this,"","uart_if",vif))
            `uvm_fatal(get_type_name(),"TX MONITOR VIF Configuration failure!")
    endfunction

  // instance sequence item and get item from VIF, sample covergroup
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_full_name(),{"Starting Run phase for ",get_type_name()}, UVM_MEDIUM)
        forever begin
        // instance sequence item to hold value get from VIF and send to scoreboard
        base_seq_item mon_seq = base_seq_item::type_id::create("mon_seq");
	    // get signal from VIF on posedge clk
        @(posedge vif.clk)
        // put rst_n to base sequence send to scoreboard in order to check 
            mon_seq.rst_n = vif.rst_n;
            mon_seq.tx = vif.tx;
            mon_seq.tx_done = vif.tx_done;
        // if no reset and there is write request, get signal and flag from VIF
        if(vif.rst_n && !vif.tx_done) begin
            mon_seq.cts_n         = vif.cts_n;
            mon_seq.tx_data       = vif.tx_data;
            mon_seq.data_bit_num  = vif.data_bit_num;
            mon_seq.stop_bit_num  = vif.stop_bit_num;
            mon_seq.parity_en     = vif.parity_en;
            mon_seq.parity_type   = vif.parity_type;

            mon_seq.tx_frame_data = 'b0;
            while(!vif.tx_done) begin
              repeat (cnt_clk) @(posedge vif.clk);
              mon_seq.tx_frame_data = {vif.tx, tx_frame_data[10:1]};
            end

            `uvm_info(get_type_name(),$sformatf("TX_MONITOR write item: %s",mon_seq.sprint()),UVM_MEDIUM)
            // increase write seq counter
            // write_cnt++;
            // `uvm_info(get_type_name(),$sformatf("TX_MONITOR write items collected : %0d ",write_cnt),UVM_MEDIUM);
            // sample covergroups
            // data_in_covergroup.sample();
            // wr_covergroup.sample();
            // status_covergroup.sample();
            // cross_covergroup.sample();
        end
      // send seq item to scoreboard through port
      // in write task must have condition when to accept data_in
        tx_mon_analysis_port.write(mon_seq);
    end
  endtask

//   // report number item collected in monitor for write agent, and display coverage percentage
//   function void report_phase(uvm_phase phase);
//     $display("STDOUT: %3.2f%% coverage for data of agent write achieved.", data_in_covergroup.get_inst_coverage());
//     $display("STDOUT: %3.2f%% coverage for write of agent write achieved.", wr_covergroup.get_inst_coverage());
//     $display("STDOUT: %3.2f%% coverage for status of agent write achieved.", status_covergroup.get_inst_coverage());
//     $display("STDOUT: %3.2f%% coverage for cross of agent write achieved.", cross_covergroup.get_inst_coverage());
//     `uvm_info(get_type_name(),$sformatf("BASE_MONITOR write items collected : %0d ",write_cnt),UVM_MEDIUM);
//   endfunction
endclass


// Read Monitor class
class rx_monitor extends uvm_monitor;
  
  //register with factory
  `uvm_component_utils(rx_monitor)

  // declare virtual interface
  virtual uart_if vif;

  // // count for read sequence
  // int read_cnt;
  
  // analysis port to commu with scoreboard
  uvm_analysis_port #(base_seq_item) rx_mon_analysis_port;


  /////////////////////////////////////////
  //  DECLARE COVERGROUP AND COVERPOINT  //
  /////////////////////////////////////////
  /*


    ......


  */

  // constructor instance analysis port and covergroup
  function new(input string name="rx_monitor", uvm_component parent=null);
    super.new(name,parent);
    mon_rd_ap = new("rx_mon_analysis_port", this);
    // data_out_covergroup = new;
    // rd_covergroup = new;
    // status_covergroup1 = new;
    // cross_covergroup1 = new;
  endfunction

  // config VIF in build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),{"Starting Build phase for ",get_type_name()}, UVM_MEDIUM)
    if(!uvm_config_db#(virtual uart_if)::get(this,"","uart_if",vif))
      `uvm_fatal(get_type_name(),"RX_MONITOR VIF Configuration failure!")
  endfunction

  // instance sequence item and get item from VIF, sample covergroup
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_full_name(),{"Starting Run phase for ",get_type_name()}, UVM_MEDIUM)
    forever begin
      // instance sequence item to hold value get from VIF and send to scoreboard
      base_seq_item mon_seq = base_seq_item::type_id::create("mon_seq");
	  // get signal from VIF on posedge clk
      @(posedge vif.clk)
      // if no reset and there is read request, get signal and flag from VIF
      if(vif.rst_n && !vif.rx_done) begin
        mon_seq.data_bit_num  = vif.data_bit_num;
        mon_seq.stop_bit_num  = vif.stop_bit_num;
        mon_seq.parity_en     = vif.parity_en;
        mon_seq.parity_type   = vif.parity_type;
        @(vif.rx_done)
        mon_seq.rx_data = vif.rx_data;
        mon_seq.parity_error = vif.parity_error;
        mon_seq.parity_bit = parity_bit
        `uvm_info(get_type_name(),$sformatf("RX_MONITOR read item: %s",mon_seq.sprint()),UVM_MEDIUM)
        // $display("[%0t] empty = %0d",$time,vif.fifo_empty); // for debug
        // increase counter for read seq
      //   read_cnt++;
      //   `uvm_info(get_type_name(),$sformatf("RX_MONITOR read items collected : %0d",read_cnt),UVM_MEDIUM);
      //   // sample covergroups
      //   data_out_covergroup.sample();
      //   rd_covergroup.sample();
      //   status_covergroup1.sample();
      //   cross_covergroup1.sample();
      end
      // send sequence item to scoreboard through port
      // in write task must have condition to accept data_out
      rx_mon_analysis_port.write(mon_seq);
    end
  endtask

//   // report number item collected in monitor for read agent, and display coverage percentage
//   function void report_phase(uvm_phase phase);
//     $display("STDOUT: %3.2f%% coverage for data out of agent read achieved.", data_out_covergroup.get_inst_coverage());
//     $display("STDOUT: %3.2f%% coverage for read request and pointer of agent read achieved.", rd_covergroup.get_inst_coverage());
//     $display("STDOUT: %3.2f%% coverage for status of agent read achieved.", status_covergroup1.get_inst_coverage());
//     $display("STDOUT: %3.2f%% coverage for cross of agent read achieved.", cross_covergroup1.get_inst_coverage());
//     `uvm_info(get_type_name(),$sformatf("RX_MONITOR read items collected : %0d ",read_cnt),UVM_MEDIUM);
//   endfunction

endclass