-- GaG 2 Perfected Auto Farm Script v7
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

getgenv().AutoCollectRainbow = false
getgenv().AutoCollectGold = false
getgenv().AutoCollectAll = false
getgenv().StealNight = false

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local SafeHomeCFrame = Character:WaitForChild("HumanoidRootPart").CFrame

if CoreGui:FindFirstChild("KyrielGaG2Hub") then
    CoreGui.KyrielGaG2Hub:Destroy()
end

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

createToggle("Event Rainbow Seed", 10, function(val) getgenv().AutoCollectRainbow = val end)
createToggle("Event Gold Seed", 50, function(val) getgenv().AutoCollectGold = val end)
createToggle("Auto All Drops", 90, function(val) getgenv().AutoCollectAll = val end)
createToggle("Steal Night (Safe)", 130, function(val) getgenv().StealNight = val end)

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
    getgenv().AutoCollectRainbow = false
    getgenv().AutoCollectGold = false
    getgenv().AutoCollectAll = false
    getgenv().StealNight = false
    ScreenGui:Destroy()
end)

-- Utility Functions
local function isNightTime()
    return Lighting.ClockTime < 6 or Lighting.ClockTime > 18
end

local ignoreList = {}
local function addToIgnore(item, duration)
    ignoreList[item] = os.clock() + duration
end
local function isIgnored(item)
    if ignoreList[item] and ignoreList[item] > os.clock() then
        return true
    end
    return false
end


local function isOwnerNearby(targetPosition)
    -- Check if any other player is within 80 studs of the target (garden)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - targetPosition).Magnitude
            if dist < 80 then
                return true -- Someone is nearby
            end
        end
    end
    return false
end

local function getTargetPart(item)
    if item:IsA("Model") and item.PrimaryPart then return item.PrimaryPart end
    if item:IsA("Tool") and item:FindFirstChild("Handle") then return item.Handle end
    if item:IsA("BasePart") then return item end
    if item:IsA("Model") then return item:FindFirstChildWhichIsA("BasePart", true) end
    return nil
end

local function isDroppedTool(item)
    return item:IsA("Tool")
end

local function getDropsFolder()
    return Workspace:FindFirstChild("Drops") or Workspace:FindFirstChild("DroppedItems") or Workspace
end

local function getDropItems()
    local folder = getDropsFolder()
    if folder == Workspace then
        return Workspace:GetChildren()
    else
        return folder:GetDescendants()
    end
end

local function teleportTo(cframe)
    pcall(function()
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            Char.HumanoidRootPart.CFrame = cframe
            Char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
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

-- Master Loop for everything to prevent overlapping actions
task.spawn(function()
    while task.wait(0.5) do
        local acted = false
        
        -- 1. Try collecting Event Seeds first (High Priority)
        if getgenv().AutoCollectRainbow or getgenv().AutoCollectGold then
            for _, item in ipairs(getDropItems()) do
                if not isIgnored(item) then
                    local itemName = string.lower(item.Name)
                    local isRainbow = getgenv().AutoCollectRainbow and string.find(itemName, "rainbow") and string.find(itemName, "seed")
                    local isGold = getgenv().AutoCollectGold and string.find(itemName, "gold") and string.find(itemName, "seed")
                    
                    if isRainbow or isGold then
                        local targetPart = getTargetPart(item)
                        if targetPart then
                            teleportTo(targetPart.CFrame)
                            interactWith(targetPart)
                            addToIgnore(item, 3)
                            acted = true
                            break
                        end
                    end
                end
            end
        end
        
        -- 2. Try Auto Collect All Drops
        if not acted and getgenv().AutoCollectAll then
            for _, item in ipairs(getDropItems()) do
                if not isIgnored(item) and isDroppedTool(item) then
                    local targetPart = getTargetPart(item)
                    if targetPart then
                        teleportTo(targetPart.CFrame)
                        interactWith(targetPart)
                        addToIgnore(item, 3)
                        acted = true
                        break
                    end
                end
            end
        end
        
        -- 3. Try Steal Night (Safe Mode)
        if not acted and getgenv().StealNight and isNightTime() then
            for _, item in ipairs(Workspace:GetDescendants()) do
                if not getgenv().StealNight or not isNightTime() then break end
                if isIgnored(item) then continue end
                
                local prompt = item:FindFirstChildWhichIsA("ProximityPrompt")
                local isHarvestable = false
                local targetPart = getTargetPart(item)
                
                if prompt and prompt.Enabled then
                    local actionText = string.lower(prompt.ActionText)
                    if string.find(actionText, "harvest") or string.find(actionText, "steal") then
                        isHarvestable = true
                    end
                end
                
                if isHarvestable and targetPart then
                    -- Check if owner is nearby before stealing
                    if not isOwnerNearby(targetPart.Position) then
                        teleportTo(targetPart.CFrame)
                        if prompt then
                            fireproximityprompt(prompt)
                        else
                            interactWith(targetPart)
                        end
                        addToIgnore(item, 5)
                        acted = true
                        task.wait(0.2)
                        break
                    end
                end
            end
        end
        
        -- 4. If nothing was done and any toggle is ON, teleport/stay Home
        if not acted and (getgenv().AutoCollectRainbow or getgenv().AutoCollectGold or getgenv().AutoCollectAll or getgenv().StealNight) then
            -- Only teleport home if we are far away from it to prevent stuttering
            local Char = LocalPlayer.Character
            if Char and Char:FindFirstChild("HumanoidRootPart") then
                local dist = (Char.HumanoidRootPart.Position - SafeHomeCFrame.Position).Magnitude
                if dist > 10 then
                    teleportTo(SafeHomeCFrame)
                end
            end
        end
        
    end
end)
