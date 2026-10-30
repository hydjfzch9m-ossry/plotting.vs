--================================================
-- PLOTTIN.VS | CLIENT VISUAL PANEL
-- Single LocalScript
--================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Old = PlayerGui:FindFirstChild("plottin.vs")
if Old then Old:Destroy() end

local GUI = Instance.new("ScreenGui")
GUI.Name = "plottin.vs"
GUI.ResetOnSpawn = false
GUI.Parent = PlayerGui

local C = {
    Background = Color3.fromRGB(12,11,17),
    Panel = Color3.fromRGB(23,21,31),
    Element = Color3.fromRGB(36,32,49),
    Purple = Color3.fromRGB(155,95,255),
    White = Color3.fromRGB(245,243,250),
    Gray = Color3.fromRGB(145,140,155)
}

local function New(class, properties, parent)
    local obj = Instance.new(class)
    for k,v in pairs(properties) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function Round(obj, radius)
    New("UICorner", {
        CornerRadius = UDim.new(0,radius or 8)
    },obj)
end

local Main = New("Frame",{
    Name = "Main",
    Size = UDim2.new(0,850,0,440),
    Position = UDim2.new(.5,-425,.5,-220),
    BackgroundColor3 = C.Background,
    BorderSizePixel = 0
},GUI)
Round(Main,12)

New("UIStroke",{
    Color = C.Purple,
    Transparency = .45,
    Thickness = 1
},Main)

local Header = New("Frame",{
    Size = UDim2.new(1,0,0,48),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0
},Main)
Round(Header,12)

New("TextLabel",{
    Text = "plottin.vs",
    Font = Enum.Font.GothamBold,
    TextSize = 21,
    TextColor3 = C.White,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(18,0),
    Size = UDim2.new(0,200,1,0),
    TextXAlignment = Enum.TextXAlignment.Left
},Header)

local Minimize = New("TextButton",{
    Text = "−",
    TextSize = 24,
    Font = Enum.Font.Gotham,
    TextColor3 = C.White,
    BackgroundTransparency = 1,
    Size = UDim2.fromOffset(42,45),
    Position = UDim2.new(1,-85,0,0)
},Header)

local Close = New("TextButton",{
    Text = "×",
    TextSize = 23,
    Font = Enum.Font.Gotham,
    TextColor3 = C.White,
    BackgroundTransparency = 1,
    Size = UDim2.fromOffset(42,45),
    Position = UDim2.new(1,-45,0,0)
},Header)

local Reopen = New("TextButton",{
    Text = "P",
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextColor3 = C.White,
    BackgroundColor3 = C.Panel,
    Size = UDim2.fromOffset(48,48),
    Position = UDim2.new(0,15,.5,0),
    Visible = false
},GUI)
Round(Reopen,10)

Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    Reopen.Visible = true
end)

Reopen.MouseButton1Click:Connect(function()
    Main.Visible = true
    Reopen.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    GUI:Destroy()
end)

-- DRAGGING
local dragging = false
local dragStart, startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position-dragStart
        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset+delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset+delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- NAVIGATION
local Sidebar = New("Frame",{
    Position = UDim2.fromOffset(12,60),
    Size = UDim2.new(0,140,1,-72),
    BackgroundTransparency = 1
},Main)

New("UIListLayout",{
    Padding = UDim.new(0,7)
},Sidebar)

local Content = New("Frame",{
    Position = UDim2.fromOffset(162,60),
    Size = UDim2.new(1,-174,1,-72),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0
},Main)
Round(Content,9)

local Pages = {}
local CurrentButton

local function CreatePage(name)
    local page = New("ScrollingFrame",{
        Name = name,
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Purple,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    },Content)

    New("UIPadding",{
        PaddingTop = UDim.new(0,12),
        PaddingLeft = UDim.new(0,13),
        PaddingRight = UDim.new(0,13),
        PaddingBottom = UDim.new(0,12)
    },page)

    New("UIListLayout",{
        Padding = UDim.new(0,8),
        SortOrder = Enum.SortOrder.LayoutOrder
    },page)

    Pages[name] = page

    local button = New("TextButton",{
        Text = name,
        Size = UDim2.new(1,0,0,36),
        BackgroundColor3 = C.Element,
        TextColor3 = C.Gray,
        Font = Enum.Font.GothamMedium,
        TextSize = 12
    },Sidebar)
    Round(button,7)

    button.MouseButton1Click:Connect(function()
        for _,p in pairs(Pages) do
            p.Visible = false
        end
        page.Visible = true

        if CurrentButton then
            CurrentButton.BackgroundColor3 = C.Element
            CurrentButton.TextColor3 = C.Gray
        end

        button.BackgroundColor3 = Color3.fromRGB(65,42,95)
        button.TextColor3 = C.White
        CurrentButton = button
    end)

    if not CurrentButton then
        CurrentButton = button
        button.BackgroundColor3 = Color3.fromRGB(65,42,95)
        button.TextColor3 = C.White
        page.Visible = true
    end

    return page
