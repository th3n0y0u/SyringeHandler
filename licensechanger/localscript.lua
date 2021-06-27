local function onEntered()
	script.Parent.Giver:FireServer(script.Parent.AddingPlayer.Text)
end

local function notonEntered()
	script.Parent.Remover:FireServer(script.Parent.RemovingPlayer.Text)
end

script.Parent.AddingPlayer.FocusLost:Connect(onEntered)
script.Parent.RemovingPlayer.FocusLost:Connect(notonEntered)
