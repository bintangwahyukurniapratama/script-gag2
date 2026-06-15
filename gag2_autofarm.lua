-- Kyriel Hub - GaG 2 Perfected Auto Farm Script (Mobile Friendly Tabbed UI)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup old
if CoreGui:FindFirstChild("KyrielMobileHub") then
    CoreGui.KyrielMobileHub:Destroy()
end

-- Global Config
getgenv().KyrielConfig = {
    ClaimRainbow = false,
    ClaimGold = false,
    ClaimAll = false,
    
    StealNight = false,
    StealFilter = {
        Bamboo = false, Blueberry = false, Corn = false, Mushroom = false,
        Apple = false, Carrot = false, Pumpkin = false, Tomato = false, 
        Watermelon = false, Wheat = false, Potato = false, Onion = false
    },
    
    WalkSpeed = 16,
    JumpPower = 50,
    SpeedEnabled = false,
    JumpEnabled = false,
    
    AutoSell = false,
    AutoBuy = false,
    TargetBuy = "None",
    TargetSell = "None",
}

local CropsList = {"None", "Bamboo", "Blueberry", "Corn", "Mushroom", "Apple", "Carrot", "Pumpkin", "Tomato", "Watermelon", "Wheat", "Potato", "Onion"}

-- Custom Mobile UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KyrielMobileHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 300)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.Parent = MainFrame

local UICornerTop = Instance.new("UICorner")
UICornerTop.CornerRadius = UDim.new(0, 8)
UICornerTop.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
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
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TopBar

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 260, 0, 30)
        MinBtn.Text = "+"
        MinBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    else
        MainFrame.Size = UDim2.new(0, 260, 0, 300)
        MinBtn.Text = "-"
        MinBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

-- Tab Buttons Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TabContainer.Parent = MainFrame

local Tab1Btn = Instance.new("TextButton")
Tab1Btn.Size = UDim2.new(0.33, 0, 1, 0)
Tab1Btn.Position = UDim2.new(0, 0, 0, 0)
Tab1Btn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
Tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab1Btn.Text = "Event"
Tab1Btn.Font = Enum.Font.GothamBold
Tab1Btn.TextSize = 12
Tab1Btn.Parent = TabContainer

local Tab2Btn = Instance.new("TextButton")
Tab2Btn.Size = UDim2.new(0.34, 0, 1, 0)
Tab2Btn.Position = UDim2.new(0.33, 0, 0, 0)
Tab2Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Tab2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab2Btn.Text = "Steal"
Tab2Btn.Font = Enum.Font.GothamBold
Tab2Btn.TextSize = 12
Tab2Btn.Parent = TabContainer

local Tab3Btn = Instance.new("TextButton")
Tab3Btn.Size = UDim2.new(0.33, 0, 1, 0)
Tab3Btn.Position = UDim2.new(0.67, 0, 0, 0)
Tab3Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Tab3Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab3Btn.Text = "Misc"
Tab3Btn.Font = Enum.Font.GothamBold
Tab3Btn.TextSize = 12
Tab3Btn.Parent = TabContainer

-- Scrolling Frames
local Scroll1 = Instance.new("ScrollingFrame")
Scroll1.Size = UDim2.new(1, 0, 1, -65)
Scroll1.Position = UDim2.new(0, 0, 0, 65)
Scroll1.BackgroundTransparency = 1
Scroll1.ScrollBarThickness = 4
Scroll1.Visible = true
Scroll1.Parent = MainFrame

local Scroll2 = Instance.new("ScrollingFrame")
Scroll2.Size = UDim2.new(1, 0, 1, -65)
Scroll2.Position = UDim2.new(0, 0, 0, 65)
Scroll2.BackgroundTransparency = 1
Scroll2.ScrollBarThickness = 4
Scroll2.Visible = false
Scroll2.Parent = MainFrame

local Scroll3 = Instance.new("ScrollingFrame")
Scroll3.Size = UDim2.new(1, 0, 1, -65)
Scroll3.Position = UDim2.new(0, 0, 0, 65)
Scroll3.BackgroundTransparency = 1
Scroll3.ScrollBarThickness = 4
Scroll3.Visible = false
Scroll3.Parent = MainFrame

local UIList1 = Instance.new("UIListLayout", Scroll1)
UIList1.Padding = UDim.new(0, 5)
UIList1.HorizontalAlignment = Enum.HorizontalAlignment.Center
local UIList2 = Instance.new("UIListLayout", Scroll2)
UIList2.Padding = UDim.new(0, 5)
UIList2.HorizontalAlignment = Enum.HorizontalAlignment.Center
local UIList3 = Instance.new("UIListLayout", Scroll3)
UIList3.Padding = UDim.new(0, 5)
UIList3.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Tab Switching Logic
local function SwitchTab(tabNum)
    Scroll1.Visible = (tabNum == 1)
    Scroll2.Visible = (tabNum == 2)
    Scroll3.Visible = (tabNum == 3)
    
    Tab1Btn.BackgroundColor3 = (tabNum == 1) and Color3.fromRGB(60, 130, 255) or Color3.fromRGB(40, 40, 45)
    Tab2Btn.BackgroundColor3 = (tabNum == 2) and Color3.fromRGB(60, 130, 255) or Color3.fromRGB(40, 40, 45)
    Tab3Btn.BackgroundColor3 = (tabNum == 3) and Color3.fromRGB(60, 130, 255) or Color3.fromRGB(40, 40, 45)