end

local function Heading(parent,text)
    return New("TextLabel",{
        Text = text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextColor3 = C.Purple,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,0,26),
        TextXAlignment = Enum.TextXAlignment.Left
    },parent)
end

local function Button(parent,text,callback)
    local b = New("TextButton",{
        Text = text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextColor3 = C.White,
        BackgroundColor3 = C.Element,
        Size = UDim2.new(1,0,0,35)
    },parent)
    Round(b,7)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function TextBox(parent,placeholder)
    local box = New("TextBox",{
        PlaceholderText = placeholder,
        Text = "",
        ClearTextOnFocus = false,
        TextColor3 = C.White,
        PlaceholderColor3 = C.Gray,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        BackgroundColor3 = C.Background,
        Size = UDim2.new(1,0,0,35)
    },parent)
    Round(box,7)
    return box
end

-- WORLDS
local Worlds = CreatePage("Worlds")
Heading(Worlds,"TEXTURE PACKS")

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogColor = Lighting.FogColor,
    FogEnd = Lighting.FogEnd
}

local OriginalParts = {}

local function SavePart(part)
    if not OriginalParts[part] then
        OriginalParts[part] = {
            Color = part.Color,
            Material = part.Material,
            Reflectance = part.Reflectance
        }
    end
end

local Packs = {
    Glossy = {
        Color = Color3.fromRGB(220,220,240),
        Material = Enum.Material.SmoothPlastic,
        Brightness = 3,
        Ambient = Color3.fromRGB(180,180,200)
    },
    Old = {
        Color = Color3.fromRGB(175,155,125),
        Material = Enum.Material.Concrete,
        Brightness = 1.5,
        Ambient = Color3.fromRGB(115,105,90)
    },
    Spooky = {
        Color = Color3.fromRGB(105,90,135),
        Material = Enum.Material.Slate,
        Brightness = .7,
        Ambient = Color3.fromRGB(55,35,75)
    },
    Bright = {
        Color = Color3.fromRGB(255,255,255),
        Material = Enum.Material.SmoothPlastic,
        Brightness = 4,
        Ambient = Color3.fromRGB(210,210,210)
    },
    Realistic = {
        Color = Color3.fromRGB(220,220,220),
        Material = Enum.Material.Concrete,
        Brightness = 2,
        Ambient = Color3.fromRGB(150,150,150)
    },
    Winter = {
        Color = Color3.fromRGB(195,220,255),
        Material = Enum.Material.Ice,
        Brightness = 2,
        Ambient = Color3.fromRGB(150,190,230)
    },
    Neon = {
        Color = Color3.fromRGB(180,100,255),
        Material = Enum.Material.Neon,
        Brightness = 2,
        Ambient = Color3.fromRGB(100,40,180)
    },
    Night = {
        Color = Color3.fromRGB(85,95,145),
        Material = Enum.Material.Slate,
        Brightness = .5,
        Ambient = Color3.fromRGB(35,40,75)
    }
}

local function ApplyPack(name)
    local pack = Packs[name]
    if not pack then return end

    -- Only modifies map models, not player characters.
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and
        not obj:IsDescendantOf(workspace:FindFirstChild("Characters") or Instance.new("Folder")) then
            SavePart(obj)
            obj.Color = pack.Color
            obj.Material = pack.Material
        end
    end

    Lighting.Brightness = pack.Brightness
    Lighting.Ambient = pack.Ambient
    Lighting.OutdoorAmbient = pack.Ambient

    print("plottin.vs applied: "..name)
end

for name in pairs(Packs) do
    Button(Worlds,"Apply "..name,function()
        ApplyPack(name)
    end)
end

Button(Worlds,"RESET ORIGINAL MAP",function()
    for part,data in pairs(OriginalParts) do
        if part.Parent then
            part.Color = data.Color
            part.Material = data.Material
            part.Reflectance = data.Reflectance
        end
    end

    for property,value in pairs(OriginalLighting) do
        Lighting[property] = value
    end
end)

-- IDENTITY
local Identity = CreatePage("Identity")
Heading(Identity,"CUSTOM DISPLAY NAME")

local NameInput = TextBox(Identity,"Enter a custom display name")

Button(Identity,"Apply Name Preview",function()
    print("Custom display name: "..NameInput.Text)
end)

Button(Identity,"Reset Name",function()
    NameInput.Text = ""
end)

