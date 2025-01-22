// Default
-sysv -access +rw
// 64 bit option required for AWS labs
-64

-uvmhome $UVMHOME

// include directories
//-incdir .

// options
+UVM_VERBOSITY=UVM_LOW

// (un)comment lines to select test
//+UVM_TESTNAME=simplex_tx_test
//+UVM_TESTNAME=simplex_rx_test
+UVM_TESTNAME=random_rx_test
//+SVSEED=random 

// compile files
testbench.sv
