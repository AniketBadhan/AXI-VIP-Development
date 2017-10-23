/*
	Author: Aniket Badhan
*/

typedef enum{
	NOP,
	READ,
	WRITE,
	WRITEREAD
} writeReadType;

typedef enum{
	FIXED,
	INCR,
	WRAP
} burstType;

class axiConfig;
	static string testName;
	static mailbox genToBFM = new();
	static mailbox monToCov = new();
	static mailbox BFMToGen = new();
	static virtual axiInterface vif;
endclass
