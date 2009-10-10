/*-------------------------------------------------------------------------------------------------------------------------
	Serverside initialization
-------------------------------------------------------------------------------------------------------------------------*/

// Show startup message
print( "\n=====================================================" )
print( " Evolve 1.0 by Overv succesfully started serverside." )
print( "=====================================================\n" )

// Load plugins
evolve:LoadPlugins()
evolve:LoadMenuTabs()

// Tell the clients Evolve is installed on the server
hook.Add( "PlayerInitialSpawn", "EvolveInit", function( ply )
	umsg.Start( "EV_Init" )
	umsg.End()
end )

// Add Evolve to the tag list (Probably beta only)
if ( !string.find( GetConVar( "sv_tags" ):GetString(), "Evolve" ) ) then
	RunConsoleCommand( "sv_tags", GetConVar( "sv_tags" ):GetString() .. ",Evolve" )
end