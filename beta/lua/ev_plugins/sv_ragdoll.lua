/*-------------------------------------------------------------------------------------------------------------------------
	Ragdoll a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Ragdoll"
PLUGIN.Description = "Ragdoll a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "ragdoll"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in pairs( pls ) do
			if ( enabled ) then
				if ( !pl.EV_Ragdolled and pl:Alive( ) ) then
					pl:DrawViewModel( false )
					pl:StripWeapons( )
					
					local doll = ents.Create( "prop_ragdoll" )
					doll:SetModel( pl:GetModel( ) )
					doll:SetPos( pl:GetPos( ) )
					doll:SetAngles( pl:GetAngles( ) )
					doll:Spawn( )
					doll:Activate( )
					
					pl.EV_Ragdoll = doll
					pl:Spectate( OBS_MODE_CHASE )
					pl:SpectateEntity( pl.EV_Ragdoll )
					pl:SetParent( pl.EV_Ragdoll )
					
					pl.EV_Ragdolled = true
				end
			else
				pl:SetNoTarget( false )
				pl:SetParent( )
				pl.EV_Ragdolled = false
				pl:Spawn( )
			end
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has ragdolled ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has unragdolled ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			end
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:CanPlayerSuicide( ply )
	ply.EV_Ragdolled = false
	ply:SetNoTarget( false )
	ply:SetParent( )
end

function PLUGIN:PlayerDisconnect( ply )
	if ( ply.EV_Ragdoll and ply.EV_Ragdoll:IsValid( ) ) then ply.EV_Ragdoll:Remove( ) end
end

function PLUGIN:PlayerSpawn( ply )
	if ( !ply.EV_Ragdolled and ply.EV_Ragdoll and ply.EV_Ragdoll:IsValid( ) ) then
		ply:SetPos( ply.EV_Ragdoll:GetPos( ) + Vector( 0, 0, 10 ) )
		ply.EV_Ragdoll:Remove( )
		ply.EV_Ragdoll = nil
	end
end

evolve:registerPlugin( PLUGIN )