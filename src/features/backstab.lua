local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Backstab = {}
Backstab.enabled = false

function Backstab:teleportBehind(player)
    if not player or not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and myHRP then
        myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
    end
end

function Backstab:start()
    -- Esta função deve ser acionada por um keybind (ex: botão do meio do mouse)
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton3 and Backstab.enabled then
            local target = Players:GetPlayerFromCharacter(game.Players.LocalPlayer:GetMouse().Target)
            if target and target.Character and target.Team ~= LocalPlayer.Team then
                Backstab:teleportBehind(target)
                -- Simula ataque com faca
                -- ...
            end
        end
    end)
end

return Backstab