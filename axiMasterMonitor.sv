/*
  Author:Aniket Badhan
*/

class axiMasterMonitor;
	axiTx writeArray[*];	//associative array
	axiTx readArray[*];		//associative array
	virtual axiInterface vif;

	//Covering cases for all the 5 channels
	task run();
		$display("AXI Monitor");
		vif = axiConfig::vif;
		forever begin
			@(posedge vif.aclk);
			if(vif.awvalid && vif.awready) begin
				writeArray[vif.awid] = new();
				writeArray[vif.awid].writeAddress = vif.awaddr;
				writeArray[vif.awid].writeLength = vif.awlen;
				writeArray[vif.awid].writeBurstSize = vif.awsize;
				writeArray[vif.awid].writeBurstTypeVar = burstType'(vif.awburst);
				writeArray[vif.awid].writeProt = vif.awprot;
				writeArray[vif.awid].writeLock = vif.awlock;
				writeArray[vif.awid].writeCache = vif.awcache;
				writeArray[vif.awid].writeID = vif.awid;
			end

			if(vif.wvalid && vif.wready) begin
				//if (writeArray[vif.wid] != null) begin
				writeArray[vif.wid].writeDataQueue.push_back(vif.wdata);
				writeArray[vif.wid].writeStrbQueue.push_back(vif.wstrb);
				//end
			end

			if(vif.bvalid && vif.bready) begin
				//if (writeArray[vif.bid] != null) begin
				writeArray[vif.bid].writeResponse = vif.bresp;
				axiConfig::monToCov.put(writeArray[vif.bid]);
				//end
			end

			if(vif.arvalid && arready) begin
				readArray[vif.arid] = new();
				readArray[vif.arid].readAddress = vif.araddr;
				readArray[vif.arid].readLength = vif.arlen;
				readArray[vif.arid].readBurstSize = vif.arsize;
				readArray[vif.arid].readBurstTypeVar = burstType'(vif.arburst);
				readArray[vif.arid].readProt = vif.arprot;
				readArray[vif.arid].readLock = vif.arlock;
				readArray[vif.arid].readCache = vif.arcache;
				readArray[vif.arid].readID = vif.arid;
			end

			if(vif.rvalid && rready) begin
				//if (readArray[vif.rid] != null) begin
				readArray[vif.rid].readDataQueue.push_back(vif.rdata);
				if(vif.rlast) begin
					axiConfig::monToCov.put(readArray[vif.rid]);
				end
				//end
			end


		end
	endtask
endclass
