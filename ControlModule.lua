local ControlModule = {}

local uis       = game:GetService("UserInputService")
local run       = game:GetService("RunService")
local RayEvent  = game.ReplicatedStorage.Remotes.RayEvent
local GunConfig = require(game.ReplicatedStorage.Modules.ConfigModule )
local RayModule = require(game.ReplicatedStorage.Modules.CastRayModule)
local GuiModule = require(game.ReplicatedStorage.Modules.GuiModule)

	local shooting         = false
    local connections      = {}
	local RenderConnection = nil
	local PlayerAmmo       = {}
	local IsReloading      = true
    local CurrentWeapon    = nil
	
function ControlModule.control(plr,weapon,rayPart,RayPart2)
	local Config = GunConfig[weapon]
	if not Config then
		warn("config"..Config)
		return Config
	end
	
	CurrentWeapon = weapon
	
	plr.CharacterAdded:Connect(function()
		PlayerAmmo[weapon] = nil
	end)
	
	local mouse = plr:GetMouse()
	local fireRate = Config.FireRate
	local lastShot = 0

	PlayerAmmo[weapon] = PlayerAmmo[weapon] or {
		Current = Config.Ammo,
		Max = Config.MaxAmmo,
	}

	local ammo = PlayerAmmo[weapon]
	if not ammo then return end
	GuiModule.Gui(plr,ammo.Current,weapon)
	table.insert(connections,uis.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.R and IsReloading and ammo.Current < ammo.Max then
			shooting = false
			IsReloading = false
			
			RayEvent:FireServer("ReloadAction",weapon,rayPart)
			task.delay(Config.ReloadTime,function()
				if CurrentWeapon == weapon then
					ammo.Current = ammo.Max
					GuiModule.GuiUp(plr,ammo.Current,weapon)
				end
				IsReloading = true
			end)
		end
	end))

	table.insert(connections,mouse.Button1Down:Connect(function()
		if RenderConnection then return end
		shooting = true
		
		--lastShot = os.clock() - fireRate 
		RenderConnection = run.RenderStepped:Connect(function(deltaTime)
			if shooting and IsReloading and (os.clock() - lastShot) >= fireRate and ammo.Current > 0 then
				lastShot = os.clock()
				local hit = mouse.Hit.Position
				ammo.Current -= 1
				GuiModule.GuiUp(plr,ammo.Current,weapon)
				RayModule.Ray(plr,weapon,rayPart,RayPart2,hit)
			end
		end)
	end))

	table.insert(connections,mouse.Button1Up:Connect(function()
		shooting = false
		if RenderConnection then
			RenderConnection:Disconnect()
			RenderConnection = nil
		end
	end))
end

function ControlModule.stop()
	    CurrentWeapon = nil
	for _, conn in pairs(connections) do
		if conn.Connected then
			conn:Disconnect()
		end
	end
	table.clear(connections)

	if RenderConnection then
		RenderConnection:Disconnect()
		RenderConnection = nil
	end
end

return ControlModule