end

Tab1Btn.MouseButton1Click:Connect(function() SwitchTab(1) end)
Tab2Btn.MouseButton1Click:Connect(function() SwitchTab(2) end)
Tab3Btn.MouseButton1Click:Connect(function() SwitchTab(3) end)

-- UI Element Creators
local function CreateToggle(parent, text, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = default and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(50, 50, 55)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = "  " .. text .. (default and " [ON]" or " [OFF]")
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 200, 100) or Color3.fromRGB(50, 50, 55)
        btn.Text = "  " .. text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
    return btn
end

local function CreateCyclic(parent, text, options, defaultIdx, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(150, 80, 200)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = "  " .. text .. ": " .. options[defaultIdx]
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local idx = defaultIdx
    btn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        btn.Text = "  " .. text .. ": " .. options[idx]
        callback(options[idx])
    end)
    return btn
end

-- Tab 1: Event
CreateToggle(Scroll1, "Auto Rainbow Seed", false, function(v) getgenv().KyrielConfig.ClaimRainbow = v end)
CreateToggle(Scroll1, "Auto Gold Seed", false, function(v) getgenv().KyrielConfig.ClaimGold = v end)
CreateToggle(Scroll1, "Auto All Drops", false, function(v) getgenv().KyrielConfig.ClaimAll = v end)

-- Tab 2: Steal
CreateToggle(Scroll2, "Enable Steal Night", false, function(v) getgenv().KyrielConfig.StealNight = v end)
for cropName, _ in pairs(getgenv().KyrielConfig.StealFilter) do
    CreateToggle(Scroll2, "Steal " .. cropName, false, function(v) getgenv().KyrielConfig.StealFilter[cropName] = v end)
end

-- Tab 3: Misc
CreateToggle(Scroll3, "Speed Mod (16-100)", false, function(v) getgenv().KyrielConfig.SpeedEnabled = v end)
CreateCyclic(Scroll3, "WalkSpeed", {"16","30","50","80","100"}, 1, function(v) getgenv().KyrielConfig.WalkSpeed = tonumber(v) end)
CreateToggle(Scroll3, "Jump Mod (50-200)", false, function(v) getgenv().KyrielConfig.JumpEnabled = v end)
CreateCyclic(Scroll3, "JumpPower", {"50","80","120","150","200"}, 1, function(v) getgenv().KyrielConfig.JumpPower = tonumber(v) end)
CreateCyclic(Scroll3, "Target Sell", CropsList, 1, function(v) getgenv().KyrielConfig.TargetSell = v end)
CreateToggle(Scroll3, "Auto Sell Crop", false, function(v) getgenv().KyrielConfig.AutoSell = v end)
CreateCyclic(Scroll3, "Target Buy", CropsList, 1, function(v) getgenv().KyrielConfig.TargetBuy = v end)
CreateToggle(Scroll3, "Auto Buy Seed", false, function(v) getgenv().KyrielConfig.AutoBuy = v end)

-- Update Canvas Sizes
task.spawn(function()
    while task.wait(1) do
        Scroll1.CanvasSize = UDim2.new(0, 0, 0, UIList1.AbsoluteContentSize.Y + 10)
        Scroll2.CanvasSize = UDim2.new(0, 0, 0, UIList2.AbsoluteContentSize.Y + 10)
        Scroll3.CanvasSize = UDim2.new(0, 0, 0, UIList3.AbsoluteContentSize.Y + 10)
    end
end)

-- ================= LOGIC LOOP =================
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

-- Speed & Jump Loop
RunService.RenderStepped:Connect(function()
    pcall(function()
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("Humanoid") then
            if getgenv().KyrielConfig.SpeedEnabled then
                Char.Humanoid.WalkSpeed = getgenv().KyrielConfig.WalkSpeed
            end
            if getgenv().KyrielConfig.JumpEnabled then
                Char.Humanoid.UseJumpPower = true
                Char.Humanoid.JumpPower = getgenv().KyrielConfig.JumpPower
            end
        end
    end)
end)

local ignoreList = {}
local function addToIgnore(item, duration)
    ignoreList[item] = os.clock() + duration
end
local function isIgnored(item)
    return ignoreList[item] and ignoreList[item] > os.clock()
end

