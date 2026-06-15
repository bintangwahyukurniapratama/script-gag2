-- GaG 2 Perfected Auto Farm Script v12 (Cyclic Selectors & Fixed Buy)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

getgenv().AutoCollectRainbow = false
getgenv().AutoCollectGold = false
getgenv().AutoCollectAll = false
getgenv().StealNight = false

getgenv().AutoSell = false
getgenv().AutoBuy = false
getgenv().AutoPlant = false
getgenv().AutoHarvest = false

getgenv().TargetBuy = "None"
getgenv().TargetPlant = "None"
getgenv().TargetSell = "All"

getgenv().StealAllCrops = true
getgenv().SelectedCrops = {
    Bamboo = false, Blueberry = false, Corn = false, Mushroom = false,
    Apple = false, Carrot = false, Pumpkin = false, Tomato = false, Watermelon = false
}

getgenv().StealAllMutations = true
getgenv().SelectedMutations = {
    Bloodlit = false, Electric = false, Frozen = false, Rainbow = false,
    Starstruck = false, Gold = false, Chained = false
}

getgenv().SafeHomeCFrame = nil
getgenv().WalkSpeedToggle = false
getgenv().WalkSpeedValue = 16
getgenv().JumpPowerToggle = false
getgenv().JumpPowerValue = 50

-- Cleanup old GUI
if CoreGui:FindFirstChild("KyrielGaG2Hub") then
    CoreGui.KyrielGaG2Hub:Destroy()
end

-- Custom UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KyrielGaG2Hub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local UICornerTop = Instance.new("UICorner")
UICornerTop.CornerRadius = UDim.new(0, 8)
UICornerTop.Parent = TopBar

local TopBarCover = Instance.new("Frame")
TopBarCover.Size = UDim2.new(1, 0, 0, 8)
TopBarCover.Position = UDim2.new(0, 0, 1, -8)
TopBarCover.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBarCover.BorderSizePixel = 0
TopBarCover.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Kyriel Hub | GaG 2"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 2)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TopBar

local UICornerMin = Instance.new("UICorner")
UICornerMin.CornerRadius = UDim.new(0, 6)
UICornerMin.Parent = MinBtn

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -45)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ScrollFrame.Visible = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 320, 0, 35)
        MinBtn.Text = "+"
        MinBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        MainFrame.Size = UDim2.new(0, 320, 0, 480)
        MinBtn.Text = "-"
        MinBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

local function CreateSection(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.95, 0, 0, 25)
    lbl.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    lbl.TextColor3 = Color3.fromRGB(100, 200, 255)
    lbl.Text = "  " .. text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = ScrollFrame
    
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, 4)
    uic.Parent = lbl
end

local function CreateToggle(name, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.BackgroundColor3 = default and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(50, 50, 55)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = "  " .. name .. (default and " [ON]" or " [OFF]")
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = ScrollFrame
    
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, 4)
    uic.Parent = btn
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(50, 50, 55)
        btn.Text = "  " .. name .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
    return btn
end

local function CreateCyclicButton(name, options, defaultIndex, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(150, 80, 200)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = "  " .. name .. ": " .. options[defaultIndex]
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = ScrollFrame
    
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, 4)
    uic.Parent = btn
    
    local index = defaultIndex
    btn.MouseButton1Click:Connect(function()
        index = index + 1
        if index > #options then index = 1 end
        btn.Text = "  " .. name .. ": " .. options[index]
        callback(options[index])
    end)
end

local function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = ScrollFrame
    
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, 4)
    uic.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local cropOptions = {"None", "Bamboo", "Blueberry", "Corn", "Mushroom", "Apple", "Carrot", "Pumpkin", "Tomato", "Watermelon"}

-- Populating UI
CreateSection("AUTO DROPS")
CreateToggle("Auto Rainbow Seed", false, function(v) getgenv().AutoCollectRainbow = v end)
CreateToggle("Auto Gold Seed", false, function(v) getgenv().AutoCollectGold = v end)
CreateToggle("Auto All Drops", false, function(v) getgenv().AutoCollectAll = v end)

