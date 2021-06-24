local tool = script.Parent
local ammo = tool:WaitForChild("Ammo")
local shoot_part = tool:WaitForChild("Needle")
local onshoot = tool:WaitForChild("OnShoot")
local onreload = tool:WaitForChild("OnReload")

local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")
local player = game.Players:GetPlayerFromCharacter(script.Parent.Parent)
local debounce = false
local reloading = false
local equipped = false

local function equip()
	if equipped == false then
		equipped = true
		
		local function equipsound()
			local sound = Instance.new("Sound", tool)
			sound.SoundId = "rbxassetid://1498950813"
			sound.Volume = 1
			sound.PlaybackSpeed = 1
			sound:Play()
			coroutine.resume(coroutine.create(function()
				wait(1.358)
				sound:Destroy()
			end))
		end
		
		equipsound() 
	end
end

local function unequip()
	if equipped == true then
		equipped = false
		
		local function unequipsound()
			local sound = Instance.new("Sound", tool)
			sound.SoundId = "rbxassetid://5917818749" 
			sound.Volume = 1
			sound.PlaybackSpeed = 1
			sound:Play()
			coroutine.resume(coroutine.create(function()
				wait(1.358)
				sound:Destroy()
			end))
		end
		
		unequipsound()
	end
end

local function reload()
	if reloading == false and equipped == true then
		if ammo.Value == 0 then
			reloading = true
			
			local function reloadsound()
				local sound = Instance.new("Sound", tool)
				sound.SoundId = "rbxassetid://5214579647"
				sound.Volume = 1
				sound.PlaybackSpeed = 1
				sound:Play()
				coroutine.resume(coroutine.create(function()
					wait(1.358)
					sound:Destroy()
				end))
			end
			
			ammo.Value = 30
			reloadsound()
			wait(1)
			reloading = false
		elseif ammo > 0 and ammo < 30 then 
			print("Not out of Ammo!")
		else
			ammo.Value = 0
			print("Returned to 0 ammo.")
		end
	end
end

local function shoot(player, position)
	if debounce == false and reloading == false and equipped == true then
		debounce = true
		if ammo.Value >= 1 then
			local function sound()
				local sound = Instance.new("Sound", tool)
				sound.SoundId = "rbxassetid://6911684149" 
				sound.Volume = 0.5
				sound.PlaybackSpeed = 1
				sound:Play()
				coroutine.resume(coroutine.create(function()
					wait(1.358)
					sound:Destroy()
				end))
			end
			
			ammo.Value -= 1
			sound()
			local origin = shoot_part.Position
			local direction = (position - origin).Unit*300
			local result = Workspace:Raycast(origin, direction)

			local intersection = result and result.Position or origin + direction
			local distance = (origin - intersection).Magnitude

			local bullet_clone = tool.Needle:Clone()
			bullet_clone.Size = Vector3.new(0.1, 0.1, 1)
			bullet_clone.CanCollide = false
			bullet_clone.CFrame = CFrame.new(origin, intersection)*CFrame.new(0, 0, -distance/2)
			bullet_clone.Parent = Workspace
			if bullet_clone:GetChildren() ~= nil then
				local children = bullet_clone:GetChildren()
				for i, v in pairs(children) do
					v:Destroy()
				end
			end
			
			if result then
				local part = result.Instance
				local humanoid = part.Parent:FindFirstChild("Humanoid") or part.Parent.Parent:FindFirstChild("Humanoid")
				if humanoid then
					if humanoid.Parent ~= script.Parent.Parent then
						local player = game.Players:GetPlayerFromCharacter(humanoid.Parent)
						local weld = Instance.new("WeldConstraint", bullet_clone) 
						weld.Part0 = part
						weld.Part1 = bullet_clone 
						if player ~= nil then
							for i, v in pairs(humanoid.Parent:GetChildren()) do
								if v ~= humanoid then
									if v:IsA("MeshPart") then
										v.BrickColor = BrickColor.new(tool.Serum.Color)
									end
								end
							end
							humanoid:TakeDamage(10)
						end
					end 
				end
			end
			
			wait(1.5)
			debounce = false
			wait(20)
			game:GetService("Debris"):AddItem(bullet_clone, 1)
		end
	end
end

onshoot.OnServerEvent:Connect(shoot)
onreload.OnServerEvent:Connect(reload)
tool.Equipped:Connect(equip)
tool.Unequipped:Connect(unequip)
