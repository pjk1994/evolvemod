/*-------------------------------------------------------------------------------------------------------------------------
	Admin chat
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Admin Chat"
PLUGIN.Description = "Prints your message to fellow admins only"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "a"
PLUGIN.Usage = "<message>"

function PLUGIN:Call( ply, args )
	if ply:IsAdmin() then
		if #args > 0 then
			local msg = table.concat( args, " " )
			
			// Print to admins
			local rf = RecipientFilter()
			for _, v in pairs( player.GetAll() ) do if v:IsAdmin() then rf:AddPlayer( v ) end end
			
			umsg.Start( "EV_AdminMessage", rf )
				umsg.Entity( ply )
				umsg.String( msg )
			umsg.End( )
			
			return true
		else
			return false, "No message specified!"
		end
	else
		return false, "You need to be an administrator to use this command!"
	end
end

function Evolve:AdminMessage( um )
	local ply = um:ReadEntity()
	local msg = um:ReadString()
	
	chat.AddText( team.GetColor( ply:Team() ), "(ADMIN) " .. ply:Nick() .. ": ", color_white, msg )
end
usermessage.Hook( "EV_AdminMessage", function( um ) Evolve:AdminMessage( um ) end )

Evolve:RegisterPlugin( PLUGIN )