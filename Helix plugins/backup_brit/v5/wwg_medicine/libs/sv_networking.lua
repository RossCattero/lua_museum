--- Networking.
-- @medical Serverside networking

/*
	Sends the `Wound` to the client;
	@realm [server]
	@networkstring [NETWORK_WOUND]
*/
util.AddNetworkString("NETWORK_WOUND")

/*
	Sends the `Wound` data to the client;
	@realm [server]
	@networkstring [NETWORK_WOUND_DATA]
*/
util.AddNetworkString("NETWORK_WOUND_DATA")

/*
	Sends the net signal to client to remove specified `Wound`;
	@realm [server]
	@networkstring [NETWORK_WOUND_REMOVE]
*/
util.AddNetworkString("NETWORK_WOUND_REMOVE")

/*
	Sends a net with `Disease` instance data;
	@realm [server]
	@networkstring [NETWORK_DISEASE]
*/
util.AddNetworkString("NETWORK_DISEASE")

/*
	Sends a net signal to remove the `Disease` on client;
	@realm [server]
	@networkstring [NETWORK_DISEASE_REMOVE]
*/
util.AddNetworkString("NETWORK_DISEASE_REMOVE")