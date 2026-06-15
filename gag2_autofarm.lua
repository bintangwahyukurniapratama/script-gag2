-- GaG 2 Perfected Auto Farm Script v10 (Custom UI - No Loadstring)
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
getgenv().AutoBuyBamboo = false
getgenv().AutoPlant = false
getgenv().AutoHarvest = false

getgenv().CropFilter = "All"
getgenv().MutationFilter = "All"
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
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = " Kyriel Hub | GaG 2"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 40, 1, 0)
MinBtn.Position = UDim2.new(1, -40, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TopBar

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -30)
ScrollFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ScrollFrame.Visible = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 300, 0, 30)
        MinBtn.Text = "+"
        MinBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 400)
        MinBtn.Text = "-"
        MinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

local function CreateToggle(name, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = default and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. (default and " [ON]" or " [OFF]")
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = ScrollFrame
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 60)
        btn.Text = name .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

local function CreateInput(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.Position = UDim2.new(0, 5, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = ScrollFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = frame
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 30)
    box.Position = UDim2.new(0, 0, 0, 20)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Text = default
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.Parent = frame
    
    box.FocusLost:Connect(function()
        callback(box.Text)
    end)
end

local function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = ScrollFrame
    btn.MouseButton1Click:Connect(callback)
end

local function CreateLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 215, 0)
    lbl.Text = text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.Parent = ScrollFrame
end

-- Populating UI
CreateLabel(" --- AUTO DROPS ---")
CreateToggle("Auto Rainbow Seed", false, function(v) getgenv().AutoCollectRainbow = v end)
CreateToggle("Auto Gold Seed", false, function(v) getgenv().AutoCollectGold = v end)
CreateToggle("Auto All Drops", false, function(v) getgenv().AutoCollectAll = v end)

CreateLabel(" --- AUTO STEAL ---")
CreateToggle("Steal Night (Safe Mode)", false, function(v) getgenv().StealNight = v end)
CreateInput("Crop Filter (ex: Bamboo, Corn, All)", "All", function(v) getgenv().CropFilter = v end)
CreateInput("Mut Filter (ex: Rainbow, Gold, All)", "All", function(v) getgenv().MutationFilter = v end)

CreateLabel(" --- AUTO FARMING ---")
CreateToggle("Auto Sell (Every 30s)", false, function(v) getgenv().AutoSell = v end)
CreateToggle("Auto Buy Bamboo Seed", false, function(v) getgenv().AutoBuyBamboo = v end)
CreateToggle("Auto Plant (Need Home)", false, function(v) getgenv().AutoPlant = v end)
CreateToggle("Auto Harvest Own (Need Home)", false, function(v) getgenv().AutoHarvest = v end)

CreateLabel(" --- HOME / GARDEN ---")
CreateButton("Set Safe Return/Garden Home", function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        getgenv().SafeHomeCFrame = Char.HumanoidRootPart.CFrame
    end
end)

CreateLabel(" --- PLAYER ---")
CreateToggle("WalkSpeed Modifier", false, function(v) getgenv().WalkSpeedToggle = v end)
CreateInput("WalkSpeed Value", "16", function(v) getgenv().WalkSpeedValue = tonumber(v) or 16 end)

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
                -- Look for sell part
                for _, part in ipairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") and (string.find(string.lower(part.Name), "sell") or (part:FindFirstChild("TouchInterest") and string.find(string.lower(part.Parent.Name), "sell"))) then
                        teleportTo(part.CFrame)
                        task.wait(1)
                        break
                    end
                end
            end
        end

        -- Auto Buy Bamboo
        if not acted and getgenv().AutoBuyBamboo then
            for _, item in ipairs(Workspace:GetDescendants()) do
                if string.find(string.lower(item.Name), "bamboo") and string.find(string.lower(item.Name), "seed") then
                    local prompt = item:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt and string.find(string.lower(prompt.ActionText), "buy") then
                        teleportTo(item:IsA("Model") and item.PrimaryPart.CFrame or item.CFrame)
                        fireproximityprompt(prompt)
                        acted = true
                        break
                    end
                end
            end
        end

        -- Auto Plant
        if not acted and getgenv().AutoPlant and getgenv().SafeHomeCFrame then
            local seed = LocalPlayer.Backpack:FindFirstChild("Bamboo Seed") or LocalPlayer.Character:FindFirstChild("Bamboo Seed")
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
                        
                        local cropFilter = string.lower(getgenv().CropFilter)
                        local mutFilter = string.lower(getgenv().MutationFilter)
                        
                        local validCrop = (cropFilter == "all" or cropFilter == "")
                        if not validCrop then
                            for word in string.gmatch(cropFilter, '([^,]+)') do
                                if string.find(itemName, string.match(word, "^%s*(.-)%s*$")) then
                                    validCrop = true
                                    break
                                end
                            end
                        end
                        
                        local validMut = (mutFilter == "all" or mutFilter == "")
                        if not validMut then
                            for word in string.gmatch(mutFilter, '([^,]+)') do
                                if string.find(itemName, string.match(word, "^%s*(.-)%s*$")) then
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

-- WalkSpeed loop
task.spawn(function()
    while task.wait(0.1) do
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("Humanoid") then
            if getgenv().WalkSpeedToggle then
                Char.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
            end
        end
    end
end)
