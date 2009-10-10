/*-------------------------------------------------------------------------------------------------------------------------
	Groups tab
-------------------------------------------------------------------------------------------------------------------------*/

local TAB = {}
TAB.Title = "Groups"
TAB.Description = "Configure user groups/ranks."
TAB.Author = "Overv"

function TAB:Initialize()
	self.Container = vgui.Create( "DPanel", evolve.menuContainer )
	self.Container:SetSize( evolve.menuw - 10, evolve.menuh )
	self.Container.Paint = function() end
	evolve.menuContainer:AddSheet( self.Title, self.Container, "gui/silkicons/application_view_detail", false, false, self.Description )
end

function TAB:Update()
	
end

evolve:RegisterMenuTab( TAB )