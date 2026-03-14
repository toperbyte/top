local TS, UIS, CG, GS = game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("CoreGui"), game:GetService("GuiService")
local  HttpService = game:GetService("HttpService")
if CG:FindFirstChild("ExoriaLib") then CG.ExoriaLib:Destroy() end

local FontNames = {
        ["ProggyClean"] = "ProggyClean.ttf"
       
    }

    local FontIndexes = {"ProggyClean"}

    local Fonts = {}; do
        local function RegisterFont(Name, Weight, Style, Asset)
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

        for name, suffix in FontNames do 
            local Weight = 400 

            if name == "Rubik" then
                Weight = 900 
            end 

            local RegisteredFont = RegisterFont(name, Weight, "Normal", {
                Id = suffix,
                Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/" .. suffix),
            }) 
            
            Fonts[name] = Font.new(RegisteredFont, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end
    end

local Library = {
    Options = {},
    Themes = {
        Default = {
            Main = Color3.fromRGB(15, 15, 15),
            Section = Color3.fromRGB(22, 22, 22),
            Accent = Color3.fromRGB(255, 0, 127),
            Outline = Color3.fromRGB(45, 45, 45),
            Inline = Color3.fromRGB(30, 30, 30),
            Text = Color3.fromRGB(235, 235, 235),
            Font = Fonts.ProggyClean
        }
    }
}

function Library:Create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props) do inst[i] = v end
    if pcall(function() return inst.BorderSizePixel end) then inst.BorderSizePixel = 0 end
    return inst
end

function Library:AddShadow(parent)
    return self:Create("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(130, 130, 130)),
        Parent = parent
    })
end

function Library:MakeDraggable(dragFrame)
    local dragging, dragStart, startPos
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = dragFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            dragFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

