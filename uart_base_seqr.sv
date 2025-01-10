`include "uvm_macros.svh"
import uvm_pkg::*;

//TX Sequencer Claas
class tx_sequencer extends uvm_sequencer#(base_seq_item);
  
  // register with factory
  `uvm_component_utils(tx_sequencer)

  // constructor
  function new(input string name="TX_SEQUENCER", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // info start of simulation phase for component
  virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Start of simulation phase for ",get_type_name()}, UVM_LOW)
  endfunction

endclass


//RX Sequencer class
class rx_sequencer extends uvm_sequencer#(base_seq_item);
  
  // register with factory
  `uvm_component_utils(rx_sequencer)

  // constructor
  function new(input string name="RX_SEQUENCER", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // info start of simulation phase for component
  virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Start of simulation phase for ",get_type_name()}, UVM_LOW)
  endfunction
    
endclass