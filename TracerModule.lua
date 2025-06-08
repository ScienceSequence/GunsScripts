local Tracer = {}

function Tracer.start(plr,rayPart)
	local mouse = plr:GetMouse()
	
	local Att0   = rayPart:FindFirstChild("Att0")
	local Att1   = rayPart:FindFirstChild("Att1")
	local Beam   = rayPart:FindFirstChild("Beam")
	local debris = game:GetService("Debris")

	if not (Att0 and Att1 and Beam) then return end
	if not mouse then return end

	local att1Clone = Att1:Clone()
	local beamClone = Beam:Clone()

	att1Clone.WorldPosition = mouse.Hit.Position
	att1Clone.Parent        = workspace.Terrain

	beamClone.Attachment0 = Att0
	beamClone.Attachment1 = att1Clone
	beamClone.Parent      = rayPart

	debris:AddItem(beamClone, 0.06)
	debris:AddItem(att1Clone, 0.06)
end

return Tracer
