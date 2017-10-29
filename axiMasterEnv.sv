/*
  Author:Aniket Badhan
*/

class axiMasterEnv;
	axiGen Gen = new();												//when no argument is passed to new function, inline new can be used, otherwise do it in Initial block
	axiMasterBFM masterBFM = new();
	axiMasterMonitor masterMonitor = new();
	axiCoverage masterCov = new();

	task run();
		fork
			masterBFM.run();
			masterGen.run();
			masterMonitor.run();
			masterCov.run();
		join
	endtask
endclass
