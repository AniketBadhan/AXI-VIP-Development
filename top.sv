/*
  Author:Aniket Badhan
*/

`timescale 1 ns / 1 ps


`include "axiConfig.sv"
`include "axiTx.sv"
`include "axiInterface.sv"
`include "axiMasterBFM.sv"
`include "axiGen.sv"
`include "axiMasterMonitor.sv"
`include "axiCoverage.sv"
`include "axiMasterEnv.sv"
`include "axiSlaveBFM.sv"
`include "axiSlaveEnv.sv"
`include "axiEnv.sv"

module top;

	reg clk, rst;
	axi_intf pif(aclk, arst);

	//No DUT instantitation as the there is no DUT in the TB, slaveBFM is imitating a Slave device

	initial begin
		aclk = 0;
		forever #2 aclk = ~aclk;
	end

	initial begin
		arst = 1;
		repeat(2) @(posedge aclk);
		arst = 0;
		#1000;
		$finish;
	end

	//program block
	axiTestBench tb();

	initial begin
		if($value$plusargs("testName=%s",axiConfig::testName) begin
			axiConfig::testName = axiConfig::testName;
		end
		axiConfig::vif = pif;
	end

endmodule
