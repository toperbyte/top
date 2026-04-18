local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local TouchEnabled = UserInputService.TouchEnabled

local Camera = Workspace.CurrentCamera
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()
local gui_offset = GuiService:GetGuiInset().Y

local vec2 = Vector2.new
local vec3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new
local dim_offset = UDim2.fromOffset
local color = Color3.new
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local hsv = Color3.fromHSV
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new
local numseq = NumberSequence.new
local numkey = NumberSequenceKeypoint.new

getgenv().Library = {
    Directory = "Library",
    Folders = {"/configs"},
    Flags = {},
    ConfigFlags = {},
    Connections = {},
    Notifications = {Notifs = {}},
    OpenElement = {},
    EasingStyle = Enum.EasingStyle.Quint,
    TweeningSpeed = 0.25,
    ActiveTheme = "darknights"
}

local themes = {
    darknights = {
        inline = rgb(30, 30, 35);
        gradient = rgb(25, 25, 30);
        outline = rgb(15, 15, 20);
        accent = rgb(200, 80, 120);
        background = rgb(20, 20, 25);
        text_color = rgb(240, 240, 245);
        text_outline = rgb(0, 0, 0);
        tab_background = rgb(28, 28, 33);
    },
    light = {
        inline = rgb(240, 240, 245);
        gradient = rgb(230, 230, 235);
        outline = rgb(200, 200, 205);
        accent = rgb(80, 120, 200);
        background = rgb(245, 245, 250);
        text_color = rgb(20, 20, 25);
        text_outline = rgb(255, 255, 255);
        tab_background = rgb(235, 235, 240);
    },
    cyberpunk = {
        inline = rgb(20, 20, 40);
        gradient = rgb(15, 15, 35);
        outline = rgb(0, 255, 255);
        accent = rgb(255, 0, 255);
        background = rgb(10, 10, 30);
        text_color = rgb(0, 255, 255);
        text_outline = rgb(0, 0, 0);
        tab_background = rgb(25, 25, 45);
    },
    midnight = {
        inline = rgb(25, 25, 35);
        gradient = rgb(20, 20, 30);
        outline = rgb(10, 10, 20);
        accent = rgb(100, 150, 255);
        background = rgb(15, 15, 25);
        text_color = rgb(220, 220, 250);
        text_outline = rgb(0, 0, 0);
        tab_background = rgb(22, 22, 32);
    }
}

local function applyTheme(themeName)
    local theme = themes[themeName]
    if not theme then return end
    
    themes.preset = theme
    
    for prop, colorValue in pairs(theme) do
        for property, instances in themes.utility[prop] or {} do 
            for _, object in instances do
                if object[property] then
                    object[property] = colorValue
                end
            end
        end
    end
    
    for _, seq in themes.gradients.Selected do
        if seq then
            seq.Color = rgbseq{rgbkey(0, theme.inline), rgbkey(1, theme.gradient)}
        end
    end
    
    for _, seq in themes.gradients.Deselected do
        if seq then
            seq.Color = rgbseq{rgbkey(0, theme.gradient), rgbkey(1, theme.background)}
        end
    end
end

themes.preset = themes.darknights
themes.utility = {}
themes.gradients = {Selected = {}, Deselected = {}}

for theme, color in pairs(themes.preset) do
    themes.utility[theme] = {
        BackgroundColor3 = {},
        TextColor3 = {},
        ImageColor3 = {},
        ScrollBarImageColor3 = {},
        Color = {}
    }
end

