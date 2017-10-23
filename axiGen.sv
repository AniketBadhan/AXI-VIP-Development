class axiGen;
	axiTx tx;
	axiTx TxQ[$];
	axiTx txResponse;
	bit compareFlag = 1'b1;

	task run();
		$display("AXI Gen");
		case(axiConfig::testName)
			"axiWriteReadTest"		:	begin
																//Write
																tx = new();
																assert(tx.randomize() with {writeRead == WRITE;});
																axiConfig::genToBFM.put(tx);
																//Read
																tx = new();
																assert(tx.randomize() with {writeRead == READ;});
																axiConfig::genToBFM.put(tx);
															end
			"axiTenWriteTestCase"	:	begin
																for(int i=0; i<10;i++) begin
																	tx = new();
																	assert(tx.randomize() with {writeRead == WRITE;});
																	axiConfig::genToBFM.put(tx);
																end
															end
			"axiTenReadTestCase"	:	begin
																for(int i=0; i<10;i++) begin
																	tx = new();
																	assert(tx.randomize() with {writeRead == READ;});
																	axiConfig::genToBFM.put(tx);
																end
															end
			"axiWriteUnaligned"		:	begin
																for(int i-0; i<10;i++) begin
																	tx = new();
																	assert(tx.randomize() with {writeRead == WRITE, writeAddress%(2**writeBurstSize) !=0;});
																	axiConfig::genToBFM.put(tx);
																end
															end
			"axiCompareWrRd"			:	begin
																for (int i = 0; i < 3; i++) begin
																	tx = new();
																	assert(tx.randomize() with {writeRead == WRITE;});
																	TxQ.push_back(tx);
																	axiConfig::genToBFM.put(tx);
																end
																for(int i=0; i<3; i++) begin
																	tx = new();
																	assert(tx.randomize() with {writeRead == READ;
																															readAddress == TxQ[i].writeAddress;
																															readLength == TxQ[i].writeLength;
																															readBurstSize == TxQ[i].writeBurstSize;
																															readBurstTypeVar == TxQ[i].writeBurstTypeVar;});
																	axiConfig::genToBFM.put(tx);
																	axiConfig::BFMToGen.get(txResponse);
																	foreach(txResponse.readDataQueue[i]) begin
																		if(txResponse.readDataQueue[i] != TxQ[i].writeDataQueue[i]) begin
																			compareFlag = 1'b0;
																		end
																	end
																	if(compareFlag) begin
																		$display("Comparison of Data queue successful!!!");
																	end
																	else begin
																		$display("Comparison Failed!!!");
																	end
																end
															end
		endcase
	endtask
endclass
