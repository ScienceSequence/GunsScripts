local GuiModule = {}

local textlabel
local textlabel2
local textlabel3


function GuiModule.Gui(plr,ammo,weapon)
	local HUD = game:GetService("ReplicatedStorage"):WaitForChild("GUI"):WaitForChild("HUD")
	local Gui = HUD:Clone()
	Gui.Enabled = true
	Gui.Parent = plr:WaitForChild("PlayerGui")
	
	textlabel = Gui:WaitForChild("Ammo"):WaitForChild("AmmoT")
	textlabel.Text = ammo.."/&"
	textlabel2 = Gui:WaitForChild("Name"):WaitForChild("NameT")
	textlabel2.Text = weapon
	textlabel3 = Gui:WaitForChild("Fire"):WaitForChild("FireT")
	textlabel3.Text = "-"
	
end

function GuiModule.GuiUp(plr,ammo,weapon)
	
	local Pgui = plr:FindFirstChild("PlayerGui")
	if not Pgui then return end
	local Hud = Pgui:FindFirstChild("HUD")
	if not Hud then return end
	
	
	textlabel = Hud:WaitForChild("Ammo"):WaitForChild("AmmoT")
	textlabel.Text = ammo.."/&"
end

function GuiModule.GuiClean(plr)
	local Gui = plr:FindFirstChild("PlayerGui"):FindFirstChild("HUD")
	if Gui then
		Gui:Destroy()
	end
end

return GuiModule
