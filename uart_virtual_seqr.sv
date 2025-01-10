`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_virtual_sequencer extends uvm_sequencer;
  // register with uvm factory
  `uvm_component_utils(fifo_virtual_sequencer)

  // declare handle for base sequencer
  tx_sequencer tx_seqr;
  rx_sequencer rx_seqr;

  // constructor
  function new(input string name="UART_VIRTUAL_SEQUENCER", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Start of simulation phase for ",get_type_name()}, UVM_LOW)
  endfunction
    
endclass