local Keys = {
    [Enum.KeyCode.LeftShift] = "LS", [Enum.KeyCode.RightShift] = "RS",
    [Enum.KeyCode.LeftControl] = "LC", [Enum.KeyCode.RightControl] = "RC",
    [Enum.KeyCode.Insert] = "INS", [Enum.KeyCode.Backspace] = "BS",
    [Enum.KeyCode.Return] = "Ent", [Enum.KeyCode.LeftAlt] = "LA",
    [Enum.KeyCode.RightAlt] = "RA", [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1", [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3", [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5", [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7", [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9", [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.KeypadOne] = "Num1", [Enum.KeyCode.KeypadTwo] = "Num2",
    [Enum.KeyCode.KeypadThree] = "Num3", [Enum.KeyCode.KeypadFour] = "Num4",
    [Enum.KeyCode.KeypadFive] = "Num5", [Enum.KeyCode.KeypadSix] = "Num6",
    [Enum.KeyCode.KeypadSeven] = "Num7", [Enum.KeyCode.KeypadEight] = "Num8",
    [Enum.KeyCode.KeypadNine] = "Num9", [Enum.KeyCode.KeypadZero] = "Num0",
    [Enum.KeyCode.Minus] = "-", [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.Tilde] = "~", [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.RightBracket] = "]", [Enum.KeyCode.Semicolon] = ";",
    [Enum.KeyCode.Quote] = "'", [Enum.KeyCode.BackSlash] = "\\",
    [Enum.KeyCode.Comma] = ",", [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Slash] = "/", [Enum.KeyCode.Asterisk] = "*",
    [Enum.KeyCode.Plus] = "+", [Enum.KeyCode.Backquote] = "`",
    [Enum.UserInputType.MouseButton1] = "MB1", [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3", [Enum.KeyCode.Escape] = "ESC",
    [Enum.KeyCode.Space] = "SPC",
}

Library.__index = Library

for _, path in Library.Folders do
    makefolder(Library.Directory .. path)
end

local Flags = Library.Flags
local ConfigFlags = Library.ConfigFlags
local Notifications = Library.Notifications

local Fonts = {}
do
    function RegisterFont(Name, Weight, Style, Asset)
        if not isfile(Asset.Id) then
            writefile(Asset.Id, Asset.Font)
        end
        if isfile(Name .. ".font") then
            delfile(Name .. ".font")
        end
        local Data = {
            name = Name,
            faces = {{name = "Normal", weight = Weight, style = Style, assetId = getcustomasset(Asset.Id)}}
        }
        writefile(Name .. ".font", HttpService:JSONEncode(Data))
        return getcustomasset(Name .. ".font")
    end
    
    local Tahoma = RegisterFont("Tahoma", 400, "Normal", {
        Id = "tahoma.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"),
    })
    Library.Font = Font.new(Tahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

function Library:GetTransparency(obj)
    if obj:IsA("Frame") then
        return {"BackgroundTransparency"}
    elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
        return {"TextTransparency", "BackgroundTransparency"}
    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        return {"BackgroundTransparency", "ImageTransparency"}
    elseif obj:IsA("ScrollingFrame") then
        return {"BackgroundTransparency", "ScrollBarImageTransparency"}
    elseif obj:IsA("TextBox") then
        return {"TextTransparency", "BackgroundTransparency"}
    elseif obj:IsA("UIStroke") then
        return {"Transparency"}
    end
    return nil
end

function Library:Tween(Object, Properties, Info)
    local tween = TweenService:Create(Object, Info or TweenInfo.new(Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.InOut, 0, false, 0), Properties)
    tween:Play()
    return tween
end

function Library:Fade(obj, prop, vis, speed)
    if not (obj and prop) then return end
    local OldTransparency = obj[prop]
    obj[prop] = vis and 1 or OldTransparency
    local Tween = Library:Tween(obj, {[prop] = vis and OldTransparency or 1}, TweenInfo.new(speed or Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.InOut, 0, false, 0))
    Library:Connection(Tween.Completed, function()
        if not vis then
            task.wait()
            obj[prop] = OldTransparency
        end
    end)
    return Tween
end

function Library:Hovering(Object)
    if type(Object) == "table" then
        for _, obj in Object do
            if Library:Hovering(obj) then return true end
        end
    else
        local y_cond = Object.AbsolutePosition.Y <= mouse.Y and mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
        local x_cond = Object.AbsolutePosition.X <= mouse.X and mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
        return (y_cond and x_cond)
    end
    return false
end

function Library:Draggify(Parent)
    local Dragging = false
    local InitialPosition, StartPosition
    local function onInputBegin(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or (TouchEnabled and Input.UserInputType == Enum.UserInputType.Touch) then
            Dragging = true
            InitialPosition = Input.Position
            StartPosition = Parent.Position
        end
    end
    local function onInputEnd(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or (TouchEnabled and Input.UserInputType == Enum.UserInputType.Touch) then
            Dragging = false
        end
    end
    Parent.InputBegan:Connect(onInputBegin)
    Parent.InputEnded:Connect(onInputEnd)
    Library:Connection(UserInputService.InputChanged, function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or (TouchEnabled and Input.UserInputType == Enum.UserInputType.Touch)) then
            Parent.Position = dim2(0, StartPosition.X.Offset + (Input.Position.X - InitialPosition.X), 0, StartPosition.Y.Offset + (Input.Position.Y - InitialPosition.Y))
        end
    end)
end

function Library:Resizify(Parent)
    local Resizing = Library:Create("TextButton", {
        Position = dim2(1, -10, 1, -10), Size = dim2(0, 10, 0, 10),
        BorderSizePixel = 0, BackgroundColor3 = rgb(255, 255, 255),
        Parent = Parent, BackgroundTransparency = 1, Text = ""
    })
    local IsResizing, Size, InputLost, ParentSize = false
    local function onInputBegin(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
            IsResizing = true; InputLost = input.Position; Size = Parent.Size; ParentSize = Parent.Size
        end
    end
    local function onInputEnd(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
            IsResizing = false
        end
    end
    Resizing.InputBegan:Connect(onInputBegin)
    Resizing.InputEnded:Connect(onInputEnd)
    Library:Connection(UserInputService.InputChanged, function(input)
        if IsResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or (TouchEnabled and input.UserInputType == Enum.UserInputType.Touch)) then
            Parent.Size = dim2(Size.X.Scale, math.clamp(Size.X.Offset + (input.Position.X - InputLost.X), 50, Camera.ViewportSize.X + 200), Size.Y.Scale, math.clamp(Size.Y.Offset + (input.Position.Y - InputLost.Y), 50, Camera.ViewportSize.Y + 200))
        end
    end)
end

function Library:Convert(str)
    local Values = {}
    for Value in string.gmatch(str, "[^,]+") do
        table.insert(Values, tonumber(Value))
    end
    if #Values == 4 then return unpack(Values) end
    return nil
end

function Library:Lerp(start, finish, t)
    t = t or 1 / 8
    return start * (1 - t) + finish * t
end

function Library:ConvertEnum(enum)
    local EnumParts = {}
    for part in string.gmatch(enum, "[%w_]+") do
        table.insert(EnumParts, part)
    end
    local EnumTable = Enum
    for i = 2, #EnumParts do
        EnumTable = EnumTable[EnumParts[i]]
    end
    return EnumTable
end

function Library:ConvertHex(color, alpha)
    local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
    local a = alpha and math.floor(alpha * 255) or 255
    return string.format("#%02X%02X%02X%02X", r, g, b, a)
end

function Library:ConvertFromHex(color)
    color = color:gsub("#", "")
    local r, g, b = tonumber(color:sub(1, 2), 16) / 255, tonumber(color:sub(3, 4), 16) / 255, tonumber(color:sub(5, 6), 16) / 255
    local a = tonumber(color:sub(7, 8), 16) and tonumber(color:sub(7, 8), 16) / 255 or 1
    return Color3.new(r, g, b), a
end

function Library:Round(num, float)
    local Multiplier = 1 / (float or 1)
    return math.floor(num * Multiplier + 0.5) / Multiplier
end

function Library:Themify(instance, theme, property)
    if not themes.utility[theme] then themes.utility[theme] = {} end
    if not themes.utility[theme][property] then themes.utility[theme][property] = {} end
    table.insert(themes.utility[theme][property], instance)
    if themes.preset[theme] then
        instance[property] = themes.preset[theme]
    end
end

function Library:SaveGradient(instance, theme)
    table.insert(themes.gradients[theme], instance)
end

function Library:RefreshTheme(theme, color)
    for property, instances in pairs(themes.utility[theme] or {}) do
        for _, object in pairs(instances) do
            if object[property] == themes.preset[theme] then
                object[property] = color
            end
        end
    end
    themes.preset[theme] = color
end

function Library:ApplyTheme(themeName)
    local theme = themes[themeName]
    if not theme then return end
    for prop, colorValue in pairs(theme) do
        for property, instances in pairs(themes.utility[prop] or {}) do
            for _, object in pairs(instances) do
                if object[property] then
                    object[property] = colorValue
                end
            end
        end
    end
    for _, seq in pairs(themes.gradients.Selected) do
        if seq then seq.Color = rgbseq{rgbkey(0, theme.inline), rgbkey(1, theme.gradient)} end
    end
    for _, seq in pairs(themes.gradients.Deselected) do
        if seq then seq.Color = rgbseq{rgbkey(0, theme.gradient), rgbkey(1, theme.background)} end
    end
    themes.preset = theme
    Library.ActiveTheme = themeName
end

function Library:Connection(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(Library.Connections, connection)
    return connection
end

function Library:CloseElement()
    if not Library.OpenElement then return end
    for _, Data in pairs(Library.OpenElement) do
        if Data.Ignore then continue end
        if Data.SetVisible then Data.SetVisible(false) end
        Data.Open = false
    end
    Library.OpenElement = {}
end

function Library:Create(instance, options)
    local ins = Instance.new(instance)
    for prop, value in pairs(options) do
        ins[prop] = value
    end
    if instance == "TextButton" then
        ins.AutoButtonColor = false
        ins.Text = ""
    end
    return ins
end

function Library:Unload()
    if Library.Items then Library.Items:Destroy() end
    if Library.Other then Library.Other:Destroy() end
    for _, connection in pairs(Library.Connections) do
        connection:Disconnect()
    end
    getgenv().Library = nil
end

function Library:Dock(properties)
    local Cfg = {
        Name = properties.Name or "Library",
        Windows = {},
        CurrentWindow = nil,
        Items = {}
    }
    
    Library.Items = Library:Create("ScreenGui", {
        Parent = CoreGui, Name = "\0", Enabled = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Global, IgnoreGuiInset = true
    })
    
    Library.Other = Library:Create("ScreenGui", {
        Parent = CoreGui, Name = "\0", Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true
    })
    
    local Items = Cfg.Items
    Items.Dock = Library:Create("Frame", {
        Parent = Library.Items, Position = dim2(0, 0, 0, 0),
        Size = dim2(1, 0, 0, 35), BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.outline, ZIndex = 100
    })
    Library:Themify(Items.Dock, "outline", "BackgroundColor3")
    
    Items.Inline = Library:Create("Frame", {
        Parent = Items.Dock, Position = dim2(0, 1, 0, 1),
        Size = dim2(1, -2, 1, -2), BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.gradient
    })
    Library:Themify(Items.Inline, "gradient", "BackgroundColor3")
    
    Items.Accent = Library:Create("Frame", {
        Parent = Items.Dock, Position = dim2(0, 1, 0, 1),
        Size = dim2(1, -2, 0, 2), BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.accent
    })
    Library:Themify(Items.Accent, "accent", "BackgroundColor3")
    
    Items.Title = Library:Create("TextLabel", {
        FontFace = Library.Font, Text = Cfg.Name,
        Parent = Items.Dock, BackgroundTransparency = 1,
        Position = dim2(0, 8, 0, 10), TextSize = 12,
        AutomaticSize = Enum.AutomaticSize.XY
    })
    Library:Themify(Items.Title, "text_color", "TextColor3")
    
    Items.ButtonContainer = Library:Create("Frame", {
        Parent = Items.Dock, BackgroundTransparency = 1,
        Position = dim2(0, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.X,
        Size = dim2(0, 0, 1, 0)
    })
    
    local buttonLayout = Library:Create("UIListLayout", {
        Parent = Items.ButtonContainer, FillDirection = Enum.FillDirection.Horizontal,
        Padding = dim(0, 4)
    })
    
    Library:Create("UIPadding", {
        Parent = Items.ButtonContainer, PaddingTop = dim(0, 8),
        PaddingBottom = dim(0, 8), PaddingLeft = dim(0, 8)
    })
    
    Items.ContentContainer = Library:Create("Frame", {
        Parent = Library.Items, Position = dim2(0, 0, 0, 35),
        Size = dim2(1, 0, 1, -35), BackgroundTransparency = 1
    })
    
    function Cfg:AddWindow(window)
        local button = Library:Create("TextButton", {
            FontFace = Library.Font, Text = window.Name,
            Parent = Items.ButtonContainer, BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.X, Size = dim2(0, 0, 0, 19),
            TextSize = 12
        })
        Library:Themify(button, "text_color", "TextColor3")
        
        local buttonFill = Library:Create("Frame", {
            Parent = button, Position = dim2(0, 0, 1, 0),
            Size = dim2(1, 0, 0, 2), BackgroundTransparency = 1,
            BackgroundColor3 = themes.preset.accent
        })
        Library:Themify(buttonFill, "accent", "BackgroundColor3")
        
        button.MouseButton1Click:Connect(function()
            for _, btn in pairs(Cfg.Windows) do
                if btn.Fill then btn.Fill.BackgroundTransparency = 1 end
                if btn.Window and btn.Window.Items and btn.Window.Items.Window then
                    btn.Window.Items.Window.Visible = false
                end
            end
            buttonFill.BackgroundTransparency = 0
            window.Items.Window.Visible = true
            window.Items.Window.Parent = Items.ContentContainer
            window.Items.Window.Position = dim2(0.5, -window.Size.X.Offset / 2, 0.5, -window.Size.Y.Offset / 2)
            Cfg.CurrentWindow = window
        end)
        
        table.insert(Cfg.Windows, {Button = button, Fill = buttonFill, Window = window})
        return button
    end
    
    function Cfg:SetTitle(text)
        Items.Title.Text = text
    end
    
    task.spawn(function()
        task.wait()
        Items.ButtonContainer.Position = dim2(0, Items.Title.AbsoluteSize.X + 16, 0, 0)
    end)
    
    return Cfg
end

function Library:Window(properties)
    local Cfg = {
        Name = properties.Name or "Window",
        Size = properties.Size or dim2(0, 550, 0, 600),
        TabInfo = nil,
        Items = {}
    }
    
    local Items = Cfg.Items
    Items.Window = Library:Create("Frame", {
        Parent = Library.Other, Position = dim2(0.5, -Cfg.Size.X.Offset / 2, 0.5, -Cfg.Size.Y.Offset / 2),
        Size = Cfg.Size, BorderSizePixel = 0, Visible = false,
        BackgroundColor3 = themes.preset.outline
    })
    Library:Themify(Items.Window, "outline", "BackgroundColor3")
    
    Items.Inline = Library:Create("Frame", {
        Parent = Items.Window, Position = dim2(0, 1, 0, 4),
        Size = dim2(1, -2, 1, -5), BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.gradient
    })
    Library:Themify(Items.Inline, "gradient", "BackgroundColor3")
    
    Items.TitleBar = Library:Create("Frame", {
        Parent = Items.Window, Size = dim2(1, 0, 0, 25),
        BackgroundTransparency = 1
    })
    
    Items.Title = Library:Create("TextLabel", {
        FontFace = Library.Font, Text = Cfg.Name,
        Parent = Items.TitleBar, BackgroundTransparency = 1,
        Position = dim2(0, 8, 0, 6), TextSize = 12,
        AutomaticSize = Enum.AutomaticSize.XY
    })
    Library:Themify(Items.Title, "text_color", "TextColor3")
    
    Items.CloseBtn = Library:Create("TextButton", {
        FontFace = Library.Font, Text = "X",
        Parent = Items.TitleBar, BackgroundTransparency = 1,
        Position = dim2(1, -25, 0, 5), Size = dim2(0, 20, 0, 15),
        TextSize = 12
    })
    Library:Themify(Items.CloseBtn, "text_color", "TextColor3")
    
    Items.CloseBtn.MouseButton1Click:Connect(function()
        Items.Window.Visible = false
    end)
    
    Items.MinimizeBtn = Library:Create("TextButton", {
        FontFace = Library.Font, Text = "_",
        Parent = Items.TitleBar, BackgroundTransparency = 1,
        Position = dim2(1, -48, 0, 5), Size = dim2(0, 20, 0, 15),
        TextSize = 12
    })
    Library:Themify(Items.MinimizeBtn, "text_color", "TextColor3")
    
    local minimized = false
    local originalSize = Cfg.Size
    Items.MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Items.Window.Size = dim2(originalSize.X.Scale, originalSize.X.Offset, 0, 25)
        else
            Items.Window.Size = originalSize
        end
    end)
    
    Items.TabContainer = Library:Create("Frame", {
        Parent = Items.Window, Position = dim2(0, 1, 0, 26),
        Size = dim2(1, -2, 0, 23), BackgroundTransparency = 1
    })
    
    Items.TabLayout = Library:Create("UIListLayout", {
        Parent = Items.TabContainer, FillDirection = Enum.FillDirection.Horizontal,
        Padding = dim(0, 2)
    })
    
    Items.Content = Library:Create("Frame", {
        Parent = Items.Window, Position = dim2(0, 1, 0, 50),
        Size = dim2(1, -2, 1, -52), BackgroundTransparency = 1
    })
    
    Library:Draggify(Items.TitleBar)
    Library:Resizify(Items.Window)
    
    function Cfg:Tab(tabProps)
        local tab = {
            Name = tabProps.name or tabProps.Name or "Tab",
            Items = {}
        }
        
        local tabButton = Library:Create("TextButton", {
            FontFace = Library.Font, Text = tab.Name,
            Parent = Items.TabContainer, BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.X, Size = dim2(0, 0, 0, 23),
            TextSize = 12
        })
        Library:Themify(tabButton, "text_color", "TextColor3")
        
        local tabFill = Library:Create("Frame", {
            Parent = tabButton, Position = dim2(0, 0, 1, 0),
            Size = dim2(1, 0, 0, 2), BackgroundTransparency = 1,
            BackgroundColor3 = themes.preset.accent
        })
        Library:Themify(tabFill, "accent", "BackgroundColor3")
        
        local tabContent = Library:Create("Frame", {
            Parent = Items.Content, BackgroundTransparency = 1,
            Size = dim2(1, 0, 1, 0), Visible = false
        })
        
        local leftSection = Library:Create("Frame", {
            Parent = tabContent, BackgroundTransparency = 1,
            Size = dim2(0.5, -5, 1, 0)
        })
        
        local rightSection = Library:Create("Frame", {
            Parent = tabContent, BackgroundTransparency = 1,
            Position = dim2(0.5, 5, 0, 0),
            Size = dim2(0.5, -5, 1, 0)
        })
        
        local leftLayout = Library:Create("UIListLayout", {
            Parent = leftSection, Padding = dim(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local rightLayout = Library:Create("UIListLayout", {
            Parent = rightSection, Padding = dim(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        tabButton.MouseButton1Click:Connect(function()
            for _, btn in pairs(Cfg.Tabs or {}) do
                if btn.Fill then btn.Fill.BackgroundTransparency = 1 end
                if btn.Content then btn.Content.Visible = false end
            end
            tabFill.BackgroundTransparency = 0
            tabContent.Visible = true
        end)
        
        if not Cfg.Tabs then
            tabFill.BackgroundTransparency = 0
            tabContent.Visible = true
        end
        
        Cfg.Tabs = Cfg.Tabs or {}
        table.insert(Cfg.Tabs, {Button = tabButton, Fill = tabFill, Content = tabContent})
        
        function tab:Section(sectionProps)
            local section = {
                Name = sectionProps.name or sectionProps.Name or "Section",
                Side = sectionProps.side or sectionProps.Side or "left",
                Items = {}
            }
            
            local parent = section.Side == "left" and leftSection or rightSection
            
            local sectionFrame = Library:Create("Frame", {
                Parent = parent, Size = dim2(1, 0, 0, 0),
                BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = themes.preset.outline
            })
            Library:Themify(sectionFrame, "outline", "BackgroundColor3")
            
            local sectionInline = Library:Create("Frame", {
                Parent = sectionFrame, Position = dim2(0, 1, 0, 1),
                Size = dim2(1, -2, 1, -2), BorderSizePixel = 0,
                BackgroundColor3 = themes.preset.gradient
            })
            Library:Themify(sectionInline, "gradient", "BackgroundColor3")
            
            local sectionTitle = Library:Create("TextLabel", {
                FontFace = Library.Font, Text = section.Name,
                Parent = sectionInline, BackgroundTransparency = 1,
                Position = dim2(0, 6, 0, 6), TextSize = 12,
                AutomaticSize = Enum.AutomaticSize.XY
            })
            Library:Themify(sectionTitle, "text_color", "TextColor3")
            
            local sectionContent = Library:Create("Frame", {
                Parent = sectionInline, Position = dim2(0, 6, 0, 24),
                Size = dim2(1, -12, 0, 0), BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y
            })
            
            local contentLayout = Library:Create("UIListLayout", {
                Parent = sectionContent, Padding = dim(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            function section:Toggle(toggleProps)
                local toggle = {
                    Name = toggleProps.Name or "Toggle",
                    Flag = toggleProps.Flag or toggleProps.Name or "Toggle",
                    Enabled = toggleProps.Default or false,
                    Callback = toggleProps.Callback or function() end,
                    Items = {}
                }
                
                local toggleFrame = Library:Create("TextButton", {
                    Parent = sectionContent, BackgroundTransparency = 1,
                    Size = dim2(1, 0, 0, 11), Text = ""
                })
                
                local toggleOutline = Library:Create("Frame", {
                    Parent = toggleFrame, Size = dim2(0, 11, 0, 11),
                    BorderSizePixel = 0, BackgroundColor3 = themes.preset.outline
                })
                Library:Themify(toggleOutline, "outline", "BackgroundColor3")
                
                local toggleFill = Library:Create("Frame", {
                    Parent = toggleOutline, Position = dim2(0, 1, 0, 1),
                    Size = dim2(1, -2, 1, -2), BorderSizePixel = 0,
                    BackgroundColor3 = themes.preset.inline
                })
                Library:Themify(toggleFill, "inline", "BackgroundColor3")
                
                local toggleAccent = Library:Create("Frame", {
                    Parent = toggleFill, Size = dim2(1, 0, 1, 0),
                    BackgroundColor3 = themes.preset.accent,
                    BackgroundTransparency = toggle.Enabled and 0 or 1
                })
                Library:Themify(toggleAccent, "accent", "BackgroundColor3")
                
                local toggleLabel = Library:Create("TextLabel", {
                    FontFace = Library.Font, Text = toggle.Name,
                    Parent = toggleFrame, BackgroundTransparency = 1,
                    Position = dim2(0, 15, 0, -2), TextSize = 12,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                Library:Themify(toggleLabel, "text_color", "TextColor3")
                
                function toggle:Set(value)
                    toggle.Enabled = value
                    toggleAccent.BackgroundTransparency = value and 0 or 1
                    Flags[toggle.Flag] = value
                    toggle.Callback(value)
                end
                
                toggleFrame.MouseButton1Click:Connect(function()
                    toggle:Set(not toggle.Enabled)
                end)
                
                toggle:Set(toggle.Enabled)
                ConfigFlags[toggle.Flag] = function(v) toggle:Set(v) end
                
                return toggle
            end
            
            function section:Slider(sliderProps)
                local slider = {
                    Name = sliderProps.Name,
                    Min = sliderProps.Min or 0,
                    Max = sliderProps.Max or 100,
                    Value = sliderProps.Default or 50,
                    Flag = sliderProps.Flag or sliderProps.Name or "Slider",
                    Callback = sliderProps.Callback or function() end,
                    Items = {}
                }
                
                local sliderFrame = Library:Create("Frame", {
                    Parent = sectionContent, BackgroundTransparency = 1,
                    Size = dim2(1, 0, 0, 25)
                })
                
                local sliderLabel = Library:Create("TextLabel", {
                    FontFace = Library.Font, Text = slider.Name,
                    Parent = sliderFrame, BackgroundTransparency = 1,
                    Position = dim2(0, 1, 0, 0), TextSize = 12,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                Library:Themify(sliderLabel, "text_color", "TextColor3")
                
                local sliderValue = Library:Create("TextLabel", {
                    FontFace = Library.Font, Text = tostring(slider.Value),
                    Parent = sliderFrame, BackgroundTransparency = 1,
                    Position = dim2(1, -30, 0, 0), TextSize = 12,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                Library:Themify(sliderValue, "text_color", "TextColor3")
                
                local sliderBar = Library:Create("TextButton", {
                    Parent = sliderFrame, Position = dim2(0, 0, 0, 14),
                    Size = dim2(1, 0, 0, 11), Text = "",
                    BackgroundColor3 = themes.preset.outline
                })
                Library:Themify(sliderBar, "outline", "BackgroundColor3")
                
                local sliderFill = Library:Create("Frame", {
                    Parent = sliderBar, Position = dim2(0, 1, 0, 1),
                    Size = dim2((slider.Value - slider.Min) / (slider.Max - slider.Min), -2, 1, -2),
                    BackgroundColor3 = themes.preset.accent
                })
                Library:Themify(sliderFill, "accent", "BackgroundColor3")
                
                local dragging = false
                sliderBar.MouseButton1Down:Connect(function() dragging = true end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                
                function slider:Set(value)
                    slider.Value = math.clamp(Library:Round(value, sliderProps.Decimal or 1), slider.Min, slider.Max)
                    sliderFill.Size = dim2((slider.Value - slider.Min) / (slider.Max - slider.Min), -2, 1, -2)
                    sliderValue.Text = tostring(slider.Value) .. (sliderProps.Suffix or "")
                    Flags[slider.Flag] = slider.Value
                    slider.Callback(slider.Value)
                end
                
                Library:Connection(UserInputService.InputChanged, function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                        slider:Set(((slider.Max - slider.Min) * pos) + slider.Min)
                    end
                end)
                
                slider:Set(slider.Value)
                ConfigFlags[slider.Flag] = function(v) slider:Set(v) end
                
                return slider
            end
            
            function section:Keybind(keybindProps)
                local keybind = {
                    Name = keybindProps.Name,
                    Flag = keybindProps.Flag or keybindProps.Name or "Keybind",
                    Key = keybindProps.Default or Enum.KeyCode.None,
                    Mode = keybindProps.Mode or "Toggle",
                    Callback = keybindProps.Callback or function() end,
                    Items = {}
                }
                
                local keybindFrame = Library:Create("Frame", {
                    Parent = sectionContent, BackgroundTransparency = 1,
                    Size = dim2(1, 0, 0, 11)
                })
                
                local keybindLabel = Library:Create("TextLabel", {
                    FontFace = Library.Font, Text = keybind.Name,
                    Parent = keybindFrame, BackgroundTransparency = 1,
                    Position = dim2(0, 1, 0, -2), TextSize = 12,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                Library:Themify(keybindLabel, "text_color", "TextColor3")
                
                local keybindButton = Library:Create("TextButton", {
                    Parent = keybindFrame, Position = dim2(1, -80, 0, -2),
                    Size = dim2(0, 70, 0, 15), Text = Keys[keybind.Key] or "None",
                    BackgroundColor3 = themes.preset.inline
                })
                Library:Themify(keybindButton, "inline", "BackgroundColor3")
                Library:Themify(keybindButton, "text_color", "TextColor3")
                
                local listening = false
                keybindButton.MouseButton1Click:Connect(function()
                    listening = true
                    keybindButton.Text = "..."
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed then return end
                        if listening then
                            local key = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
                            keybind.Key = key
                            keybindButton.Text = Keys[key] or tostring(key):gsub("Enum.", ""):gsub("KeyCode.", ""):gsub("UserInputType.", "")
                            Flags[keybind.Flag] = {Key = keybind.Key, Mode = keybind.Mode}
                            keybind.Callback(key)
                            listening = false
                            conn:Disconnect()
                        end
                    end)
                    task.wait(3)
                    if listening then
                        listening = false
                        keybindButton.Text = Keys[keybind.Key] or "None"
                        conn:Disconnect()
                    end
                end)
                
                Flags[keybind.Flag] = {Key = keybind.Key, Mode = keybind.Mode}
                ConfigFlags[keybind.Flag] = function(v) if v.Key then keybind.Key = v.Key keybindButton.Text = Keys[v.Key] or "None" end end
                
                return keybind
            end
            
            function section:Dropdown(dropdownProps)
                local dropdown = {
                    Name = dropdownProps.Name,
                    Options = dropdownProps.Options or {},
                    Value = dropdownProps.Default or (dropdownProps.Options and dropdownProps.Options[1] or ""),
                    Flag = dropdownProps.Flag or dropdownProps.Name or "Dropdown",
                    Callback = dropdownProps.Callback or function() end,
                    Open = false,
                    Items = {}
                }
                
                local dropdownFrame = Library:Create("Frame", {
                    Parent = sectionContent, BackgroundTransparency = 1,
                    Size = dim2(1, 0, 0, 32)
                })
                
                local dropdownLabel = Library:Create("TextLabel", {
                    FontFace = Library.Font, Text = dropdown.Name,
                    Parent = dropdownFrame, BackgroundTransparency = 1,
                    Position = dim2(0, 1, 0, 0), TextSize = 12,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                Library:Themify(dropdownLabel, "text_color", "TextColor3")
                
                local dropdownButton = Library:Create("TextButton", {
                    Parent = dropdownFrame, Position = dim2(0, 0, 0, 14),
                    Size = dim2(1, 0, 0, 18), Text = "",
                    BackgroundColor3 = themes.preset.outline
                })
                Library:Themify(dropdownButton, "outline", "BackgroundColor3")
                
                local dropdownText = Library:Create("TextLabel", {
                    FontFace = Library.Font, Text = dropdown.Value,
                    Parent = dropdownButton, BackgroundTransparency = 1,
                    Position = dim2(0, 4, 0, 3), TextSize = 12,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                Library:Themify(dropdownText, "text_color", "TextColor3")
                
                local dropdownArrow = Library:Create("TextLabel", {
                    FontFace = Library.Font, Text = "v",
                    Parent = dropdownButton, BackgroundTransparency = 1,
                    Position = dim2(1, -12, 0, 3), TextSize = 12,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                Library:Themify(dropdownArrow, "text_color", "TextColor3")
                
                local dropdownList = Library:Create("Frame", {
                    Parent = Library.Other, Size = dim2(0, 0, 0, 0),
                    BackgroundColor3 = themes.preset.outline,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Visible = false, ZIndex = 999
                })
                Library:Themify(dropdownList, "outline", "BackgroundColor3")
                
                local listLayout = Library:Create("UIListLayout", {
                    Parent = dropdownList, SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                function dropdown:RefreshOptions(options)
                    for _, child in pairs(dropdownList:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    for _, opt in pairs(options) do
                        local optButton = Library:Create("TextButton", {
                            FontFace = Library.Font, Text = opt,
                            Parent = dropdownList, BackgroundTransparency = 1,
                            AutomaticSize = Enum.AutomaticSize.XY, Size = dim2(1, 0, 0, 0),
                            TextSize = 12
                        })
                        Library:Themify(optButton, "text_color", "TextColor3")
                        optButton.MouseButton1Click:Connect(function()
                            dropdown.Value = opt
                            dropdownText.Text = opt
                            dropdown:SetVisible(false)
                            Flags[dropdown.Flag] = opt
                            dropdown.Callback(opt)
                        end)
                    end
                    dropdownList.Size = dim2(dropdownButton.AbsoluteSize.X, 0, 0, 0)
                end
                
                function dropdown:SetVisible(visible)
                    if Library.OpenElement ~= dropdown then Library:CloseElement() end
                    if visible then
                        dropdownList.Position = dim2(0, dropdownButton.AbsolutePosition.X, 0, dropdownButton.AbsolutePosition.Y + dropdownButton.AbsoluteSize.Y)
                        dropdownList.Size = dim2(dropdownButton.AbsoluteSize.X, 0, 0, 0)
                        dropdownList.Parent = Library.Items
                        dropdownList.Visible = true
                        Library.OpenElement = dropdown
                    else
                        dropdownList.Visible = false
                        dropdownList.Parent = Library.Other
                    end
                    dropdown.Open = visible
                    dropdownArrow.Text = visible and "^" or "v"
                end
                
                dropdownButton.MouseButton1Click:Connect(function()
                    dropdown:SetVisible(not dropdown.Open)
                end)
                
                dropdown:RefreshOptions(dropdown.Options)
                Flags[dropdown.Flag] = dropdown.Value
                ConfigFlags[dropdown.Flag] = function(v) dropdown.Value = v dropdownText.Text = v end
                
                return dropdown
            end
            
            function section:Textbox(textboxProps)
                local textbox = {
                    Name = textboxProps.Name,
                    Value = textboxProps.Default or "",
                    Flag = textboxProps.Flag or textboxProps.Name or "Textbox",
                    Callback = textboxProps.Callback or function() end,
                    Items = {}
                }
                
                local textboxFrame = Library:Create("Frame", {
                    Parent = sectionContent, BackgroundTransparency = 1,
                    Size = dim2(1, 0, 0, 32)
                })
                
                local textboxLabel = Library:Create("TextLabel", {
                    FontFace = Library.Font, Text = textbox.Name,
                    Parent = textboxFrame, BackgroundTransparency = 1,
                    Position = dim2(0, 1, 0, 0), TextSize = 12,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                Library:Themify(textboxLabel, "text_color", "TextColor3")
                
                local textboxInput = Library:Create("TextBox", {
                    FontFace = Library.Font, Text = textbox.Value,
                    Parent = textboxFrame, Position = dim2(0, 0, 0, 14),
                    Size = dim2(1, 0, 0, 18), TextSize = 12,
                    BackgroundColor3 = themes.preset.inline,
                    PlaceholderText = textboxProps.PlaceHolder or "Enter text..."
                })
                Library:Themify(textboxInput, "inline", "BackgroundColor3")
                Library:Themify(textboxInput, "text_color", "TextColor3")
                
                textboxInput:GetPropertyChangedSignal("Text"):Connect(function()
                    textbox.Value = textboxInput.Text
                    Flags[textbox.Flag] = textbox.Value
                    textbox.Callback(textbox.Value)
                end)
                
                Flags[textbox.Flag] = textbox.Value
                ConfigFlags[textbox.Flag] = function(v) textbox.Value = v textboxInput.Text = v end
                
                return textbox
            end
            
            function section:Label(labelProps)
                local label = {
                    Name = labelProps.Name or "Label",
                    Items = {}
                }
                
                local labelFrame = Library:Create("Frame", {
                    Parent = sectionContent, BackgroundTransparency = 1,
                    Size = dim2(1, 0, 0, 11)
                })
                
                local labelText = Library:Create("TextLabel", {
                    FontFace = Library.Font, Text = label.Name,
                    Parent = labelFrame, BackgroundTransparency = 1,
                    Position = dim2(0, 1, 0, -2), TextSize = 12,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                Library:Themify(labelText, "text_color", "TextColor3")
                
                function label:Set(text)
                    labelText.Text = text
                end
                
                return label
            end
            
            function section:Button(buttonProps)
                local button = {
                    Name = buttonProps.Name or "Button",
                    Callback = buttonProps.Callback or function() end,
                    Items = {}
                }
                
                local buttonFrame = Library:Create("TextButton", {
                    Parent = sectionContent, Size = dim2(1, 0, 0, 18),
                    BackgroundColor3 = themes.preset.inline
                })
                Library:Themify(buttonFrame, "inline", "BackgroundColor3")
                
                local buttonText = Library:Create("TextLabel", {
                    FontFace = Library.Font, Text = button.Name,
                    Parent = buttonFrame, BackgroundTransparency = 1,
                    Position = dim2(0, 4, 0, 3), TextSize = 12,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                Library:Themify(buttonText, "text_color", "TextColor3")
                
                buttonFrame.MouseButton1Click:Connect(function()
                    button.Callback()
                end)
                
                return button
            end
            
            return section
        end
        
        return tab
    end
    
    return Cfg
end

applyTheme("darknights")

return Library, Notifications, themes