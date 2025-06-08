local RayEvent        = game:GetService("ReplicatedStorage").Remotes.RayEvent
local EquippedEvent   = game:GetService("ReplicatedStorage").Remotes.EquippedEvent

local CastRayModule   = require(game.ServerStorage.Modules.CastRayModule   )
local AnimationModule = require(game.ServerStorage.Modules.AnimationModule )
local GunConfig       = require(game.ReplicatedStorage.Modules.ConfigModule)
local TracerModule    = require(game.ServerStorage.Modules.TracerModule    )

    local PlayerAmmo    = {}
	local IsReloading   = true
    local CurrentWeapon = nil

EquippedEvent.OnServerEvent:Connect(function(player,weapon,tool,RayPart,Action)
	if Action == "Equipped" then
		AnimationModule.Hold(player,tool)
	elseif Action == "Unequipped" then
		AnimationModule.Stop()
	end
end)

game.Players.PlayerRemoving:Connect(function(plr)
	PlayerAmmo[plr] = nil
end)
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		PlayerAmmo[player] = nil
	end)
end)

RayEvent.OnServerEvent:Connect(function(plr,Action,weapon,rayPart,hit,origin,direction)
	if not plr then return end
	local Config = GunConfig[weapon]
	if not Config then
		warn("Attention")
	end
	
	CurrentWeapon = weapon
	
	PlayerAmmo[plr] = PlayerAmmo[plr] or {}
	PlayerAmmo[plr][weapon] = PlayerAmmo[plr][weapon] or {
		Current = Config.Ammo,
		Max = Config.MaxAmmo,
		IsReloading = true,
	}
	local ammo = PlayerAmmo[plr][weapon]
	if not ammo then return end
	
	if Action == "Fire" and ammo.Current > 0 and ammo.IsReloading then
		local Sfire = rayPart:FindFirstChild("Fire")
		CastRayModule.Ray(plr,weapon,rayPart,hit,origin,direction)
		ammo.Current -= 1
		Sfire:Play()
	elseif Action == "ReloadAction" and ammo.Current < ammo.Max and ammo.IsReloading then
		local SReload = rayPart:FindFirstChild("Reload")
		ammo.IsReloading = false
		SReload:Play()
		task.delay(Config.ReloadTime,function()
			if CurrentWeapon == weapon then
				ammo.Current = ammo.Max
			end
			ammo.IsReloading = true
		end)
	end
end)

