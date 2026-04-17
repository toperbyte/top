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
    Directory = "MyLibrary v1",
    Folders = {
        "/configs",
    },
    Flags = {},
    ConfigFlags = {},
    Connections = {},
    Notifications = {Notifs = {}},
    OpenElement = {},
    EasingStyle = Enum.EasingStyle.Quint,
    TweeningSpeed = 0.25
}

local themes = {
    preset = {
        inline = rgb(50, 50, 50);
        gradient = rgb(40, 40, 40);
        outline = rgb(20, 20, 20);
        accent = rgb(50, 119, 186);
        background = rgb(30, 30, 30);
        text_color = rgb(239, 239, 239);
        text_outline = rgb(0, 0, 0);
        tab_background = rgb(26, 26, 26);
    },
    utility = {},
    gradients = {
        Selected = {};
        Deselected = {};
    },
}

for theme,color in themes.preset do 
    themes.utility[theme] = {
        BackgroundColor3 = {};
        TextColor3 = {};
        ImageColor3 = {};
        ScrollBarImageColor3 = {};
        Color = {};
    }
end

local Keys = {
    [Enum.KeyCode.LeftShift] = "LS",
    [Enum.KeyCode.RightShift] = "RS",
    [Enum.KeyCode.LeftControl] = "LC",
    [Enum.KeyCode.RightControl] = "RC",
    [Enum.KeyCode.Insert] = "INS",
    [Enum.KeyCode.Backspace] = "BS",
    [Enum.KeyCode.Return] = "Ent",
    [Enum.KeyCode.LeftAlt] = "LA",
    [Enum.KeyCode.RightAlt] = "RA",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.KeypadOne] = "Num1",
    [Enum.KeyCode.KeypadTwo] = "Num2",
    [Enum.KeyCode.KeypadThree] = "Num3",
    [Enum.KeyCode.KeypadFour] = "Num4",
    [Enum.KeyCode.KeypadFive] = "Num5",
    [Enum.KeyCode.KeypadSix] = "Num6",
    [Enum.KeyCode.KeypadSeven] = "Num7",
    [Enum.KeyCode.KeypadEight] = "Num8",
    [Enum.KeyCode.KeypadNine] = "Num9",
    [Enum.KeyCode.KeypadZero] = "Num0",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.Tilde] = "~",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.RightParenthesis] = ")",
    [Enum.KeyCode.LeftParenthesis] = "(",
    [Enum.KeyCode.Semicolon] = ",",
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = "\\",
    [Enum.KeyCode.Comma] = ",",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Asterisk] = "*",
    [Enum.KeyCode.Plus] = "+",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
    [Enum.KeyCode.Escape] = "ESC",
    [Enum.KeyCode.Space] = "SPC",
}

Library.__index = Library

for _,path in Library.Folders do 
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
            faces = {
                {
                    name = "Normal",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Asset.Id),
                },
            },
        }

        writefile(Name .. ".font", HttpService:JSONEncode(Data))
        return getcustomasset(Name .. ".font");
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
        return { "TextTransparency", "BackgroundTransparency" }
    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        return { "BackgroundTransparency", "ImageTransparency" }
    elseif obj:IsA("ScrollingFrame") then
        return { "BackgroundTransparency", "ScrollBarImageTransparency" }
    elseif obj:IsA("TextBox") then
        return { "TextTransparency", "BackgroundTransparency" }
    elseif obj:IsA("UIStroke") then 
        return { "Transparency" }
    end
    
    return nil
end

function Library:Tween(Object, Properties, Info)
    local tween = TweenService:Create(Object, Info or TweenInfo.new(Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.InOut, 0, false, 0), Properties)
    tween:Play()
    return tween
end

function Library:Fade(obj, prop, vis, speed)
    if not (obj and prop) then
        return
    end

    local OldTransparency = obj[prop]
    obj[prop] = vis and 1 or OldTransparency

    local Tween = Library:Tween(obj, { [prop] = vis and OldTransparency or 1 }, TweenInfo.new(speed or Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.InOut, 0, false, 0))

    Library:Connection(Tween.Completed, function()
        if not vis then
            task.wait()
            obj[prop] = OldTransparency
        end
    end)

    return Tween
end

function Library:Resizify(Parent)
    local Resizing = Library:Create("TextButton", {
        Position = dim2(1, -10, 1, -10);
        BorderColor3 = rgb(0, 0, 0);
        Size = dim2(0, 10, 0, 10);
        BorderSizePixel = 0;
        BackgroundColor3 = rgb(255, 255, 255);
        Parent = Parent;
        BackgroundTransparency = 1; 
        Text = ""
    })

    local IsResizing = false 
    local Size 
    local InputLost 
    local ParentSize = Parent.Size  
    
    local function onInputBegin(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
            IsResizing = true
            InputLost = input.Position
            Size = Parent.Size
        end
    end
    
    local function onInputEnd(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
            IsResizing = false
        end
    end
    
    Resizing.InputBegan:Connect(onInputBegin)
    Resizing.InputEnded:Connect(onInputEnd)

    Library:Connection(UserInputService.InputChanged, function(input, game_event) 
        if IsResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or (TouchEnabled and input.UserInputType == Enum.UserInputType.Touch)) then            
            Parent.Size = dim2(
                Size.X.Scale,
                math.clamp(Size.X.Offset + (input.Position.X - InputLost.X), 50, Camera.ViewportSize.X + 200), 
                Size.Y.Scale, 
                math.clamp(Size.Y.Offset + (input.Position.Y - InputLost.Y), 50, Camera.ViewportSize.Y + 200)
            )
        end
    end)
end

function Library:Hovering(Object)
    if type(Object) == "table" then 
        local Pass = false;
        for _,obj in Object do 
            if Library:Hovering(obj) then 
                Pass = true
                return Pass
            end 
        end 
    else 
        local y_cond = Object.AbsolutePosition.Y <= mouse.Y and mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
        local x_cond = Object.AbsolutePosition.X <= mouse.X and mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
        return (y_cond and x_cond)
    end 
end  

function Library:Draggify(Parent)
    local Dragging = false 
    local InitialPosition 
    local StartPosition

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

    Library:Connection(UserInputService.InputChanged, function(Input, game_event) 
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or (TouchEnabled and Input.UserInputType == Enum.UserInputType.Touch)) then
            local NewPosition = dim2(
                0,
                StartPosition.X.Offset + (Input.Position.X - InitialPosition.X),
                0,
                StartPosition.Y.Offset + (Input.Position.Y - InitialPosition.Y)
            )
            Parent.Position = NewPosition
        end
    end)
