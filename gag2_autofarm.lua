-- GaG 2 Perfected Auto Farm Script v9 (Rayfield UI + Mobile Logo + Filters)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

getgenv().AutoCollectRainbow = false
getgenv().AutoCollectGold = false
getgenv().AutoCollectAll = false
getgenv().StealNight = false
getgenv().WalkSpeedToggle = false
getgenv().WalkSpeedValue = 16
getgenv().JumpPowerToggle = false
getgenv().JumpPowerValue = 50
getgenv().SafeHomeCFrame = nil

getgenv().StealCrops = {"All"}
getgenv().StealMutations = {"All"}

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

-- Master Loop
task.spawn(function()
    while task.wait(0.5) do
        local acted = false
        
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
                        
                        -- Evaluate Crop & Mutation Filters
                        local parentName = item.Parent and item.Parent.Name or ""
                        local itemName = string.lower(parentName .. " " .. item.Name)
                        
                        local validCrop = false
                        if table.find(getgenv().StealCrops, "All") then
                            validCrop = true
                        else
                            for _, crop in ipairs(getgenv().StealCrops) do
                                if string.find(itemName, string.lower(crop)) then
                                    validCrop = true
                                    break
                                end
                            end
                        end
                        
                        local validMut = false
                        if table.find(getgenv().StealMutations, "All") then
                            validMut = true
                        else
                            local hasMut = false
                            for _, mut in ipairs({"bloodlit", "electric", "frozen", "rainbow", "starstruck", "gold", "chained"}) do
                                if string.find(itemName, mut) then
                                    hasMut = true
                                    if table.find(getgenv().StealMutations, mut:gsub("^%l", string.upper)) then
                                        validMut = true
                                        break
                                    end
                                end
                            end
                            if not hasMut and table.find(getgenv().StealMutations, "None") then
                                validMut = true
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
        
        -- Safe Home Return
        if not acted and getgenv().SafeHomeCFrame and (getgenv().AutoCollectRainbow or getgenv().AutoCollectGold or getgenv().AutoCollectAll or getgenv().StealNight) then
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

-- WalkSpeed & JumpPower Loop
task.spawn(function()
    while task.wait(0.1) do
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("Humanoid") then
            if getgenv().WalkSpeedToggle then
                Char.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
            end
            if getgenv().JumpPowerToggle then
                Char.Humanoid.JumpPower = getgenv().JumpPowerValue
            end
        end
    end
end)

-- Floating Logo Toggle (For Mobile/Small Screens)
if CoreGui:FindFirstChild("KyrielToggleLogo") then
    CoreGui.KyrielToggleLogo:Destroy()
end

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "KyrielToggleLogo"
ToggleGui.Parent = CoreGui

local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -25, 0, 10)
ToggleBtn.Image = "rbxassetid://4483362458" -- Ninja Icon
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.UICorner = Instance.new("UICorner", ToggleBtn)
ToggleBtn.UICorner.CornerRadius = UDim.new(0.5, 0)
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ToggleGui

local isUiVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    isUiVisible = not isUiVisible
    local rayfieldGui = CoreGui:FindFirstChild("Rayfield")
    if rayfieldGui then
        rayfieldGui.Enabled = isUiVisible
    end
end)

-- Rayfield UI Initialization
getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/siriussoftwarehub/Rayfield/build/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Kyriel Hub | GaG 2",
   LoadingTitle = "Loading Kyriel Hub...",
   LoadingSubtitle = "by Kyriel",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "KyrielHub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local StealTab = Window:CreateTab("Steal", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)

-- Main Tab
MainTab:CreateSection("Auto Collect Drops")

MainTab:CreateToggle({
   Name = "Auto Collect Rainbow Seed",
   CurrentValue = false,
   Flag = "AutoRainbow",
   Callback = function(Value)
        getgenv().AutoCollectRainbow = Value
   end,
})

MainTab:CreateToggle({
   Name = "Auto Collect Gold Seed",
   CurrentValue = false,
   Flag = "AutoGold",
   Callback = function(Value)
        getgenv().AutoCollectGold = Value
   end,
})

MainTab:CreateToggle({
   Name = "Auto Collect All Dropped Items",
   CurrentValue = false,
   Flag = "AutoAllDrops",
   Callback = function(Value)
        getgenv().AutoCollectAll = Value
   end,
})

-- Steal Tab
StealTab:CreateSection("Steal Filters")

StealTab:CreateDropdown({
   Name = "Select Crops to Steal",
   Options = {"All", "Bamboo", "Blueberry", "Corn", "Mushroom", "Apple", "Carrot", "Pumpkin", "Tomato", "Watermelon"},
   CurrentOption = {"All"},
   MultipleOptions = true,
   Flag = "DropdownCrops",
   Callback = function(Options)
        getgenv().StealCrops = Options
   end,
})

StealTab:CreateDropdown({
   Name = "Select Mutations to Steal",
   Options = {"All", "None", "Bloodlit", "Electric", "Frozen", "Rainbow", "Starstruck", "Gold", "Chained"},
   CurrentOption = {"All"},
   MultipleOptions = true,
   Flag = "DropdownMutations",
   Callback = function(Options)
        getgenv().StealMutations = Options
   end,
})

StealTab:CreateSection("Steal Execution")

StealTab:CreateToggle({
   Name = "Steal Night (Safe Mode)",
   CurrentValue = false,
   Flag = "StealNight",
   Callback = function(Value)
        getgenv().StealNight = Value
   end,
})

StealTab:CreateButton({
   Name = "Set Safe Return Garden (Home)",
   Callback = function()
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            getgenv().SafeHomeCFrame = Char.HumanoidRootPart.CFrame
            Rayfield:Notify({
               Title = "Home Set",
               Content = "Character will return here after collecting/stealing.",
               Duration = 3,
               Image = 4483362458,
            })
        end
   end,
})

-- Player Tab
PlayerTab:CreateSection("Local Player Modifications")

PlayerTab:CreateToggle({
   Name = "Walk Speed Modifier",
   CurrentValue = false,
   Flag = "WSToggle",
   Callback = function(Value)
        getgenv().WalkSpeedToggle = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "Walk Speed Value",
   Range = {16, 200},
   Increment = 1,
   Suffix = "WS",
   CurrentValue = 16,
   Flag = "WSValue",
   Callback = function(Value)
        getgenv().WalkSpeedValue = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "Jump Power Modifier",
   CurrentValue = false,
   Flag = "JPToggle",
   Callback = function(Value)
        getgenv().JumpPowerToggle = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "Jump Power Value",
   Range = {50, 200},
   Increment = 1,
   Suffix = "JP",
   CurrentValue = 50,
   Flag = "JPValue",
   Callback = function(Value)
        getgenv().JumpPowerValue = Value
   end,
})

Rayfield:LoadConfiguration()
