local ViewModule = {}

function ViewModule.LoadViewModel(weapon,camera)
	local ViewModeles = game:GetService("ReplicatedStorage").ViewModels
	local ViewModel = ViewModeles:FindFirstChild(weapon)
	
	if not ViewModel then
		warn("tool dont have viewmodel ".. weapon)
	end
	
	local ViewModelClon = ViewModel:Clone()
	ViewModelClon.Parent = camera
	
	return ViewModelClon
end

function ViewModule.CleanUp(player)
	local hud = player:FindFirstChild("PlayerGui"):FindFirstChild("HUD")
	if hud then
		hud:Destroy()
	end
end


return ViewModule
