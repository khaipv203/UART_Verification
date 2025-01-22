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
  tx8_stop2_np tx_8_2;
  tx8_stop1_odd tx_8_odd_1;
  tx8_stop2_odd tx_8_odd_2;
  tx8_stop2_even tx_8_even_2;

  // constructor
  function new(input string name="POST_TEST_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_MEDIUM)
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_MEDIUM)
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"First started ",get_type_name()},UVM_MEDIUM)
    `uvm_do_on(tx_8, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Second started : ",get_type_name()},UVM_MEDIUM)
    `uvm_do_on(tx_7, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Third started : ",get_type_name()},UVM_MEDIUM)
    `uvm_do_on(tx_6, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_MEDIUM)
    `uvm_do_on(tx_5, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Fifth started : ",get_type_name()},UVM_MEDIUM)
    `uvm_do_on(tx_8_2, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"6th started : ",get_type_name()},UVM_MEDIUM)
    `uvm_do_on(tx_8_odd_1, p_sequencer.tx_seqr);  
    `uvm_info(get_full_name(),{"7th started : ",get_type_name()},UVM_MEDIUM)   
    `uvm_do_on(tx_8_odd_2, p_sequencer.tx_seqr);   
    `uvm_info(get_full_name(),{"8th started : ",get_type_name()},UVM_MEDIUM) 
    `uvm_do_on(tx_8_even_2, p_sequencer.tx_seqr);  
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_MEDIUM)
  endtask
endclass


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
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_MEDIUM)
    // write half to mem
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_MEDIUM)
    //do nothing
    `uvm_do_on(tx_8, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Third started : ",get_type_name()},UVM_MEDIUM)
    // single write
    `uvm_do_on(tx_7, p_sequencer.tx_seqr);

    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_MEDIUM)
    // write half to mem
    #5
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);

    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_MEDIUM)
    // do nothing
    `uvm_do_on(tx_6, p_sequencer.tx_seqr);
    
    `uvm_info(get_full_name(),{"Fifth started : ",get_type_name()},UVM_MEDIUM)
    // single read
      `uvm_do_on(tx_5, p_sequencer.tx_seqr);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_MEDIUM)
  endtask
endclass

class simplex_rx extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(simplex_rx)

  // set handle for sequence called in this sequence
  reset_seq rst_n_seq;
  rx8_stop1_np rx_8;
  rx7_stop1_np rx_7;
  rx6_stop1_np rx_6;
  rx5_stop1_np rx_5;

  // constructor
  function new(input string name="POST_TEST_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_MEDIUM)
    // write half to mem
    `uvm_do_on(rst_n_seq, p_sequencer.rx_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_MEDIUM)
    //do nothing
    `uvm_do_on(rx_8, p_sequencer.rx_seqr);
    `uvm_info(get_full_name(),{"Third started : ",get_type_name()},UVM_MEDIUM)
    // single write
    `uvm_do_on(rx_7, p_sequencer.rx_seqr);

    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_MEDIUM)
    // do nothing
    `uvm_do_on(rx_6, p_sequencer.rx_seqr);
    
    `uvm_info(get_full_name(),{"Fifth started : ",get_type_name()},UVM_MEDIUM)
    // single read
    `uvm_do_on(rx_5, p_sequencer.rx_seqr);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_MEDIUM)
  endtask
endclass

// class random_tx_seq extends uart_virtual_seq;
//     `uvm_object_utils(random_tx_seq)

//   // declare handle for sequence used in this high level sequence
//   reset_seq rst_n_seq;
//   tx5_rand tx5_r;
//   tx6_rand tx6_r;
//   tx7_rand tx7_r;
//   tx8_rand tx8_r;
//   tx_rand_np tx_np;
//   tx_rand_odd tx_odd;
//   tx_rand_even tx_even;
//   tx_rand_stop1 tx_stop_1;
//   tx_rand_stop2 tx_stop_2;

//   function new(input string name="RESET_TEST_SEQUENCE");
//     super.new(name);
//   endfunction

//   // Execute the sequences one after another
//     virtual task body();
//     `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_MEDIUM)
//     // write half to mem
//     `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
//     repeat(50) begin
//     `uvm_info(get_full_name(),{"Tx5_r seq ",get_type_name()},UVM_MEDIUM)
//     `uvm_do_on(tx5_r, p_sequencer.tx_seqr);
//     `uvm_info(get_full_name(),{"Tx6_r started : ",get_type_name()},UVM_MEDIUM)
//     `uvm_do_on(tx6_r, p_sequencer.tx_seqr);

