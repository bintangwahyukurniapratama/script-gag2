-- GaG 2 Simple UI Auto Farm Script
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

getgenv().AutoCollectRainbow = false
getgenv().AutoCollectGold = false
getgenv().StealNight = false

-- Remove old UI if it exists
if CoreGui:FindFirstChild("KyrielGaG2Hub") then
    CoreGui.KyrielGaG2Hub:Destroy()
end

-- Create Basic UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KyrielGaG2Hub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "GaG 2 Hub by Kyriel"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

local function createToggle(name, yPos, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, -20, 0, 30)
    ToggleBtn.Position = UDim2.new(0, 10, 0, yPos)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = name .. " [OFF]"
    ToggleBtn.Parent = MainFrame
    
    local state = false
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            ToggleBtn.Text = name .. " [ON]"
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            ToggleBtn.Text = name .. " [OFF]"
        end
        callback(state)
    end)
end

createToggle("Auto Rainbow Seed", 40, function(val) getgenv().AutoCollectRainbow = val end)
createToggle("Auto Gold Seed", 80, function(val) getgenv().AutoCollectGold = val end)
createToggle("Steal Night", 120, function(val) getgenv().StealNight = val end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -20, 0, 30)
CloseBtn.Position = UDim2.new(0, 10, 0, 210)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "Close Menu"
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Farming Logic
local function teleportTo(part)
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if Character and Character:FindFirstChild("HumanoidRootPart") and part then
        Character.HumanoidRootPart.CFrame = part.CFrame
        task.wait(0.1)
    end
end

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

task.spawn(function()
    while task.wait(1) do
        if getgenv().StealNight then
            local lighting = game:GetService("Lighting")
            if lighting.ClockTime > 6 and lighting.ClockTime < 18 then
                lighting.ClockTime = 0
            end
        end
    end
end)
