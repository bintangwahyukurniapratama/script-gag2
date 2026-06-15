-- GaG 2 (Grow a Garden 2) Auto Farm Script with UI
-- Features: Auto Collect Rainbow Seed, Gold Seed, Steal Night

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexsoftware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "GaG 2 Hub by Kyriel", HidePremium = false, SaveConfig = true, ConfigFolder = "GaG2Config"})

-- Variables
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

getgenv().AutoCollectRainbow = false
getgenv().AutoCollectGold = false
getgenv().StealNight = false

-- Utility function to teleport
local function teleportTo(part)
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if Character and Character:FindFirstChild("HumanoidRootPart") and part then
        Character.HumanoidRootPart.CFrame = part.CFrame
        task.wait(0.1)
    end
end

-- Main Auto Collect Loop
task.spawn(function()
    while task.wait(0.5) do
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            if getgenv().AutoCollectRainbow or getgenv().AutoCollectGold then
                local dropsFolder = Workspace:FindFirstChild("Drops") or Workspace
                for _, item in ipairs(dropsFolder:GetChildren()) do
                    if item:IsA("BasePart") or item:IsA("Model") then
                        local itemName = string.lower(item.Name)
                        
                        if getgenv().AutoCollectRainbow and string.find(itemName, "rainbow") and string.find(itemName, "seed") then
                            local targetPart = item:IsA("Model") and item.PrimaryPart or item
                            if targetPart then
                                teleportTo(targetPart)
                                firetouchinterest(Character.HumanoidRootPart, targetPart, 0)
                                firetouchinterest(Character.HumanoidRootPart, targetPart, 1)
                            end
                        end
                        
                        if getgenv().AutoCollectGold and string.find(itemName, "gold") and string.find(itemName, "seed") then
                            local targetPart = item:IsA("Model") and item.PrimaryPart or item
                            if targetPart then
                                teleportTo(targetPart)
                                firetouchinterest(Character.HumanoidRootPart, targetPart, 0)
                                firetouchinterest(Character.HumanoidRootPart, targetPart, 1)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Main Steal Night Loop
task.spawn(function()
    while task.wait(1) do
        if getgenv().StealNight then
            local lighting = game:GetService("Lighting")
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            if remotes and remotes:FindFirstChild("StealNightEvent") then
                remotes.StealNightEvent:FireServer()
            end
            if lighting.ClockTime > 6 and lighting.ClockTime < 18 then
                lighting.ClockTime = 0
            end
        end
    end
end)

-- UI Setup
local FarmTab = Window:MakeTab({
	Name = "Auto Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

FarmTab:AddToggle({
	Name = "Auto Collect Rainbow Seed",
	Default = false,
	Callback = function(Value)
		getgenv().AutoCollectRainbow = Value
	end    
})

FarmTab:AddToggle({
	Name = "Auto Collect Gold Seed",
	Default = false,
	Callback = function(Value)
		getgenv().AutoCollectGold = Value
	end    
})

local MiscTab = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

MiscTab:AddToggle({
	Name = "Steal Night",
	Default = false,
	Callback = function(Value)
		getgenv().StealNight = Value
	end    
})

OrionLib:Init()
