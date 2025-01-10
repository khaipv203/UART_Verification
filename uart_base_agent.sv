`include "uvm_macros.svh"
import uvm_pkg::*;
class tx_agent extends uvm_agent;

  // declare child component handle 
  tx_sequencer tx_seqr;
  tx_driver tx_drv;
  tx_monitor tx_mon;
  // declare virtual interface handle
  virtual uart_if vif;

  // register with factory and set agent active 
  `uvm_component_utils_begin(tx_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)  // active or passive
  `uvm_component_utils_end

  // constructor
  function new(input string name="TX_AGENT", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // instance all children of agent inside build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),{"Starting Build phase for ",get_type_name()}, UVM_LOW)
    // instance monitor
    tx_mon = tx_monitor::type_id::create("tx_mon", this);
    // check config virtual interface
    if(!uvm_config_db#(virtual uart_if)::get(this,"","uart_if",vif))
      `uvm_fatal(get_type_name(),"tx_agent VIF Configuration failure!")
    //if agent is active, instance sequencer and driver
    if(is_active == UVM_ACTIVE) begin
      tx_seqr = tx_sequencer::type_id::create("tx_seqr", this);
      tx_drv  = tx_driver::type_id::create("tx_drv", this);
	end
  endfunction

  // connect phase to connect sequencer port to driver port 
  virtual function void connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Starting Connect phase for ",get_type_name()}, UVM_LOW)
    super.connect_phase(phase);
    // if agent is active, connect sequencer port to driver port
    if(is_active == UVM_ACTIVE) begin
      tx_drv.seq_item_port.connect(tx_seqr.seq_item_export);
    end
  endfunction
    
endclass


class rx_agent extends uvm_agent;
    
  // declare child component handle   
  rx_sequencer rx_seqr;
  rx_driver rx_drv;
  rx_monitor rx_mon;
  
  // declare virtual interface handle
  virtual uart_if vif;

  // register with factory and set agent active
  `uvm_component_utils_begin(rx_agent)
     `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  // constructor
  function new(input string name="RX_AGENT", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // instance all children of agent inside build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),{"Starting Build phase for ",get_type_name()}, UVM_LOW)
    // instance monitor
    rx_mon = rx_monitor::type_id::create("rx_mon", this);
    // check config virtual interface
    if(!uvm_config_db#(virtual uart_if)::get(this,"","uart_if",vif))
      `uvm_fatal(get_type_name(),"Driver Interface Configuration failure!")
    // if agent is active, instance sequencer and driver
    if(is_active == UVM_ACTIVE) begin
      rx_seqr = rx_sequencer::type_id::create("rx_seqr", this);
      rx_drv  = rx_driver::type_id::create("rx_drv", this);
    end
  endfunction

  virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Start of simulation phase for ",get_type_name()}, UVM_LOW)
  endfunction

  // connect phase to connect sequencer port to driver port
  virtual function void connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Starting Connect phase for ",get_type_name()}, UVM_LOW)
    super.connect_phase(phase);
    // if agent is active, connect sequencer port to driver port
    if(is_active == UVM_ACTIVE) begin
       rx_drv.seq_item_port.connect(tx_seqr.seq_item_export);
    end
  endfunction
    
endclass : rx_agent