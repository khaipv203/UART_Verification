// `include "uvm_macros.svh"
// import uvm_pkg::*;

class uart_base_seq extends uvm_sequence#(base_seq_item);
    `uvm_object_utils(uart_base_seq)

    function new(input string name="UART_BASE_SEQ");
        super.new(name);
    endfunction
endclass

//Define simple test case

//Reset
class reset_seq extends uart_base_seq;
    `uvm_object_utils(reset_seq)

    base_seq_item seq;
    function new(input string name="RESET_SEQ");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {rst_n == 0;});
        finish_item(seq);
        #20;
    endtask
endclass

//Transmit fixed length = 8, one stop bit and no parity
class tx8_stop1_np extends uart_base_seq;
    `uvm_object_utils(tx8_stop1_np)

    base_seq_item seq;
    function new(input string name="tx8_stop1_np");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
      assert(seq.randomize() with {tx_data == 8'hF; data_bit_num == 2'b11; stop_bit_num == 1'b0; parity_en == 1'b0; cts_n == 1'b0; start_tx == 1'b1;});
        finish_item(seq);
    endtask
endclass

//Transmit fixed length = 7, one stop bit and no parity
class tx7_stop1_np extends uart_base_seq;
    `uvm_object_utils(tx7_stop1_np)

    base_seq_item seq;
    function new(input string name="tx7_stop1_np");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b10; stop_bit_num == 1'b0; parity_en == 1'b0; cts_n == 1'b0; start_tx == 1'b1;});
        finish_item(seq);
    endtask
endclass

//Transmit fixed length = 6, one stop bit and no parity
class tx6_stop1_np extends uart_base_seq;
    `uvm_object_utils(tx6_stop1_np)

    base_seq_item seq;
    function new(input string name="tx6_stop1_np");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b01; stop_bit_num == 1'b0; parity_en == 1'b0; cts_n == 1'b0; start_tx == 1'b1;});
        finish_item(seq);
    endtask
endclass

//Transmit fixed length = 5, one stop bit and no parity
class tx5_stop1_np extends uart_base_seq;
    `uvm_object_utils(tx5_stop1_np)

    base_seq_item seq;
    function new(input string name="tx5_stop1_np");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b00; stop_bit_num == 1'b0; parity_en == 1'b0; cts_n == 1'b0; start_tx == 1'b1;});
        finish_item(seq);
    endtask
endclass

//Transmit fixed length = 8, two stop bit and no parity
class tx8_stop2_np extends uart_base_seq;
    `uvm_object_utils(tx8_stop2_np)

    base_seq_item seq;
    function new(input string name="tx8_stop2_np");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b11; stop_bit_num == 1'b1; parity_en == 1'b0; cts_n == 1'b0; start_tx == 1'b1;});
        finish_item(seq);
    endtask
endclass

//Transmit fixed length = 8, one stop bit and odd parity
class tx8_stop1_odd extends uart_base_seq;
    `uvm_object_utils(tx8_stop1_odd)

    base_seq_item seq;
    function new(input string name="tx8_stop1_odd");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b11; stop_bit_num == 1'b0; parity_en == 1'b1; cts_n == 1'b0; start_tx == 1'b1; parity_type == 1'b0;});
        finish_item(seq);
    endtask
endclass

//Transmit fixed length = 8, one stop bit and even parity
class tx8_stop1_even extends uart_base_seq;
    `uvm_object_utils(tx8_stop1_even)

    base_seq_item seq;
    function new(input string name="RESET_SEQ");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("tx8_stop1_even");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b11; stop_bit_num == 1'b0; parity_en == 1'b1; cts_n == 1'b0; start_tx == 1'b1; parity_type == 1'b1;});
        finish_item(seq);
    endtask
endclass

//Transmit fixed length = 8, two stop bit and odd parity
class tx8_stop2_odd extends uart_base_seq;
    `uvm_object_utils(tx8_stop2_odd)

    base_seq_item seq;
    function new(input string name="tx8_stop2_odd");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b11; stop_bit_num == 1'b1; parity_en == 1'b1; cts_n == 1'b0; start_tx == 1'b1; parity_type == 1'b0;});
        finish_item(seq);
    endtask
endclass

