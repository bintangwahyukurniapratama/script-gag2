-- Kyriel Hub - GaG 2 Perfected Auto Farm Script (Rayfield UI + Advanced Buy/Sell)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kyriel Hub | GaG 2",
   LoadingTitle = "Loading Kyriel Hub...",
   LoadingSubtitle = "by Kyriel",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = false,
})

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

-- ================= TAB 1: CLAIM EVENT =================
local TabClaim = Window:CreateTab("Claim Event", 4483362458)

TabClaim:CreateSection("Auto Claim Seeds")

TabClaim:CreateToggle({
   Name = "Auto Claim Rainbow Seed",
   CurrentValue = false,
   Flag = "ClaimRainbow",
   Callback = function(Value)
        getgenv().KyrielConfig.ClaimRainbow = Value
   end,
})

TabClaim:CreateToggle({
   Name = "Auto Claim Gold Seed",
   CurrentValue = false,
   Flag = "ClaimGold",
   Callback = function(Value)
        getgenv().KyrielConfig.ClaimGold = Value
   end,
})

TabClaim:CreateToggle({
   Name = "Auto Claim All Drops",
   CurrentValue = false,
   Flag = "ClaimAll",
   Callback = function(Value)
        getgenv().KyrielConfig.ClaimAll = Value
   end,
})

-- ================= TAB 2: STEAL NIGHT =================
local TabSteal = Window:CreateTab("Steal Night", 4483362458)

TabSteal:CreateSection("Steal Settings")

TabSteal:CreateToggle({
   Name = "Enable Steal Night",
   CurrentValue = false,
   Flag = "StealNight",
   Callback = function(Value)
        getgenv().KyrielConfig.StealNight = Value
   end,
})

TabSteal:CreateSection("Crop Filters")

for cropName, _ in pairs(getgenv().KyrielConfig.StealFilter) do
    TabSteal:CreateToggle({
       Name = "Steal " .. cropName,
       CurrentValue = false,
       Flag = "Steal_" .. cropName,
       Callback = function(Value)
            getgenv().KyrielConfig.StealFilter[cropName] = Value
       end,
    })
end

-- ================= TAB 3: MISC & AUTO FARM =================
local TabMisc = Window:CreateTab("Misc & Farm", 4483362458)

TabMisc:CreateSection("Character Mods")

TabMisc:CreateToggle({
   Name = "Enable Speed Mod",
   CurrentValue = false,
   Flag = "SpeedEnabled",
   Callback = function(Value)
        getgenv().KyrielConfig.SpeedEnabled = Value
   end,
})
TabMisc:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
        getgenv().KyrielConfig.WalkSpeed = Value
   end,
})

TabMisc:CreateToggle({
   Name = "Enable Jump Mod",
   CurrentValue = false,
   Flag = "JumpEnabled",
   Callback = function(Value)
        getgenv().KyrielConfig.JumpEnabled = Value
   end,
})
TabMisc:CreateSlider({
   Name = "JumpPower",
   Range = {50, 200},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpPowerSlider",
   Callback = function(Value)
        getgenv().KyrielConfig.JumpPower = Value
   end,
})

TabMisc:CreateSection("Auto Buy & Sell")

TabMisc:CreateDropdown({
   Name = "Select Crop to Buy",
   Options = CropsList,
   CurrentOption = {"None"},
   MultipleOptions = false,
   Flag = "TargetBuyDrop",
   Callback = function(Option)
        getgenv().KyrielConfig.TargetBuy = Option[1]
   end,
})

TabMisc:CreateToggle({
   Name = "Auto Buy Selected Seed",
   CurrentValue = false,
   Flag = "AutoBuyEnabled",
   Callback = function(Value)
        getgenv().KyrielConfig.AutoBuy = Value
   end,
})

TabMisc:CreateDropdown({
   Name = "Select Crop to Sell",
   Options = CropsList,
   CurrentOption = {"None"},
   MultipleOptions = false,
   Flag = "TargetSellDrop",
   Callback = function(Option)
        getgenv().KyrielConfig.TargetSell = Option[1]
   end,
})

TabMisc:CreateToggle({
   Name = "Auto Sell Selected Crop",
   CurrentValue = false,
   Flag = "AutoSellEnabled",
   Callback = function(Value)
        getgenv().KyrielConfig.AutoSell = Value
   end,
})


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

        -- Steal Night
        local isNightTime = Lighting.ClockTime < 6 or Lighting.ClockTime > 18
        if not acted and cfg.StealNight and isNightTime then
            for _, item in ipairs(Workspace:GetDescendants()) do
                if not cfg.StealNight or not (Lighting.ClockTime < 6 or Lighting.ClockTime > 18) then break end
                if isIgnored(item) then continue end
                
                local prompt = item:FindFirstChildWhichIsA("ProximityPrompt")
                local isHarvestable = false
                local tPart = nil
                
                if prompt and prompt.Enabled then
                    local actionText = string.lower(prompt.ActionText)
                    if string.find(actionText, "harvest") or string.find(actionText, "steal") then
                        
                        tPart = item:IsA("Model") and item.PrimaryPart or (item:IsA("BasePart") and item or item.Parent)
                        local parentName = item.Parent and item.Parent.Name or ""
                        local itemName = string.lower(parentName .. " " .. item.Name)
                        
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
                    -- Pastikan mencari text npc sell
                    if string.find(text, "sell") or string.find(text, "merchant") or string.find(text, "shop") then
                        local tPart = prompt.Parent
                        if tPart:IsA("BasePart") then
                            teleportTo(tPart.CFrame)
                            fireproximityprompt(prompt)
                            task.wait(1.5) -- Load UI time
                            
                            -- Cari UI Sell sesuai TargetSell atau Sell All
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

Rayfield:Notify({
   Title = "Kyriel Hub Injected",
   Content = "GaG 2 Script Loaded! Check your tabs.",
   Duration = 5,
   Image = 4483362458,
})
