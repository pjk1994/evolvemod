/*-------------------------------------------------------------------------------------------------------------------------
	Serverside autorun file
-------------------------------------------------------------------------------------------------------------------------*/

// The table holding all built in functions used by Evolve
Evolve = {}

// Include the serverside files and distribute clientside files
AddCSLuaFile( "autorun/client/ev_autorun.lua" )
AddCSLuaFile( "ev_cl_init.lua" )
AddCSLuaFile( "ev_framework.lua" )
include( "ev_framework.lua" )
include( "ev_init.lua" )