CreateSection("AUTO FARMING TARGETS")
CreateCyclicButton("Target Buy", cropOptions, 1, function(v) getgenv().TargetBuy = v end)
CreateCyclicButton("Target Plant", cropOptions, 1, function(v) getgenv().TargetPlant = v end)
CreateCyclicButton("Target Sell", {"All", "Bamboo", "Blueberry", "Corn"}, 1, function(v) getgenv().TargetSell = v end)

CreateSection("AUTO FARMING & STEAL")
CreateToggle("Auto Buy Seed (Target Buy)", false, function(v) getgenv().AutoBuy = v end)
CreateToggle("Auto Plant (Target Plant & Home)", false, function(v) getgenv().AutoPlant = v end)
CreateToggle("Auto Harvest Own (Need Home)", false, function(v) getgenv().AutoHarvest = v end)
CreateToggle("Auto Sell (Every 30s)", false, function(v) getgenv().AutoSell = v end)
CreateToggle("Steal Night (Safe Mode)", false, function(v) getgenv().StealNight = v end)

CreateSection("HOME SETTINGS")
CreateButton("Set Safe Return/Garden Home", function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        getgenv().SafeHomeCFrame = Char.HumanoidRootPart.CFrame
    end
end)

CreateSection("CROP FILTER (For Steal)")
CreateToggle("All Crops", true, function(v) getgenv().StealAllCrops = v end)
for cropName, _ in pairs(getgenv().SelectedCrops) do
    CreateToggle(cropName, false, function(v) getgenv().SelectedCrops[cropName] = v end)
end

CreateSection("MUTATION FILTER (For Steal)")
CreateToggle("All Mutations", true, function(v) getgenv().StealAllMutations = v end)
for mutName, _ in pairs(getgenv().SelectedMutations) do
    CreateToggle(mutName, false, function(v) getgenv().SelectedMutations[mutName] = v end)
end

-- Update Canvas Size
task.delay(0.5, function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

-- Utility Functions
local ignoreList = {}
local function addToIgnore(item, duration)
    ignoreList[item] = os.clock() + duration
end
local function isIgnored(item)
    return ignoreList[item] and ignoreList[item] > os.clock()
end

local function isOwnerNearby(targetPosition)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - targetPosition).Magnitude
            if dist < 80 then
                return true
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

-- Core Logic
local sellTimer = 0

