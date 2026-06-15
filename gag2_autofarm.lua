-- GaG 2 Universal UI Auto Farm Script
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

getgenv().AutoCollectRainbow = false
getgenv().AutoCollectGold = false
getgenv().StealNight = false

-- Remove old UI
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

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "GaG 2 Hub by Kyriel"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = TopBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 40, 1, 0)
MinBtn.Position = UDim2.new(1, -40, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 18
MinBtn.Parent = TopBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ContentFrame.Visible = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 200, 0, 30)
        MinBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 200, 0, 250)
        MinBtn.Text = "-"
    end
end)

local function createToggle(name, yPos, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, -20, 0, 30)
    ToggleBtn.Position = UDim2.new(0, 10, 0, yPos)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = name .. " [OFF]"
    ToggleBtn.Parent = ContentFrame
    
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

createToggle("Auto Rainbow Seed", 10, function(val) getgenv().AutoCollectRainbow = val end)
createToggle("Auto Gold Seed", 50, function(val) getgenv().AutoCollectGold = val end)
createToggle("Steal Fruit (Night)", 90, function(val) getgenv().StealNight = val end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -20, 0, 30)
CloseBtn.Position = UDim2.new(0, 10, 0, 180)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "Close Menu"
CloseBtn.Parent = ContentFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Universal Farming Logic
local function teleportTo(part)
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if Character and Character:FindFirstChild("HumanoidRootPart") and part then
        Character.HumanoidRootPart.CFrame = part.CFrame
        task.wait(0.15)
    end
end

local function interactWith(part)
    -- Try touch
    local Character = LocalPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        firetouchinterest(Character.HumanoidRootPart, part, 0)
        firetouchinterest(Character.HumanoidRootPart, part, 1)
    end
    -- Try ProximityPrompt
    local prompt = part:FindFirstChildWhichIsA("ProximityPrompt")
    if prompt then
        fireproximityprompt(prompt)
    end
    -- Try ClickDetector
    local click = part:FindFirstChildWhichIsA("ClickDetector")
    if click then
        fireclickdetector(click)
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoCollectRainbow or getgenv().AutoCollectGold then
            -- Scan entire workspace to be safe instead of just a Drops folder
            for _, item in ipairs(Workspace:GetDescendants()) do
                if item:IsA("BasePart") or item:IsA("Model") then
                    local itemName = string.lower(item.Name)
                    local isRainbow = string.find(itemName, "rainbow")
                    local isGold = string.find(itemName, "gold")
                    local isSeed = string.find(itemName, "seed") or string.find(itemName, "drop")
                    
                    local targetPart = item:IsA("Model") and item.PrimaryPart or item
                    
                    if getgenv().AutoCollectRainbow and isRainbow and targetPart then
                        teleportTo(targetPart)
                        interactWith(targetPart)
                    end
                    
                    if getgenv().AutoCollectGold and isGold and targetPart then
                        teleportTo(targetPart)
                        interactWith(targetPart)
                    end
                end
            end
        end
    end
end)

-- Steal Night (Steal Fruit at Night) Logic
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().StealNight then
            -- Find all crops/fruits in workspace to steal
            for _, item in ipairs(Workspace:GetDescendants()) do
                if item:IsA("BasePart") or item:IsA("Model") then
                    local itemName = string.lower(item.Name)
                    -- Often crops have specific names or ProximityPrompts with action "Harvest" or "Steal"
                    local prompt = item:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt then
                        local actionText = string.lower(prompt.ActionText)
                        if string.find(actionText, "harvest") or string.find(actionText, "steal") or string.find(actionText, "pick") then
                            local targetPart = item:IsA("Model") and item.PrimaryPart or item
                            if targetPart then
                                teleportTo(targetPart)
                                fireproximityprompt(prompt)
                                task.wait(0.2)
                            end
                        end
                    end
                    
                    -- Also just checking names for fruit if it relies on touch
                    if string.find(itemName, "fruit") or string.find(itemName, "crop") then
                        local targetPart = item:IsA("Model") and item.PrimaryPart or item
                        if targetPart then
                            teleportTo(targetPart)
                            interactWith(targetPart)
                        end
                    end
                end
            end
        end
    end
end)
