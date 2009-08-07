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
for _, v in pairs( file.FindInLua( "ev_menu/*.lua" ) ) do
	AddCSLuaFile( "ev_menu/" .. v )
end

// Load serverside initialization file
include( "ev_framework.lua" )
include( "ev_sv_init.lua" )