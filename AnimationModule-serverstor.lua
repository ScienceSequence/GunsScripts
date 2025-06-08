local AnimationModule = {}

local track

function AnimationModule.Hold(player,weapon)
	
	local character = player.Character
	local hum = character:FindFirstChildOfClass("Humanoid")
	if not hum  then
		warn("character warn"..tostring(character))
		return
	end
	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator  then
		warn("Animator warn"..tostring(hum))
		return
	end
	
	local AnimFolder = game:GetService("ReplicatedStorage").Animations
	local animFolder = AnimFolder:FindFirstChild(weapon)
	if not animFolder  then
		warn("animfolder warn"..animFolder)
		return
	end
	
	local anim = animFolder:FindFirstChild(weapon.."_Hold")
	if not anim then
		warn("anim warn")
		return
	end
	track = animator:LoadAnimation(anim)
	track:Play()
end

function AnimationModule.Stop()
	if track then
		track:Stop()
	end
end


return AnimationModule
