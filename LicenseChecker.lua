local tool = script.Parent
local licenses = {"bentnicknick", "Hi29YOLO"}

local function checklicense()
	if equipped == false then
		equipped = true
		local allowed = false
		for i, v in pairs(licenses) do
			if script.Parent.Parent.Name == v then
				allowed = true
			end
		end
		if allowed == false then
			local player = game.Players:GetPlayerFromCharacter(script.Parent.Parent)
			player:Kick("No doing illegal stuff.")
		else
			print("Allowed to use syringe.")
		end
	end
end

local function attempttopickup()
	
	local function touched(character)
		if character.Parent:FindFirstChild("Humanoid") then
			if character.Parent.Humanoid.Health > 0 then
				if character ~= nil then
					local allowed = false
					local player = game.Players:GetPlayerFromCharacter(character.Parent)
					for i, v in pairs(licenses) do
						if tool.Parent.Name == v then
							allowed = true
						end
					end
					if allowed == true then
						for v = 1, 10, 1 do
							wait(1)
							player.Character:BreakJoints()
						end
						if player ~= nil and game.Workspace:FindFirstChild("player.Character") then
							player:Kick("Imagine trying to cheat the system.")
						end
					end
				end
			end
		end
	end
	
	if tool.Parent == game.Workspace then
		for i, v in pairs(tool:GetChildren()) do
			if v:IsA("Part") or v:IsA("UnionOperation") then
				v.Touched:Connect(touched)
			end
		end
	end
end

local function unequip()
	if equipped == true then
		equipped = false
	end
end

tool.Equipped:Connect(checklicense)
tool.Unequipped:Connect(unequip)
game.Workspace.ChildAdded:Connect(function(item)
	if item:IsA("Tool") then
		if item.Name == "Syringe" then
			attempttopickup()
		end
	end
end)
