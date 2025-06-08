local CastRayModule = {}

    local RunService    = game:GetService("RunService")
	local GunConfig     = require(game.ReplicatedStorage.Modules.ConfigModule)
	local TracertModule = require(game.ServerStorage.Modules.TracerModule)
	local Counter       = require(game.ServerStorage.Modules.CounterModule)
	
function CastRayModule.Ray(plr,weapon,rayPart,hit,origin,direction)
	local Config = GunConfig[weapon]
	if not Config  then
		warn("Attention")
	end
	
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {plr.Character}
	rayParams.FilterType = Enum.RaycastFilterType.Exclude

	local result = workspace:Raycast(origin, direction * Config.Range, rayParams)
	
	TracertModule.start(plr,rayPart,hit)
	
	if result then
		local hum = result.Instance.Parent:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:TakeDamage(Config.Damage)
		end
	end
end

return CastRayModule
