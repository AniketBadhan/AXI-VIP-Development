interface axiInterface(input bit aclk, input bit arst);

	// Write Address channel
  bit [31:0] awaddr;
  bit [3:0] awlen;
  bit [2:0] awsize;
  bit [1:0] awburst;
  bit [1:0] awlock;
  bit [1:0] awprot;
  bit [3:0] awcache;
  bit [3:0] awid;
  bit awvalid;
  bit awready;

  // Write data channel
  bit [31:0] wdata;
  bit wvalid;
  bit wready;
  bit [3:0] wstrb;
  bit [3:0] wid;
  bit wlast;

  // write response channel
  bit bvalid;
  bit bready;
  bit [1:0] bresp;
  bit [3:0] bid;

  // Read address channel
  bit [31:0] araddr;
  bit [3:0] arlen;
  bit [2:0] arsize;
  bit [1:0] arburst;
  bit [1:0] arlock;
  bit [1:0] arprot;
  bit [3:0] arcache;
  bit [3:0] arid;
  bit arvalid;
  bit arready;

  // Read data channel
  bit [31:0] rdata;
  bit rvalid;
  bit rready;
  bit rlast;
  bit [3:0] rid;
  bit [1:0] rresp;

endinterface
