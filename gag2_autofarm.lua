-- GaG 2 Universal UI Auto Farm Script v5
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

getgenv().AutoCollectRainbow = false
getgenv().AutoCollectGold = false
getgenv().AutoCollectAll = false
getgenv().StealNight = false

-- Save original home position so we can escape
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local SafeHomeCFrame = Character:WaitForChild("HumanoidRootPart").CFrame

-- Remove old UI
if CoreGui:FindFirstChild("KyrielGaG2Hub") then
    CoreGui.KyrielGaG2Hub:Destroy()
end

-- Create Basic UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KyrielGaG2Hub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 290)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -145)
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
        MainFrame.Size = UDim2.new(0, 200, 0, 290)
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
createToggle("Auto All Drops", 90, function(val) getgenv().AutoCollectAll = val end)
createToggle("Steal Fruit (Night)", 130, function(val) getgenv().StealNight = val end)

local SetHomeBtn = Instance.new("TextButton")
SetHomeBtn.Size = UDim2.new(1, -20, 0, 30)
SetHomeBtn.Position = UDim2.new(0, 10, 0, 170)
SetHomeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
SetHomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SetHomeBtn.Text = "Set Safe Home Here"
SetHomeBtn.Parent = ContentFrame

SetHomeBtn.MouseButton1Click:Connect(function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        SafeHomeCFrame = Char.HumanoidRootPart.CFrame
        SetHomeBtn.Text = "Home Saved!"
        task.wait(1)
        SetHomeBtn.Text = "Set Safe Home Here"
    end
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -20, 0, 30)
CloseBtn.Position = UDim2.new(0, 10, 0, 210)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "Close Menu"
CloseBtn.Parent = ContentFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Universal Farming Logic
local function teleportTo(part)
    pcall(function()
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") and part then
            Char.HumanoidRootPart.CFrame = part.CFrame
            task.wait(0.15)
        end
    end)
end

local function teleportHome()
    pcall(function()
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            Char.HumanoidRootPart.CFrame = SafeHomeCFrame
            task.wait(0.2)
        end
    end)
end

local function interactWith(part)
    pcall(function()
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            firetouchinterest(Char.HumanoidRootPart, part, 0)
            firetouchinterest(Char.HumanoidRootPart, part, 1)
        end
        local prompt = part:FindFirstChildWhichIsA("ProximityPrompt")
        if prompt then fireproximityprompt(prompt) end
        local click = part:FindFirstChildWhichIsA("ClickDetector")
        if click then fireclickdetector(click) end
    end)
end

-- Drops Collector Loop
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoCollectRainbow or getgenv().AutoCollectGold or getgenv().AutoCollectAll then
            pcall(function()
                for _, item in ipairs(Workspace:GetDescendants()) do
                    if item:IsA("BasePart") or item:IsA("Model") then
                        local itemName = string.lower(item.Name)
                        local isRainbow = string.find(itemName, "rainbow")
                        local isGold = string.find(itemName, "gold")
                        local isDrop = string.find(itemName, "drop") or string.find(itemName, "seed") or item.Parent.Name == "Drops"
                        
                        local targetPart = item:IsA("Model") and item.PrimaryPart or item
                        if targetPart then
                            if getgenv().AutoCollectAll and isDrop then
                                teleportTo(targetPart)
                                interactWith(targetPart)
                            elseif getgenv().AutoCollectRainbow and isRainbow then
                                teleportTo(targetPart)
                                interactWith(targetPart)
                            elseif getgenv().AutoCollectGold and isGold then
                                teleportTo(targetPart)
                                interactWith(targetPart)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Steal Night Loop
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().StealNight then
            pcall(function()
                local hasStolen = false
                for _, item in ipairs(Workspace:GetDescendants()) do
                    if item:IsA("BasePart") or item:IsA("Model") then
                        local prompt = item:FindFirstChildWhichIsA("ProximityPrompt")
                        if prompt then
                            local actionText = string.lower(prompt.ActionText)
                            if string.find(actionText, "harvest") or string.find(actionText, "steal") or string.find(actionText, "pick") then
                                local targetPart = item:IsA("Model") and item.PrimaryPart or item
                                if targetPart then
                                    teleportTo(targetPart)
                                    fireproximityprompt(prompt)
                                    hasStolen = true
                                    task.wait(0.1)
                                end
                            end
                        end
                        
                        -- Fallback for touch-based stealing
                        local itemName = string.lower(item.Name)
                        if string.find(itemName, "fruit") or string.find(itemName, "crop") then
                            local targetPart = item:IsA("Model") and item.PrimaryPart or item
                            if targetPart and targetPart:FindFirstChild("TouchInterest") then
                                teleportTo(targetPart)
                                interactWith(targetPart)
                                hasStolen = true
                                task.wait(0.1)
                            end
                        end
                    end
                end
                
                -- Escaping logic
                if hasStolen then
                    teleportHome()
                    task.wait(1) -- Wait a bit so we don't look suspicious teleporting back immediately to steal again
                end
            end)
        end
    end
end)