Heading(Identity,"DEVICE DISPLAY")

local Device = "PC"

for _,name in ipairs({"Phone","PC","Console","VR","Tablet"}) do
    Button(Identity,name,function()
        Device = name
        print("Device display set to "..Device)
    end)
end

-- VISUALS
local Visuals = CreatePage("Visuals")
Heading(Visuals,"CROSSHAIR")

local Crosshair = New("TextLabel",{
    Text = "+",
    Size = UDim2.fromOffset(40,40),
    Position = UDim2.fromScale(.5,.5),
    AnchorPoint = Vector2.new(.5,.5),
    BackgroundTransparency = 1,
    TextColor3 = C.White,
    TextSize = 26,
    Font = Enum.Font.GothamBold
},GUI)

Button(Visuals,"Toggle Crosshair",function()
    Crosshair.Visible = not Crosshair.Visible
end)

Button(Visuals,"Purple Crosshair",function()
    Crosshair.TextColor3 = C.Purple
end)

Button(Visuals,"White Crosshair",function()
    Crosshair.TextColor3 = C.White
end)

Button(Visuals,"Red Crosshair",function()
    Crosshair.TextColor3 = Color3.fromRGB(255,65,65)
end)

-- PERFORMANCE
local Performance = CreatePage("Performance")
Heading(Performance,"CLIENT PERFORMANCE")

local FPSLabel = New("TextLabel",{
    Text = "FPS: 0",
    Size = UDim2.new(1,0,0,28),
    BackgroundTransparency = 1,
    TextColor3 = C.White,
    TextSize = 13,
    Font = Enum.Font.Gotham
},Performance)

local frames,elapsed = 0,0

RunService.RenderStepped:Connect(function(dt)
    frames += 1
    elapsed += dt
    if elapsed >= 1 then
        FPSLabel.Text = "FPS: "..math.floor(frames/elapsed)
        frames,elapsed = 0,0
    end
end)

-- SETTINGS
local Settings = CreatePage("Settings")
Heading(Settings,"ANIMATED SNOW")

local SnowEnabled = true
local SnowObjects = {}

local function SpawnSnow()
    if not SnowEnabled or not Main.Visible then return end

    local side = math.random(1,2)
    local x = side == 1 and math.random(0,12)/100
        or math.random(88,99)/100

    local flake = New("TextLabel",{
        Text = "❄",
        TextSize = math.random(10,18),
        TextColor3 = Color3.fromRGB(225,225,255),
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(24,24),
        Position = UDim2.fromScale(x,-.05)
    },GUI)

    table.insert(SnowObjects,flake)

    local tween = TweenService:Create(
        flake,
        TweenInfo.new(math.random(5,10),Enum.EasingStyle.Linear),
        {
            Position = UDim2.fromScale(
                x+math.random(-5,5)/100,
                1.1
            ),
            Rotation = 360
        }
    )

    tween:Play()
    tween.Completed:Connect(function()
        if flake.Parent then flake:Destroy() end
    end)
end

Button(Settings,"Toggle Snow",function()
    SnowEnabled = not SnowEnabled
    for _,flake in ipairs(SnowObjects) do
        flake.Visible = SnowEnabled and Main.Visible
    end
end)

Heading(Settings,"WATERMARK")

local Watermark = New("TextLabel",{
    Text = "plottin.vs | "..Player.Name,
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextColor3 = C.White,
    BackgroundColor3 = C.Background,
    Size = UDim2.fromOffset(300,26),
    Position = UDim2.new(.5,-150,1,-32)
},GUI)
Round(Watermark,6)

Button(Settings,"Toggle Watermark",function()
    Watermark.Visible = not Watermark.Visible
end)

Heading(Settings,"INTERFACE")

Button(Settings,"Reset Panel Position",function()
    Main.Position = UDim2.new(.5,-425,.5,-220)
end)

Button(Settings,"Reset Crosshair",function()
    Crosshair.Text = "+"
    Crosshair.TextColor3 = C.White
    Crosshair.Visible = true
end)

Button(Settings,"Reset Texture Pack",function()
    for part,data in pairs(OriginalParts) do
        if part.Parent then
            part.Color = data.Color
            part.Material = data.Material
            part.Reflectance = data.Reflectance
        end
    end
    for property,value in pairs(OriginalLighting) do
        Lighting[property] = value
    end
end)

task.spawn(function()
    while GUI.Parent do
        SpawnSnow()
        task.wait(.2)
    end
end)

Main:GetPropertyChangedSignal("Visible"):Connect(function()
    for _,flake in ipairs(SnowObjects) do
        flake.Visible = Main.Visible and SnowEnabled
    end
end)

print("plottin.vs loaded.")
