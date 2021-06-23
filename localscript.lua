local tool = script.Parent
local onshoot = tool:WaitForChild("OnShoot")
local onreload = tool:WaitForChild("OnReload")
local userinputservice = game:GetService("UserInputService")
local ammo = tool:WaitForChild("Ammo")
local gui = tool:WaitForChild("ToolGUI")
local reloading = false
local equipped = false

local animations = {script.EquippedAnimation, script.UnequippedAnimation, script.ReloadAnimation, script.ShootAnimation}

local Players = game:GetService("Players")
local client = Players.LocalPlayer
local animator = client.Character:WaitForChild("Humanoid"):WaitForChild("Animator")
local cursor = client:GetMouse() 
local userinputservice = game:GetService("UserInputService")

local function equip()
	if equipped == false then
		equipped = true 
		local loadanimation = animator:LoadAnimation(animations[1])
		loadanimation:Play()
		local newgui = gui:Clone()
		newgui.Parent = client.PlayerGui
		if equipped == true and reloading == false then
			while equipped == true and reloading == false and wait() do 
				if equipped == false then 
					break
				elseif reloading == true then
					while wait() do
						if reloading == false then
							break 
						end
					end
				else
					newgui.Frame.TextLabel.Text = ammo.Value.."/30"
				end
			end
			loadanimation:Stop()
		else
			print("No.")
		end
	end
end

local function unequip()
	if equipped == true then
		equipped = false
		local loadanimation = animator:LoadAnimation(animations[2])
		loadanimation:Play()
		if client.PlayerGui:FindFirstChild("ToolGUI") ~= nil then
			local newgui = client.PlayerGui:FindFirstChild("ToolGUI")
			newgui:Destroy()
		else
			local newgui = client.PlayerGui:WaitForChild("ToolGUI")
			newgui:Destroy()
		end
		loadanimation:Stop()
	end
end

local function reload(input, gameprocessed)
	if input ~= nil then
		if input.KeyCode == Enum.KeyCode.R then
			if reloading == false and equipped == true then
				if ammo.Value == 0 then
					local loadanimation = animator:LoadAnimation(animations[3])
					loadanimation:Play()
					reloading = true 
					local newgui = client.PlayerGui:WaitForChild("ToolGUI")
					newgui.Frame.TextLabel.Text = "Reloading..."
					onreload:FireServer() 
					wait(2.358)
					newgui.Frame.TextLabel.Text = "30/30"
					reloading = false
				  loadanimation:Stop()
				else
					print("No.")
				end
			end
		end
	end
end 

local function shoot()
	if reloading == false and equipped == true then
		local loadanimation = animator:LoadAnimation(animations[4])
		loadanimation:Play()
		onshoot:FireServer(cursor.Hit.Position)
		loadanimation:Stop()
	else
		print("Not Reloading...")
	end
end

tool.Activated:Connect(shoot)
tool.Equipped:Connect(equip)
tool.Unequipped:Connect(unequip)
userinputservice.InputBegan:Connect(reload)
