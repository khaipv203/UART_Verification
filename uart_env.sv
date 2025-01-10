`include "uvm_macros.svh"
import uvm_pkg::*;
class base_env extends uvm_env;

  // register with factory
  `uvm_component_utils(base_env)

  // declare child component handle
  uart_virtual_sequencer vseqr;
  tx_agent tx_agt;
  base_agent1 base_agt1;
  fifo_scoreboard fifo_sb;
  
  // declare virtual interface handle
  virtual base_intf base_vif;

  // constructor
  function new(input string name="BASE_ENV", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // instance child component inside build phase
  virtual function void build_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Starting Build phase for ",get_type_name()}, UVM_LOW)
    super.build_phase(phase);
    // check config virtual interface
    if(!uvm_config_db#(virtual base_intf)::get(this,"","base_intf",base_vif))
        `uvm_fatal(get_type_name(),"BASE_ENV VIF Configuration failure!")
    // instance components
    base_agt   = base_agent::type_id::create("base_agt",this);
    base_agt1  = base_agent1::type_id::create("base_agt1",this);
    fifo_sb    = fifo_scoreboard::type_id::create("fifo_sb",this);
    vseqr      = fifo_virtual_sequencer::type_id::create("vseqr",this);
  endfunction

  // connect handles of local sequencers to virtual sequencer
  virtual function void connect_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Starting Connect phase for ",get_type_name()}, UVM_LOW)
    super.connect_phase(phase);
    // connect virtual sequencer to sequencer in agent 
    vseqr.base_seqr = base_agt.base_seqr;
    vseqr.base_seqr1 = base_agt1.base_seqr1;
    // connect monitor port to scoreboard
    base_agt.base_mon.mon_wr_ap.connect(fifo_sb.wr2sb_port);
    base_agt1.base_mon1.mon_rd_ap.connect(fifo_sb.rd2sb_port);
  endfunction
    
endclass : base_env