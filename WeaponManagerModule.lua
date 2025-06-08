local WeaponManager = {}

local ControlModule = require(game.ReplicatedStorage.Modules.ControlModule)
local ViewModulSway = require(game.ReplicatedStorage.Modules.ViewModelSway)
local ViewModule    = require(game.ReplicatedStorage.Modules.ViewModule   )
local EquippedEvent = game:GetService("ReplicatedStorage").Remotes.EquippedEvent

    local toolConnections  = {} 

function WeaponManager.Equipped(tool,character,player)
	if not tool:IsA("Tool") then return end
	local character = player.Character 
	local camera    = workspace.CurrentCamera
	
	local weapon = tool.Name

	for _, v in pairs(tool:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
		end
	end

	local RayPart = tool:FindFirstChild("RayPart")
	if not RayPart then
		warn("Tool dont have a raypart " ..tool.Name)
		return
	end
    
	ViewModule.LoadViewModel(weapon,camera)
	ViewModulSway.Sway(player,camera,character)
	local ViewModel = camera:FindFirstChild(weapon)
	local RayPart2 = ViewModel:FindFirstChild("RayPart")
	ControlModule.control(player,weapon,RayPart,RayPart2)
	
	EquippedEvent:FireServer(player,weapon,RayPart,"Equipped")
	
	if not toolConnections[tool] then
		toolConnections[tool] = tool.Unequipped:Connect(function()

			ControlModule.stop()
			ViewModulSway.Stop(camera,weapon)
			ViewModule.CleanUp(player)
			EquippedEvent:FireServer(player,weapon,RayPart,"Unequipped")

			if toolConnections[tool] then
				toolConnections[tool]:Disconnect()
				toolConnections[tool] = nil
			end
		end)
	end
end

function WeaponManager.Init(player)
	local function setupToolListener(character)
		character.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				WeaponManager.Equipped(child, character, player)
			end
		end)
	end

	if player.Character then
		setupToolListener(player.Character)
	end

	player.CharacterAdded:Connect(setupToolListener)
end

return WeaponManager
