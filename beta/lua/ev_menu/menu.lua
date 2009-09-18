/*-------------------------------------------------------------------------------------------------------------------------
	Evolve GUI clientside
-------------------------------------------------------------------------------------------------------------------------*/

evolve.menuw = 600
evolve.menuh = 400
evolve.menutabs = { }

function evolve:registerMenuTab( funcBuild, funcUpdate, minRank )
	local tab = { }
	tab.build = funcBuild
	tab.update = funcUpdate
	tab.rank = minRank
	
	table.insert( self.menutabs, tab )
end

function evolve:buildMenu()	
	self.menu = vgui.Create( "DFrame" )
	self.menu:SetSize( self.menuw, self.menuh )
	self.menu:SetPos( ScrW() / 2 - self.menuw / 2, ScrH() / 2 - self.menuh / 2 )
	self.menu:SetDraggable( false )
	self.menu:ShowCloseButton( false )
	self.menu:SetTitle( "" )
	self.menu.Paint = function() end
	self.menu:MakePopup()
	
	self.menuContainer = vgui.Create( "DPropertySheet", self.menu )
	self.menuContainer:SetPos( 0, 0 )
	self.menuContainer:SetSize( self.menuw, self.menuh )
	
	include( "ev_menu/control_toolbutton.lua" )
	for _, v in pairs( file.FindInLua( "ev_menu/tab_*.lua" ) ) do
		include( "ev_menu/" .. v )
		
		self.menutabs[ #self.menutabs ].build()
	end
end

function evolve:openMenu()
	if ( !LocalPlayer():EV_IsAdmin() ) then return false end
	if ( !self.menu ) then self:buildMenu() end
	
	for _, tab in pairs( self.menutabs ) do
		tab.update()
	end
	
	self.menu:SetVisible( true )
end

function evolve:closeMenu()
	self.menu:SetVisible( false )
end

concommand.Add( "+ev_menu", function()
	evolve:openMenu()
end )
concommand.Add( "-ev_menu", function()
	evolve:closeMenu()
end )