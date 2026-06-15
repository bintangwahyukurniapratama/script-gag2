-- GaG 2 (Grow a Garden 2) Auto Farm Script
-- Features: Auto Collect Rainbow Seed, Gold Seed, Steal Night

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Toggle Settings
getgenv().AutoCollectRainbow = true
getgenv().AutoCollectGold = true
getgenv().StealNight = true

-- Utility function to teleport to an item
local function teleportTo(part)
    if Character and Character:FindFirstChild("HumanoidRootPart") and part then
        Character.HumanoidRootPart.CFrame = part.CFrame
        task.wait(0.1) -- Wait for teleport to register
    end
end

-- Auto Collect Seeds Function
local function autoCollect()
    while getgenv().AutoCollectRainbow or getgenv().AutoCollectGold do
        task.wait(0.5)
        
        -- Loop through all drops in the workspace (adjust path based on actual game structure)
        -- Assuming seeds are stored in a folder called 'Drops' or directly in Workspace
        local dropsFolder = Workspace:FindFirstChild("Drops") or Workspace
        
        for _, item in ipairs(dropsFolder:GetChildren()) do
            if item:IsA("BasePart") or item:IsA("Model") then
                local itemName = string.lower(item.Name)
                
                -- Check for Rainbow Seed
                if getgenv().AutoCollectRainbow and string.find(itemName, "rainbow") and string.find(itemName, "seed") then
                    teleportTo(item:IsA("Model") and item.PrimaryPart or item)
                    -- Fire proximity prompt or touch event here depending on game mechanics
                    firetouchinterest(HumanoidRootPart, item, 0)
                    firetouchinterest(HumanoidRootPart, item, 1)
                end
                
                -- Check for Gold Seed
                if getgenv().AutoCollectGold and string.find(itemName, "gold") and string.find(itemName, "seed") then
                    teleportTo(item:IsA("Model") and item.PrimaryPart or item)
                    firetouchinterest(HumanoidRootPart, item, 0)
                    firetouchinterest(HumanoidRootPart, item, 1)
                end
            end
        end
    end
end

-- Steal Night Function (Changes time or triggers night specific events)
local function stealNight()
    while getgenv().StealNight do
        task.wait(1)
        
        local lighting = game:GetService("Lighting")
        -- If it relies on a specific item or remote event to "steal" night
        -- Example: firing a remote
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("StealNightEvent") then
            remotes.StealNightEvent:FireServer()
        end
        
        -- Or just changing the client time to night if that's what the script implies
        if lighting.ClockTime > 6 and lighting.ClockTime < 18 then
            lighting.ClockTime = 0 -- Set to midnight
        end
    end
end

-- Start loops
task.spawn(autoCollect)
task.spawn(stealNight)

print("GaG 2 Script Loaded! Auto Rainbow, Gold, and Steal Night active.")
