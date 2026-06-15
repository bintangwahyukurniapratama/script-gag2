-- Kyriel Hub | GaG2 | Steal Night + Auto Pickup ONLY
-- Mobile friendly, draggable, compact
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Cleanup
if CoreGui:FindFirstChild("KyrielHub") then CoreGui.KyrielHub:Destroy() end

-- State
local cfg = {
    StealNight = false,
    AutoPickup  = false,
    StealFilter = {
        All        = true,
        Bamboo     = false,
        Blueberry  = false,
        Corn       = false,
        Mushroom   = false,
        Apple      = false,
        Carrot     = false,
        Pumpkin    = false,
        Tomato     = false,
        Watermelon = false,
        Wheat      = false,
        Potato     = false,
        Onion      = false,
    }
}

-- ============ UI ============
local SG = Instance.new("ScreenGui")
SG.Name = "KyrielHub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = CoreGui

-- Main frame (kecil, di tengah atas)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 270, 0, 380)
Main.Position = UDim2.new(0, 10, 0, 10)   -- pojok kiri atas, ga nembus
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Main.Active = true
Main.Draggable = true
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Stroke
local stroke = Instance.new("UIStroke", Main)
stroke.Color = Color3.fromRGB(80, 80, 100)
stroke.Thickness = 1

-- Title bar
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)
-- cover agar corner bawah title ga kelihatan
local cover = Instance.new("Frame", TitleBar)
cover.Size = UDim2.new(1, 0, 0.5, 0)
cover.Position = UDim2.new(0, 0, 0.5, 0)
cover.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
cover.BorderSizePixel = 0

local TitleLbl = Instance.new("TextLabel", TitleBar)
TitleLbl.Size = UDim2.new(1, -40, 1, 0)
TitleLbl.Position = UDim2.new(0, 10, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "⚡ Kyriel | GaG 2"
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 13
TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -32, 0, 2)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
MinBtn.Text = "−"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- Content scroll
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Name = "Scroll"
Scroll.Size = UDim2.new(1, 0, 1, -36)
Scroll.Position = UDim2.new(0, 0, 0, 34)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local List = Instance.new("UIListLayout", Scroll)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Padding = UDim.new(0, 5)
List.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Padding = Instance.new("UIPadding", Scroll)
Padding.PaddingTop = UDim.new(0, 6)

-- Auto resize scroll
local function UpdateScroll()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 14)
end
List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateScroll)

-- Minimize
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Scroll.Visible = not minimized
    Main.Size = minimized and UDim2.new(0, 270, 0, 36) or UDim2.new(0, 270, 0, 380)
    MinBtn.Text = minimized and "+" or "−"
    MinBtn.BackgroundColor3 = minimized and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(255, 70, 70)
end)

-- ===== UI Builders =====
local function MakeSection(label)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(0.94, 0, 0, 20)
    f.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    f.LayoutOrder = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, -8, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = Color3.fromRGB(140, 200, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function MakeToggle(label, default, onToggle)
    local state = default
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.94, 0, 0, 32)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    local function Refresh()
        btn.BackgroundColor3 = state and Color3.fromRGB(50, 180, 90) or Color3.fromRGB(45, 45, 55)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Text = "  " .. label .. (state and "  ✔" or "  ✘")
    end
    Refresh()

    btn.MouseButton1Click:Connect(function()
        state = not state
        Refresh()
        onToggle(state)
    end)
    return btn
end

-- ===== Build UI Content =====
MakeSection("  AUTO PICKUP (Drop / Event)")
MakeToggle("Auto Pickup Items / Drops", false, function(v) cfg.AutoPickup = v end)

MakeSection("  STEAL NIGHT")
MakeToggle("Enable Steal Night", false, function(v) cfg.StealNight = v end)

MakeSection("  CROP FILTER  (Steal)")
MakeToggle("All Crops", true, function(v)
    cfg.StealFilter.All = v
end)

local cropOrder = {"Bamboo","Blueberry","Corn","Mushroom","Apple","Carrot","Pumpkin","Tomato","Watermelon","Wheat","Potato","Onion"}
for _, crop in ipairs(cropOrder) do
    local c = crop
    MakeToggle(c, false, function(v)
        cfg.StealFilter[c] = v
    end)
end

-- ============ CORE LOGIC ============
local ignoreMap = {}
local function SetIgnore(obj, secs)
    ignoreMap[obj] = tick() + secs
end
local function IsIgnored(obj)
    local t = ignoreMap[obj]
    return t and tick() < t
end

-- Teleport safe
local function TP(cf)
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = cf + Vector3.new(0, 3, 0) -- offset sedikit di atas biar ga nyangkut
        end
    end)