//Transmit fixed length = 8, two stop bit and even parity
class tx8_stop2_even extends uart_base_seq;
    `uvm_object_utils(tx8_stop2_even)

    base_seq_item seq;
    function new(input string name="tx8_stop2_even");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b11; stop_bit_num == 1'b1; parity_en == 1'b1; cts_n == 1'b0; start_tx == 1'b1; parity_type == 1'b1;});
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 8, one stop bit and no parity
class rx8_stop1_np extends uart_base_seq;
    `uvm_object_utils(rx8_stop1_np)

    base_seq_item seq;
    function new(input string name="rx7_stop2_odd");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b10; stop_bit_num == 1'b1; parity_en == 1'b1; parity_type == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 8, one stop bit and odd parity
class rx8_stop1_odd extends uart_base_seq;
    `uvm_object_utils(rx8_stop1_odd)

    base_seq_item seq;
    function new(input string name="rx8_stop1_odd");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b11; stop_bit_num == 1'b0; parity_en == 1'b1; parity_type == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 8, one stop bit and even parity
class rx8_stop1_even extends uart_base_seq;
    `uvm_object_utils(rx8_stop1_even)

    base_seq_item seq;
    function new(input string name="rx8_stop1_even");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b11; stop_bit_num == 1'b0; parity_en == 1'b1; parity_type == 1'b1; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 8, two stop bit and no parity
class rx8_stop2_np extends uart_base_seq;
    `uvm_object_utils(rx8_stop2_np)

    base_seq_item seq;
    function new(input string name="rx8_stop2_np");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b11; stop_bit_num == 1'b1; parity_en == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 8, 2 stop bit and odd parity
class rx8_stop2_odd extends uart_base_seq;
    `uvm_object_utils(rx8_stop2_odd)

    base_seq_item seq;
    function new(input string name="rx8_stop2_odd");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b11; stop_bit_num == 1'b1; parity_en == 1'b1; parity_type == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 8, 2 stop bit and even parity
class rx8_stop2_even extends uart_base_seq;
    `uvm_object_utils(rx8_stop2_even)

    base_seq_item seq;
    function new(input string name="rx8_stop2_even");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b11; stop_bit_num == 1'b1; parity_en == 1'b1; parity_type == 1'b1; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 7, one stop bit and no parity
class rx7_stop1_np extends uart_base_seq;
    `uvm_object_utils(rx7_stop1_np)

    base_seq_item seq;
    function new(input string name="rx7_stop1_np");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b10; stop_bit_num == 1'b0; parity_en == 1'b0; rx_serial_data inside {[8'h00:8'h7F]};});
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 7, one stop bit and odd parity
class rx7_stop1_odd extends uart_base_seq;
    `uvm_object_utils(rx7_stop1_odd)

    base_seq_item seq;
    function new(input string name="rx7_stop1_odd");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b10; stop_bit_num == 1'b0; parity_en == 1'b1; parity_type == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 7, one stop bit and even parity
class rx7_stop1_even extends uart_base_seq;
    `uvm_object_utils(rx7_stop1_even)

    base_seq_item seq;
    function new(input string name="rx7_stop1_even");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b10; stop_bit_num == 1'b0; parity_en == 1'b1; parity_type == 1'b1; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 7, two stop bit and no parity
class rx7_stop2_np extends uart_base_seq;
    `uvm_object_utils(rx7_stop2_np)

    base_seq_item seq;
    function new(input string name="rx7_stop2_np");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b10; stop_bit_num == 1'b1; parity_en == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 7, 2 stop bit and odd parity
class rx7_stop2_odd extends uart_base_seq;
    `uvm_object_utils(rx7_stop2_odd)

    base_seq_item seq;
    function new(input string name="rx7_stop2_odd");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b10; stop_bit_num == 1'b1; parity_en == 1'b1; parity_type == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 7, 2 stop bit and even parity
class rx7_stop2_even extends uart_base_seq;
    `uvm_object_utils(rx7_stop2_even)

    base_seq_item seq;
    function new(input string name="rx7_stop2_even");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b10; stop_bit_num == 1'b1; parity_en == 1'b1; parity_type == 1'b1; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 8, one stop bit and even parity
class rx6_stop1_np extends uart_base_seq;
    `uvm_object_utils(rx6_stop1_np)

    base_seq_item seq;
    function new(input string name="rx8_stop1_even");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b01; stop_bit_num == 1'b0; parity_en == 1'b0; rx_serial_data inside {[8'h00:8'h3F]};});
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 6, one stop bit and odd parity
class rx6_stop1_odd extends uart_base_seq;
    `uvm_object_utils(rx6_stop1_odd)

    base_seq_item seq;
    function new(input string name="rx6_stop1_odd");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b01; stop_bit_num == 1'b0; parity_en == 1'b1; parity_type == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 6, one stop bit and even parity
class rx6_stop1_even extends uart_base_seq;
    `uvm_object_utils(rx6_stop1_even)

    base_seq_item seq;
    function new(input string name="rx6_stop1_even");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b01; stop_bit_num == 1'b0; parity_en == 1'b1; parity_type == 1'b1; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 6, two stop bit and no parity
