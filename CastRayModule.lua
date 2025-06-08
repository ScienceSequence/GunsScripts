local CastRayModule = {}

    local RunService   = game:GetService("RunService")
	local GunConfig    = require(game.ReplicatedStorage.Modules.ConfigModule)
	local TracerModule = require(game.ReplicatedStorage.Modules.TracerModule)
    local RayEvent     = game:GetService("ReplicatedStorage").Remotes.RayEvent
	
function CastRayModule.Ray(plr,weapon,rayPart,RayPart2,hit)
	local Config = GunConfig[weapon]
	if not Config  then
		warn("Attention")
	end
	
	local camera = workspace.CurrentCamera
	local origin = camera.CFrame.Position
	local direction = camera.CFrame.LookVector
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
	rayParams.FilterType = Enum.RaycastFilterType.Exclude

	local result = workspace:Raycast(origin, direction * Config.Range, rayParams)

	TracerModule.start(plr,RayPart2)
	
	if result then
	end
	RayEvent:FireServer("Fire",weapon,rayPart,hit,origin,direction)
end

return CastRayModule
