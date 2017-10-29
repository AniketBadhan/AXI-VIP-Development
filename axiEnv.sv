/*
  Author:Aniket Badhan
*/

class axiEnv;

  axiMasterEnv masterEnv = new();
  axiSlaveEnv slaveEnv = new();

  task run();
    fork
      masterEnv.run;
      slaveEnv.run;
    join
  endtask

endclass
