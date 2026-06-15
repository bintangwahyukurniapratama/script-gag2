--[[
    Kyriel Hub | Grow a Garden 2
    Fitur: Steal Night + Auto Pickup (Rainbow/Gold Seed)
    Mobile friendly | Draggable | Compact
--]]

local Players      = game:GetService("Players")
local Workspace    = game:GetService("Workspace")
local Lighting     = game:GetService("Lighting")
local CoreGui      = game:GetService("CoreGui")
local RunService   = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP           = Players.LocalPlayer

-- ═══════════════════════════════════════════
-- CLEANUP
-- ═══════════════════════════════════════════
if CoreGui:FindFirstChild("KyrielHub") then
    CoreGui:FindFirstChild("KyrielHub"):Destroy()
end

-- ═══════════════════════════════════════════
-- STATE
-- ═══════════════════════════════════════════
local Enabled = {
    StealNight = false,
    AutoPickup = false,
}

local StealFilter = {
    All        = true,   -- kalau true, curi semua crop
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

local CROP_LIST = {
    "Bamboo","Blueberry","Corn","Mushroom","Apple",
    "Carrot","Pumpkin","Tomato","Watermelon","Wheat","Potato","Onion"
}

-- ═══════════════════════════════════════════
-- UI
-- ═══════════════════════════════════════════
local SG = Instance.new("ScreenGui")
SG.Name             = "KyrielHub"
SG.ResetOnSpawn     = false
SG.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder     = 999
SG.Parent           = CoreGui

-- Main frame
local Main = Instance.new("Frame")
Main.Name            = "Main"
Main.Size            = UDim2.new(0, 265, 0, 0)  -- height diisi auto
Main.Position        = UDim2.new(0, 8, 0, 8)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.Active          = true
Main.Draggable       = true
Main.Parent          = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local ms = Instance.new("UIStroke", Main)
ms.Color     = Color3.fromRGB(70, 70, 95)
ms.Thickness = 1.2

-- Title bar
local TBar = Instance.new("Frame", Main)
TBar.Size             = UDim2.new(1, 0, 0, 30)
TBar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
TBar.ZIndex           = 2
Instance.new("UICorner", TBar).CornerRadius = UDim.new(0, 10)
local tbc = Instance.new("Frame", TBar)  -- fix bottom corner
tbc.Size              = UDim2.new(1, 0, 0.5, 0)
tbc.Position          = UDim2.new(0, 0, 0.5, 0)
tbc.BackgroundColor3  = Color3.fromRGB(12, 12, 18)
tbc.BorderSizePixel   = 0

local TLbl = Instance.new("TextLabel", TBar)
TLbl.Size               = UDim2.new(1, -38, 1, 0)
TLbl.Position           = UDim2.new(0, 10, 0, 0)
TLbl.BackgroundTransparency = 1
TLbl.Text               = "⚡ Kyriel Hub | GaG 2"
TLbl.Font               = Enum.Font.GothamBold
TLbl.TextSize           = 13
TLbl.TextColor3         = Color3.fromRGB(220, 220, 255)
TLbl.TextXAlignment     = Enum.TextXAlignment.Left
TLbl.ZIndex             = 3

local MinBtn = Instance.new("TextButton", TBar)
MinBtn.Size             = UDim2.new(0, 26, 0, 26)
MinBtn.Position         = UDim2.new(1, -30, 0, 2)
MinBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
MinBtn.Text             = "−"
MinBtn.Font             = Enum.Font.GothamBold
MinBtn.TextSize         = 16
MinBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
MinBtn.BorderSizePixel  = 0
MinBtn.ZIndex           = 3
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- Scroll body
local Body = Instance.new("ScrollingFrame", Main)
Body.Name                  = "Body"
Body.Size                  = UDim2.new(1, 0, 0, 0)
Body.Position              = UDim2.new(0, 0, 0, 32)
Body.BackgroundTransparency = 1
Body.ScrollBarThickness    = 3
Body.ScrollBarImageColor3  = Color3.fromRGB(80, 80, 110)
Body.CanvasSize            = UDim2.new(0, 0, 0, 0)

local BList = Instance.new("UIListLayout", Body)
BList.SortOrder            = Enum.SortOrder.LayoutOrder
BList.Padding              = UDim.new(0, 4)
BList.HorizontalAlignment  = Enum.HorizontalAlignment.Center

local BPad = Instance.new("UIPadding", Body)
BPad.PaddingTop    = UDim.new(0, 6)
BPad.PaddingBottom = UDim.new(0, 8)

-- Auto height update
local MAX_H = 370  -- max frame tinggi
local function UpdateHeight()
    local contentH = BList.AbsoluteContentSize.Y + 16
    local frameH   = math.min(contentH + 32, MAX_H)
    local bodyH    = frameH - 32
    Main.Size = UDim2.new(0, 265, 0, frameH)
    Body.Size = UDim2.new(1, 0, 0, bodyH)
    Body.CanvasSize = UDim2.new(0, 0, 0, contentH)
end
BList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateHeight)

