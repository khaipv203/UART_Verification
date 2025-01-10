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
    
endclass : uart_virtual_seq


// Sequence check fifo after test to make sure fifo still work correctly
class post_test_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(post_test_seq)

  // set handle for sequence called in this sequence
  half_write_seq h_write_seq;
  half_read_seq h_read_seq;
  no_read_write_seq no_rw_seq;
  single_write_seq s_write_seq;
  single_read_seq s_read_seq;

  // constructor
  function new(input string name="POST_TEST_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write half to mem
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    //do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sec started : ",get_type_name()},UVM_LOW)
    // read half from mem
    `uvm_do_on(h_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Third started : ",get_type_name()},UVM_LOW)
    // single write
    `uvm_do_on(s_write_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Fifth started : ",get_type_name()},UVM_LOW)
    // single read
    `uvm_do_on(s_read_seq, p_sequencer.base_seqr1);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
endclass : post_test_seq

// Sequence check fifo reset
class reset_n_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(reset_n_seq)

  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  consecutive_read_seq c_read_seq;
  consecutive_write_seq c_write_seq;
  half_write_seq h_write_seq;
  half_read_seq h_read_seq;
  no_read_write_seq no_rw_seq;
  single_write_seq s_write_seq;
  single_read_seq s_read_seq;
  post_test_seq post_seq;

  // constructor
  function new(input string name="RESET_TEST_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    // write full
    `uvm_do_on(c_write_seq, p_sequencer.base_seqr);
    
    // read half
    `uvm_do_on(h_read_seq, p_sequencer.base_seqr1);
    
    // ***** Be cause reset is asynchronous, so before push reset should push sequence do nothing to delay so the sequence right before it can be executed and not overwrite *****//
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);
    
    // reset -> EMPTY
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);
    
    // read half
    `uvm_do_on(h_read_seq, p_sequencer.base_seqr1);
    
    // single write
    `uvm_do_on(s_write_seq, p_sequencer.base_seqr);
    
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);
    
    // reset -> EMPTY
    // ***** Be cause reset is asynchronous, so must add delay to control when to trigger reset *****//
    #5 // wait to trigger reset at middle of clock level
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);
    
    // single read
    `uvm_do_on(s_read_seq, p_sequencer.base_seqr1);
    
    // read full -> FULL
    `uvm_do_on(c_write_seq, p_sequencer.base_seqr1);
    
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);
    
    // reset -> EMPTY
    #10 // wait to pull reset at rising edge of clock
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);
    
    // single read
    `uvm_do_on(s_read_seq, p_sequencer.base_seqr1);
    
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);
    
    // post sequence check after test
    `uvm_do(post_seq);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
endclass : reset_n_seq

// write full memsize
class fifo_full_seq extends uart_virtual_seq;

  // register with factory
  `uvm_object_utils(fifo_full_seq)

  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  consecutive_write_seq c_write_seq;
  consecutive_read_seq c_read_seq;
  single_write_seq s_write_seq;
  no_read_write_seq no_rw_seq;
  post_test_seq post_seq;

  // constructor
  function new(input string name="FIFO_FULL_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write full -> FULL
    `uvm_do_on(c_write_seq, p_sequencer.base_seqr);
    
    // write single -> not accept
    `uvm_do_on(s_write_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"Sec seq ",get_type_name()},UVM_LOW)
    // read full -> CHECK FIFO OUTPUT
    `uvm_do_on(c_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Third seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence check after test
    `uvm_do(post_seq);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_full_seq

// write full memsize after some tasks
class fifo_full_corner_seq extends uart_virtual_seq;

  // register with factory
  `uvm_object_utils(fifo_full_corner_seq)

  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  half_write_seq h_write_seq;
  half_read_seq h_read_seq;
  no_read_write_seq no_rw_seq;
  single_read_write_simul rw_simul_seq;
  consecutive_read_seq c_read_seq;
  post_test_seq post_seq;
  single_write_seq s_write_seq;
  single_read_seq s_read_seq;

  // constructor
  function new(input string name="FIFO_FULL_CORNER_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    //reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write half
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"Sec seq ",get_type_name()},UVM_LOW)
    // read - write same time x5
    repeat(5) begin
      `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    end
    
    `uvm_info(get_full_name(),{"Third started : ",get_type_name()},UVM_LOW)
    // write half -> FULL
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);
    // write single -> not accept write
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Fourth started : ",get_type_name()},UVM_LOW)
    // read full -> CHECK FIFO OUTPUT
    `uvm_do_on(s_write_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence to check
    `uvm_do(post_seq);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_full_corner_seq

// write full and then continue write, and then read write at the same time
class fifo_overflow_seq extends uart_virtual_seq;

  // register with factory
  `uvm_object_utils(fifo_overflow_seq)

  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  consecutive_write_seq c_write_seq;
  half_write_seq h_write_seq;
  single_read_write_simul rw_simul_seq;
  no_read_write_seq no_rw_seq;
  single_write_seq s_write_seq;
  single_read_seq s_read_seq;
  post_test_seq post_seq;

  // constructor
  function new(input string name="FIFO_OVERFLOW_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write full
    `uvm_do_on(c_write_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"Sec seq ",get_type_name()},UVM_LOW)
    // write half -> OVERFLOW
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Third seq ",get_type_name()},UVM_LOW)
    // read - write same time -> FIFO ONLY READ
    `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    // read (memsize - 1) times
    repeat(MEM_SIZE-1) begin
      `uvm_do_on(s_read_seq, p_sequencer.base_seqr1);
    end
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence check after all sequence
    `uvm_do(post_seq);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_overflow_seq

// perfome some tasks before overflow, and then read write at the same time
class fifo_overflow_corner_seq extends uart_virtual_seq;

  // register with factory
  `uvm_object_utils(fifo_overflow_corner_seq)
  
  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  half_write_seq h_write_seq;
  single_read_write_simul rw_simul_seq;
  no_read_write_seq no_rw_seq;
  consecutive_write_seq c_write_seq;
  consecutive_read_seq c_read_seq;
  single_write_seq s_write_seq;
  single_read_seq s_read_seq;
  post_test_seq post_seq;

  // constructor
  function new(input string name="FIFO_OVERFLOW_CORNER_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    //reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write full -> FULL
    `uvm_do_on(c_write_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // read - write same time x1 -> ONLY READ
    `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Sec seq ",get_type_name()},UVM_LOW)
    // write half -> OVERFLOW
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Third seq ",get_type_name()},UVM_LOW)
    // read - write same time x1 -> ONLY READ
    `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    // read (memsize - 1) times
    repeat(MEM_SIZE-1) begin
      `uvm_do_on(s_read_seq, p_sequencer.base_seqr1);
    end
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence to check
    `uvm_do(post_seq);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_overflow_corner_seq

// read after write to check empty
class fifo_empty_seq extends uart_virtual_seq;

  // register with factory
  `uvm_object_utils(fifo_empty_seq)

  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  consecutive_write_seq c_write_seq;
  consecutive_read_seq c_read_seq;
  half_write_seq h_write_seq;
  half_read_seq h_read_seq;
  single_read_seq s_read_seq;
  no_read_write_seq no_rw_seq;
  post_test_seq post_seq;

  // constructor
  function new(input string name="FIFO_EMPTY_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write full -> FULL
    `uvm_do_on(c_write_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"Sec seq ",get_type_name()},UVM_LOW)
    // read full -> EMPTY
    `uvm_do_on(c_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Third seq ",get_type_name()},UVM_LOW)
    // write half
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    // read half -> EMPTY
    `uvm_do_on(h_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Fifth seq ",get_type_name()},UVM_LOW)
    // read single 
    `uvm_do_on(s_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence to check
    `uvm_do(post_seq);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
   
endclass : fifo_empty_seq

// check empty after some tasks
class fifo_empty_corner_seq extends uart_virtual_seq;

  // register with factory
  `uvm_object_utils(fifo_empty_corner_seq)

  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  half_write_seq h_write_seq;
  half_read_seq h_read_seq;
  no_read_write_seq no_rw_seq;
  single_read_write_simul rw_simul_seq;
  consecutive_read_seq c_read_seq;
  post_test_seq post_seq;

  // constructor
  function new(input string name="FIFO_EMPTY_CORNER_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write half
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // read - write same time x1
    `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);

    `uvm_info(get_full_name(),{"Sec seq ",get_type_name()},UVM_LOW)
    // write half -> FULL
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Third seq ",get_type_name()},UVM_LOW)
    // read full -> EMPTY
    `uvm_do_on(c_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    // write half
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Fifth seq ",get_type_name()},UVM_LOW)
    // read half -> EMPTY
    `uvm_do_on(h_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence to check
    `uvm_do(post_seq);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
   
endclass : fifo_empty_corner_seq

// write and read to make fifo empty, and then continue read
// after that send read write request at the same time
class fifo_underflow_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(fifo_underflow_seq)
  
  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  half_read_seq h_read_seq;
  consecutive_write_seq c_write_seq;
  single_read_seq s_read_seq;
  consecutive_read_seq c_read_seq;
  single_read_write_simul rw_simul_seq;
  no_read_write_seq no_rw_seq;
  post_test_seq post_seq;
  
  // constructor
  function new(input string name="FIFO_UNDERFLOW_SEQUENCE");
    super.new(name);
  endfunction
  
  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write full
    `uvm_do_on(c_write_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"First seq : ",get_type_name()},UVM_LOW)
    // read full -> EMPTY
    `uvm_do_on(c_read_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sec seq ",get_type_name()},UVM_LOW)
    // read half -> UNDERFLOW
    `uvm_do_on(h_read_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    // read - write same time x5 
    repeat(5) begin
      `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    end
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence to check
    `uvm_do(post_seq);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_underflow_seq


// TEST undeflow after some tasks
class fifo_underflow_corner_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(fifo_underflow_corner_seq)
  
  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  half_write_seq h_write_seq;
  half_read_seq h_read_seq;
  single_read_seq s_read_seq;
  single_read_write_simul rw_simul_seq;
  no_read_write_seq no_rw_seq;
  consecutive_write_seq c_write_seq;
  consecutive_read_seq c_read_seq;
  post_test_seq post_seq;
  
  // constructor
  function new(input string name="FIFO_UNDERFLOW_SEQUENCE");
    super.new(name);
  endfunction
  
  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write full
    `uvm_do_on(c_write_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // read half
    `uvm_do_on(h_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Sec seq : ",get_type_name()},UVM_LOW)
    // read - write same time x5
    repeat(5) begin
      `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    end
    
    `uvm_info(get_full_name(),{"Third seq ",get_type_name()},UVM_LOW)
    // read full -> OVERFLOW
    `uvm_do_on(c_read_seq, p_sequencer.base_seqr1);

    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    // read - write same time -> ONLY WRITE
    `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Fifth seq ",get_type_name()},UVM_LOW)
    // single read
    `uvm_do_on(s_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Sixth seq ",get_type_name()},UVM_LOW)
    //  read - write same time -> ONLY WRITE
    `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence to check
    `uvm_do(post_seq);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_underflow_corner_seq

// Read after Write Sequence
class write_read_seq extends uart_virtual_seq;

  // register with factory
  `uvm_object_utils(write_read_seq)

  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  consecutive_write_seq c_write_seq;
  consecutive_read_seq c_read_seq;
  no_read_write_seq no_rw_seq;
  single_read_write_simul rw_simul_seq;
  post_test_seq post_seq;

  // constructor
  function new(input string name="WRITE_READ_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write full -> FULL
    `uvm_do_on(c_write_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // read - write same time
    `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);

    `uvm_info(get_full_name(),{"Sec seq ",get_type_name()},UVM_LOW)
    // read full -> EMPTY
    `uvm_do_on(c_read_seq, p_sequencer.base_seqr1);

    `uvm_info(get_full_name(),{"Third seq ",get_type_name()},UVM_LOW)
    // read - write same time
    `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence to check
    `uvm_do(post_seq);
    
    #30ns; // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask

endclass : write_read_seq

// Read and Write mix Sequence
class write_read_corner_seq extends uart_virtual_seq;

  // register with factory
  `uvm_object_utils(write_read_corner_seq)

  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;
  consecutive_write_seq c_write_seq;
  consecutive_read_seq c_read_seq;
  half_write_seq h_write_seq;
  half_read_seq h_read_seq;
  single_write_seq s_write_seq;
  single_read_seq s_read_seq;
  no_read_write_seq no_rw_seq;
  single_read_write_simul rw_simul_seq;
  post_test_seq post_seq;

  // constructor
  function new(input string name="WRITE_READ_CORNER_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write full -> FULL
    `uvm_do_on(c_write_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // read - write same time 
    repeat(5) `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);

    `uvm_info(get_full_name(),{"Sec seq ",get_type_name()},UVM_LOW)
    // read single
    `uvm_do_on(s_read_seq, p_sequencer.base_seqr1);

    `uvm_info(get_full_name(),{"Third seq ",get_type_name()},UVM_LOW)
    // read half
    `uvm_do_on(h_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Fourth seq ",get_type_name()},UVM_LOW)
    // read - write same time
    repeat(5) `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Fifth seq ",get_type_name()},UVM_LOW)
    // single write
    `uvm_do_on(s_write_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sixth seq ",get_type_name()},UVM_LOW)
    // read half -> EMPTY
    `uvm_do_on(h_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence to check
    `uvm_do(post_seq);
    
    #30ns; // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask

endclass : write_read_corner_seq

// Read and write alternatly Sequence
class write_read_alternating_seq extends uart_virtual_seq;

  // register with factory
  `uvm_object_utils(write_read_alternating_seq)

  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq;  
  half_write_seq h_write_seq;
  half_read_seq h_read_seq;
  single_write_seq s_write_seq;
  single_read_seq s_read_seq;
  no_read_write_seq no_rw_seq;
  post_test_seq post_seq;

  // constructor
  function new(input string name="WRITE_READ_ALTERNATING_SEQUENCE");
    super.new(name);
  endfunction

  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write half
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // read - write same time 
    repeat(2*MEM_SIZE) begin
      `uvm_do_on(s_write_seq, p_sequencer.base_seqr);
      `uvm_do_on(s_read_seq, p_sequencer.base_seqr1);
    end
    
    `uvm_info(get_full_name(),{"Sixth seq ",get_type_name()},UVM_LOW)
    // read half -> EMPTY
    `uvm_do_on(h_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence to check 
    `uvm_do(post_seq);
    
    #30ns; // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask

endclass : write_read_alternating_seq

// read and write at the same time when fifo not empty and full
class fifo_rw_simul_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(fifo_rw_simul_seq)
 
  // declare handle for sequence used in this high level sequence
  reset_seq rst_n_seq; 
  half_write_seq h_write_seq;
  half_read_seq h_read_seq;
  single_read_write_simul rw_simul_seq;
  no_read_write_seq no_rw_seq;
  post_test_seq post_seq;
  
  // constructor
  function new(input string name="FIFO_READ_WRITE_SIMULTANEOUSLY_SEQUENCE");
    super.new(name);
  endfunction
  
  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Reset started : ",get_type_name()},UVM_LOW)
    // reset
    `uvm_do_on(rst_n_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // write half
    `uvm_do_on(h_write_seq, p_sequencer.base_seqr);
    
    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"Sec seq ",get_type_name()},UVM_LOW)
    // read - write same time x8
    repeat(8) begin
      `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    end
    
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // read half -> EMPTY
    `uvm_do_on(h_read_seq, p_sequencer.base_seqr1);
    
    `uvm_info(get_full_name(),{"First seq ",get_type_name()},UVM_LOW)
    // do nothing
    `uvm_do_on(no_rw_seq, p_sequencer.base_seqr);

    `uvm_info(get_full_name(),{"Sec seq ",get_type_name()},UVM_LOW)
    // read - write same time
    repeat(8) begin
      `uvm_do_on(rw_simul_seq, p_sequencer.base_seqr1);
    end
    
    `uvm_info(get_full_name(),{"Post seq ",get_type_name()},UVM_LOW)
    // post sequence to check
    `uvm_do(post_seq);
    
    #30ns;  // Wait for sequence ended
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_rw_simul_seq

//--------- MERGE 1 ---------//

// Combine full test sequence 
class fifo_full_combine_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(fifo_full_combine_seq)
  
  // declare handle for sequence used in this high level sequence
  fifo_full_seq full_seq;
  fifo_full_corner_seq full_corner_seq;
  
  // constructor
  function new(input string name="FIFO_FULL_COMBINE_SEQUENCE");
    super.new(name);
  endfunction
  
  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // high level full sequence
    `uvm_do(full_seq);
    // high level full corner sequence
    `uvm_do(full_corner_seq);
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_full_combine_seq

// Combine empty test sequence 
class fifo_underflow_combine_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(fifo_underflow_combine_seq)
  
  // declare handle for sequence used in this high level sequence
  fifo_underflow_seq underflow_seq;
  fifo_underflow_corner_seq underflow_corner_seq;
  
  function new(input string name="FIFO_UNDERFLOW_COMBINE_SEQUENCE");
    super.new(name);
  endfunction
  
  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // high level underflow sequence
    `uvm_do(underflow_seq);
    // high level underflow corner sequence
    `uvm_do(underflow_corner_seq);
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_underflow_combine_seq

// Combine empty test sequence 
class fifo_empty_combine_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(fifo_empty_combine_seq)
  
  // declare handle for sequence used in this high level sequence
  fifo_empty_seq empty_seq;
  fifo_empty_corner_seq empty_corner_seq;
  
  // constructor
  function new(input string name="FIFO_EMPTY_COMBINE_SEQUENCE");
    super.new(name);
  endfunction
  
  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // high level empty sequence
    `uvm_do(empty_seq);
    // high level empty corner sequence
    `uvm_do(empty_corner_seq);
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_empty_combine_seq

// Combine overflow test sequence 
class fifo_overflow_combine_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(fifo_overflow_combine_seq)

  // declare handle for sequence used in this high level sequence
  fifo_overflow_seq overflow_seq;
  fifo_overflow_corner_seq overflow_corner_seq;
  
  function new(input string name="FIFO_OVERFLOW_COMBINE_SEQUENCE");
    super.new(name);
  endfunction
  
  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // high level overflow sequence
    `uvm_do(overflow_seq);
    // high level overflow corner sequence
    `uvm_do(overflow_corner_seq);
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_overflow_combine_seq

// Combine write and read test sequence 
class fifo_wr_rd_combine_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(fifo_wr_rd_combine_seq)
  
  // declare handle for sequence used in this high level sequence
  write_read_seq wr_seq;
  write_read_corner_seq wr_corner_seq;
  
  // constructor
  function new(input string name="FIFO_WRITE_READ_COMBINE_SEQUENCE");
    super.new(name);
  endfunction
  
  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // high level write and write corner sequence
    `uvm_do(wr_seq);
    // write and read corner seq
    `uvm_do(wr_corner_seq);
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_wr_rd_combine_seq

// Combine write and read and other feature test sequence 
class fifo_wr_of_comb_seq extends uart_virtual_seq;
  
  // register with factory
  `uvm_object_utils(fifo_wr_of_comb_seq)
  
  // declare handle for sequence used in this high level sequence
  write_read_seq wr_seq;
  write_read_corner_seq wr_corner_seq;
  write_read_alternating_seq wr_alter_seq;
  fifo_rw_simul_seq rw_simul_seq;
  
  // constructor
  function new(input string name="FIFO_WRITE_READ_OTHER_FEATURE_COMBINE_SEQUENCE");
    super.new(name);
  endfunction
  
  // Execute the sequences one after another
  virtual task body();
    `uvm_info(get_full_name(),{"Sequence started : ",get_type_name()},UVM_LOW)
    // high level read and write sequence
    `uvm_do(wr_seq);
    // read and write corner seq
    `uvm_do(wr_corner_seq);
    // read and write alternatelly seq
    `uvm_do(wr_alter_seq);
    // read and write simultanouslly seq
    `uvm_do(rw_simul_seq);
    `uvm_info(get_full_name(),{"Sequence ended : ",get_type_name()},UVM_LOW)
  endtask
  
endclass : fifo_wr_of_comb_seq

//--------- MERGE 2 ----------