/*
	Author: Aniket Badhan
*/

class axi_slave_bfm;
	axiTx tx;
	axiTx writeArray[*];
	axiTx readArray[*];

	byte mem[*];				//imitating an AXI Slave (a memory of byte), so basically, write and read operations happen to memory

	virtual axiInterface vif;
	task run();
		vif = axiConfig::vif;
		wait (vif.arst == 0);
		forever begin
			@(posedge vif.aclk);

			//Write Address Phase
			if (vif.awvalid == 1) begin
				vif.awready = 1;
				//Capturing the write address phase information
				writeArray[vif.awid] = new();
				writeArray[vif.awid].writeAddress = vif.awaddr;
				writeArray[vif.awid].writeLength = vif.awlen;
				writeArray[vif.awid].writeBurstSize = vif.awsize;
				writeArray[vif.awid].writeBurstTypeVar = burstTypeVar'(vif.awburst);
				writeArray[vif.awid].writeProt = vif.awprot;
				writeArray[vif.awid].writeLock = vif.awlock;
				writeArray[vif.awid].writeCache = vif.awcache;
				writeArray[vif.awid].writeID = vif.awid;
			end
			else begin
				vif.awready = 0;
			end

			//Write data phase
			if (vif.wvalid == 1) begin
				vif.wready = 1;
				mem[writeArray[vif.wid].writeAddress] = vif.wdata[7:0];
				mem[writeArray[vif.wid].writeAddress+1] = vif.wdata[15:8];
				mem[writeArray[vif.wid].writeAddress+2] = vif.wdata[23:16];
				mem[writeArray[vif.wid].writeAddress+3] = vif.wdata[31:24];
				if (vif.wlast == 1) begin
					doWriteResponse(vif.wid);
				end
			end
			else begin
				vif.wready = 0;
			end

			//Read Address phase
			if (vif.arvalid == 1) begin
				vif.arready = 1;
				//Capturing the read address phase information
				readArray[vif.arid] = new();
				readArray[vif.arid].readAddress = vif.araddr;
				readArray[vif.arid].readLength = vif.arlen;
				readArray[vif.arid].readBurstSize = vif.arsize;
				readArray[vif.arid].readBurstTypeVar = burstType'(vif.arburst);
				readArray[vif.arid].readProt = vif.arprot;
				readArray[vif.arid].readLock = vif.arlock;
				readArray[vif.arid].readCache = vif.arcache;
				readArray[vif.arid].readID = vif.arid;
				doReadData(vif.arid);
			end
			else begin
				vif.arready = 0;
			end
		end
	endtask

	//in this task, the read operation is performed after the read address phase is complete
	task doReadData(bit [3:0] rid);
		bit readReadyFlag = 0;
		for (int i = 0; i <= readArray[rid].readLength; i++) begin
			vif.rid = rid;
			vif.rresp = 2'b00;
			vif.rvalid = 1;
			vif.rlast = 0;

			//for the last read
			if (i == readArray[rid].readLength) begin
				vif.rlast = 1;
			end

			if  (mem.exists(readArray[rid].readAddress)) begin			//if condition to make sure if the address at which data tp be read exists.
				vif.rdata[7:0] = mem[readArray[rid].readAddress];
				vif.rdata[15:8] = mem[readArray[rid].readAddress+1];
				vif.rdata[23:16] = mem[readArray[rid].readAddressr+2];
				vif.rdata[31:24] = mem[readArray[rid].readAddressr+3];
			end
			else begin
				vif.rdata = $random;
			end

			while (readReadyFlag == 0) begin
				@(posedge vif.aclk);
				vif.arready = 0;
				//checking the read ready signal from the master
				if (vif.rready == 1) begin
					readReadyFlag = 1;
				end
			end

			//releasing the signals after the operation is complete
			@(negedge vif.aclk);
			vif.rvalid = 1'b0;
			vif.rlast = 0;
			vif.rdata = 0;
			vif.rid = 0;
			readReadyFlag = 1'b0;
		end

	endtask


	//in this task, we wait for the bready signal from the master. bvalid will be sent by the slave
	task doWriteResponse(bit [3:0] id);
		bit bReadyFlag = 0;
		vif.bid = id;
		vif.bresp = 2'b00;
		vif.bvalid = 1;
		while (bReadyFlag == 0) begin
			@(posedge vif.aclk);
			if (vif.bready == 1) bReadyFlag = 1;
		end
		@(negedge vif.aclk);
		vif.bvalid = 1'b0;
	endtask
endclass