end 

function Library:Convert(str)
    local Values = {}
    for Value in string.gmatch(str, "[^,]+") do
        table.insert(Values, tonumber(Value))
    end
    if #Values == 4 then              
        return unpack(Values)
    else
        return
    end
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
        local EnumItem = EnumTable[EnumParts[i]]
        EnumTable = EnumItem
    end
    return EnumTable
end

function Library:ConvertHex(color, alpha)
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    local a = alpha and math.floor(alpha * 255) or 255
    return string.format("#%02X%02X%02X%02X", r, g, b, a)
end

function Library:ConvertFromHex(color)
    color = color:gsub("#", "")
    local r = tonumber(color:sub(1, 2), 16) / 255
    local g = tonumber(color:sub(3, 4), 16) / 255
    local b = tonumber(color:sub(5, 6), 16) / 255
    local a = tonumber(color:sub(7, 8), 16) and tonumber(color:sub(7, 8), 16) / 255 or 1
    return Color3.new(r, g, b), a
end

local ConfigHolder;
function Library:UpdateConfigList() 
    if not ConfigHolder then 
        return 
    end
    local List = {}
    for _,file in listfiles(Library.Directory .. "/configs") do
        local Name = file:gsub(Library.Directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(Library.Directory .. "\\configs\\", "")
        List[#List + 1] = Name
    end
    ConfigHolder.RefreshOptions(List)
end

function Library:GetConfig()
    local Config = {}
    for Idx, Value in Flags do
        if type(Value) == "table" and Value.key then
            Config[Idx] = {active = Value.Active, mode = Value.Mode, key = tostring(Value.Key)}
        elseif type(Value) == "table" and Value["Transparency"] and Value["Color"] then
            Config[Idx] = {Transparency = Value["Transparency"], Color = Value["Color"]:ToHex()}
        else
            Config[Idx] = Value
        end
    end 
    return HttpService:JSONEncode(Config)
end

function Library:LoadConfig(JSON) 
    local Config = HttpService:JSONDecode(JSON)
    for Idx, Value in Config do                
        if Idx == "config_name_list" then 
            continue 
        end
        local Function = ConfigFlags[Idx]
        if Function then 
            if type(Value) == "table" and Value["Transparency"] and Value["Color"] then
                Function(hex(Value["Color"]), Value["Transparency"])
            elseif type(Value) == "table" and Value["Active"] then 
                Function(Value)
            else
                Function(Value)
            end
        end 
    end 
end 

function Library:Round(num, float) 
    local Multiplier = 1 / (float or 1)
    return math.floor(num * Multiplier + 0.5) / Multiplier
end

function Library:Themify(instance, theme, property)
    table.insert(themes.utility[theme][property], instance)
end

function Library:SaveGradient(instance, theme)
    table.insert(themes.gradients[theme], instance)
end

function Library:RefreshTheme(theme, color)
    for property,instances in themes.utility[theme] do 
        for _,object in instances do
            if object[property] == themes.preset[theme] then 
                object[property] = color 
            end
        end 
    end
    themes.preset[theme] = color 
end 

function Library:Connection(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(Library.Connections, connection)
    return connection 
end

function Library:CloseElement() 
    if not Library.OpenElement then 
        return 
    end
    for i = 1, #Library.OpenElement do
        local Data = Library.OpenElement[i]
        if Data.Ignore then 
            continue 
        end 
        Data.SetVisible(false)
        Data.Open = false
    end
    Library.OpenElement = {}
end

function Library:Create(instance, options)
    local ins = Instance.new(instance) 
    for prop, value in options do
        ins[prop] = value
    end
    if instance == "TextButton" then 
        ins.AutoButtonColor = false 
        ins.Text = ""
    end 
    return ins 
end

function Library:Unload() 
    if Library.Items then 
        Library.Items:Destroy()
    end
    if Library.Other then 
        Library.Other:Destroy()
    end
    for _,connection in Library.Connections do 
        connection:Disconnect() 
        connection = nil 
    end
    getgenv().Library = nil 
end

function Library:Window(properties)
    local Cfg = {
        Name = properties.Name or "nebula";
        Size = properties.Size or dim2(0, 455, 0, 605);
        TabInfo;
        Items = {};
    }
    
    Library.Items = Library:Create("ScreenGui", {
        Parent = CoreGui;
        Name = "\0";
        Enabled = true;
        ZIndexBehavior = Enum.ZIndexBehavior.Global;
        IgnoreGuiInset = true;
    })
    
    Library.Other = Library:Create("ScreenGui", {
        Parent = CoreGui;
        Name = "\0";
        Enabled = false;
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        IgnoreGuiInset = true;
    })

    local Items = Cfg.Items; do
        Items.Window = Library:Create("Frame", {
            Parent = Library.Items;
            Name = "\0";
            Position = dim2(0.5, -Cfg.Size.X.Offset / 2, 0.5, -Cfg.Size.Y.Offset / 2);
            BorderColor3 = rgb(0, 0, 0);
            Size = Cfg.Size;
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Items.Window.Position = dim2(0, Items.Window.AbsolutePosition.X, 0, Items.Window.AbsolutePosition.Y)
        Library:Themify(Items.Window, "outline", "BackgroundColor3")

        Items.Inline = Library:Create("Frame", {
            Parent = Items.Window;
            Name = "\0";
            Position = dim2(0, 1, 0, 4);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -5);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.gradient
        })
        Library:Themify(Items.Inline, "gradient", "BackgroundColor3")
        
        Items.Gradient = Library:Create("Frame", {
            Parent = Items.Inline;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 0, 16);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local gradient = Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Gradient;
            Color = rgbseq{rgbkey(0, themes.preset.inline), rgbkey(1, themes.preset.gradient)}
        })
        Library:SaveGradient(gradient, "Selected")
        
        Items.Inline = Library:Create("Frame", {
            Parent = Items.Inline;
            Name = "\0";
            Position = dim2(0, 5, 0, 18);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -10, 1, -23);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.inline
        })
        Library:Themify(Items.Inline, "inline", "BackgroundColor3")
        
        Items.Outline = Library:Create("Frame", {
            Parent = Items.Inline;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Outline, "outline", "BackgroundColor3")
        
        Items.Background = Library:Create("Frame", {
            Parent = Items.Outline;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.background
        })
        Library:Themify(Items.Background, "background", "BackgroundColor3")
        
        Items.PageHolder = Library:Create("Frame", {
            Parent = Items.Background;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.PageHolder, "outline", "BackgroundColor3")
        
        Items.TabButtons = Library:Create("Frame", {
            Parent = Items.PageHolder;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 0, 23);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Items.Accent = Library:Create("Frame", {
            Name = "\0";
            Parent = Items.TabButtons;
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 2);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.accent
        })
        Library:Themify(Items.Accent, "accent", "BackgroundColor3")
        
        Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Accent;
            Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(158, 158, 158))}
        })
        
        Items.Outline = Library:Create("Frame", {
            Parent = Items.TabButtons;
            Name = "\0";
            Position = dim2(0, 0, 0, 2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Outline, "outline", "BackgroundColor3")

        local gradient = Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.TabButtons;
            Color = rgbseq{rgbkey(0, themes.preset.gradient), rgbkey(1, themes.preset.background)}
        })
        Library:SaveGradient(gradient, "Deselected")
        
        Items.Buttons = Library:Create("Frame", {
            Parent = Items.TabButtons;
            BackgroundTransparency = 1;
            Name = "\0";
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 1, -1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIListLayout", {
            Parent = Items.Buttons;
            FillDirection = Enum.FillDirection.Horizontal;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Padding = dim(0, -1);
        })
        
        Library:Create("UIPadding", {
            Parent = Items.Buttons;
            PaddingTop = dim(0, 3)
        })
        
        Items.Outline = Library:Create("Frame", {
            BorderColor3 = rgb(0, 0, 0);
            AnchorPoint = vec2(0, 1);
            Parent = Items.TabButtons;
            Name = "\0";
            Position = dim2(0, 0, 1, 0);
            Size = dim2(1, 0, 0, 1);
            ZIndex = 2;
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Outline, "outline", "BackgroundColor3")
        
        Items.PageHolder = Library:Create("Frame", {
            Parent = Items.PageHolder;
            Name = "\0";
            Position = dim2(0, 1, 0, 24);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -25);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.background
        })
        Library:Themify(Items.PageHolder, "background", "BackgroundColor3")

        Items.Fade = Library:Create("Frame", {
            Parent = Items.PageHolder;
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            ZIndex = 5;
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.background
        })
        Library:Themify(Items.Fade, "background", "BackgroundColor3")                

        Items.FadeGradient = Library:Create("Frame", {
            Name = "\0";
            Parent = Items.Fade;
            ZIndex = 5;
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 20);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local gradient = Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.FadeGradient;
            Color = rgbseq{rgbkey(0, themes.preset.gradient), rgbkey(1, themes.preset.background)}
        })
        Library:SaveGradient(gradient, "Deselected")                

        Items.Gradient = Library:Create("Frame", {
            Name = "\0";
            Parent = Items.PageHolder;
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 20);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local gradient = Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Gradient;
            Color = rgbseq{rgbkey(0, themes.preset.gradient), rgbkey(1, themes.preset.background)}
        })
        Library:SaveGradient(gradient, "Deselected")
        
        Items.Inline = Library:Create("Frame", {
            Parent = Items.Inline;
            Size = dim2(1, -2, 1, -5);
            Name = "\0";
            Position = dim2(0, 1, 0, 4);
            BorderColor3 = rgb(0, 0, 0);
            ZIndex = 0;
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.gradient
        })
        Library:Themify(Items.Inline, "gradient", "BackgroundColor3")
        
        Items.Accent = Library:Create("Frame", {
            Parent = Items.Window;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 0, 2);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.accent
        })
        Library:Themify(Items.Accent, "accent", "BackgroundColor3")
        
        Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Accent;
            Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(158, 158, 158))}
        })
        
        Items.Outline = Library:Create("Frame", {
            Parent = Items.Window;
            Name = "\0";
            Position = dim2(0, 0, 0, 3);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Outline, "outline", "BackgroundColor3")
        
        Items.UITitle = Library:Create("TextLabel", {
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = Cfg.Name;
            Parent = Items.Window;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 5, 0, 6);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.UITitle;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Items.Keybind_List = Library:Create("Frame", {
            Parent = Library.Items;
            Name = "\0";
            Position = dim2(0, 50, 0, 500);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Keybind_List, "outline", "BackgroundColor3")
        Library:Draggify(Items.Keybind_List)
            
        Items.Inline = Library:Create("Frame", {
            Parent = Items.Keybind_List;
            Name = "\0";
            Position = dim2(0, 1, 0, 4);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 6, 1, 22);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.gradient
        })
        Library:Themify(Items.Inline, "gradient", "BackgroundColor3")
        
        Items.Accent = Library:Create("Frame", {
            Parent = Items.Keybind_List;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 6, 0, 2);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.accent
        })
        Library:Themify(Items.Accent, "accent", "BackgroundColor3")
        
        Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Accent;
            Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(158, 158, 158))}
        })
        
        Items.Outline = Library:Create("Frame", {
            Parent = Items.Keybind_List;
            Name = "\0";
            Position = dim2(0, 0, 0, 3);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 7, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Outline, "outline", "BackgroundColor3")
        
        Items.Activity = Library:Create("TextLabel", {
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = "Activity";
            Parent = Items.Keybind_List;
            Name = "\0";
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundTransparency = 1;
            Position = dim2(0, 3, 0, 6);
            BorderSizePixel = 0;
            ZIndex = 2;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.Activity;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Items.Gradient = Library:Create("Frame", {
            Parent = Items.Keybind_List;
            Name = "\0";
            Position = dim2(0, 1, 0, 4);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 6, 0, 16);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local gradient = Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Gradient;
            Color = rgbseq{rgbkey(0, themes.preset.inline), rgbkey(1, themes.preset.gradient)}
        })
        Library:SaveGradient(gradient, "Selected")
        
        Library:Create("UIPadding", {
            PaddingBottom = dim(0, 5);
            Parent = Items.Keybind_List
        })
        
        Items.Elements = Library:Create("Frame", {
            BorderColor3 = rgb(0, 0, 0);
            Parent = Items.Keybind_List;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 16, 0, 38);
            Size = dim2(1, -8, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        Library.KeybindParent = Items.Elements
        
        Library:Create("UIListLayout", {
            Parent = Items.Elements;
            Padding = dim(0, 3);
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        Items.Keybinds = Library:Create("TextLabel", {
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = "Keybinds";
            Parent = Items.Keybind_List;
            Name = "\0";
            AutomaticSize = Enum.AutomaticSize.XY;
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            Position = dim2(0, 8, 0, 22);
            RichText = true;
            ZIndex = 2;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.Keybinds;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Items.Activity = Library:Create("TextLabel", {
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = "Activity: Ready";
            Parent = Items.Keybind_List;
            Name = "\0";
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundTransparency = 1;
            Position = dim2(0, 6, 1, 8);
            BorderSizePixel = 0;
            ZIndex = 2;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.Activity;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Library:Create("UIPadding", {
            PaddingBottom = dim(0, 7);
            Parent = Items.Activity
        })
        
        Items.ActivityLine = Library:Create("Frame", {
            Parent = Items.Keybind_List;
            Name = "\0";
            Position = dim2(0, 5, 1, 5);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -3, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(204, 204, 204)
        })
        
        Items.Watermark = Library:Create("Frame", {
            Parent = Library.Items;
            Name = "\0";
            Position = dim2(0, 20, 0, 60);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundColor3 = themes.preset.inline
        })
        Library:Themify(Items.Watermark, "inline", "BackgroundColor3")
        Library:Draggify(Items.Watermark)

        local stroke = Library:Create("UIStroke", {
            Color = themes.preset.outline;
            LineJoinMode = Enum.LineJoinMode.Miter;
            Parent = Items.Watermark
        })
        Library:Themify(stroke, "outline", "Color")
        
        Items.Holder = Library:Create("Frame", {
            Parent = Items.Watermark;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local grad = Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Holder;
            Color = rgbseq{rgbkey(0, themes.preset.inline), rgbkey(1, themes.preset.gradient)}
        })
        Library:SaveGradient(grad, "Selected")
        
        Items.Accent = Library:Create("Frame", {
            Name = "\0";
            Parent = Items.Watermark;
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 2);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.accent
        })
        Library:Themify(Items.Accent, "accent", "BackgroundColor3")
        
        Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Accent;
            Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(158, 158, 158))}
        })
        
        Items.Outline = Library:Create("Frame", {
            Parent = Items.Watermark;
            Name = "\0";
            Position = dim2(0, 0, 0, 2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Outline, "outline", "BackgroundColor3")
        
        Items.WatermarkTitle = Library:Create("TextLabel", {
            FontFace = Library.Font;
            TextColor3 = rgb(239, 239, 239);
            BorderColor3 = rgb(0, 0, 0);
            RichText = true;
            Text = Cfg.Name;
            Parent = Items.Watermark;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 5, 0, -2);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.WatermarkTitle;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Library:Create("UIPadding", {
            PaddingTop = dim(0, 5);
            PaddingBottom = dim(0, 2);
            Parent = Items.WatermarkTitle;
            PaddingRight = dim(0, 5);
            PaddingLeft = dim(0, 5)
        })
        
        
    end

    do
        Library:Draggify(Items.Window)
        Library:Resizify(Items.Window)
    end

    function Cfg.ToggleMenu(bool) 
        if Cfg.Tweening then 
            return 
        end 
        Cfg.Tweening = true 
        if bool then 
            Items.Window.Visible = true
        end
        local Children = Items.Window:GetDescendants()
        table.insert(Children, Items.Window)
        local Tween;
        for _,obj in Children do
            local Index = Library:GetTransparency(obj)
            if not Index then 
                continue 
            end
            if type(Index) == "table" then
                for _,prop in Index do
                    Tween = Library:Fade(obj, prop, bool)
                end
            else
                Tween = Library:Fade(obj, Index, bool)
            end
        end
        Library:Connection(Tween.Completed, function()
            Cfg.Tweening = false
            Items.Window.Visible = bool
        end)
    end 

    function Cfg.ChangeTitle(text)
        Items.UITitle.Text = text
    end

    function Cfg.ToggleWatermark(bool) 
        Items.Watermark.Visible = bool
    end 

    function Cfg.ChangeWatermarkTitle(text)
        Items.WatermarkTitle.Text = text
    end

    function Cfg.ToggleStatus(bool) 
        Items.Activity.Visible = bool
        Items.ActivityLine.Visible = bool
    end

    function Cfg.ToggleKeybindList(bool)
        Items.Keybind_List.Visible = bool
    end
    
    return setmetatable(Cfg, Library)
end 

function Library:Tab(properties)
    local Cfg = {
        Name = properties.name or properties.Name or "visuals"; 
        Items = {};
    }

    local Items = Cfg.Items; do 
        Items.Button = Library:Create("TextButton", {
            Parent = self.Items.Buttons;
            Name = "\0";
            Size = dim2(0, 0, 1, 0);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            Text = "";
            AutomaticSize = Enum.AutomaticSize.XY;
            AutoButtonColor = false;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Items.Background = Library:Create("TextLabel", {
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = Cfg.Name;
            Parent = Items.Button;
            Name = "\0";
            BackgroundTransparency = 0;
            Size = dim2(0, 0, 1, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 12;
            BackgroundColor3 = themes.preset.tab_background
        })
        Library:Themify(Items.Background, "tab_background", "BackgroundColor3")
        
        Items.TextPadding = Library:Create("UIPadding", {
            Parent = Items.Background;
            PaddingRight = dim(0, 6);
            PaddingLeft = dim(0, 5)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.Background;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Items.Fill = Library:Create("Frame", {
            BorderColor3 = rgb(0, 0, 0);
            AnchorPoint = vec2(0, 1);
            Parent = Items.Button;
            Name = "\0";
            Position = dim2(0, 0, 1, 1);
            Size = dim2(1, -2, 0, 1);
            ZIndex = 3;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.gradient
        })
        Library:Themify(Items.Fill, "gradient", "BackgroundColor3")
        
        local gradient = Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Button;
            Color = rgbseq{rgbkey(0, themes.preset.inline), rgbkey(1, themes.preset.gradient)}
        })
        Library:SaveGradient(gradient, "Selected")
        
        Items.UIStroke = Library:Create("UIStroke", {
            Color = themes.preset.outline;
            LineJoinMode = Enum.LineJoinMode.Miter;
            Parent = Items.Button;
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
        Library:Themify(Items.UIStroke, "outline", "Color")
        
        Items.Page = Library:Create("Frame", {
            Parent = Library.Other;
            Name = "\0";
            Visible = false;
            BackgroundTransparency = 1;
            Position = dim2(0, 2, 0, 2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -4, 1, -4);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalFlex = Enum.UIFlexAlignment.Fill;
            Parent = Items.Page;
            Padding = dim(0, 4);
            SortOrder = Enum.SortOrder.LayoutOrder;
            VerticalFlex = Enum.UIFlexAlignment.Fill
        })
        
        Items.Left = Library:Create("Frame", {
            Parent = Items.Page;
            BackgroundTransparency = 1;
            Name = "\0";
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 100, 0, 100);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIListLayout", {
            Parent = Items.Left;
            Padding = dim(0, 4);
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        Items.Right = Library:Create("Frame", {
            Parent = Items.Page;
            BackgroundTransparency = 1;
            Name = "\0";
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 100, 0, 100);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIListLayout", {
            Parent = Items.Right;
            Padding = dim(0, 4);
            SortOrder = Enum.SortOrder.LayoutOrder;
        })
    end 

    function Cfg.OpenTab() 
        local Tab = self.TabInfo
        if Tab then
            Library:Tween(Tab.Fill, {BackgroundTransparency = 1})
            Library:Tween(Tab.Background, {BackgroundTransparency = 0})
            Tab.Page.Visible = false
            Tab.Page.Parent = Library.Other
        end
        Library:Tween(Items.Fill, {BackgroundTransparency = 0})
        Library:Tween(Items.Background, {BackgroundTransparency = 1})
        Items.Page.Parent = self.Items.PageHolder
        Items.Page.Visible = true
        if Tab ~= Items then
            Library:Tween(self.Items.Fade, {BackgroundTransparency = 1})
            Library:Tween(self.Items.FadeGradient, {BackgroundTransparency = 1})
            self.Items.Fade.BackgroundTransparency = 0 
            self.Items.FadeGradient.BackgroundTransparency = 0
        end 
        self.TabInfo = Cfg.Items
    end

    Items.Button.MouseButton1Down:Connect(function()
        Library:CloseElement()
        Cfg.OpenTab()
    end)

    if not self.TabInfo then
        Items.TextPadding.PaddingRight = dim(0, 8);
        Cfg.OpenTab()
    end

    return setmetatable(Cfg, Library)
end

function Library:Section(properties)
    local Cfg = {
        Name = properties.name or properties.Name or "Section"; 
        Side = properties.side or properties.Side or "Left";
        Size = properties.size or properties.Size or nil;
        Items = {};
    }
    
    local Items = Cfg.Items; do
        Items.Section = Library:Create("Frame", {
            Parent = self.Items[Cfg.Side];
            Name = "\0";
            Size = dim2(1, 0, Cfg.Size or 0, -4);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Cfg.Size and Enum.AutomaticSize.None or Enum.AutomaticSize.Y;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Section, "outline", "BackgroundColor3")
        
        Items.Inline = Library:Create("Frame", {
            Parent = Items.Section;
            Size = dim2(1, -2, Cfg.Size and 1 or 0, -4);
            Name = "\0";
            Position = dim2(0, 1, 0, 4);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Cfg.Size and Enum.AutomaticSize.None or Enum.AutomaticSize.Y;
            BackgroundColor3 = themes.preset.gradient
        })
        Library:Themify(Items.Inline, "gradient", "BackgroundColor3")

        Items.Gradient = Library:Create("Frame", {
            Parent = Items.Inline;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 0, 16);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local gradient = Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Gradient;
            Color = rgbseq{rgbkey(0, themes.preset.inline), rgbkey(1, themes.preset.gradient)}
        })
        Library:SaveGradient(gradient, "Selected")
        
        Items.Elements = Library:Create("Frame", {
            BorderColor3 = rgb(0, 0, 0);
            Parent = Items.Inline;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 6, 0, 20);
            Size = dim2(1, -12, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        if Cfg.Size then 
            Items.ScrollingFrame = Library:Create("ScrollingFrame", {
                Active = true;
                ScrollingEnabled = true;
                AutomaticCanvasSize = Enum.AutomaticSize.Y;
                ZIndex = 2;
                BorderSizePixel = 0;
                CanvasSize = dim2(0, 0, 0, 0);
                ScrollBarImageColor3 = themes.preset.accent;
                MidImage = "rbxassetid://120496541810421";
                BorderColor3 = rgb(0, 0, 0);
                ScrollBarThickness = 0;
                Parent = Items.Inline;
                Size = dim2(1, -3, 1, -23);
                TopImage = "rbxassetid://118750478739322";
                Position = dim2(0, 0, 0, 20);
                BottomImage = "rbxassetid://74268315755026";
                BackgroundTransparency = 1;
                BackgroundColor3 = rgb(255, 255, 255)
            })
            Library:Themify(Items.ScrollingFrame, "accent", "ScrollBarImageColor3")
            
            Items.ScrollingLine = Library:Create("Frame", {
                Visible = false;
                BorderColor3 = rgb(0, 0, 0);
                AnchorPoint = vec2(1, 0);
                Name = "\0";
                Position = dim2(1, -2, 0, 19);
                Parent = Items.Inline;
                Size = dim2(0, 4, 1, -21);
                BorderSizePixel = 0;
                BackgroundColor3 = themes.preset.outline
            })
            Library:Themify(Items.ScrollingLine, "outline", "BackgroundColor3")
            
            Items.Elements:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if Items.ScrollingFrame.AbsoluteSize.Y < Items.Elements.AbsoluteSize.Y then 
                    Items.ScrollingLine.Visible = true 
                    Library:Tween(Items.ScrollingFrame, {ScrollBarThickness = 2})
                    Library:Tween(Items.Elements, {Size = dim2(1, -14, 0, 0)})
                else
                    Items.ScrollingLine.Visible = false
                    Library:Tween(Items.ScrollingFrame, {ScrollBarThickness = 0})
                    Library:Tween(Items.Elements, {Size = dim2(1, -10, 0, 0)})
                end     
            end)

            Items.Elements.Parent = Items.ScrollingFrame
            Items.Elements.Position = dim2(0, 6, 0, 0)
        end 

        Library:Create("UIListLayout", {
            Parent = Items.Elements;
            Padding = dim(0, 4);
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        Library:Create("UIPadding", {
            PaddingBottom = dim(0, 5);
            Parent = Items.Inline
        })
        
        Items.Accent = Library:Create("Frame", {
            Parent = Items.Section;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 0, 2);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.accent
        })
        Library:Themify(Items.Accent, "accent", "BackgroundColor3")
        
        Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Accent;
            Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(158, 158, 158))}
        })
        
        Items.Outline = Library:Create("Frame", {
            Parent = Items.Section;
            Name = "\0";
            Position = dim2(0, 0, 0, 3);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 1);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Outline, "outline", "BackgroundColor3")
        
        Items.UITitle = Library:Create("TextLabel", {
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = Cfg.Name;
            Parent = Items.Section;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 5, 0, 6);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        Library:Themify(Items.UITitle, "text_outline", "BackgroundColor3")
        
        Library:Create("UIStroke", {
            Parent = Items.UITitle;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Library:Create("UIPadding", {
            PaddingBottom = dim(0, 1);
            Parent = Items.Section
        })                
    end

    return setmetatable(Cfg, Library)
end  

function Library:Toggle(properties) 
    local Cfg = {
        Name = properties.Name or "Toggle";
        Flag = properties.Flag or properties.Name or "Toggle";
        Enabled = properties.Default or false;
        Callback = properties.Callback or function() end;
        Items = {};
    }

    local Items = Cfg.Items; do 
        Items.Object = Library:Create("TextButton", {
            FontFace = Library.Font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.Items.Elements;
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(1, 0, 0, 11);
            BorderSizePixel = 0;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        })

        Items.Outline = Library:Create("Frame", {
            Name = "\0";
            Parent = Items.Object;
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 11, 0, 11);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Outline, "outline", "BackgroundColor3")

        Items.Accent = Library:Create("Frame", {
            Parent = Items.Outline;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.accent
        })
        Library:Themify(Items.Accent, "accent", "BackgroundColor3")
        Library:Themify(Items.Accent, "inline", "BackgroundColor3")
        Items.Accent.BackgroundColor3 = themes.preset.inline 

        Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Accent;
            Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(158, 158, 158))}
        })

        Items.Name = Library:Create("TextLabel", {
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = Cfg.Name;
            Parent = Items.Object;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 15, 0, -2);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.Name;
            LineJoinMode = Enum.LineJoinMode.Miter
        })

        Items.Components = Library:Create("Frame", {
            Parent = Items.Object;
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIListLayout", {
            Parent = Items.Components;
            FillDirection = Enum.FillDirection.Horizontal;
            SortOrder = Enum.SortOrder.LayoutOrder;
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            Padding = dim(0, 4)
        })
    end
    
    function Cfg.Set(bool)
        Cfg.Callback(bool)
        Library:Tween(Items.Accent, {BackgroundColor3 = bool and themes.preset.accent or themes.preset.inline})
        Flags[Cfg.Flag] = bool
    end 
    
    Items.Object.MouseButton1Click:Connect(function()
        Cfg.Enabled = not Cfg.Enabled
        Cfg.Set(Cfg.Enabled)
    end)

    Cfg.Set(Cfg.Enabled)
    ConfigFlags[Cfg.Flag] = Cfg.Set

    return setmetatable(Cfg, Library)
end 

function Library:Slider(properties) 
    local Cfg = {
        Name = properties.Name,
        Suffix = properties.Suffix or "",
        Flag = properties.Flag or properties.Name or "Slider",
        Callback = properties.Callback or function() end, 
        Min = properties.Min or 0,
        Max = properties.Max or 100,
        Intervals = properties.Decimal or 1,
        Value = properties.Default or 10, 
        Dragging = false,
        Items = {}
    } 

    local Items = Cfg.Items; do
        Items.Slider = Library:Create("TextButton", {
            FontFace = Library.Font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.Items.Elements;
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(1, 0, 0, 25);
            BorderSizePixel = 0;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Items.Outline = Library:Create("TextButton", {
            Parent = Items.Slider;
            Text = "";
            AutoButtonColor = false;
            Name = "\0";
            Position = dim2(0, 0, 0, 14);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 11);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Outline, "outline", "BackgroundColor3")
        
        Items.Accent = Library:Create("Frame", {
            Parent = Items.Outline;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0.5, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.accent
        })
        Library:Themify(Items.Accent, "accent", "BackgroundColor3")
        
        Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Accent;
            Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(158, 158, 158))}
        })
        
        Items.Value = Library:Create("TextLabel", {
            LayoutOrder = -1;
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = "0.1";
            Parent = Items.Outline;
            Name = "\0";
            BackgroundTransparency = 1;
            Size = dim2(1, 0, 1, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.Value;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Library:Create("UIPadding", {
            Parent = Items.Value;
            PaddingTop = dim(0, -1)
        })
        
        Items.Name = Library:Create("TextLabel", {
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = Cfg.Name;
            Parent = Items.Slider;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 1, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.Name;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Items.Components = Library:Create("Frame", {
            Parent = Items.Slider;
            Name = "\0";
            Position = dim2(1, 0, 0, 2);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 0, 11);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            Parent = Items.Components;
            Padding = dim(0, 4);
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        Items.Minus = Library:Create("ImageButton", {
            ScaleType = Enum.ScaleType.Fit;
            AutoButtonColor = false;
            BorderColor3 = rgb(0, 0, 0);
            Parent = Items.Components;
            Image = "rbxassetid://120056247050601";
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(0, 7, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Items.Plus = Library:Create("ImageButton", {
            ScaleType = Enum.ScaleType.Fit;
            AutoButtonColor = false;
            BorderColor3 = rgb(0, 0, 0);
            Parent = Items.Components;
            Image = "rbxassetid://120458671764177";
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(0, 7, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Items.Interval = Library:Create("TextLabel", {
            LayoutOrder = -1;
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = Cfg.Intervals;
            Parent = Items.Components;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 1, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.Interval;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Library:Create("UIPadding", {
            Parent = Items.Interval;
            PaddingTop = dim(0, -1)
        })                          
    end 

    function Cfg.Set(value)
        Cfg.Value = math.clamp(Library:Round(value, Cfg.Intervals), Cfg.Min, Cfg.Max)
        Items.Accent.Size = dim2((Cfg.Value - Cfg.Min) / (Cfg.Max - Cfg.Min), Cfg.Value == Cfg.Min and 0 or -2, 1, -2)
        Items.Value.Text = tostring(Cfg.Value) .. Cfg.Suffix
        Flags[Cfg.Flag] = Cfg.Value
        Cfg.Callback(Flags[Cfg.Flag])
    end
    
    local function onInputBegin()
        Cfg.Dragging = true 
    end
    
    Items.Outline.MouseButton1Down:Connect(onInputBegin)
    

    Library:Connection(UserInputService.InputChanged, function(input)
        if Cfg.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or (TouchEnabled and input.UserInputType == Enum.UserInputType.Touch)) then 
            local Size = (input.Position.X - Items.Outline.AbsolutePosition.X) / Items.Outline.AbsoluteSize.X
            local Value = ((Cfg.Max - Cfg.Min) * Size) + Cfg.Min
            Cfg.Set(Value)
        end
    end)

    Library:Connection(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
            Cfg.Dragging = false
        end 
    end)

    Cfg.Set(Cfg.Value)
    ConfigFlags[Cfg.Flag] = Cfg.Set

    return setmetatable(Cfg, Library)
end 

function Library:Label(properties)
    local Cfg = {
        Name = properties.Name or "Label",
        Items = {};
    }

    local Items = Cfg.Items; do 
        Items.Label = Library:Create("TextButton", {
            LayoutOrder = 1;
            FontFace = Library.Font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.Items.Elements;
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(1, 0, 0, 11);
            BorderSizePixel = 0;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Items.Name = Library:Create("TextLabel", {
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = Cfg.Name;
            Parent = Items.Label;
            BackgroundTransparency = 1;
            Name = "\0";
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.Name;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Items.Components = Library:Create("Frame", {
            Parent = Items.Label;
            Name = "\0";
            Position = dim2(1, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 1, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIListLayout", {
            Parent = Items.Components;
            SortOrder = Enum.SortOrder.LayoutOrder;
            HorizontalAlignment = Enum.HorizontalAlignment.Right
        })                
    end 

    function Cfg.Set(Text)
        Items.Name.Text = Text
    end 

    return setmetatable(Cfg, Library)
end

function Library:Textbox(properties) 
    local Cfg = {
        Name = properties.Name or "TextBox",
        PlaceHolder = properties.PlaceHolder or properties.PlaceHolderText or "Type here...",
        Default = properties.Default or "",
        Flag = properties.Flag or properties.Name or "TextBox",
        Callback = properties.Callback or function() end,
        Items = {};
    }

    Flags[Cfg.Flag] = Cfg.Default

    local Items = Cfg.Items; do 
        Items.Textbox = Library:Create("TextButton", {
            FontFace = Library.Font;
            TextColor3 = rgb(0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = self.Items.Elements;
            BackgroundTransparency = 1;
            Name = "\0";
            Size = dim2(1, 0, 0, 32);
            BorderSizePixel = 0;
            TextSize = 14;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Items.Outline = Library:Create("Frame", {
            Parent = Items.Textbox;
            Name = "\0";
            Position = dim2(0, 0, 0, 14);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, 0, 0, 18);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.outline
        })
        Library:Themify(Items.Outline, "outline", "BackgroundColor3")
        
        Items.Inline = Library:Create("Frame", {
            Parent = Items.Outline;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.inline
        })
        Library:Themify(Items.Inline, "inline", "BackgroundColor3")
        
        Items.Background = Library:Create("Frame", {
            Parent = Items.Inline;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local gradient = Library:Create("UIGradient", {
            Rotation = 90;
            Parent = Items.Background;
            Color = rgbseq{rgbkey(0, themes.preset.inline), rgbkey(1, themes.preset.gradient)}
        })
        Library:SaveGradient(gradient, "Selected")
        
        Items.Input = Library:Create("TextBox", {
            FontFace = Library.Font;
            ClearTextOnFocus = false;
            Active = true;
            Selectable = false;
            PlaceholderColor3 = themes.preset.text_color;
            PlaceholderText = Cfg.PlaceHolder;
            TextSize = 12;
            TextTruncate = Enum.TextTruncate.AtEnd;
            Size = dim2(1, 0, 1, 0);
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = Cfg.Default;
            Parent = Items.Background;
            TextXAlignment = Enum.TextXAlignment.Left;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 3, 0, 0);
            CursorPosition = -1;
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.Input;
            LineJoinMode = Enum.LineJoinMode.Miter
        })
        
        Items.Name = Library:Create("TextLabel", {
            FontFace = Library.Font;
            TextColor3 = themes.preset.text_color;
            BorderColor3 = rgb(0, 0, 0);
            Text = Cfg.Name;
            Parent = Items.Textbox;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 1, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIStroke", {
            Parent = Items.Name;
            LineJoinMode = Enum.LineJoinMode.Miter
        })                
    end 
    
    function Cfg.Set(text) 
        Flags[Cfg.Flag] = text
        Items.Input.Text = text
        Cfg.Callback(text)
    end 
    
    Items.Input:GetPropertyChangedSignal("Text"):Connect(function()
        Cfg.Set(Items.Input.Text) 
    end) 

    if Cfg.Default then 
        Cfg.Set(Cfg.Default) 
    end

    ConfigFlags[Cfg.Flag] = Cfg.Set

    return setmetatable(Cfg, Library)
end

function Notifications:Create(properties)
    local Cfg = {
        Name = properties.Name or "Notification!";
        Lifetime = properties.LifeTime or 3;
        Items = {};
    }

    local Items = Cfg.Items; do 
        Items.Outline = Library:Create("Frame", {
            Parent = Library.Items;
            Size = dim2(0, 0, 0, 18);
            Name = "\0";
            AnchorPoint = vec2(1, 0);
            Position = dim2(0, 7, 0, 46);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundColor3 = rgb(52, 52, 52)
        })
        
        Items.Inline = Library:Create("Frame", {
            Parent = Items.Outline;
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundColor3 = rgb(5, 5, 5)
        })
        
        Library:Create("UIPadding", {
            PaddingTop = dim(0, 7);
            PaddingBottom = dim(0, 6);
            Parent = Items.Inline;
            PaddingRight = dim(0, 8);
            PaddingLeft = dim(0, 4)
        })
        
        Items.Text = Library:Create("TextLabel", {
            FontFace = Library.Font;
            Parent = Items.Inline;
            TextColor3 = rgb(255, 255, 255);
            BorderColor3 = rgb(0, 0, 0);
            Text = Cfg.Name;
            Name = "\0";
            AutomaticSize = Enum.AutomaticSize.XY;
            Size = dim2(1, -4, 1, 0);
            Position = dim2(0, 4, 0, -2);
            BackgroundTransparency = 1;
            TextXAlignment = Enum.TextXAlignment.Left;
            BorderSizePixel = 0;
            ZIndex = 2;
            TextSize = 12;
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        Library:Create("UIPadding", {
            PaddingBottom = dim(0, 1);
            PaddingRight = dim(0, 1);
            Parent = Items.Outline
        })
        
        Items.AccentLine = Library:Create("Frame", {
            Parent = Items.Outline;
            Name = "\0";
            Position = dim2(0, 2, 1, -1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -1, 0, 1);
            BorderSizePixel = 0;
            ZIndex = 100;
            BackgroundColor3 = themes.preset.accent
        })
        Library:Themify(Items.AccentLine, "accent", "BackgroundColor3")
        
        Items.Accent = Library:Create("Frame", {
            Parent = Items.Outline;
            Name = "\0";
            ZIndex = 100;
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 1, 1, -1);
            BorderSizePixel = 0;
            BackgroundColor3 = themes.preset.accent
        })
        Library:Themify(Items.Accent, "accent", "BackgroundColor3")                    
    end 
    
    local index = #Notifications.Notifs + 1
    Notifications.Notifs[index] = Items.Outline

    local offset = 50
    for i, v in Notifications.Notifs do
        local Position = vec2(20, offset)
        Library:Tween(v, {Position = dim_offset(Position.X, Position.Y)})
        offset = offset + (v.AbsoluteSize.Y + 10)
    end

    Items.Outline.Position = dim_offset(20, offset)

    Library:Tween(Items.Outline, {AnchorPoint = vec2(0, 0)})
    Library:Tween(Items.AccentLine, {Size = dim2(0, -2, 0, 1)}, TweenInfo.new(Cfg.Lifetime, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0))

    task.spawn(function()
        task.wait(Cfg.Lifetime)
        Notifications.Notifs[index] = nil
        Library:Tween(Items.Outline, {BackgroundTransparency = 1})
        for _, instance in Items.Outline:GetDescendants() do 
            if instance:IsA("UIStroke") then
                Library:Tween(instance, {Transparency = 1})
            end
            if instance:IsA("TextLabel") then
                Library:Tween(instance, {TextTransparency = 1})
            end
        end
        Library:Tween(Items.Outline, {AnchorPoint = vec2(1, 0)})
        task.wait(1)
        Items.Outline:Destroy() 
    end)
end

return Library, Notifications, themes
