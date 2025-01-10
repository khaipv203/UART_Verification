`include "uvm_macros.svh"
import uvm_pkg::*;
class base_env extends uvm_env;

  // register with factory
  `uvm_component_utils(base_env)

  // declare child component handle
  uart_virtual_sequencer uart_vseqr;
  tx_agent tx_agt;
  rx_agent rx_agt;
  uart_scoreboard uart_sb;
  
  // declare virtual interface handle
  virtual uart_if vif;

  // constructor
  function new(input string name="BASE_ENV", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // instance child component inside build phase
  virtual function void build_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Starting Build phase for ",get_type_name()}, UVM_LOW)
    super.build_phase(phase);
    // check config virtual interface
    if(!uvm_config_db#(virtual uart_if)::get(this,"","uart_if",vif))
        `uvm_fatal(get_type_name(),"BASE_ENV VIF Configuration failure!")
    // instance components
    tx_agt     = tx_agent::type_id::create("tx_agt",this);
    rx_agt     = rx_agent::type_id::create("rx_agt",this);
    uart_sb    = uart_scoreboard::type_id::create("uart_sb",this);
    uart_vseqr = uart_virtual_sequencer::type_id::create("uart_vseqr",this);
  endfunction

  // connect handles of local sequencers to virtual sequencer
  virtual function void connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Starting Connect phase for ",get_type_name()}, UVM_LOW)
    super.connect_phase(phase);
    // connect virtual sequencer to sequencer in agent 
    uart_vseqr.tx_seqr = tx_agt.tx_seqr;
    uart_vseqr.rx_seqr = rx_agt.rx_seqr;
    // connect monitor port to scoreboard
    tx_agt.tx.tx_mon_analysis_port.connect(uart_sb.tx2sb_port);
    rx_agt.rx_mon.rx_mon_analysis_port.connect(uart_sb.rx2sb_port);
  endfunction
    
endclass