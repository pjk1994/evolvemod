/*-------------------------------------------------------------------------------------------------------------------------
	Player name boxes
-------------------------------------------------------------------------------------------------------------------------*/
if CLIENT then

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Player Boxes"
PLUGIN.Description = "Displays boxes with names and avatars above players"
PLUGIN.Author = "Overv"

/*-------------------------------------------------------------------------------------------------------------------------
	The playerbox vgui panel
-------------------------------------------------------------------------------------------------------------------------*/
local PANEL = {}

// Initialisation code
function PANEL:Init( )
	// Set default size
	self:SetTall( 24 )
	self:SetWide( 24 )
	
	// Create avatar image
	local av = vgui.Create( "AvatarImage", self )
	av:SetSize( 16, 16 )
	av:SetPos( 4, 4 )
	self.Avatar = av
end

// Set the player the box belongs to
function PANEL:SetPlayer( ply )
	self.Player = ply
	
	// Update avatar
	self.Avatar:SetPlayer( ply )
	self.Avatar:InvalidateLayout( )
end

function PANEL:Paint( )
	if self.Player then
		// Resize to fit
		surface.SetFont( "ScoreboardText" )
		self:SetWide( surface.GetTextSize( self.Player:Nick() ) + 32 )
		
		// Update position
		local headIndex = self.Player:LookupBone( "ValveBiped.Bip01_Head1" )
		local headPos = self.Player:GetBonePosition( headIndex )
		local drawPos = headPos:ToScreen( )
		local pDistance = LocalPlayer():GetShootPos():Distance( headPos )
		drawPos.y = drawPos.y - 50
		drawPos.y = drawPos.y + 100 * pDistance / 4096
		drawPos.x = drawPos.x - self:GetWide() / 2
		drawPos.y = drawPos.y  - self:GetTall() / 2
		
		// Check visibility
		local td = { }
		td.start = LocalPlayer():GetShootPos( )
		td.endpos = headPos
		local trace = util.TraceLine( td )
		
		if drawPos.x + self:GetWide() > 0 and drawPos.y + self:GetTall() > 0 and drawPos.x < ScrW() and drawPos.y < ScrH() and pDistance <= 2048 and !trace.HitWorld then
			self:SetPos( drawPos.x, drawPos.y )
			
			//Calculate alpha
			local Alpha = 128
			if pDistance > 512 then
				Alpha = 128 - math.Clamp( ( pDistance - 512 ) / ( 2048 - 512 ) * 128, 0, 128 )
			end
			
			// Draw the background
			surface.SetDrawColor( 0, 0, 0, Alpha )
			surface.DrawRect( 0, 0, self:GetWide( ), self:GetTall( ) )
			
			// Draw the player name
			local teamColor = team.GetColor( self.Player:Team() )
			draw.DrawText( self.Player:Nick(), "ScoreboardText", 28, 4, Color( teamColor.r, teamColor.g, teamColor.b, Alpha ), 0 )
		end
	end
end

derma.DefineControl( "PlayerBox", "A box holding a player's name and avatar", PANEL, "DPanel" )

/*-------------------------------------------------------------------------------------------------------------------------
	Create boxes for joining players
-------------------------------------------------------------------------------------------------------------------------*/

function PLUGIN:HUDPaint( )
	for _, v in pairs( player.GetAll() ) do
		if !v.EV_PBox and v != LocalPlayer() then
			local pb = vgui.Create( "PlayerBox" )
			pb:SetPos( 10, 10 )
			pb:SetPlayer( v )
			v.EV_PBox = pb
			Msg( "Created playerbox!\n" )
		end
	end
end

Evolve:RegisterPlugin( PLUGIN )

end