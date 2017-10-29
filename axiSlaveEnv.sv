/*
  Author:Aniket Badhan
*/

class axiSlaveEnv;
	//axiSlaveGen slaveGen = new();			//No generator required for slave
	axiSlaveBFM slaveBFM = new();
	axiMasterMonitor slaveMonitor = new();	//when no argument is passed to new function, inline new can be used, otherwise do it in Initial block
	//axiSlaveCoverage slaveCov = new();	//Coverage will be same for Master and Slave

	task run();
		fork
			slaveBFM.run();
			slaveMonitor.run();
		join
	endtask

endclass
