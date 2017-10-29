/*
	Author: Aniket Badhan
	Description: Getting transactions from generator block and driving it to the Slave BFM
*/

class axiMasterBFM;
	axiTx tx;
	//using semaphore to mkae sure that the virtual interface is shared across all the tasks
	semaphore smpAwaddr = new(1);
	semaphore smpWData = new(1);
	semaphore smpAraddr = new(1);
	virtual axiInterface vif;
	task run();
		$display("AXI Master BFM");
		vif = axiConfig::vif;
		wait(vif.arst == 0);
		fork
			forever begin
				axiConfig::genToBFM.get(tx);
				tx.print;
				fork				//this is to achieve out of order or overlapping transactions
					driveTx(tx);
				join_none
			end
			forever begin
				@(posedge vif.aclk);
				if (vif.bvalid == 0) vif.bready = 0;
				if (vif.rvalid == 0) vif.rready = 0;
			end
		join
	endtask

	task driveTx(axiTx tx);
		case(tx.writeRead) begin
			NOP		: begin

					  end
			WRITE		: begin
						writeAddressPhase(tx);
						writeDataPhase(tx);
						writeResponsePhase(tx);
			 		  end
			READ		: begin
						readAddressPhase(tx);
						readDataPhase(tx);
					  end
			WRITEREAD	: begin
						fork
							begin
								writeAddressPhase(tx);
								writeDataPhase(tx);
								writeResponsePhase(tx);
							end
							begin
								readAddressPhase(tx);
								readDataPhase(tx);
							end
						join
					  end
		endcase
	endtask
	
	// task for assigning signals on the interface for the write address phase
	task writeAddressPhase(axiTx tx);
		bit awreadyFlag = 0;
		$display("Write Address phase");
		smpAwaddr.get(1);
		vif.awvalid = 1'b1;
		vif.awaddr = tx.writeAddress;
		vif.awlen = tx.writeLength;
		vif.awsize = tx.writeBurstSize;
		vif.awburst = tx.writeBurstTypeVar;
		vif.awlock = tx.writeLock;
		vif.awprot = tx.writeProt;
		vif.awcache = tx.writeCache;
		vif.awid = tx.writeID;
		while (awreadyFlag == 0) begin
			@(posedge vif.aclk);
			if (vif.awready == 1) begin
				awreadyFlag = 1;
			end
		end
		@(negedge vif.aclk);
		vif.awvalid = 1'b0;
		vif.awaddr = 1'b0;
		vif.awsize = 1'b0;
		vif.awlen = 1'b0;
		vif.awcache = 1'b0;
		vif.awburst = 1'b0;
		vif.awprot = 1'b0;
		awreadyFlag = 0;
		smpAwaddr.put(1);
	endtask
	
	// task for assigning signals on the interface for the write data phase
	task writeDataPhase(axiTx tx);
			bit wReadyFlag = 0;
			$display("Write Data phase");
			for (int i = 0; i <= tx.wr_len; i++) begin
				smpWData.get(1);
				vif.wdata = tx.writeDataQueue.pop_front();
				vif.wstrb = tx.writeStrbQueue.pop_front();
				vif.wid = tx.writeID;
				vif.wvalid = 1;
				vif.wlast = 0;
				if (i == tx.wr_len) vif.wlast = 1;		//in the last iteration of data, send wlast = 1
				while (wReadyFlag == 0) begin
					@(posedge vif.aclk);
					if (vif.wready == 1) wReadyFlag = 1;
				end
				//resetting the values after the operation is performed
				@(negedge vif.aclk);
				vif.wvalid = 1'b0;
				vif.wdata = 1'b0;
				vif.wid = 1'b0;
				vif.wstrb = 1'b0;
				vif.wlast = 1'b0;
				wReadyFlag = 0;
				smpWData.put(1);
			end
	endtask
	
	// task for assigning signals on the interface for the write response phase
	task writeResponsePhase(axiTx tx);
		bit bValidFlag = 0;
		$display("Write Response phase");
		while (bValidFlag == 0) begin
			@(posedge vif.aclk);
			if (vif.bvalid == 1 && vif.bid == tx.writeID) begin
				bValidFlag = 1;
				vif.bready = 1;
				tx.writeResponse = vif.bresp;
			end
		end
	endtask

	// task for assigning signals on the interface for the read address phase
	task readAddressPhase(axiTx tx);
		bit aReadyFlag = 0;
		$display("Read Address phase");
		smpAraddr.get(1);
		vif.arvalid = 1'b1;
		vif.araddr = tx.readAddress;
		vif.arlen = tx.readLength;
		vif.arsize = tx.readBurstSize;
		vif.arburst = tx.readBurstTypeVar;
		vif.arlock = tx.readLock;
		vif.arprot = tx.readProt;
		vif.arcache = tx.readCache;
		vif.arid = tx.readID;
		while (aReadyFlag == 0) begin
			@(posedge vif.aclk);
			if (vif.arready == 1) aReadyFlag = 1;
		end
		@(negedge vif.aclk);
		vif.arvalid = 1'b0;
		vif.araddr = 1'b0;
		vif.arsize = 1'b0;
		vif.arlen = 1'b0;
		vif.arcache = 1'b0;
		vif.arburst = 1'b0;
		vif.arprot = 1'b0;
		aReadyFlag = 0;
		smpAraddr.put(1);
	endtask

	// task for assigning signals on the interface for the read data phase
	task readDataPhase(axiTx tx);
		bit readFlag = 0;
		$display("Read Data Phase");
		for (int i = 0; i <= tx.readLength; i++) begin
			while (readFlag == 0) begin
				@(posedge vif.aclk);
				if (vif.rvalid == 1 && vif.rid == tx.readID) begin
					readFlag = 1;
					vif.rready = 1;
					tx.readResponse = vif.rresp;
				end
		  	end
			readFlag = 0;
		end
	endtask

endclass