task.spawn(function()
    while task.wait(0.5) do
        local acted = false
        
        -- Auto Sell
        if getgenv().AutoSell then
            sellTimer = sellTimer + 0.5
            if sellTimer >= 30 then
                sellTimer = 0
                for _, part in ipairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") and (string.find(string.lower(part.Name), "sell") or (part:FindFirstChild("TouchInterest") and string.find(string.lower(part.Parent.Name), "sell"))) then
                        -- GaG 2 normally has a single sell pad that sells everything, so TargetSell filter isn't deeply implemented on part level unless it's a specific seller NPC.
                        teleportTo(part.CFrame)
                        task.wait(1)
                        break
                    end
                end
            end
        end

        -- Auto Buy Target
        if not acted and getgenv().AutoBuy and getgenv().TargetBuy ~= "None" then
            for _, item in ipairs(Workspace:GetDescendants()) do
                if item:IsA("ProximityPrompt") then
                    local parentName = string.lower(item.Parent.Name)
                    local targetName = string.lower(getgenv().TargetBuy)
                    if string.find(parentName, targetName) and string.find(parentName, "seed") then
                        -- It's the dispenser for our target seed!
                        local tPart = getTargetPart(item.Parent) or item.Parent
                        teleportTo(tPart.CFrame)
                        fireproximityprompt(item)
                        acted = true
                        task.wait(0.5)
                        break
                    end
                end
            end
        end

        -- Auto Plant Target
        if not acted and getgenv().AutoPlant and getgenv().SafeHomeCFrame and getgenv().TargetPlant ~= "None" then
            local targetName = string.lower(getgenv().TargetPlant)
            local seed = nil
            -- Check backpack
            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if string.find(string.lower(tool.Name), targetName) and string.find(string.lower(tool.Name), "seed") then
                    seed = tool
                    break
                end
            end
            -- Check character
            if not seed and LocalPlayer.Character then
                for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                    if string.find(string.lower(tool.Name), targetName) and string.find(string.lower(tool.Name), "seed") then
                        seed = tool
                        break
                    end
                end
            end
            
            if seed then
                teleportTo(getgenv().SafeHomeCFrame)
                if seed.Parent == LocalPlayer.Backpack then
                    seed.Parent = LocalPlayer.Character
                end
                seed:Activate()
                acted = true
                task.wait(0.5)
            end
        end

        -- Auto Harvest Own Garden
        if not acted and getgenv().AutoHarvest and getgenv().SafeHomeCFrame then
            for _, item in ipairs(Workspace:GetDescendants()) do
                local prompt = item:FindFirstChildWhichIsA("ProximityPrompt")
                if prompt and prompt.Enabled and string.find(string.lower(prompt.ActionText), "harvest") then
                    local tPart = getTargetPart(item)
                    if tPart then
                        local dist = (tPart.Position - getgenv().SafeHomeCFrame.Position).Magnitude
                        if dist < 60 then
                            teleportTo(tPart.CFrame)
                            fireproximityprompt(prompt)
                            acted = true
                            task.wait(0.2)
                            break
                        end
                    end
                end
            end
        end

        -- Drops
        if not acted and (getgenv().AutoCollectRainbow or getgenv().AutoCollectGold or getgenv().AutoCollectAll) then
            local folder = getDropsFolder()
            local items = folder == Workspace and Workspace:GetChildren() or folder:GetDescendants()
            for _, item in ipairs(items) do
                if not isIgnored(item) then
                    local itemName = string.lower(item.Name)
                    local isRainbow = getgenv().AutoCollectRainbow and string.find(itemName, "rainbow") and string.find(itemName, "seed")
                    local isGold = getgenv().AutoCollectGold and string.find(itemName, "gold") and string.find(itemName, "seed")
                    local isDrop = getgenv().AutoCollectAll and isDroppedTool(item)
                    
                    if isRainbow or isGold or isDrop then
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
        
        -- Steal Night
        local isNightTime = Lighting.ClockTime < 6 or Lighting.ClockTime > 18
        if not acted and getgenv().StealNight and isNightTime then
            for _, item in ipairs(Workspace:GetDescendants()) do
                if not getgenv().StealNight or not (Lighting.ClockTime < 6 or Lighting.ClockTime > 18) then break end
                if isIgnored(item) then continue end
                
                local prompt = item:FindFirstChildWhichIsA("ProximityPrompt")
                local isHarvestable = false
                local targetPart = getTargetPart(item)
                
                if prompt and prompt.Enabled then
                    local actionText = string.lower(prompt.ActionText)
                    if string.find(actionText, "harvest") or string.find(actionText, "steal") then
                        
                        local parentName = item.Parent and item.Parent.Name or ""
                        local itemName = string.lower(parentName .. " " .. item.Name)
                        
                        -- Check Crop Filter
                        local validCrop = getgenv().StealAllCrops
                        if not validCrop then
                            for cropName, isSelected in pairs(getgenv().SelectedCrops) do
                                if isSelected and string.find(itemName, string.lower(cropName)) then
                                    validCrop = true
                                    break
                                end
                            end
                        end
                        
                        -- Check Mutation Filter
                        local validMut = getgenv().StealAllMutations
                        if not validMut then
                            for mutName, isSelected in pairs(getgenv().SelectedMutations) do
                                if isSelected and string.find(itemName, string.lower(mutName)) then
                                    validMut = true
                                    break
                                end
                            end
                        end
                        
                        if validCrop and validMut then
                            isHarvestable = true
                        end
                    end
                end
                
                if isHarvestable and targetPart then
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
        
        -- Home Return
        if not acted and getgenv().SafeHomeCFrame and (getgenv().AutoCollectRainbow or getgenv().AutoCollectGold or getgenv().AutoCollectAll or getgenv().StealNight or getgenv().AutoPlant or getgenv().AutoHarvest) then
            local Char = LocalPlayer.Character
            if Char and Char:FindFirstChild("HumanoidRootPart") then
                local dist = (Char.HumanoidRootPart.Position - getgenv().SafeHomeCFrame.Position).Magnitude
                if dist > 15 then
                    teleportTo(getgenv().SafeHomeCFrame)
                end
            end
        end
    end
end)