-- Minimize
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Body.Visible          = not minimized
    Main.Size             = minimized and UDim2.new(0, 265, 0, 32) or UDim2.new(0, 265, 0, math.min(BList.AbsoluteContentSize.Y + 48, MAX_H))
    MinBtn.Text           = minimized and "+" or "−"
    MinBtn.BackgroundColor3 = minimized and Color3.fromRGB(50, 180, 70) or Color3.fromRGB(220, 60, 60)
end)

-- ─── UI builders ───
local loIdx = 0
local function NextLO() loIdx += 1 return loIdx end

local function MkSection(txt)
    local f = Instance.new("Frame", Body)
    f.Size              = UDim2.new(0.94, 0, 0, 20)
    f.BackgroundColor3  = Color3.fromRGB(35, 35, 50)
    f.LayoutOrder       = NextLO()
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local l = Instance.new("TextLabel", f)
    l.Size              = UDim2.new(1, -8, 1, 0)
    l.Position          = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.Text              = txt
    l.Font              = Enum.Font.GothamBold
    l.TextSize          = 11
    l.TextColor3        = Color3.fromRGB(120, 180, 255)
    l.TextXAlignment    = Enum.TextXAlignment.Left
end

local function MkToggle(label, state, onChange)
    local btn = Instance.new("TextButton", Body)
    btn.Size              = UDim2.new(0.94, 0, 0, 30)
    btn.Font              = Enum.Font.Gotham
    btn.TextSize          = 12
    btn.TextXAlignment    = Enum.TextXAlignment.Left
    btn.BorderSizePixel   = 0
    btn.LayoutOrder       = NextLO()
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    local function Refresh(v)
        btn.BackgroundColor3 = v and Color3.fromRGB(40, 170, 80) or Color3.fromRGB(42, 42, 58)
        btn.TextColor3       = Color3.fromRGB(255, 255, 255)
        btn.Text             = "  " .. label .. (v and "   ✔" or "   ✘")
    end
    Refresh(state)

    btn.MouseButton1Click:Connect(function()
        state = not state
        Refresh(state)
        onChange(state)
    end)
    return btn
end

-- ─── Build UI content ───
MkSection(" ⚡ AUTO PICKUP  (Rainbow / Gold Seed)")
MkToggle("Auto Pickup Event Seed", false, function(v)
    Enabled.AutoPickup = v
end)

MkSection(" 🌙 STEAL NIGHT")
MkToggle("Enable Steal Night", false, function(v)
    Enabled.StealNight = v
end)

MkSection(" 🌱 CROP FILTER  (Steal Night)")
MkToggle("All Crops (default ON)", true, function(v)
    StealFilter.All = v
end)
for _, crop in ipairs(CROP_LIST) do
    local c = crop
    MkToggle(c, false, function(v)
        StealFilter[c] = v
    end)
end

-- trigger first height
task.defer(UpdateHeight)

-- ═══════════════════════════════════════════
-- UTILITY
-- ═══════════════════════════════════════════
local ignoreMap = {}
local function SetIgnore(obj, secs) ignoreMap[obj] = tick() + secs end
local function IsIgnored(obj) return ignoreMap[obj] and tick() < ignoreMap[obj] end

-- Teleport ke CFrame + sedikit offset atas
local function TP(cf)
    pcall(function()
        local char = LP.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = cf * CFrame.new(0, 3.5, 0)
            task.wait(0.05)
        end
    end)
end

-- Coba semua cara interact
local function Interact(part)
    pcall(function()
        local char = LP.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Touch (cara paling reliable di GaG2 untuk pickup)
            if firetouchinterest then
                firetouchinterest(hrp, part, 0)
                task.wait(0.06)
                firetouchinterest(hrp, part, 1)
            end
        end
        -- ProximityPrompt
        local pp = part:FindFirstChildWhichIsA("ProximityPrompt")
            or part.Parent and part.Parent:FindFirstChildWhichIsA("ProximityPrompt")
        if pp and pp.Enabled then
            fireproximityprompt(pp)
        end
        -- ClickDetector
        local cd = part:FindFirstChildWhichIsA("ClickDetector")
        if cd then fireclickdetector(cd) end
    end)
