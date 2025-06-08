local Players = game:GetService("Players")
local player  = Players.LocalPlayer
local camera  = workspace.CurrentCamera
local mouse = player:GetMouse()
mouse.Icon = "rbxassetid://15059193546"

local TracerEvent     = game:GetService("ReplicatedStorage").Remotes.TracerEvent

local WeaponManagerModule = require(game.ReplicatedStorage.Modules.WeaponManagerModule)
WeaponManagerModule.Init(player)

TracerEvent.OnClientEvent:Connect(function(Beam)
	Beam.Enabled = false
	Beam:Destroy()
end)
