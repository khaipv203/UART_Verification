`include "uvm_macros.svh"
import uvm_pkg::*;
class base_test extends uvm_test;
  
  // register with factory
  `uvm_component_utils(base_test)

  // create handle for virtual base interface
  virtual uart_if vif;
  
  // create handle for base environment
  base_env uart_env;           

  // declare handle for uvm factory
  uvm_factory my_factory;
  // declare handle for uvm objection
  uvm_objection base_test_objection; 

  // constructor
  function new(input string name="BASE_TEST", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // instance environment in build phase
  virtual function void build_phase(uvm_phase phase);
    // set config
    uvm_config_int::set( this, "*", "recording_detail", 1);
    super.build_phase(phase);
    // instance environment
    uart_env = base_env::type_id::create("uart_env",this);
  endfunction

  // print topology of uvm and retrieve handle to uvm factory
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Starting End of Elaboration phase for ",get_type_name()}, UVM_LOW)
    uvm_top.print_topology();
    // Retrieve a handle to the global factory instance, which is then used to print factory contents
    // This is a common practice to verify the registered components and the factory's configuration
    my_factory = uvm_factory::get();
    // print all types registered with factory
    my_factory.print();
  endfunction

  virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Start of simulation phase for ",get_type_name()}, UVM_LOW)
  endfunction

  // check config inside check phase
  virtual function void check_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"We are in Check Phase",UVM_LOW);
    `uvm_info(get_type_name(),"Check Config Usage:",UVM_LOW);
    check_config_usage();
  endfunction

  virtual task run_phase(uvm_phase phase);
     base_test_objection = phase.get_objection();
     base_test_objection.set_drain_time(this, 3000);
  endtask
    
endclass : base_test

//Normal full Test
class reset_test extends base_test;
  
  // register with factory
  `uvm_component_utils(reset_test)
    
  // declare handle for sequence used in test
  reset_n_seq rstn_seq;
  uvm_objection reset_test_objection;
    
  // constructor
  function new(input string name="reset_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction
    
  // set base sequence is overriden by high level sequence
  function void build_phase(uvm_phase phase);
    set_type_override_by_type(uart_base_seq::get_type(), reset_n_seq::get_type());
    super.build_phase(phase);
  endfunction

  // run sequence test
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Starting Run phase for ",get_type_name()}, UVM_LOW)
    // instance sequence
    rstn_seq = reset_n_seq::type_id::create("rstn_seq");
    if(phase != null) begin
      // raise objection
      phase.raise_objection(this, {"Sequence started : ",get_name()});
      // start sequence
      rstn_seq.start(uart_env.uart_vseqr);
      #10ns;	// delay one more clock edge to make sure sequence ended
      // drop objection
      phase.drop_objection(this, {"Sequence ended : ",get_name()});
      reset_test_objection = phase.get_objection();
      //reset_test_objection.set_drain_time(this, 800);
    end
  endtask

endclass : reset_test

class simplex_tx_test extends base_test;
  
  // register with factory
  `uvm_component_utils(simplex_tx_test)

  // declare handle for sequence used in test
  simplex_tx splx_tx_test;
  uvm_objection splx_tx_test_objection;

  // constructor
  function new(input string name="splx_tx_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // set base sequence is overriden by high level sequence
  function void build_phase(uvm_phase phase);
    set_type_override_by_type(uart_base_seq::get_type(), simplex_tx::get_type());
    super.build_phase(phase);
  endfunction

  // run sequence test
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Starting Run phase for ",get_type_name()}, UVM_LOW)
    // instance sequence
    splx_tx_test = simplex_tx::type_id::create("splx_tx_test");
    if(phase != null) begin
      // raise objection
      phase.raise_objection(this, {"Sequence started : ",get_name()});
      // start sequence
      splx_tx_test.start(uart_env.uart_vseqr);
      #10ns;	// delay one more clock edge to make sure sequence ended
      // drob objection
      phase.drop_objection(this, {"Sequence ended : ",get_name()} );
      splx_tx_test_objection = phase.get_objection();
      //full_test_objection.set_drain_time(this, 800);
    end
  endtask

endclass

class simplex_rx_test extends base_test;
  
  // register with factory
  `uvm_component_utils(simplex_rx_test)

  // declare handle for sequence used in test
  simplex_rx splx_rx_test;
  uvm_objection splx_rx_test_objection;

  // constructor
  function new(input string name="splx_rx_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // set base sequence is overriden by high level sequence
  function void build_phase(uvm_phase phase);
    set_type_override_by_type(uart_base_seq::get_type(), simplex_rx::get_type());
    super.build_phase(phase);
  endfunction 

  // run sequence test
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Starting Run phase for ",get_type_name()}, UVM_LOW)
    // instance sequence
    splx_rx_test = simplex_rx::type_id::create("splx_rx_test");
    if(phase != null) begin
      // raise objection
      phase.raise_objection(this, {"Sequence started : ",get_name()});
      // start sequence
      splx_rx_test.start(uart_env.uart_vseqr);
      #10ns;	// delay one more clock edge to make sure sequence ended
      // drop objection
      phase.drop_objection(this, {"Sequence ended : ",get_name()});
      splx_rx_test_objection = phase.get_objection();
      //full_test_objection.set_drain_time(this, 800);
    end
  endtask

endclass

class random_test extends base_test;
  
  // register with factory
  `uvm_component_utils(random_test)

  // declare handle for sequence used in test
  random_tx_seq random_seq_test;
  uvm_objection random_seq_test_objection;

  // constructor
  function new(input string name="random_seq_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // set base sequence is overriden by high level sequence
  function void build_phase(uvm_phase phase);
    set_type_override_by_type(uart_base_seq::get_type(), random_tx_seq::get_type());
    super.build_phase(phase);
  endfunction

  // run sequence test
  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(),{"Starting Run phase for ",get_type_name()}, UVM_LOW)
    // instance sequence
    random_seq_test = random_tx_seq::type_id::create("random_seq_test");
    if(phase != null) begin
      // raise objection
      phase.raise_objection(this, {"Sequence started : ",get_name()});
      // start sequence
      random_seq_test.start(uart_env.uart_vseqr);
      #10ns;	// delay one more clock edge to make sure sequence ended
      // drob objection
      phase.drop_objection(this, {"Sequence ended : ",get_name()} );
      random_seq_test_objection = phase.get_objection();
      //full_test_objection.set_drain_time(this, 800);
    end
  endtask

endclass