end

-- Fire semua cara interact yang umum di roblox executors
local function DoInteract(part)
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if firetouchinterest then
                firetouchinterest(hrp, part, 0)
                task.wait(0.05)
                firetouchinterest(hrp, part, 1)
            end
        end
        -- ProximityPrompt
        local pp = part:FindFirstChildWhichIsA("ProximityPrompt", true)
        if pp and pp.Enabled then
            fireproximityprompt(pp)
        end
        -- ClickDetector
        local cd = part:FindFirstChildWhichIsA("ClickDetector", true)
        if cd then fireclickdetector(cd) end
    end)
end

-- Cek apakah ada player lain dekat posisi itu
local function OwnerNearby(pos)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - pos).Magnitude < 60 then
                return true
            end
        end
    end
    return false
end

-- Cek apakah nama crop valid sesuai filter
local function CropAllowed(name)
    if cfg.StealFilter.All then return true end
    local lower = string.lower(name)
    for _, crop in ipairs(cropOrder) do
        if cfg.StealFilter[crop] and string.find(lower, string.lower(crop)) then
            return true
        end
    end
    return false
end

-- ===== MAIN LOOP =====
task.spawn(function()
    while true do
        task.wait(0.4)
        pcall(function()

            -- ---- AUTO PICKUP (Rainbow Seed & Gold Seed dari event) ----
            if cfg.AutoPickup then
                -- Scan semua descendants workspace
                -- Event seed biasanya berbentuk Tool atau Model di dalam workspace langsung
                -- atau di folder seperti "Drops", "EventDrops", dsb.
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if IsIgnored(obj) then continue end

                    local targetPart = nil
                    local targetRoot = nil

                    -- Kalau dia Tool (dropped)
                    if obj:IsA("Tool") then
                        local n = string.lower(obj.Name)
                        -- Spesifik Rainbow Seed dan Gold Seed
                        local isRainbow = string.find(n, "rainbow") and string.find(n, "seed")
                        local isGold    = string.find(n, "gold")    and string.find(n, "seed")
                        if isRainbow or isGold then
                            targetPart = obj:FindFirstChild("Handle")
                            targetRoot = obj
                        end
                    end

                    -- Kalau dia BasePart dengan nama seed
                    if obj:IsA("BasePart") and not targetPart then
                        local n = string.lower(obj.Name)
                        local isRainbow = string.find(n, "rainbow") and string.find(n, "seed")
                        local isGold    = string.find(n, "gold")    and string.find(n, "seed")
                        if isRainbow or isGold then
                            targetPart = obj
                            targetRoot = obj
                        end
                    end

                    -- Kalau dia Model yang namanya Rainbow/Gold Seed
                    if obj:IsA("Model") and not targetPart then
                        local n = string.lower(obj.Name)
                        local isRainbow = string.find(n, "rainbow") and string.find(n, "seed")
                        local isGold    = string.find(n, "gold")    and string.find(n, "seed")
                        if isRainbow or isGold then
                            targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            targetRoot = obj
                        end
                    end

                    if targetPart and targetRoot then
                        TP(targetPart.CFrame)
                        task.wait(0.1)
                        DoInteract(targetPart)
                        SetIgnore(targetRoot, 5)
                    end
                end
            end

            -- ---- STEAL NIGHT ----
            -- Hanya jalan saat malam: ClockTime < 6 (subuh) atau > 18 (sore ke malam)
            local clockTime = Lighting.ClockTime
            local isNight = clockTime < 6 or clockTime > 18

            if cfg.StealNight and isNight then
                for _, pp in ipairs(Workspace:GetDescendants()) do
                    if not pp:IsA("ProximityPrompt") then continue end
                    if not pp.Enabled then continue end

                    local actionLow = string.lower(pp.ActionText)
                    -- GaG2 prompt untuk crop orang lain: "Steal" atau "Harvest"
                    local isStealAction = string.find(actionLow, "steal") or string.find(actionLow, "harvest")
                    if not isStealAction then continue end

                    local part = pp.Parent
                    if not part or not part:IsA("BasePart") then continue end
                    if IsIgnored(part) then continue end

                    -- Filter crop
                    local fullName = part.Name .. " " .. (part.Parent and part.Parent.Name or "")
                    if not CropAllowed(fullName) then continue end

                    -- Skip kalau ada owner di sekitar (radius 60 stud)
                    if OwnerNearby(part.Position) then continue end

                    -- TP dan steal
                    TP(part.CFrame)
                    task.wait(0.15)
                    fireproximityprompt(pp)
                    SetIgnore(part, 6)
                    task.wait(0.2)
                end
            end

        end)
    end
end)
