local modulescript = game:GetService("ServerScriptService"):WaitForChild("LicenseTable")
local licenses = require(modulescript)

function updatelicense(player, text)
	local player = game.Players:FindFirstChild(text)
	if player ~= nil then
		table.insert(licenses, text)
	else
		print("Invalid Input!!!!")
	end
end

function removeplayer(player, text)
	local player = game.Players:FindFirstChild(text)
	if player ~= nil then
		local count = 0
		local removefromplayer = table.find(licenses, text)
		if removefromplayer ~= nil then
			licenses[removefromplayer] = nil
		else
			print("Invalid Input!!!!")
		end
	else
		print("Invalid Input!!!!")
	end
end

script.Parent.Giver.OnServerEvent:Connect(updatelicense)
script.Parent.Remover.OnServerEvent:Connect(removeplayer)
