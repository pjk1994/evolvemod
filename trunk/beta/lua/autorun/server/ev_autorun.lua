/*-------------------------------------------------------------------------------------------------------------------------
	Serverside autorun file
-------------------------------------------------------------------------------------------------------------------------*/

// Set up Evolve table
evolve = { }

// Requirements
require( "glon" )

// Distribute clientside and shared files
AddCSLuaFile( "autorun/client/ev_autorun.lua" )
AddCSLuaFile( "ev_framework.lua" )
AddCSLuaFile( "ev_cl_init.lua" )
AddCSLuaFile( "ev_cl_menu.lua" )

// Load serverside initialization file
include( "ev_framework.lua" )
include( "ev_sv_init.lua" )