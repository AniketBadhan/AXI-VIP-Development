/*
	Author:Aniket Badhan
	Description: Coverage Block
*/

class axiCoverage;
	axiTx tx;

	covergroup ADDR_LEN_SIZE;
		WRITEADDR_CP : coverpoint tx.writeAddress {
			option.auto_bin_max = 8;
			option.at_least = 1;
		}
		WRITELENGTH_CP : coverpoint tx.writeLength {
			option.auto_bin_max = 4;
			option.at_least = 1;
		}
		WRITESIZE_CP : coverpoint tx.writeBurstSize {
			option.auto_bin_max = 2;
			option.at_least = 1;
		}
		READADDR_CP : coverpoint tx.readAddress {
			option.auto_bin_max = 8;
			option.at_least = 1;
		}
		READLENGTH_CP : coverpoint tx.readLength {
			option.auto_bin_max = 4;
			option.at_least = 1;
		}
		READSIZE_CP : coverpoint tx.readBurstSize {
			option.auto_bin_max = 2;
			option.at_least = 1;
		}
	endgroup

	function new();
		ADDR_LEN_SIZE = new();
	endfunction

	task run();
		$display("AXI Coverage::run");
		forever begin
			axiConfig::monToCov.get(tx);
			ADDR_LEN_SIZE.sample();
		end
	endtask
endclass
