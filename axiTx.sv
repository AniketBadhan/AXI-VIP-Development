/*
	Author: Aniket Badhan
	Description: basic transaction class to be used for the TB architecture
*/

class axiTx;

	bit [31:0] wrapUpperBoundary;
	bit [31:0] wrapLowerBoundary;
	//write, read, write/read
	//WRITE
	rand writeReadType writeRead;
	rand bit [31:0] writeAddress;
	rand bit [31:0] writeDataQueue[$];
	rand bit [3:0] writeStrbQueue[$];
	rand bit [3:0] writeLength;		//how many writes
	rand burstType writeBurstTypeVar;
	rand bit [2:0] writeBurstSize;
	rand bit [3:0] writeCache;
	rand bit [3:0] writeLock;
	rand bit [3:0] writeID;
	rand bit [3:0] writeProt;
	rand bit [1:0] writeResponse;		//TODO: Add this in the print, compare and copy functions

	//READ
	rand bit [31:0] readAddress;
	rand bit [31:0] readDataQueue[$];
	rand bit [3:0] readLength;		//how many writes
	rand burstType readBurstTypeVar;
	rand bit [2:0] readBurstSize;
	rand bit [3:0] readCache;
	rand bit [3:0] readLock;
	rand bit [3:0] readID;
	rand bit [3:0] readProt;
	rand bit [1:0] readResponse		//TODO: Add this in the print, compare and copy functions

	//constraints
	constraint writeReadConst{
		writeRead!= NOP;
	}

	constraint lengthConst{
		writeDataQueue.size() == writeLength + 1;
		readDataQueue.size() == readLength + 1;
	}

	function void post_randomize();
		int txSize = (writeLength + 1) * (2**writeBurstSize);
		bit [31:0] offset = writeAddress%txSize;
		wrapLowerBoundary = writeAddress - offset;
		wrapUpperBoundary = wrapLowerBoundary + txSize - 1'b1;
	endfunction

	//methods: Print, compare, copy (copy can be made as shallow copy as there is no object under object)
	function void print();
		if(writeRead == WRITE) begin
			$display("AXI WRITE TX");
			$display("Write Address: %h", writeAddress);
			$display("Write Data Queue: %p", writeDataQueue);
			$display("Write Strobe Queue: %h", writeStrbQueue);
			$display("Write Length: %h", writeLength);
			$display("Write Burst Type: %h", writeBurstTypeVar);
			$display("Write Cache: %h", writeCache);
			$display("Write Lock: %h", writeLock);
			$display("Write ID: %h", writeID);
			$display("Write Protection: %h", writeProt);
			$display("Write Response: %h", writeResponse);
		end
		if(readRead == READ) begin
			$display("AXI READ TX");
			$display("Read Address: %h", readAddress);
			$display("Read Data Queue: %p", readDataQueue);
			$display("Read Length: %h", readLength);
			$display("Read Burst Type: %h", readBurstTypeVar);
			$display("Read Cache: %h", readCache);
			$display("Read Lock: %h", readLock);
			$display("Read ID: %h", readID);
			$display("Read Protection: %h", readProt);
			$display("Read Response: %h", readResponse);
		end
		if(writeRead == WRITEREAD) begin
			$display("AXI WRITE TX");
			$display("Write Address: %h", writeAddress);
			$display("Write Data Queue: %p", writeDataQueue);
			$display("Write Strobe Queue: %h", writeStrbQueue);
			$display("Write Length: %h", writeLength);
			$display("Write Burst Type: %h", writeBurstTypeVar);
			$display("Write Cache: %h", writeCache);
			$display("Write Lock: %h", writeLock);
			$display("Write ID: %h", writeID);
			$display("Write Protection: %h", writeProt);
			$display("Read Address: %h", readAddress);
			$display("Read Data Queue: %p", readDataQueue);
			$display("Read Length: %h", readLength);
			$display("Read Burst Type: %h", readBurstTypeVar);
			$display("Read Cache: %h", readCache);
			$display("Read Lock: %h", readLock);
			$display("Read ID: %h", readID);
			$display("Read Protection: %h", readProt);
		end
	endfunction

	//function for deep copy of the axi transaction
	function bit deepCopy(output axiTx outputTx);
		outputTx = new();
		outputTx.writeRead = this.writeRead;
		outputTx.writeAddress = this.writeAddress;
		outputTx.writeDataQueue = this.writeDataQueue;
		outputTx.writeStrbQueue = this.writeStrbQueue;
		outputTx.writeLength = this.writeLength;
		outputTx.burstTypeVar = this.writeBurstTypeVar;
		outputTx.writeBurstSize = this.writeBurstSize;
		outputTx.writeCache = this.writeCache;
		outputTx.writeLock = this.writeLock;
		outputTx.writeID = this.writeID;
		outputTx.writeProt = this.writeProt;
		outputTx.writeResponse = this.writeResponse;
		outputTx.readAddress = this.readAddress;
		outputTx.readDataQueue = this.readDataQueue;
		outputTx.readLength = this.readLength;
		outputTx.burstTypeVar = this.readBurstTypeVar;
		outputTx.readBurstSize = this.readBurstSize;
		outputTx.readCache = this.readCache;
		outputTx.readLock = this.readLock;
		outputTx.readID = this.readID;
		outputTx.readProt = this.readProt;
		outputTx.readResponse = this.readResponse;
	endfunction

	//function to compare the axi transaction
	function bit compare(axiTx inputTx);
		if(inputTx.writeRead == this.writeRead) begin
			return 0;
		end
		if(inputTx.writeAddress == this.writeAddress) begin
			return 0;
		end
		if(inputTx.writeDataQueue == this.writeDataQueue) begin
			return 0;
		end
		if(inputTx.writeStrbQueue == this.writeStrbQueue) begin
			return 0;
		end
		if(inputTx.writeLength == this.writeLength) begin
			return 0;
		end
		if(inputTx.writeBurstTypeVar == this.writeBurstTypeVar) begin
			return 0;
		end
		if(inputTx.writeBurstSize == this.writeBurstSize) begin
			return 0;
		end
		if(inputTx.writeCache == this.writeCache) begin
			return 0;
		end
		if(inputTx.writeLock == this.writeLock) begin
			return 0;
		end
		if(inputTx.writeID == this.writeID) begin
			return 0;
		end
		if(inputTx.writeProt == this.writeProt) begin
			return 0;
		end
		if(inputTx.writeResponse == this.writeResponse) begin
			return 0;
		end
		if(inputTx.readAddress == this.readAddress) begin
			return 0;
		end
		if(inputTx.readDataQueue == this.readDataQueue) begin
			return 0;
		end
		if(inputTx.readLength == this.readLength) begin
			return 0;
		end
		if(inputTx.readBurstTypeVar == this.readBurstTypeVar) begin
			return 0;
		end
		if(inputTx.readBurstSize == this.readBurstSize) begin
			return 0;
		end
		if(inputTx.readCache == this.readCache) begin
			return 0;
		end
		if(inputTx.readLock == this.readLock) begin
			return 0;
		end
		if(inputTx.readID == this.readID) begin
			return 0;
		end
		if(inputTx.readProt == this.readProt) begin
			return 0;
		end
		if(inputTx.readResponse == this.readResponse) begin
			return 0;
		end
		return 1;
	endfunction

endclass