function Library:CreateWindow(info)
    local Theme = self.Themes.Default
    local ScreenGui = self:Create("ScreenGui", {
        Name = "ExoriaLib",
        Parent = CG,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    
    local Outer = self:Create("Frame", {
        Size = UDim2.new(0, 625 + 35, 0, 545 + 35),
        Position = UDim2.new(0.5, -(625/2 + 17), 0.5, -(545/2 + 17)),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        ZIndex = 2,
        Parent = ScreenGui
    })
    Library:AddShadow(Outer)

    
    local Main = self:Create("Frame", {
        Size = UDim2.new(0, 625, 0, 545),
        Position = UDim2.new(0.5, -625/2, 0.5, -545/2),
        BackgroundColor3 = Theme.Main,
        ZIndex = 95,
        Parent = ScreenGui
    })

    self:MakeDraggable(Main)

    local ac = self:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = Theme.Accent,
        Parent = Main
    })
    Library:AddShadow(ac)

    local TabHolder = self:Create("Frame", {
        Size = UDim2.new(1, -20, 0, 36),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Theme.Inline,
        Parent = Main
    })
    Library:AddShadow(TabHolder)
    self:Create("UIStroke", { Color = Theme.Outline, Parent = TabHolder })

    local TabList = self:Create("UIListLayout", {
        FillDirection = "Horizontal",
        Parent = TabHolder
    })

    local Container = self:Create("Frame", {
        Size = UDim2.new(1, -20, 1, -66),
        Position = UDim2.new(0, 10, 0, 56),
        BackgroundColor3 = Theme.Main,
        Parent = Main
    })
    self:Create("UIStroke", { Color = Theme.Outline, Parent = Container })

    
    game:GetService("RunService").RenderStepped:Connect(function()
        Outer.Position = UDim2.new(
            Main.Position.X.Scale,
            Main.Position.X.Offset - 17,
            Main.Position.Y.Scale,
            Main.Position.Y.Offset - 17
        )
    end)

    local Window = { TabButtons = {} }

    function Window:AddTab(name)
        local TabPage = Library:Create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Parent = Container })
        local LeftSide = Library:Create("ScrollingFrame", { Size = UDim2.new(0.5, -10, 1, -10), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1, CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 0, Parent = TabPage })
        local RightSide = Library:Create("ScrollingFrame", { Size = UDim2.new(0.5, -10, 1, -10), Position = UDim2.new(0.5, 5, 0, 5), BackgroundTransparency = 1, CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 0, Parent = TabPage })

        for _, side in pairs({LeftSide, RightSide}) do
            local list = Library:Create("UIListLayout", { Padding = UDim.new(0, 18), Parent = side })
            Library:Create("UIPadding", { PaddingTop = UDim.new(0, 15), Parent = side })
            list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() side.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 30) end)
        end

        local TabBtn = Library:Create("TextButton", { BackgroundColor3 = Theme.Inline, Text = name:upper(), TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 12, Parent = TabHolder })
        local uc = self:Create("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(160, 160, 170)),
            Parent = TabBtn
        })
        table.insert(Window.TabButtons, {Btn = TabBtn, Page = TabPage})
        for _, v in pairs(Window.TabButtons) do v.Btn.Size = UDim2.new(1/#Window.TabButtons, 0, 1, 0) end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Window.TabButtons) do v.Page.Visible = false; v.Btn.BackgroundColor3 = Theme.Inline; v.Btn.TextColor3 = Theme.Text end
            TabPage.Visible = true; TabBtn.BackgroundColor3 = Theme.Section; TabBtn.TextColor3 = Theme.Accent
        end)
        if #Window.TabButtons == 1 then TabPage.Visible = true; TabBtn.BackgroundColor3 = Theme.Section; TabBtn.TextColor3 = Theme.Accent end

        local function CreateElements(ContentObj)
            local Elements = {}

            local function handleInput(frame, cb)
                local con; con = UIS.InputChanged:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                        local inset = GS:GetGuiInset()
                        cb(math.clamp((inp.Position.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X, 0, 1), math.clamp((inp.Position.Y - (frame.AbsolutePosition.Y + inset.Y)) / frame.AbsoluteSize.Y, 0, 1))
                    end
                end)
                local endCon; endCon = UIS.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then con:Disconnect(); endCon:Disconnect() end
                end)
            end

            local function createAddonHolder(parent)
                local h = Library:Create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = parent })
                Library:Create("UIListLayout", { FillDirection = "Horizontal", HorizontalAlignment = "Right", VerticalAlignment = "Center", Padding = UDim.new(0, 5), Parent = h })
                return h
            end

            local function addKeybind(holder, id, cfg)
                local KB = { Value = cfg.Default or Enum.KeyCode.F }
                local B = Library:Create("TextButton", { Size = UDim2.new(0, 45, 0, 16), BackgroundColor3 = Theme.Inline, Text = KB.Value.Name, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 10, Parent = holder })
                Library:Create("UIStroke", { Color = Theme.Outline, Parent = B })
                function KB:SetValue(v) self.Value = v; B.Text = v.Name; if cfg.Callback then cfg.Callback(v) end end
                B.MouseButton1Click:Connect(function() B.Text = "..."; local c; c = UIS.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Keyboard then KB:SetValue(i.KeyCode); c:Disconnect() end end) end)
                Library.Options[id] = KB return KB
            end

            local function addColorPicker(holder, id, cfg)
                local CP = { h=0, s=1, v=1, Value = cfg.Default or Color3.new(1,1,1) }
                CP.h, CP.s, CP.v = CP.Value:ToHSV()
                local B = Library:Create("TextButton", { Size = UDim2.new(0, 22, 0, 12), BackgroundColor3 = CP.Value, Text = "", Parent = holder })
                Library:Create("UIStroke", { Color = Theme.Outline, Parent = B }); Library:AddShadow(B)
                local Win = Library:Create("Frame", { Size = UDim2.new(0, 180, 0, 160), BackgroundColor3 = Theme.Main, Visible = false, ZIndex = 5000, Parent = ScreenGui })
                Library:Create("UIStroke", { Color = Theme.Outline, Parent = Win })
                local Sat = Library:Create("TextButton", { Size = UDim2.new(0, 130, 0, 130), Position = UDim2.new(0, 10, 0, 10), BackgroundColor3 = Color3.fromHSV(CP.h,1,1), Text = "", AutoButtonColor = false, ZIndex = 5001, Parent = Win })
                local WhiteG = Library:Create("Frame", { Size = UDim2.new(1,0,1,0), ZIndex = 5002, Parent = Sat }); Library:Create("UIGradient", { Color = ColorSequence.new(Color3.new(1,1,1)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}), Parent = WhiteG })
                local BlackG = Library:Create("Frame", { Size = UDim2.new(1,0,1,0), ZIndex = 5003, Parent = Sat }); Library:Create("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.new(0,0,0)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)}), Parent = BlackG })
                local SCur = Library:Create("Frame", { Size = UDim2.new(0, 4, 0, 4), Position = UDim2.new(CP.s, -2, 1-CP.v, -2), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 5005, Parent = Sat }); Library:Create("UIStroke", { Parent = SCur })
                local Hue = Library:Create("TextButton", { Size = UDim2.new(0, 15, 0, 130), Position = UDim2.new(0, 150, 0, 10), Text = "", AutoButtonColor = false, ZIndex = 5001, Parent = Win }); local HCur = Library:Create("Frame", { Size = UDim2.new(1, 4, 0, 2), Position = UDim2.new(0, -2, 1-CP.h, 0), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 5005, Parent = Hue }); Library:Create("UIStroke", { Parent = HCur }); Library:Create("UIGradient", { Rotation = 90, Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,0,0)), ColorSequenceKeypoint.new(0.17,Color3.new(1,1,0)), ColorSequenceKeypoint.new(0.33,Color3.new(0,1,0)), ColorSequenceKeypoint.new(0.5,Color3.new(0,1,1)), ColorSequenceKeypoint.new(0.67,Color3.new(0,0,1)), ColorSequenceKeypoint.new(0.83,Color3.new(1,0,1)), ColorSequenceKeypoint.new(1,Color3.new(1,0,0))}), Parent = Hue })
                local function update() CP.Value = Color3.fromHSV(CP.h, CP.s, CP.v); B.BackgroundColor3 = CP.Value; Sat.BackgroundColor3 = Color3.fromHSV(CP.h, 1, 1); SCur.Position = UDim2.new(CP.s, -2, 1-CP.v, -2); HCur.Position = UDim2.new(0, -2, 1-CP.h, 0); if cfg.Callback then cfg.Callback(CP.Value) end end
                Sat.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then handleInput(Sat, function(x,y) CP.s = x; CP.v = 1-y; update() end) end end)
                Hue.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then handleInput(Hue, function(_,y) CP.h = 1-y; update() end) end end)
                B.MouseButton1Click:Connect(function() Win.Position = UDim2.new(0, B.AbsolutePosition.X - 190, 0, B.AbsolutePosition.Y + GS:GetGuiInset().Y); Win.Visible = not Win.Visible end)
                function CP:SetValue(v) self.Value = v; self.h, self.s, self.v = v:ToHSV(); update() end
                Library.Options[id] = CP return CP
            end

           -- function Elements:AddToggle(id, cfg) local T = { Value = cfg.Default or false } local B = Library:Create("TextButton", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "", Parent = ContentObj }) local Box = Library:Create("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Theme.Inline, Parent = B }) Library:Create("UIStroke", { Color = Theme.Outline, Parent = Box }) local Inner = Library:Create("Frame", { Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = T.Value and Theme.Accent or Theme.Section, BackgroundTransparency = T.Value and 0 or 1, Parent = Box }) local Glow = Library:Create("ImageLabel", { Size = UDim2.new(2, 0, 2, 0), Position = UDim2.new(-0.5, 0, -0.5, 0), BackgroundTransparency = 1, Image = "rbxassetid://3523727242", ImageColor3 = Theme.Accent, ImageTransparency = T.Value and 0.5 or 1, Parent = Inner }) Library:Create("TextLabel", { Size = UDim2.new(1, -26, 1, 0), Position = UDim2.new(0, 26, 0, 0), Text = cfg.Text or id, TextColor3 = T.Value and Theme.Text or Color3.fromRGB(160, 160, 160), FontFace = Theme.Font, TextSize = 13, TextXAlignment = "Left", BackgroundTransparency = 1, Parent = B }) local Holder = createAddonHolder(B) function T:SetValue(v) self.Value = v game:GetService("TweenService"):Create(Inner, TweenInfo.new(0.15), { BackgroundColor3 = v and Theme.Accent or Theme.Section, BackgroundTransparency = v and 0 or 1 }):Play() game:GetService("TweenService"):Create(Glow, TweenInfo.new(0.15), { ImageTransparency = v and 0.5 or 1 }):Play() game:GetService("TweenService"):Create(B.TextLabel, TweenInfo.new(0.15), { TextColor3 = v and Theme.Text or Color3.fromRGB(160, 160, 160) }):Play() if cfg.Callback then cfg.Callback(v) end end B.MouseButton1Click:Connect(function() T:SetValue(not T.Value) end) function T:AddColorPicker(id2, ccfg) return addColorPicker(Holder, id2, ccfg) end function T:AddKeybind(id2, kcfg) return addKeybind(Holder, id2, kcfg) end Library.Options[id] = T return T end  function Elements:AddSlider(id, cfg) local S = { Value = cfg.Default or cfg.Min } local F = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = ContentObj }) Library:Create("TextLabel", { Size = UDim2.new(1, 0, 0, 14), Text = cfg.Text or id, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 12, TextXAlignment = "Left", BackgroundTransparency = 1, Parent = F }) local Bar = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 0, 18), BackgroundColor3 = Theme.Inline, Parent = F }); Library:Create("UIStroke", { Color = Theme.Outline, Parent = Bar }) local Fill = Library:Create("Frame", { Size = UDim2.new((S.Value-cfg.Min)/(cfg.Max-cfg.Min), 0, 1, 0), BackgroundColor3 = Theme.Accent, Parent = Bar }); Library:AddShadow(Fill) local Val = Library:Create("TextLabel", { Size = UDim2.new(0, 30, 0, 12), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Text = S.Value.."/"..cfg.Max, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 10, Parent = Bar }) function S:SetValue(v) v = math.floor(math.clamp(v, cfg.Min, cfg.Max)); self.Value = v; Fill.Size = UDim2.new((v-cfg.Min)/(cfg.Max-cfg.Min), 0, 1, 0); Val.Text = v.."/"..cfg.Max; if cfg.Callback then cfg.Callback(v) end end Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then handleInput(Bar, function(x) S:SetValue(cfg.Min + (cfg.Max-cfg.Min)*x) end) end end) Library.Options[id] = S return S end  function Elements:AddToggle(id, cfg) local T = { Value = cfg.Default or false } local B = Library:Create("TextButton", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "", Parent = ContentObj }) local Box = Library:Create("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Theme.Inline, Parent = B }); Library:Create("UIStroke", { Color = Theme.Outline, Parent = Box }) local Inner = Library:Create("Frame", { Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = T.Value and Theme.Accent or Theme.Section, Parent = Box }); Library:AddShadow(Inner) Library:Create("TextLabel", { Size = UDim2.new(1, -26, 1, 0), Position = UDim2.new(0, 26, 0, 0), Text = cfg.Text or id, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 13, TextXAlignment = "Left", BackgroundTransparency = 1, Parent = B }) local Holder = createAddonHolder(B) function T:SetValue(v) self.Value = v; Inner.BackgroundColor3 = v and Theme.Accent or Theme.Section; if cfg.Callback then cfg.Callback(v) end end B.MouseButton1Click:Connect(function() T:SetValue(not T.Value) end) function T:AddColorPicker(id2, ccfg) return addColorPicker(Holder, id2, ccfg) end function T:AddKeybind(id2, kcfg) return addKeybind(Holder, id2, kcfg) end Library.Options[id] = T return T end
            function Elements:AddToggle(id, cfg) local T = { Value = cfg.Default or false } local B = Library:Create("TextButton", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "", Parent = ContentObj }) local Box = Library:Create("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Theme.Inline, Parent = B }); Library:Create("UIStroke", { Color = Theme.Outline, Parent = Box }) local Inner = Library:Create("Frame", { Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = T.Value and Theme.Accent or Theme.Section, Parent = Box }); Library:AddShadow(Inner) Library:Create("TextLabel", { Size = UDim2.new(1, -26, 1, 0), Position = UDim2.new(0, 26, 0, 0), Text = cfg.Text or id, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 13, TextXAlignment = "Left", BackgroundTransparency = 1, Parent = B }) local Holder = createAddonHolder(B) function T:SetValue(v) self.Value = v; Inner.BackgroundColor3 = v and Theme.Accent or Theme.Section; if cfg.Callback then cfg.Callback(v) end end B.MouseButton1Click:Connect(function() T:SetValue(not T.Value) end) function T:AddColorPicker(id2, ccfg) return addColorPicker(Holder, id2, ccfg) end function T:AddKeybind(id2, kcfg) return addKeybind(Holder, id2, kcfg) end Library.Options[id] = T return T end 
            function Elements:AddSlider(id, cfg)
    local S = { Value = cfg.Default or cfg.Min }
    local F = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = ContentObj })
    Library:Create("TextLabel", { Size = UDim2.new(1, 0, 0, 14), Text = cfg.Text or id, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 12, TextXAlignment = "Left", BackgroundTransparency = 1, Parent = F })
    local Bar = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 0, 18), BackgroundColor3 = Theme.Inline, Parent = F }); Library:Create("UIStroke", { Color = Theme.Outline, Parent = Bar })
    local Fill = Library:Create("Frame", { Size = UDim2.new((S.Value-cfg.Min)/(cfg.Max-cfg.Min), 0, 1, 0), BackgroundColor3 = Theme.Accent, Parent = Bar }); Library:AddShadow(Fill)
    local Val = Library:Create("TextLabel", { Size = UDim2.new(0, 30, 0, 12), Position = UDim2.new(1, -35, 0.5, -6), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Text = S.Value.."/"..cfg.Max, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 10, Parent = Bar })
    function S:SetValue(v) v = math.floor(math.clamp(v, cfg.Min, cfg.Max)); self.Value = v; Fill.Size = UDim2.new((v-cfg.Min)/(cfg.Max-cfg.Min), 0, 1, 0); Val.Text = v.."/"..cfg.Max; if cfg.Callback then cfg.Callback(v) end end
    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then handleInput(Bar, function(x) S:SetValue(cfg.Min + (cfg.Max-cfg.Min)*x) end) end end)
    Library.Options[id] = S return S
                        end
            function Elements:AddListBox(id, cfg)
                local L = { Value = {}, List = cfg.List or {}, MultiSelect = cfg.MultiSelect or false }
                local F = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, (cfg.Height or 120) + 22), BackgroundTransparency = 1, Parent = ContentObj })
                Library:Create("TextLabel", { Size = UDim2.new(1, 0, 0, 14), Text = cfg.Text or id, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 13, TextXAlignment = "Left", BackgroundTransparency = 1, Parent = F })
                local Box = Library:Create("ScrollingFrame", { Size = UDim2.new(1, 0, 0, cfg.Height or 120), Position = UDim2.new(0, 0, 0, 18), BackgroundColor3 = Theme.Inline, ScrollBarThickness = 2, Parent = F }); Library:Create("UIStroke", { Color = Theme.Outline, Parent = Box })
                local ly = Library:Create("UIListLayout", { Parent = Box }); local function upd()
                    for _, v in pairs(Box:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _, i in pairs(L.List) do
                        local sel = L.Value[i]; local ib = Library:Create("TextButton", { Size = UDim2.new(1, -4, 0, 24), BackgroundColor3 = sel and Theme.Accent or Theme.Section, BackgroundTransparency = sel and 0.4 or 1, Text = "  "..tostring(i), TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 12, TextXAlignment = "Left", Parent = Box })
                        if sel then Library:AddShadow(ib) end; ib.MouseButton1Click:Connect(function() if L.MultiSelect then L.Value[i] = not L.Value[i] else L.Value = {[i] = true} end; upd(); if cfg.Callback then cfg.Callback(L.Value) end end)
                    end; Box.CanvasSize = UDim2.new(0,0,0,ly.AbsoluteContentSize.Y)
                end
                function L:Add(i) table.insert(self.List, i); upd() end
                function L:Remove(i) for k,v in pairs(self.List) do if v==i then table.remove(self.List, k) end end; self.Value[i]=nil; upd() end
                function L:Refresh(nl) self.List = nl or {}; self.Value = {}; upd() end
                upd(); Library.Options[id] = L return L
            end

            function Elements:AddButton(t, cb)
                local B = { Instance = Library:Create("TextButton", { Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Theme.Inline, Text = t, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 13, Parent = ContentObj }) }
                Library:Create("UIStroke", { Color = Theme.Outline, Parent = B.Instance }); Library:AddShadow(B.Instance)
                B.Instance.MouseButton1Click:Connect(cb)
                function B:SetText(nt) self.Instance.Text = nt end
                return B
            end

            function Elements:AddTextbox(id, cfg)
                local T = { Value = cfg.Default or "" }
                local F = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Parent = ContentObj })
                Library:Create("TextLabel", { Size = UDim2.new(1, 0, 0, 14), Text = cfg.Text or id, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 13, TextXAlignment = "Left", BackgroundTransparency = 1, Parent = F })
                local Box = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 24), Position = UDim2.new(0, 0, 0, 18), BackgroundColor3 = Theme.Inline, Parent = F }); Library:Create("UIStroke", { Color = Theme.Outline, Parent = Box })
                local TBox = Library:Create("TextBox", { Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = T.Value, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 12, Parent = Box })
                TBox.FocusLost:Connect(function() T.Value = TBox.Text; if cfg.Callback then cfg.Callback(TBox.Text) end end)
                function T:SetValue(v) self.Value = v; TBox.Text = v; if cfg.Callback then cfg.Callback(v) end end
                return T
            end

            function Elements:AddDivider(text)
                local f = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = ContentObj })
                Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Theme.Outline, Parent = f })
                if text then local l = Library:Create("TextLabel", { Size = UDim2.new(0, #text * 8 + 20, 1, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),BackgroundTransparency = 1,  BackgroundColor3 = Theme.Main, Text = text, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 11, Parent = f }); Library:Create("UIStroke", { Color = Theme.Outline, Parent = l }) end
            end
            function Elements:AddPicture(id, cfg)
                local img = Library:Create("ImageLabel", { Size = UDim2.new(1, 0, 0, cfg.Height or 150), BackgroundColor3 = Theme.Inline, Image = cfg.Image or "", Parent = ContentObj })
                Library:Create("UIStroke", { Color = Theme.Outline, Parent = img }); return { SetImage = function(_, ni) img.Image = ni end }
            end
            function Elements:AddLabel(t)
                local l = Library:Create("TextLabel", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = t, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 13, TextXAlignment = "Left", Parent = ContentObj })
                return { SetText = function(_, nt) l.Text = nt end }
            end

            function Elements:AddMultiSection(sections)
                local M = { Subs = {} }
                local Holder = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = ContentObj })
                local hly = Library:Create("UIListLayout", { Padding = UDim.new(0, 10), Parent = Holder })
                local TabBar = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Theme.Inline, Parent = Holder }); Library:Create("UIStroke", { Color = Theme.Outline, Parent = TabBar }); Library:Create("UIListLayout", { FillDirection = "Horizontal", Parent = TabBar })
                local PageH = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Parent = Holder }); local ply = Library:Create("UIListLayout", { Padding = UDim.new(0, 10), Parent = PageH })
                local function upS() local t = 26; for _, p in pairs(PageH:GetChildren()) do if p:IsA("Frame") and p.Visible then t = t + p.UIListLayout.AbsoluteContentSize.Y + 10 end end Holder.Size = UDim2.new(1, 0, 0, t) end
                for i, n in pairs(sections) do
                    local pg = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Visible = false, Parent = PageH }); local pLy = Library:Create("UIListLayout", { Padding = UDim.new(0, 10), Parent = pg })
                    pLy:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() if pg.Visible then pg.Size = UDim2.new(1,0,0,pLy.AbsoluteContentSize.Y); upS() end end)
                    local bt = Library:Create("TextButton", { Size = UDim2.new(1/#sections, 0, 1, 0), BackgroundColor3 = Theme.Inline, Text = n, TextColor3 = Theme.Text, FontFace = Theme.Font, TextSize = 11, Parent = TabBar })
                    bt.MouseButton1Click:Connect(function() for _, v in pairs(M.Subs) do v.Page.Visible = false; v.Btn.BackgroundColor3 = Theme.Inline end; pg.Visible = true; bt.BackgroundColor3 = Theme.Section; upS() end)
                    M.Subs[n] = CreateElements(pg); M.Subs[n].Page = pg; M.Subs[n].Btn = bt; if i == 1 then pg.Visible = true; bt.BackgroundColor3 = Theme.Section end
                end; return M.Subs
            end

            return Elements
        end

        return {AddSection = function(_, label, side)
            local s = (side == "Right" and RightSide or LeftSide)
            local o = Library:Create("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Section, Parent = s }); Library:Create("UIStroke", { Color = Theme.Outline, Thickness = 1.5, Parent = o })
            Library:Create("TextLabel", { Size = UDim2.new(0, 0, 0, 2), Position = UDim2.new(0, 13, 0, -1), Text = " "..label:upper().." ", TextColor3 = Theme.Accent, BackgroundColor3 = Theme.Main, FontFace = Theme.Font, TextSize = 12, Parent = o, TextXAlignment = "Left" })
            local c = Library:Create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = o }); local ly = Library:Create("UIListLayout", { Padding = UDim.new(0, 12), Parent = c }); Library:Create("UIPadding", { PaddingTop = UDim.new(0, 18), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), Parent = c })
            ly:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() o.Size = UDim2.new(1, 0, 0, ly.AbsoluteContentSize.Y + 28) end)
            return CreateElements(c)
        end}
    end
    return Window
end
return Library
