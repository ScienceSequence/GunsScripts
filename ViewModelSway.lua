local ViewModelSway = {}

local RunService = game:GetService("RunService")

local SwayAMT = 10;
local SwayCF = CFrame.new()
local LastCameraCF = CFrame.new()

local connection

function ViewModelSway.Sway(player,camera,character)

	connection = RunService.RenderStepped:Connect(function(deltaTime)

		local rot = camera.CFrame:ToObjectSpace(LastCameraCF)
		local X, Y, Z = rot:ToOrientation()

		local swayX = math.clamp(X, -1, 1) * SwayAMT
		local swayY = math.clamp(Y, -1, 1) * SwayAMT
		local swayZ = math.clamp(Z, -1, 1) * SwayAMT

		local hum = character:FindFirstChildOfClass("Humanoid")
		if hum then
			local BobOffset = CFrame.new()

			if hum.MoveDirection.Magnitude > 0  then
				BobOffset = CFrame.new(-hum.CameraOffset.X/3,-hum.CameraOffset.Y/3,-hum.CameraOffset.Z/3) * CFrame.Angles(0,math.sin(tick() * -4) * .05, math.cos(tick() * -4) * .05)

				local HeadBoby = math.sin(tick() * 10) * .1
				local bob = Vector3.new(0,HeadBoby,0)

				hum.CameraOffset = hum.CameraOffset:Lerp(bob, math.clamp(deltaTime * 10,0,1))
			else
				local breath = math.sin(tick() * 2) * .0005
				SwayCF *= CFrame.Angles(breath, 0, 0)
				hum.CameraOffset = hum.CameraOffset:Lerp(Vector3.new(), math.clamp(deltaTime * 10,0,1))
			end

			for i,v in pairs(camera:GetChildren()) do
				if v:IsA("Model") then
					v:SetPrimaryPartCFrame(camera.CFrame * SwayCF * BobOffset)
				end
			end
		end

		SwayCF = SwayCF:Lerp(
			CFrame.Angles(swayX, swayY, swayZ),
			math.clamp(deltaTime * 8, 0, 1)
		)
		
        LastCameraCF = camera.CFrame
	end)
end

function ViewModelSway.Stop(camera,weapon)
	local viewModel = camera:FindFirstChild(weapon)
	
	if connection then
		connection:Disconnect()
		connection = nil
	end

	if viewModel then
		viewModel:Destroy()
	end
end

return ViewModelSway
