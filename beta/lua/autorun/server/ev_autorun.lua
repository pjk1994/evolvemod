/*-------------------------------------------------------------------------------------------------------------------------
	Serverside autorun file
-------------------------------------------------------------------------------------------------------------------------*/

// Set up Evolve table
evolve = {}

// Requirements
require( "glon" )
require( "gatekeeper" )

// Distribute clientside and shared files
AddCSLuaFile( "autorun/client/ev_autorun.lua" )
AddCSLuaFile( "ev_framework.lua" )
AddCSLuaFile( "ev_cl_init.lua" )
AddCSLuaFile( "ev_ranks.lua" )
for _, v in pairs( file.FindInLua( "ev_menu/*.lua" ) ) do
	AddCSLuaFile( "ev_menu/" .. v )
end

// Load serverside files
include( "ev_framework.lua" )
include( "ev_menu/menu.lua" )
include( "ev_sv_init.lua" )
include( "ev_ranks.lua" )