-- Main Farm Loop
task.spawn(function()
    while task.wait(0.5) do
        local acted = false
        local cfg = getgenv().KyrielConfig
        
        -- Auto Drops (Claim Event)
        if not acted and (cfg.ClaimRainbow or cfg.ClaimGold or cfg.ClaimAll) then
            local folder = Workspace:FindFirstChild("Drops") or Workspace:FindFirstChild("DroppedItems") or Workspace
            local items = folder == Workspace and Workspace:GetChildren() or folder:GetDescendants()
            for _, item in ipairs(items) do
                if not isIgnored(item) then
                    local itemName = string.lower(item.Name)
                    local isRainbow = cfg.ClaimRainbow and string.find(itemName, "rainbow") and string.find(itemName, "seed")
                    local isGold = cfg.ClaimGold and string.find(itemName, "gold") and string.find(itemName, "seed")
                    local isDrop = cfg.ClaimAll and item:IsA("Tool")
                    
                    if isRainbow or isGold or isDrop then
                        local tPart = item:FindFirstChild("Handle") or (item:IsA("BasePart") and item)
                        if tPart then
                            teleportTo(tPart.CFrame)
                            interactWith(tPart)
                            addToIgnore(item, 3)
                            acted = true
                            break
                        end
                    end
                end
            end
        end

        -- Steal Night (FIXED)
        -- Removing rigid time check, relying on "Steal" action text and optionally night time
        if not acted and cfg.StealNight then
            for _, item in ipairs(Workspace:GetDescendants()) do
                if isIgnored(item) then continue end
                
                local prompt = item:FindFirstChildWhichIsA("ProximityPrompt")
                local isHarvestable = false
                local tPart = nil
                
                if prompt and prompt.Enabled then
                    local actionText = string.lower(prompt.ActionText)
                    -- If the game specifically says "Steal" it's definitely stealable.
                    -- Some games say "Harvest" but it belongs to someone else.
                    if string.find(actionText, "steal") or string.find(actionText, "harvest") then
                        
                        tPart = item:IsA("Model") and item.PrimaryPart or (item:IsA("BasePart") and item or item.Parent)
                        local parentName = item.Parent and item.Parent.Name or ""
                        local itemName = string.lower(parentName .. " " .. item.Name)
                        
                        -- Cek filter crop
                        local validCrop = false
                        for cropName, isSelected in pairs(cfg.StealFilter) do
                            if isSelected and string.find(itemName, string.lower(cropName)) then
                                validCrop = true
                                break
                            end
                        end
                        
                        if validCrop then
                            isHarvestable = true
                        end
                    end
                end
                
                if isHarvestable and tPart and tPart:IsA("BasePart") then
                    -- Cek owner nearby biar ga ketahuan
                    if not isOwnerNearby(tPart.Position) then
                        teleportTo(tPart.CFrame)
                        if prompt then
                            fireproximityprompt(prompt)
                        else
                            interactWith(tPart)
                        end
                        addToIgnore(item, 5)
                        acted = true
                        task.wait(0.2)
                        break
                    end
                end
            end
        end
        
        -- Auto Sell
        if not acted and cfg.AutoSell and cfg.TargetSell ~= "None" then
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local text = string.lower(prompt.ActionText .. " " .. prompt.ObjectText .. " " .. prompt.Parent.Name)
                    if string.find(text, "sell") or string.find(text, "merchant") or string.find(text, "shop") then
                        local tPart = prompt.Parent
                        if tPart:IsA("BasePart") then
                            teleportTo(tPart.CFrame)
                            fireproximityprompt(prompt)
                            task.wait(1.5) -- Load UI time
                            
                            for _, ui in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                                if ui:IsA("TextButton") then
                                    local uiText = string.lower(ui.Text)
                                    if string.find(uiText, string.lower(cfg.TargetSell)) or string.find(uiText, "sell all") then
                                        if getconnections then
                                            for _, conn in ipairs(getconnections(ui.MouseButton1Click)) do
                                                conn:Fire()
                                            end
                                        else
                                            local VirtualUser = game:GetService("VirtualUser")
                                            VirtualUser:ClickButton1(Vector2.new(ui.AbsolutePosition.X + ui.AbsoluteSize.X/2, ui.AbsolutePosition.Y + ui.AbsoluteSize.Y/2))
                                        end
                                        acted = true
                                        break
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            end
        end

        -- Auto Buy
        if not acted and cfg.AutoBuy and cfg.TargetBuy ~= "None" then
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local pText = string.lower(prompt.ActionText .. " " .. prompt.ObjectText)
                    local parentName = string.lower(prompt.Parent.Name)
                    local targetName = string.lower(cfg.TargetBuy)
                    
                    if (string.find(pText, "buy") or string.find(pText, "purchase") or string.find(pText, "$")) then
                        if string.find(pText, targetName) or string.find(parentName, targetName) then
                            local tPart = prompt.Parent
                            if tPart:IsA("BasePart") then
                                teleportTo(tPart.CFrame)
                                fireproximityprompt(prompt)
                                acted = true
                                task.wait(1)
                                break
                            end
                        end
                    end
                end
            end
        end

    end
end)
