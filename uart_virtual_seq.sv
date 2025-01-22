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
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"First started ",get_type_name()},UVM_LOW)
    `uvm_do_on(tx_8, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Second started : ",get_type_name()},UVM_LOW)
    `uvm_do_on(tx_7, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Third started : ",get_type_name()},UVM_LOW)
    `uvm_do_on(tx_6, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    `uvm_do_on(tx_5, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Fifth started : ",get_type_name()},UVM_LOW)
    `uvm_do_on(tx_8_2, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"6th started : ",get_type_name()},UVM_LOW)
    `uvm_do_on(tx_8_odd_1, p_sequencer.tx_seqr);  
    `uvm_info(get_full_name(),{"7th started : ",get_type_name()},UVM_LOW)   
    `uvm_do_on(tx_8_odd_2, p_sequencer.tx_seqr);   
    `uvm_info(get_full_name(),{"8th started : ",get_type_name()},UVM_LOW) 
    `uvm_do_on(tx_8_even_2, p_sequencer.tx_seqr);  
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
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
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write half to mem
    `uvm_do_on(rst_n_seq, p_sequencer.rx_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    //do nothing
    `uvm_do_on(rx_8, p_sequencer.rx_seqr);
    `uvm_info(get_full_name(),{"Third started : ",get_type_name()},UVM_LOW)
    // single write
    `uvm_do_on(rx_7, p_sequencer.rx_seqr);

    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(rx_6, p_sequencer.rx_seqr);
    
    `uvm_info(get_full_name(),{"Fifth started : ",get_type_name()},UVM_LOW)
    // single read
    `uvm_do_on(rx_5, p_sequencer.rx_seqr);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
endclass

class random_tx_seq extends uart_virtual_seq;
    `uvm_object_utils(random_tx_seq)

  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  tx5_rand tx5_r;
  tx6_rand tx6_r;
  tx7_rand tx7_r;
  tx8_rand tx8_r;
  tx_rand_np tx_np;
  tx_rand_odd tx_odd;
  tx_rand_even tx_even;
  tx_rand_stop1 tx_stop_1;
  tx_rand_stop2 tx_stop_2;

  function new(input string name="RESET_TEST_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
    virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // write half to mem
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
    repeat(50) begin
    `uvm_info(get_full_name(),{"Tx5_r seq ",get_type_name()},UVM_LOW)
    `uvm_do_on(tx5_r, p_sequencer.tx_seqr);
    `uvm_info(get_full_name(),{"Tx6_r started : ",get_type_name()},UVM_LOW)
    `uvm_do_on(tx6_r, p_sequencer.tx_seqr);

    `uvm_info(get_full_name(),{"Tx7_r started : ",get_type_name()},UVM_LOW)
    `uvm_do_on(tx7_r, p_sequencer.tx_seqr);

    `uvm_info(get_full_name(),{"tx8_r seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(tx8_r, p_sequencer.tx_seqr);
    
    `uvm_info(get_full_name(),{"tx_odd started : ",get_type_name()},UVM_LOW)
    // single read
    `uvm_do_on(tx_odd, p_sequencer.tx_seqr);
      `uvm_info(get_full_name(),{"tx_even started : ",get_type_name()},UVM_LOW)
    // single read
    `uvm_do_on(tx_even, p_sequencer.tx_seqr);
      `uvm_info(get_full_name(),{"tx_stop_1 started : ",get_type_name()},UVM_LOW)
    // single read
      `uvm_do_on(tx_stop_1, p_sequencer.tx_seqr);
      `uvm_info(get_full_name(),{"tx_stop_2 started : ",get_type_name()},UVM_LOW)
    // single read
      `uvm_do_on(tx_stop_2, p_sequencer.tx_seqr);

    end
   
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
endclass

class tx_5bit_seq extends uart_virtual_seq;
    `uvm_object_utils(tx_5bit_seq)

  // declare handle for sequence used in this high level sequence
  // reset_seq rst_n_seq;
  tx5_stop1_np tx5_1;
  tx5_stop1_odd tx5_2;
  tx5_stop1_even tx5_3;
  tx5_stop2_np tx5_4;
  tx5_stop2_odd tx5_5;
  tx5_stop2_even tx5_6;

  function new(input string name="TX_5BIT_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
    virtual task body();
    // `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr); 
    repeat(50) begin
    int rand_seed = $urandom_range(0, 5);
    case (rand_seed)
      0: begin
        `uvm_do_on(tx5_1, p_sequencer.tx_seqr);
      end
      1:  begin
        `uvm_do_on(tx5_2, p_sequencer.tx_seqr);
      end
      2:  begin
        `uvm_do_on(tx5_3, p_sequencer.tx_seqr);
      end
      3: begin  
      `uvm_do_on(tx5_4, p_sequencer.tx_seqr);
      end
      4: begin  
      `uvm_do_on(tx5_5, p_sequencer.tx_seqr);
      end
      5:  begin
        `uvm_do_on(tx5_6, p_sequencer.tx_seqr);
      end
    endcase
    end
  endtask
endclass

class tx_6bit_seq extends uart_virtual_seq;
    `uvm_object_utils(tx_6bit_seq)

  // declare handle for sequence used in this high level sequence
  // reset_seq rst_n_seq;
  tx6_stop1_np tx6_1;
  tx6_stop1_odd tx6_2;
  tx6_stop1_even tx6_3;
  tx6_stop2_np tx6_4;
  tx6_stop2_odd tx6_5;
  tx6_stop2_even tx6_6;

  function new(input string name="TX_6BIT_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
    virtual task body();
    // `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
    int rand_seed;  
    repeat(50) begin
    rand_seed = $urandom_range(0, 5);
    case (rand_seed)
      0: begin
        `uvm_do_on(tx6_1, p_sequencer.tx_seqr);
      end
      1:  begin
        `uvm_do_on(tx6_2, p_sequencer.tx_seqr);
      end
      2:  begin
        `uvm_do_on(tx6_3, p_sequencer.tx_seqr);
      end
      3: begin  
      `uvm_do_on(tx6_4, p_sequencer.tx_seqr);
      end
      4: begin  
      `uvm_do_on(tx6_5, p_sequencer.tx_seqr);
      end
      5:  begin
        `uvm_do_on(tx6_6, p_sequencer.tx_seqr);
      end
    endcase
    end
  endtask
endclass

class tx_7bit_seq extends uart_virtual_seq;
    `uvm_object_utils(tx_7bit_seq)

  // declare handle for sequence used in this high level sequence
  // reset_seq rst_n_seq;
  tx7_stop1_np tx7_1;
  tx7_stop1_odd tx7_2;
  tx7_stop1_even tx7_3;
  tx7_stop2_np tx7_4;
  tx7_stop2_odd tx7_5;
  tx7_stop2_even tx7_6;

  function new(input string name="TX_7BIT_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
    virtual task body();
    // `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
    int rand_seed;  
    repeat(50) begin
    rand_seed = $urandom_range(0, 5);
    case (rand_seed)
      0: begin
        `uvm_do_on(tx7_1, p_sequencer.tx_seqr);
      end
      1:  begin
        `uvm_do_on(tx7_2, p_sequencer.tx_seqr);
      end
      2:  begin
        `uvm_do_on(tx7_3, p_sequencer.tx_seqr);
      end
      3: begin  
      `uvm_do_on(tx7_4, p_sequencer.tx_seqr);
      end
      4: begin  
      `uvm_do_on(tx7_5, p_sequencer.tx_seqr);
      end
      5:  begin
        `uvm_do_on(tx7_6, p_sequencer.tx_seqr);
      end
    endcase
    end
  endtask
endclass

class tx_8bit_seq extends uart_virtual_seq;
    `uvm_object_utils(tx_8bit_seq)

  // declare handle for sequence used in this high level sequence
  // reset_seq rst_n_seq;
  tx8_stop1_np tx8_1;
  tx8_stop1_odd tx8_2;
  tx8_stop1_even tx8_3;
  tx8_stop2_np tx8_4;
  tx8_stop2_odd tx8_5;
  tx8_stop2_even tx8_6;

  function new(input string name="TX_8BIT_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
    virtual task body();
    // `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
    int rand_seed;  
    repeat(50) begin
    rand_seed = $urandom_range(0, 5);
    case (rand_seed)
      0: begin
        `uvm_do_on(tx8_1, p_sequencer.tx_seqr);
      end
      1:  begin
        `uvm_do_on(tx8_2, p_sequencer.tx_seqr);
      end
      2:  begin
        `uvm_do_on(tx8_3, p_sequencer.tx_seqr);
      end
      3: begin  
      `uvm_do_on(tx8_4, p_sequencer.tx_seqr);
      end
      4: begin  
      `uvm_do_on(tx8_5, p_sequencer.tx_seqr);
      end
      5:  begin
        `uvm_do_on(tx8_6, p_sequencer.tx_seqr);
      end
    endcase
    end
  endtask
endclass

class tx_8bit_run_seq extends uart_virtual_seq;
    `uvm_object_utils(tx_8bit_run_seq)
    
    reset_seq rst_n_seq;
    tx_8bit_seq tx_8_seq;

  function new(input string name="TX_8BIT_SEQUENCE");
    super.new(name);
  endfunction

  virtual task body();
    // `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
    // `uvm_info(get_full_name(),{"TX 8 BIT started : ",get_type_name()},UVM_LOW)
    repeat(10) begin
    `uvm_do(tx_8_seq);
    end
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
endclass

class tx_7bit_run_seq extends uart_virtual_seq;
    `uvm_object_utils(tx_7bit_run_seq)
    
    reset_seq rst_n_seq;
    tx_7bit_seq tx_7_seq;

  function new(input string name="TX_7BIT_SEQUENCE");
    super.new(name);
  endfunction

  virtual task body();
    // `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
    // `uvm_info(get_full_name(),{"TX 7 BIT started : ",get_type_name()},UVM_LOW)
    repeat(10) begin
    `uvm_do(tx_7_seq);
    end
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
endclass

class tx_6bit_run_seq extends uart_virtual_seq;
    `uvm_object_utils(tx_6bit_run_seq)
    
    reset_seq rst_n_seq;
    tx_6bit_seq tx_6_seq;

  function new(input string name="TX_6BIT_SEQUENCE");
    super.new(name);
  endfunction

  virtual task body();
    // `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
    // `uvm_info(get_full_name(),{"TX 6 BIT started : ",get_type_name()},UVM_LOW)
    repeat(10) begin
    `uvm_do(tx_6_seq);
    end
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
endclass

class tx_5bit_run_seq extends uart_virtual_seq;
    `uvm_object_utils(tx_5bit_run_seq)
    
    reset_seq rst_n_seq;
    tx_5bit_seq tx_5_seq;

  function new(input string name="TX_5BIT_SEQUENCE");
    super.new(name);
  endfunction

  virtual task body();
    // `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
    // `uvm_info(get_full_name(),{"TX 5 BIT started : ",get_type_name()},UVM_LOW)
    repeat(10) begin
    `uvm_do(tx_5_seq);
    end
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
endclass

class stress_tx_seq extends uart_virtual_seq;
    `uvm_object_utils(stress_tx_seq)
    
    reset_seq rst_n_seq;
    tx_5bit_seq tx_5_seq;
    tx_6bit_seq tx_6_seq;
    tx_7bit_seq tx_7_seq;
    tx_8bit_seq tx_8_seq;

  function new(input string name="STRESS TX");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_on(rst_n_seq, p_sequencer.tx_seqr);
    // `uvm_info(get_full_name(),{"TX 5 BIT started : ",get_type_name()},UVM_LOW)
    `uvm_do(tx_5_seq);

    // `uvm_info(get_full_name(),{"TX 6 BIT started : ",get_type_name()},UVM_LOW)
    `uvm_do(tx_6_seq);  

    // `uvm_info(get_full_name(),{"TX 7 BIT started : ",get_type_name()},UVM_LOW)
    `uvm_do(tx_7_seq);

    // `uvm_info(get_full_name(),{"TX 8 BIT started : ",get_type_name()},UVM_LOW)
    `uvm_do(tx_8_seq);
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
endclass

