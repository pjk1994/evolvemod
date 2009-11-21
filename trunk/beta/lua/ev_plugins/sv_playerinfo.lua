/*-------------------------------------------------------------------------------------------------------------------------
	Player Info
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Player Info"
PLUGIN.Description = "When players join, show info about them."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = nil

function PLUGIN:ShowPlayerInfo( ply )		
	if ( ply:GetProperty( "Nick" ) ) then
		evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " last joined at ", evolve.colors.red, os.date( "%c", ply:GetProperty( "LastJoin" ) ), evolve.colors.white, " as " .. ply:GetProperty( "Nick" ), evolve.colors.white, "." )
		
		ply:SetProperty( "Nick", ply:Nick() )
		ply:SetProperty( "LastJoin", os.time() )
		ply:SetProperty( "SteamID", ply:SteamID() )
		ply:SetProperty( "IPAddress", ply:IPAddress() )
		ply:CommitProperties()
	else
		evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has joined for the first time." )
		
		ply:SetProperty( "Nick", ply:Nick() )
		ply:SetProperty( "LastJoin", os.time() )
		ply:SetProperty( "SteamID", ply:SteamID() )
		ply:SetProperty( "IPAddress", ply:IPAddress() )
		ply:CommitProperties()
	end
end

function PLUGIN:PlayerInitialSpawn( ply )
	ply.EV_IntroductionPending = true
end

function PLUGIN:PlayerSpawn( ply )
	if ( ply.EV_IntroductionPending ) then
		self:ShowPlayerInfo( ply )
		ply.EV_IntroductionPending = false
	end
end

evolve:RegisterPlugin( PLUGIN )