end

-- Cek player lain dekat posisi (radius 55 stud = anggap penjaga ada)
local function OwnerNearby(pos)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local c   = p.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - pos).Magnitude < 55 then
                return true
            end
        end
    end
    return false
end

-- Filter crop name check
local function CropAllowed(name)
    if StealFilter.All then return true end
    local lower = string.lower(name)
    for _, crop in ipairs(CROP_LIST) do
        if StealFilter[crop] and string.find(lower, string.lower(crop)) then
            return true
        end
    end
    return false
end

-- Malam = ClockTime < 6 atau > 18
local function IsNight()
    local t = Lighting.ClockTime
    return t < 6 or t > 18
end

-- ═══════════════════════════════════════════
-- MAIN LOOP
-- ═══════════════════════════════════════════
task.spawn(function()
    while true do
        task.wait(0.35)
        pcall(function()

            local char = LP.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- ────────────────────────────────
            -- AUTO PICKUP: Rainbow & Gold Seed
            -- Scan SEMUA descendants workspace
            -- GaG2 event drop = biasanya Model/Tool di workspace
            -- dengan nama "Rainbow Seed" atau "Gold Seed"
            -- ────────────────────────────────
            if Enabled.AutoPickup then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if IsIgnored(obj) then continue end
                    local n = string.lower(obj.Name)

                    -- Match: mengandung "rainbow" ATAU "gold", DAN "seed"
                    local isTarget = (string.find(n, "rainbow") or string.find(n, "gold"))
                                  and string.find(n, "seed")

                    if not isTarget then continue end

                    -- Cari BasePart yang bisa di-interact
                    local target = nil
                    if obj:IsA("BasePart") then
                        target = obj
                    elseif obj:IsA("Tool") then
                        target = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    elseif obj:IsA("Model") then
                        target = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    end

                    if target then
                        TP(target.CFrame)
                        task.wait(0.1)
                        Interact(target)
                        -- Juga coba touch langsung hrp ke part
                        pcall(function()
                            if firetouchinterest then
                                firetouchinterest(hrp, target, 0)
                                task.wait(0.05)
                                firetouchinterest(hrp, target, 1)
                            end
                        end)
                        SetIgnore(obj, 5)
                    end
                end
            end

            -- ────────────────────────────────
            -- STEAL NIGHT
            -- Hanya jalan saat malam, dan garden tidak dijaga
            -- ────────────────────────────────
            if Enabled.StealNight and IsNight() then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not Enabled.StealNight or not IsNight() then break end
                    if IsIgnored(obj) then continue end

                    -- Cari ProximityPrompt yang punya action "Steal" atau "Harvest"
                    local pp = nil
                    if obj:IsA("ProximityPrompt") then
                        pp = obj
                    end
                    if not pp then continue end
                    if not pp.Enabled then continue end

                    local actionLow = string.lower(pp.ActionText)
                    local isSteal = string.find(actionLow, "steal")
                               or  string.find(actionLow, "harvest")
                               or  string.find(actionLow, "pick")
                    if not isSteal then continue end

                    -- Ambil BasePart induk
                    local part = pp.Parent
                    if not part then continue end
                    -- Kalau parent bukan BasePart, coba parent.PrimaryPart
                    if not part:IsA("BasePart") then
                        part = part:IsA("Model") and (part.PrimaryPart or part:FindFirstChildWhichIsA("BasePart")) or nil
                    end
                    if not part then continue end
                    if IsIgnored(part) then continue end

                    -- Filter crop
                    local nameCheck = pp.Parent.Name .. " " .. (pp.Parent.Parent and pp.Parent.Parent.Name or "")
                    if not CropAllowed(nameCheck) then continue end

                    -- Skip jika pemilik ada di sekitar
                    if OwnerNearby(part.Position) then continue end

                    -- TP dan fire prompt
                    TP(part.CFrame)
                    task.wait(0.12)
                    fireproximityprompt(pp)
                    SetIgnore(part, 7)
                    SetIgnore(pp.Parent, 7)
                    task.wait(0.15)
                end
            end

        end)
    end
end)