//     `uvm_info(get_full_name(),{"Tx7_r started : ",get_type_name()},UVM_MEDIUM)
//     `uvm_do_on(tx7_r, p_sequencer.tx_seqr);

//     `uvm_info(get_full_name(),{"tx8_r seq ",get_type_name()},UVM_MEDIUM)
//     // do nothing
//     `uvm_do_on(tx8_r, p_sequencer.tx_seqr);
    
//     `uvm_info(get_full_name(),{"tx_odd started : ",get_type_name()},UVM_MEDIUM)
//     // single read
//     `uvm_do_on(tx_odd, p_sequencer.tx_seqr);
//       `uvm_info(get_full_name(),{"tx_even started : ",get_type_name()},UVM_MEDIUM)
//     // single read
//     `uvm_do_on(tx_even, p_sequencer.tx_seqr);
//       `uvm_info(get_full_name(),{"tx_stop_1 started : ",get_type_name()},UVM_MEDIUM)
//     // single read
//       `uvm_do_on(tx_stop_1, p_sequencer.tx_seqr);
//       `uvm_info(get_full_name(),{"tx_stop_2 started : ",get_type_name()},UVM_MEDIUM)
//     // single read
//       `uvm_do_on(tx_stop_2, p_sequencer.tx_seqr);

//     end
   
    
//     #30ns;  // Wait for sequence ended
//     `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_MEDIUM)
//   endtask
// endclass

class random_rx_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(random_rx_seq)

  // set handle for sequence called in this sequence
  reset_seq rst_n_seq;

  // rx sequences
  rx8_stop1_np rx_8_s1_np;
  rx8_stop1_odd rx_8_s1_o;
  rx8_stop1_even rx_8_s1_e;
  rx8_stop2_np rx_8_s2_np;
  rx8_stop2_odd rx_8_s2_o;
  rx8_stop2_even rx_8_s2_e;
  rx7_stop1_np rx_7_s1_np;
  rx7_stop1_odd rx_7_s1_o;
  rx7_stop1_even rx_7_s1_e;
  rx7_stop2_np rx_7_s2_np;
  rx7_stop2_odd rx_7_s2_o;
  rx7_stop2_even rx_7_s2_e;
  rx6_stop1_np rx_6_s1_np;
  rx6_stop1_odd rx_6_s1_o;
  rx6_stop1_even rx_6_s1_e;
  rx6_stop2_np rx_6_s2_np;
  rx6_stop2_odd rx_6_s2_o;
  rx6_stop2_even rx_6_s2_e;
  rx5_stop1_np rx_5_s1_np;
  rx5_stop1_odd rx_5_s1_o;
  rx5_stop1_even rx_5_s1_e;
  rx5_stop2_np rx_5_s2_np;
  rx5_stop2_odd rx_5_s2_o;
  rx5_stop2_even rx_5_s2_e;

  function new(input string name="RESET_TEST_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences randomly
  virtual task body(); 
    // First reset
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_MEDIUM)
    `uvm_do_on(rst_n_seq, p_sequencer.rx_seqr);
    // Then drive randomly
    repeat (100) begin
      randcase
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx8_stop1_np started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_8_s1_np, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx8_stop1_odd started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_8_s1_o, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx8_stop1_even started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_8_s1_e, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx8_stop2_np started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_8_s2_np, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx8_stop2_odd started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_8_s2_o, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx8_stop2_even started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_8_s2_e, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx7_stop1_np started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_7_s1_np, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx7_stop1_odd started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_7_s1_o, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx7_stop1_even started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_7_s1_e, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx7_stop2_np started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_7_s2_np, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx7_stop2_odd started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_7_s2_o, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx7_stop2_even started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_7_s2_e, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx6_stop1_np started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_6_s1_np, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx6_stop1_odd started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_6_s1_o, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx6_stop1_even started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_6_s1_e, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx6_stop2_np started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_6_s2_np, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx6_stop2_odd started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_6_s2_o, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx6_stop2_even started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_6_s2_e, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx5_stop1_np started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_5_s1_np, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx5_stop1_odd started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_5_s1_o, p_sequencer.rx_seqr);
        end
        1: begin
          `uvm_info(get_full_name(),{"Sequence rx5_stop1_even started : ",get_type_name()},UVM_MEDIUM)
          `uvm_do_on(rx_5_s1_e, p_sequencer.rx_seqr);
        end
      endcase
    end
  endtask
endclass
    
