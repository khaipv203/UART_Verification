// Virtual Sequence
class uart_virtual_seq extends uvm_sequence#(uvm_sequence_item);

  // register with factory
  `uvm_object_utils(uart_virtual_seq)
  `uvm_declare_p_sequencer(uart_virtual_sequencer)

  // constructor
  function new(input string name="FIFO_VIRTUAL_SEQUENCE");
    super.new(name);
  endfunction

  // call before body task to raise objection
  virtual task pre_body();
    uvm_phase phase;
    phase = starting_phase;
    if(phase != null) begin
      phase.raise_objection(this,{"Virtual sequence started : ",get_type_name()});
    end
  endtask

  // called after body task to drop object
  virtual task post_body();
    uvm_phase phase;
    phase = starting_phase;
    if(phase != null) begin
      phase.drop_objection(this,{"Virtual sequence ended : ",get_type_name()});
    end
  endtask
    
endclass

class simplex_tx extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(simplex_tx)

  // set handle for sequence called in this sequence
  reset_seq rst_n_seq;
  tx8_stop1_np tx_8;
  tx7_stop1_np tx_7;
  tx6_stop1_np tx_6;
  tx5_stop1_np tx_5;

  // constructor
  function new(input string name="POST_TEST_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write half to mem
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    //do nothing
    `uvm_do_on(tx_8, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Third started : ",get_type_name()},UVM_LOW)
    // single write
    `uvm_do_on(tx_7, p_sequencer.tx_seqr);

    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(tx_6, p_sequencer.tx_seqr);
    
    `uvm_info(get_full_name(),{"Fifth started : ",get_type_name()},UVM_LOW)
    // single read
    `uvm_do_on(tx_5, p_sequencer.tx_seqr);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
endclass

// Sequence check fifo reset
class reset_n_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(reset_n_seq)

  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  tx8_stop1_np tx_8;
  tx7_stop1_np tx_7;
  tx6_stop1_np tx_6;
  tx5_stop1_np tx_5;

  // constructor
  function new(input string name="RESET_TEST_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
    virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // write half to mem
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    //do nothing
    `uvm_do_on(tx_8, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Third started : ",get_type_name()},UVM_LOW)
    // single write
    `uvm_do_on(tx_7, p_sequencer.tx_seqr);

    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // write half to mem
    #5
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);

    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(tx_6, p_sequencer.tx_seqr);
    
    `uvm_info(get_full_name(),{"Fifth started : ",get_type_name()},UVM_LOW)
    // single read
      `uvm_do_on(tx_5, p_sequencer.tx_seqr);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
endclass

// write full memsize