class rx6_stop2_np extends uart_base_seq;
    `uvm_object_utils(rx6_stop2_np)

    base_seq_item seq;
    function new(input string name="rx6_stop2_np");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b01; stop_bit_num == 1'b1; parity_en == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 6, 2 stop bit and odd parity
class rx6_stop2_odd extends uart_base_seq;
    `uvm_object_utils(rx6_stop2_odd)

    base_seq_item seq;
    function new(input string name="rx6_stop2_odd");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b01; stop_bit_num == 1'b1; parity_en == 1'b1; parity_type == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 6, 2 stop bit and even parity
class rx6_stop2_even extends uart_base_seq;
    `uvm_object_utils(rx6_stop2_even)

    base_seq_item seq;
    function new(input string name="rx6_stop2_even");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b01; stop_bit_num == 1'b1; parity_en == 1'b1; parity_type == 1'b1; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 5, one stop bit and no parity
class rx5_stop1_np extends uart_base_seq;
    `uvm_object_utils(rx5_stop1_np)

    base_seq_item seq;
    function new(input string name="rx5_stop1_np");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b00; stop_bit_num == 1'b0; parity_en == 1'b0; rx_serial_data inside {[8'h00:8'h1F]};});
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 5, one stop bit and odd parity
class rx5_stop1_odd extends uart_base_seq;
    `uvm_object_utils(rx5_stop1_odd)

    base_seq_item seq;
    function new(input string name="rx5_stop1_odd");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b00; stop_bit_num == 1'b0; parity_en == 1'b1; parity_type == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 5, one stop bit and even parity
class rx5_stop1_even extends uart_base_seq;
    `uvm_object_utils(rx5_stop1_even)

    base_seq_item seq;
    function new(input string name="rx5_stop1_even");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b00; stop_bit_num == 1'b0; parity_en == 1'b1; parity_type == 1'b1; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 6, two stop bit and no parity
class rx5_stop2_np extends uart_base_seq;
    `uvm_object_utils(rx5_stop2_np)

    base_seq_item seq;
    function new(input string name="rx5_stop2_np");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b00; stop_bit_num == 1'b1; parity_en == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 5, 2 stop bit and odd parity
class rx5_stop2_odd extends uart_base_seq;
    `uvm_object_utils(rx5_stop2_odd)

    base_seq_item seq;
    function new(input string name="rx5_stop2_odd");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b00; stop_bit_num == 1'b1; parity_en == 1'b1; parity_type == 1'b0; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

//Receive fixed length = 5, 2 stop bit and even parity
class rx5_stop2_even extends uart_base_seq;
    `uvm_object_utils(rx5_stop2_even)

    base_seq_item seq;
    function new(input string name="rx5_stop2_even");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {data_bit_num == 2'b00; stop_bit_num == 1'b1; parity_en == 1'b1; parity_type == 1'b1; rx_serial_data inside {[8'h00:8'hFF]};});  
        finish_item(seq);
    endtask
endclass

class tx_rand_stop1 extends uart_base_seq;
    `uvm_object_utils(tx_rand_stop1)

    base_seq_item seq;
    function new(input string name="tx_rand_stop1");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {stop_bit_num == 1'b0; cts_n == 1'b0; start_tx == 1'b1;});
        finish_item(seq);
    endtask
endclass

class tx_rand_stop2 extends uart_base_seq;
    `uvm_object_utils(tx_rand_stop2)

    base_seq_item seq;
    function new(input string name="tx_rand_stop2");
        super.new(name);
    endfunction

    virtual task body();
        seq = base_seq_item::type_id::create("seq");
        start_item(seq);
        assert(seq.randomize() with {stop_bit_num == 1'b1; cts_n == 1'b0; start_tx == 1'b1;});
        finish_item(seq);
    endtask
endclass
////////////////////////////////////////////////



////////////////////////////////////////////////
/*
HALF-DUPLEX Test
*/
////////////////////////////////////////////////




