/*-------------------------------------------------------------------------------------------------------------------------
	Imitation
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Imitate"
PLUGIN.Description = "Mimic a player saying something you specify"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "im"
PLUGIN.Usage = "<player> <message>"

function PLUGIN:Call( ply, args )
	// First check if the caller is a superadmin
	if ply:IsSuperAdmin() then
	
		// Find the player to god
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to god this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't imitate a player with an equal or higher rank!"
			end
			
			// Get the optional reason or choose the default N/A
			local Message = ""
			if #args > 1 then
				Message = table.concat( args, " ", 2 )
			else
				return false, "No message specified!"
			end
			
			self:Imitate( pl, Message )
			
			return true
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not a super administrator!"
	end
end

function PLUGIN:Imitate( ply, mess )
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	
	umsg.Start( "EV_Imitate", rf )
		umsg.Entity( ply )
		umsg.String( mess )
	umsg.End( )
end

function Evolve:PlayerMessage( um )
	local ply = um:ReadEntity()
	local msg = um:ReadString()
	
	chat.AddText( team.GetColor( ply:Team() ), ply:Nick() .. ": ", color_white, msg )
end
usermessage.Hook( "EV_Imitate", function( um ) Evolve:PlayerMessage( um ) end )

Evolve:RegisterPlugin( PLUGIN )