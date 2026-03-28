local settings = {
    folder_name = "deadcell";
    default_accent = Color3.fromRGB(255, 105, 180);
};

local function setupFonts()
    if not isfolder(settings.folder_name) then
        makefolder(settings.folder_name);
        makefolder(settings.folder_name .. "/configs");
        makefolder(settings.folder_name .. "/assets");
        makefolder(settings.folder_name .. "/fonts");
    end
    local fontPath = settings.folder_name .. "/fonts/main.ttf"
    if not isfile(fontPath) then
        writefile(fontPath, game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf"))
    end
    local fontData = {
        name = "CustomFont",
        faces = {{name = "Regular", weight = 400, style = "normal", assetId = getcustomasset and getcustomasset(fontPath) or ""}}
    }
    local fontJsonPath = settings.folder_name .. "/fonts/font_data.json"
    if not isfile(fontJsonPath) then
        writefile(fontJsonPath, game:GetService("HttpService"):JSONEncode(fontData))
    end
    return Font.new(getcustomasset and getcustomasset(fontJsonPath) or Enum.Font.Gotham, Enum.FontWeight.Regular)
end

local customFont = setupFonts()

local services = setmetatable({}, {
    __index = function(_, k)
        k = (k == "InputService" and "UserInputService") or k
        return game:GetService(k)
    end
})

local client = services.Players.LocalPlayer
local guiRoot = services.CoreGui

local library = {
    theme = {
        Accent = settings.default_accent,
        WindowOutlineBackground = Color3.fromRGB(39,39,47),
        WindowInlineBackground = Color3.fromRGB(23,23,30),
        WindowHolderBackground = Color3.fromRGB(32,32,38),
        PageUnselected = Color3.fromRGB(32,32,38),
        PageSelected = Color3.fromRGB(55,55,64),
        SectionBackground = Color3.fromRGB(27,27,34),
        SectionInnerBorder = Color3.fromRGB(50,50,58),
        SectionOuterBorder = Color3.fromRGB(19,19,27),
        WindowBorder = Color3.fromRGB(58,58,67),
        Text = Color3.fromRGB(245, 245, 245),
        RiskyText = Color3.fromRGB(245, 239, 120),
        ObjectBackground = Color3.fromRGB(41,41,50)
    },
    flags = {},
    folder = settings.folder_name,
    themeTracking = {}
}

function library:applyTheme(instance, theme, property)
    if not self.themeTracking[theme] then
        self.themeTracking[theme] = {}
    end
    if not self.themeTracking[theme][property] then
        self.themeTracking[theme][property] = {}
    end
    table.insert(self.themeTracking[theme][property], instance)
end

function library:updateTheme(theme, color)
    local tracking = self.themeTracking[theme]
    if tracking then
        for property, objects in pairs(tracking) do
            for _, obj in pairs(objects) do
                if obj and obj[property] == self.theme[theme] then
                    obj[property] = color
                end
                if obj and obj:IsA("UIGradient") and property == "Color" then
                    obj.Color = color
                end
            end
        end
    end
    self.theme[theme] = color
end

function library:setupThemeTracking()
    for _, obj in pairs(screenGui:GetDescendants()) do
        if obj:IsA("Frame") then
            if obj.BackgroundColor3 == self.theme.WindowOutlineBackground then
                self:applyTheme(obj, "WindowOutlineBackground", "BackgroundColor3")
            elseif obj.BackgroundColor3 == self.theme.WindowInlineBackground then
                self:applyTheme(obj, "WindowInlineBackground", "BackgroundColor3")
            elseif obj.BackgroundColor3 == self.theme.WindowHolderBackground then
                self:applyTheme(obj, "WindowHolderBackground", "BackgroundColor3")
            elseif obj.BackgroundColor3 == self.theme.PageUnselected then
                self:applyTheme(obj, "PageUnselected", "BackgroundColor3")
            elseif obj.BackgroundColor3 == self.theme.PageSelected then
                self:applyTheme(obj, "PageSelected", "BackgroundColor3")
            elseif obj.BackgroundColor3 == self.theme.SectionBackground then
                self:applyTheme(obj, "SectionBackground", "BackgroundColor3")
            elseif obj.BackgroundColor3 == self.theme.ObjectBackground then
                self:applyTheme(obj, "ObjectBackground", "BackgroundColor3")
            elseif obj.BackgroundColor3 == self.theme.Accent then
                self:applyTheme(obj, "Accent", "BackgroundColor3")
            end
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if obj.TextColor3 == self.theme.Text then
                self:applyTheme(obj, "Text", "TextColor3")
            elseif obj.TextColor3 == self.theme.RiskyText then
                self:applyTheme(obj, "RiskyText", "TextColor3")
            end
        elseif obj:IsA("UIStroke") then
            if obj.Color == self.theme.WindowBorder then
                self:applyTheme(obj, "WindowBorder", "Color")
            elseif obj.Color == self.theme.SectionInnerBorder then
                self:applyTheme(obj, "SectionInnerBorder", "Color")
            elseif obj.Color == self.theme.SectionOuterBorder then
                self:applyTheme(obj, "SectionOuterBorder", "Color")
            end
        elseif obj:IsA("UIGradient") then
            self:applyTheme(obj, "Accent", "Color")
        end
    end
end

function library:create_watermark(cfg)
    local watermark_tbl = {}
    
    local screenGui = create("ScreenGui", {
        Name = "ZephyrusWatermark",
        Parent = guiRoot,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local watermarkFrame = create("Frame", {
        Parent = screenGui,
        BackgroundColor3 = library.theme.WindowOutlineBackground,
        BackgroundTransparency = 0.25,
        Size = UDim2.new(0, 280, 0, 36),
        Position = UDim2.new(0, 12, 1, -42),
        ZIndex = 1000,
        Visible = true
    })
    
    outline(watermarkFrame, Color3.fromRGB(0,0,0), 2)
    outline(watermarkFrame, library.theme.WindowBorder, 1)
    
    local accentBar = create("Frame", {
        Parent = watermarkFrame,
        BackgroundColor3 = library.theme.Accent,
        Size = UDim2.new(0, 3, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        ZIndex = 1001
    })
    
    local watermarkText = create("TextLabel", {
        Parent = watermarkFrame,
        Text = cfg.text or "constant.cc | 01:03AM | uid = 05 | 56 fps | 96 ms\n0x00000000",
        TextColor3 = library.theme.Text,
        TextSize = 11,
        FontFace = customFont,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 6),
        Size = UDim2.new(1, -15, 1, 0),
        TextXAlignment = 0,
        TextYAlignment = 0,
        ZIndex = 1002
    })
    
    function watermark_tbl:update(text)
        watermarkText.Text = text
    end
    
    function watermark_tbl:set_visible(state)
        watermarkFrame.Visible = state
    end
    
    return watermark_tbl
end

function library:create_ui_settings(section)
    local accentColor = section:new_toggle({
        name = "Accent Color",
        state = true,
        callback = function(s) end
    }):add_colorpicker({
        name = "Accent",
        default = self.theme.Accent,
        callback = function(c)
            self:updateTheme("Accent", c)
            for _, obj in pairs(screenGui:GetDescendants()) do
                if obj:IsA("UIGradient") and obj.Parent and obj.Parent:IsA("Frame") and obj.Parent.BackgroundColor3 == c then
                    obj.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
                    })
                end
            end
        end
    })
    
    local textColor = section:new_toggle({
        name = "Text Color",
        state = true,
        callback = function(s) end
    }):add_colorpicker({
        name = "Text",
        default = self.theme.Text,
        callback = function(c)
            self:updateTheme("Text", c)
        end
    })
    
    local backgroundColor = section:new_toggle({
        name = "Background Color",
        state = true,
        callback = function(s) end
    }):add_colorpicker({
        name = "Background",
        default = self.theme.WindowOutlineBackground,
        callback = function(c)
            self:updateTheme("WindowOutlineBackground", c)
            self:updateTheme("WindowInlineBackground", Color3.fromRGB(c.R * 0.6, c.G * 0.6, c.B * 0.6))
            self:updateTheme("WindowHolderBackground", Color3.fromRGB(c.R * 0.8, c.G * 0.8, c.B * 0.8))
            self:updateTheme("PageUnselected", Color3.fromRGB(c.R * 0.8, c.G * 0.8, c.B * 0.8))
            self:updateTheme("PageSelected", Color3.fromRGB(c.R, c.G, c.B))
            self:updateTheme("SectionBackground", Color3.fromRGB(c.R * 0.7, c.G * 0.7, c.B * 0.7))
            self:updateTheme("ObjectBackground", Color3.fromRGB(c.R, c.G, c.B))
        end
    })
    
    return {
        accentColor = accentColor,
        textColor = textColor,
        backgroundColor = backgroundColor
    }
end

local function create(class, properties)
    local obj = Instance.new(class)
    pcall(function() obj.BorderSizePixel = 0 end)
    for prop, value in pairs(properties) do
        if prop == "FontFace" then obj.FontFace = customFont
        else pcall(function() obj[prop] = value end) end
    end
    if (class == "TextLabel" or class == "TextButton") and not properties.FontFace then
        obj.FontFace = customFont
    end
    return obj
end

local function addGradient(obj)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
    })
    grad.Rotation = 90
    grad.Parent = obj
    return grad
end

local function outline(obj, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
    return stroke
end

local function textLength(str, fontSize)
    local textLabel = Instance.new("TextLabel")
    textLabel.FontFace = customFont
    textLabel.TextSize = fontSize
    textLabel.Text = str
    local bounds = textLabel.TextBounds
    textLabel:Destroy()
    return bounds
end

local totalUnnamedFlags = 0
local function nextFlag()
    totalUnnamedFlags = totalUnnamedFlags + 1
    return "flag_" .. tostring(totalUnnamedFlags)
end

function library:new_window(cfg)
    local window_tbl = {pages = {}, page_buttons = {}, page_accents = {}}
    local sizeX, sizeY = cfg.size.X or 500, cfg.size.Y or 400
    
    local screenGui = create("ScreenGui", {Name = "ZephyrusUI", Parent = guiRoot, ZIndexBehavior = 1})
    local windowOutline = create("Frame", {Parent = screenGui, BackgroundColor3 = library.theme.WindowOutlineBackground, Size = UDim2.new(0, sizeX, 0, sizeY), Position = UDim2.new(0.5, -sizeX/2, 0.5, -sizeY/2), ZIndex = 1})
    outline(windowOutline, Color3.fromRGB(0,0,0), 2)
    outline(windowOutline, library.theme.WindowBorder, 1)
    
    local windowInline = create("Frame", {Parent = windowOutline, BackgroundColor3 = library.theme.WindowInlineBackground, Size = UDim2.new(1, -10, 1, -10), Position = UDim2.new(0, 5, 0, 5), ZIndex = 2})
    local accentBar = create("Frame", {Parent = windowInline, BackgroundColor3 = library.theme.Accent, Size = UDim2.new(1, -2, 0, 2), Position = UDim2.new(0, 1, 0, 1), ZIndex = 3})
    addGradient(accentBar)
    
    local windowHolder = create("Frame", {Parent = windowInline, BackgroundColor3 = library.theme.WindowHolderBackground, Size = UDim2.new(1, -30, 1, -30), Position = UDim2.new(0, 15, 0, 15), ZIndex = 4})
    local pagesHolder = create("Frame", {Parent = windowHolder, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), ZIndex = 5})
    
    local dragFrame = create("TextButton", {Parent = windowOutline, Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), ZIndex = 100})
    local dragging, dragStart, objectPosition
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position objectPosition = windowOutline.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    services.InputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            windowOutline.Position = UDim2.new(objectPosition.X.Scale, objectPosition.X.Offset + delta.X, objectPosition.Y.Scale, objectPosition.Y.Offset + delta.Y)
        end
    end)

    function window_tbl:new_page(pcfg)
        local page_tbl = {}
        local pageButton = create("TextButton", {Parent = pagesHolder, BackgroundColor3 = library.theme.PageUnselected, Text = "", ZIndex = 6})
        addGradient(pageButton)
        local pageTitle = create("TextLabel", {Parent = pageButton, Text = pcfg.name, TextColor3 = library.theme.Text, TextSize = 13, BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 7})
        local pageAccent = create("Frame", {Parent = pageButton, BackgroundColor3 = library.theme.Accent, Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), Visible = false, ZIndex = 7})
        local page = create("Frame", {Parent = windowHolder, BackgroundTransparency = 1, Size = UDim2.new(1, -40, 1, -45), Position = UDim2.new(0, 20, 0, 40), Visible = false, ZIndex = 6, ClipsDescendants = false})
        
        local function createScrollList(pos)
            local s = create("ScrollingFrame", {
                Parent = page,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, -14, 1, -10),
                Position = pos,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 0,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                ClipsDescendants = true,
                ZIndex = 1
            })
            local layout = create("UIListLayout", {Parent = s, Padding = UDim.new(0, 20), SortOrder = Enum.SortOrder.LayoutOrder})
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                s.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
            end)
            return s
        end

        local leftList = createScrollList(UDim2.new(0, 0, 0, 0))
        local rightList = createScrollList(UDim2.new(0.5, 14, 0, 0))

        table.insert(window_tbl.page_buttons, pageButton)
        table.insert(window_tbl.page_accents, pageAccent)
        table.insert(window_tbl.pages, page)
        
        local function updateTabs()
            local w = 1 / #window_tbl.page_buttons
            for i, v in ipairs(window_tbl.page_buttons) do v.Size = UDim2.new(w, 0, 1, 0) v.Position = UDim2.new(w*(i-1),0,0,0) end
        end
        updateTabs()

        pageButton.MouseButton1Click:Connect(function()
            for i, v in ipairs(window_tbl.pages) do v.Visible = (v == page) end
            for i, v in ipairs(window_tbl.page_buttons) do v.BackgroundColor3 = (v == pageButton and library.theme.PageSelected or library.theme.PageUnselected) end
            for i, v in ipairs(window_tbl.page_accents) do v.Visible = (v == pageAccent) end
        end)

        function page_tbl:new_section(scfg)
    local section_tbl = {}
    local side = (scfg.side == "left") and leftList or rightList
    local section = create("Frame", {Parent = side, BackgroundColor3 = library.theme.SectionBackground, Size = UDim2.new(1, 0, 0, scfg.size or 100), ZIndex = 10, ClipsDescendants = false})
    outline(section, library.theme.SectionOuterBorder, 1)
    outline(section, library.theme.SectionInnerBorder, 1)
    
    local titleContainer = create("Frame", {Parent = section, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, -10), ZIndex = 11, ClipsDescendants = false})
    local titleCover = create("Frame", {Parent = titleContainer, BackgroundColor3 = library.theme.SectionBackground, Size = UDim2.new(0, textLength(scfg.name, 13).X + 12, 0, 4), Position = UDim2.new(0, 8, 0, 14), ZIndex = 11, BorderSizePixel = 0})
    local sectionTitle = create("TextLabel", {Parent = titleContainer, Text = scfg.name, TextColor3 = library.theme.Text, TextSize = 13, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 10), ZIndex = 12, AutomaticSize = Enum.AutomaticSize.XY})
    
    local content = create("Frame", {Parent = section, BackgroundTransparency = 1, Size = UDim2.new(1, -32, 1, -20), Position = UDim2.new(0, 16, 0, 12), ZIndex = 11, ClipsDescendants = false})
    local layout = create("UIListLayout", {Parent = content, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder})

    if scfg.auto_size then
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            section.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 30)
        end)
    end
            function section_tbl:new_toggle(tcfg)
                local t_state = tcfg.state or false
                local flag = tcfg.flag or nextFlag()
                local cp_count = 0 
                
                local holder = create("TextButton", {
                    Parent = content, 
                    BackgroundTransparency = 1, 
                    Text = "", 
                    Size = UDim2.new(1, 0, 0, 16), 
                    ZIndex = 15
                })
                
                local box = create("Frame", {
                    Parent = holder, 
                    BackgroundColor3 = library.theme.ObjectBackground, 
                    Size = UDim2.new(0, 12, 0, 12), 
                    Position = UDim2.new(0, 0, 0.5, -6), 
                    ZIndex = 16
                })
                outline(box, library.theme.SectionInnerBorder, 1)
                addGradient(box)
                
                create("TextLabel", {
                    Parent = holder, 
                    Text = tcfg.name, 
                    TextColor3 = tcfg.risky and library.theme.RiskyText or library.theme.Text, 
                    TextSize = 13, 
                    BackgroundTransparency = 1, 
                    Position = UDim2.new(0, 18, 0.5, 0), 
                    AnchorPoint = Vector2.new(0, 0.5), 
                    TextXAlignment = 0, 
                    ZIndex = 16
                })

                local function update() 
                    box.BackgroundColor3 = t_state and library.theme.Accent or library.theme.ObjectBackground
                    library.flags[flag] = t_state
                    if tcfg.callback then tcfg.callback(t_state) end
                end
                
                holder.MouseButton1Click:Connect(function() t_state = not t_state update() end)
                update()

                local toggle_methods = {}

                function toggle_methods:add_colorpicker(cpcfg)
                    cp_count = cp_count + 1
                    local cp_flag = cpcfg.flag or nextFlag()
                    local cp_current = cpcfg.default or Color3.fromRGB(255, 255, 255)
                    local h, s, v = cp_current:ToHSV()
                    local opened = false

                    
                    local cp_preview = create("TextButton", {
                        Parent = holder,
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        Size = UDim2.new(0, 20, 0, 10),
                        
                        Position = UDim2.new(1, -(cp_count * 25), 0.5, -5),
                        Text = "",
                        ZIndex = 17
                    })
                    outline(cp_preview, Color3.new(0, 0, 0), 1)
                    
                   
                    local icon_gradient = Instance.new("UIGradient")
                    icon_gradient.Rotation = 90
                    icon_gradient.Parent = cp_preview

                    local picker_gui = create("Frame", {
                        Parent = screenGui,
                        BackgroundColor3 = library.theme.SectionBackground,
                        Size = UDim2.new(0, 150, 0, 170),
                        Visible = false,
                        ZIndex = 2000
                    })
                    outline(picker_gui, library.theme.WindowBorder, 1)
                    outline(picker_gui, Color3.new(0,0,0), 2)

                    
                    local sat_val_bg = create("Frame", {
                        Parent = picker_gui, Size = UDim2.new(0, 130, 0, 130),
                        Position = UDim2.new(0, 10, 0, 10), BackgroundColor3 = Color3.fromHSV(h, 1, 1), ZIndex = 2001
                    })
                    local w_grad = create("Frame", {Parent = sat_val_bg, Size = UDim2.new(1,0,1,0), ZIndex = 2002})
                    local g1 = Instance.new("UIGradient", w_grad)
                    g1.Color = ColorSequence.new(Color3.new(1,1,1))
                    g1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})
                    local b_grad = create("Frame", {Parent = sat_val_bg, Size = UDim2.new(1,0,1,0), ZIndex = 2003})
                    local g2 = Instance.new("UIGradient", b_grad)
                    g2.Color = ColorSequence.new(Color3.new(0,0,0))
                    g2.Rotation = 90
                    g2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)})
                    local cursor = create("Frame", {
                        Parent = sat_val_bg, Size = UDim2.new(0, 4, 0, 4), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 2005
                    })
                    outline(cursor, Color3.new(0,0,0), 1)

                    local hue_bar = create("Frame", {
                        Parent = picker_gui, Size = UDim2.new(0, 130, 0, 12), Position = UDim2.new(0, 10, 1, -22), ZIndex = 2001
                    })
                    local h_grad = Instance.new("UIGradient", hue_bar)
                    h_grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)), ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17,1,1)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33,1,1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67,1,1)), ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83,1,1)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
                    })

                    local function updateCP()
                        local color = Color3.fromHSV(h, s, v)
                      
                        icon_gradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, color),
                            ColorSequenceKeypoint.new(1, Color3.new(color.R * 0.7, color.G * 0.7, color.B * 0.7))
                        })
                        sat_val_bg.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        cursor.Position = UDim2.new(s, -2, 1-v, -2)
                        library.flags[cp_flag] = color
                        if cpcfg.callback then cpcfg.callback(color) end
                    end

                    
                    local function handleInput(input, frame, is_hue)
                        local pos = input.Position
                        local size = frame.AbsoluteSize
                        local fPos = frame.AbsolutePosition
                        local relX = math.clamp((pos.X - fPos.X) / size.X, 0, 1)
                        local relY = math.clamp((pos.Y - fPos.Y) / size.Y, 0, 1)
                        if is_hue then h = relX else s = relX v = 1 - relY end
                        updateCP()
                    end

                    local dragging_sv, dragging_h = false, false
                    sat_val_bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging_sv = true handleInput(i, sat_val_bg, false) end end)
                    hue_bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging_h = true handleInput(i, hue_bar, true) end end)
                    services.InputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then if dragging_sv then handleInput(i, sat_val_bg, false) elseif dragging_h then handleInput(i, hue_bar, true) end end end)
                    services.InputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging_sv, dragging_h = false, false end end)

                    cp_preview.MouseButton1Click:Connect(function()
                        opened = not opened
                        if opened then
                            picker_gui.Position = UDim2.new(0, cp_preview.AbsolutePosition.X - 155, 0, cp_preview.AbsolutePosition.Y)
                            picker_gui.Visible = true
                        else picker_gui.Visible = false end
                    end)

                    updateCP()
                  
                    return toggle_methods 
                end

                return toggle_methods
            end

            function section_tbl:new_slider(slcfg)
                local flag, min, max, float = slcfg.flag or nextFlag(), slcfg.min or 0, slcfg.max or 100, slcfg.float or 1
                local current = slcfg.default or min
                local precision = 0
                if tostring(float):find("%.") then precision = #tostring(float):split(".")[2] end

                local holder = create("Frame", {Parent = content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28), ZIndex = 15})
                create("TextLabel", {Parent = holder, Text = slcfg.name, TextColor3 = library.theme.Text, TextSize = 13, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 13), TextXAlignment = 0})
                local back = create("Frame", {Parent = holder, BackgroundColor3 = library.theme.ObjectBackground, Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0, 18), ZIndex = 14})
                outline(back, library.theme.SectionInnerBorder, 1)
                local fill = create("Frame", {Parent = back, BackgroundColor3 = library.theme.Accent, Size = UDim2.new(0, 0, 1, 0), ZIndex = 15})
                addGradient(fill)
                local valText = create("TextLabel", {Parent = back, Text = "", TextColor3 = library.theme.Text, TextSize = 12, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0), ZIndex = 16})
                
                local function set(val)
                    val = math.clamp(val, min, max)
                    val = math.floor(val / float + 0.5) * float
                    local formattedVal = tonumber(string.format("%." .. precision .. "f", val))
                    current = formattedVal
                    library.flags[flag] = formattedVal
                    local p = (formattedVal - min) / (max - min)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    valText.Position = UDim2.new(p, 0, 1, 2)
                    valText.Text = tostring(formattedVal)
                    if slcfg.callback then slcfg.callback(formattedVal) end
                end

                local function update(input)
                    local pos = input.Position
                    local perc = math.clamp((pos.X - back.AbsolutePosition.X) / back.AbsoluteSize.X, 0, 1)
                    set(min + (max - min) * perc)
                end
                local active = false
                back.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then active = true update(i) end end)
                services.InputService.InputChanged:Connect(function(i) if active and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i) end end)
                services.InputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then active = false end end)
                set(current)
            end
            function section_tbl:new_dropdown(dcfg)
                local flag = dcfg.flag or nextFlag()
                local options = dcfg.options or {}
                local current = dcfg.default or (dcfg.multiselect and {} or options[1])
                local opened = false
                
                local holder = create("Frame", {Parent = content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), ZIndex = 20})
                create("TextLabel", {Parent = holder, Text = dcfg.name, TextColor3 = library.theme.Text, TextSize = 13, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 13), TextXAlignment = 0})
                
                local background = create("TextButton", {Parent = holder, Name = "background", BackgroundColor3 = library.theme.ObjectBackground, Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 16), Text = "", ZIndex = 21})
                outline(background, library.theme.SectionInnerBorder, 1)
                
                local valText = create("TextLabel", {
                    Parent = background, 
                    Text = "", 
                    TextColor3 = library.theme.Text, 
                    TextSize = 12, 
                    BackgroundTransparency = 1, 
                    Position = UDim2.new(0, 5, 0, 0), 
                    Size = UDim2.new(1, -20, 1, 0), 
                    TextXAlignment = 0, 
                    ZIndex = 22,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                
                local arrow = create("ImageLabel", {
                    Parent = background,
                    Name = "arrow",
                    Image = "rbxassetid://116204929609664",
                    Position = UDim2.new(1, -13, 0, 7),
                    Size = UDim2.new(0, 5, 0, 3),
                    BackgroundTransparency = 1,
                    ImageColor3 = library.theme.Text,
                    ZIndex = 22
                })

                local optionHolder = create("Frame", {Parent = background, BackgroundColor3 = library.theme.ObjectBackground, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 1), Visible = false, ZIndex = 25, ClipsDescendants = true})
                outline(optionHolder, library.theme.SectionInnerBorder, 1)
                local optionLayout = create("UIListLayout", {Parent = optionHolder, SortOrder = Enum.SortOrder.LayoutOrder})

                local function updateVal()
                    if dcfg.multiselect then
                        local str = ""
                        for i, v in pairs(current) do str = str .. tostring(v) .. ", " end
                        valText.Text = #str > 0 and str:sub(1, #str - 2) or "None"
                        library.flags[flag] = current
                    else
                        valText.Text = tostring(current)
                        library.flags[flag] = current
                    end
                    if dcfg.callback then dcfg.callback(library.flags[flag]) end
                end

                local function toggle(state)
                    opened = state
                    arrow.Rotation = opened and 180 or 0
                    optionHolder.Visible = opened
                    optionHolder.Size = opened and UDim2.new(1, 0, 0, optionLayout.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 0)
                    
                    if scfg.auto_size then
                        holder.Size = opened and UDim2.new(1, 0, 0, 32 + optionLayout.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 32)
                    end
                end

                local function build()
                    for _, v in pairs(optionHolder:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _, opt in pairs(options) do
                        local optBtn = create("TextButton", {Parent = optionHolder, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Text = "", ZIndex = 26})
                        local optText = create("TextLabel", {
                            Parent = optBtn, 
                            Text = tostring(opt), 
                            TextColor3 = (dcfg.multiselect and table.find(current, opt) or current == opt) and library.theme.Accent or library.theme.Text, 
                            TextSize = 12, 
                            BackgroundTransparency = 1, 
                            Position = UDim2.new(0, 5, 0, 0), 
                            Size = UDim2.new(1, -5, 1, 0), 
                            TextXAlignment = 0, 
                            ZIndex = 27,
                            TextTruncate = Enum.TextTruncate.AtEnd
                        })
                        
                        optBtn.MouseButton1Click:Connect(function()
                            if dcfg.multiselect then
                                if table.find(current, opt) then
                                    table.remove(current, table.find(current, opt))
                                    optText.TextColor3 = library.theme.Text
                                else
                                    table.insert(current, opt)
                                    optText.TextColor3 = library.theme.Accent
                                end
                            else
                                current = opt
                                for _, v in pairs(optionHolder:GetChildren()) do
                                    if v:IsA("TextButton") then v.TextLabel.TextColor3 = library.theme.Text end
                                end
                                optText.TextColor3 = library.theme.Accent
                                toggle(false)
                            end
                            updateVal()
                        end)
                    end
                end

                background.MouseButton1Click:Connect(function()
                    toggle(not opened)
                end)

                build()
                updateVal()
                
                return {
                    set = function(val) 
                        current = val 
                        updateVal() 
                        build()
                    end,
                    refresh = function(new_options)
                        options = new_options or {}
                        build()
                        if opened then toggle(true) end
                    end
                }
            end
            function section_tbl:new_listbox(lcfg)
                local flag = lcfg.flag or nextFlag()
                local options = lcfg.options or {}
                local current = lcfg.default or ""
                local list_height = lcfg.height or 100

                local holder = create("Frame", {
                    Parent = content, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, list_height + 20), 
                    ZIndex = 15
                })
                
                create("TextLabel", {
                    Parent = holder, 
                    Text = lcfg.name, 
                    TextColor3 = library.theme.Text, 
                    TextSize = 13, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, 13), 
                    TextXAlignment = 0
                })

                local background = create("ScrollingFrame", {
                    Parent = holder,
                    BackgroundColor3 = library.theme.ObjectBackground,
                    Size = UDim2.new(1, 0, 0, list_height),
                    Position = UDim2.new(0, 0, 0, 18),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = library.theme.Accent,
                    BorderSizePixel = 0,
                    ZIndex = 16
                })
                outline(background, library.theme.SectionInnerBorder, 1)
                
                local listLayout = create("UIListLayout", {
                    Parent = background, 
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 0)
                })

                local function updateVal(val)
                    current = val
                    library.flags[flag] = val
                    if lcfg.callback then lcfg.callback(val) end
                end

                local function build()
                    for _, v in pairs(background:GetChildren()) do 
                        if v:IsA("TextButton") then v:Destroy() end 
                    end
                    
                    for _, opt in pairs(options) do
                        local btn = create("TextButton", {
                            Parent = background,
                            Size = UDim2.new(1, 0, 0, 18),
                            BackgroundColor3 = library.theme.PageSelected,
                            BackgroundTransparency = (current == opt) and 0.8 or 1,
                            Text = "",
                            ZIndex = 17
                        })
                        
                        local txt = create("TextLabel", {
                            Parent = btn,
                            Text = tostring(opt),
                            TextColor3 = (current == opt) and library.theme.Accent or library.theme.Text,
                            TextSize = 12,
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 5, 0, 0),
                            Size = UDim2.new(1, -5, 1, 0),
                            TextXAlignment = 0,
                            ZIndex = 18
                        })

                        btn.MouseButton1Click:Connect(function()
                            for _, child in pairs(background:GetChildren()) do
                                if child:IsA("TextButton") then
                                    child.BackgroundTransparency = 1
                                    child.TextLabel.TextColor3 = library.theme.Text
                                end
                            end
                            btn.BackgroundTransparency = 0.8
                            txt.TextColor3 = library.theme.Accent
                            updateVal(opt)
                        end)
                    end
                    background.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
                end

                build()
                if current ~= "" then updateVal(current) end

                local list_methods = {}
                
                
                function list_methods:refresh(new_options)
                    options = new_options or {}
                    build()
                end

                
                function list_methods:add(val)
                    if not table.find(options, val) then
                        table.insert(options, val)
                        build()
                    end
                end

                
                function list_methods:remove(val)
                    local idx = table.find(options, val)
                    if idx then
                        table.remove(options, idx)
                        if current == val then current = "" end 
                        build()
                    end
                end

            
                function list_methods:set(val)
                    current = val
                    build()
                    updateVal(val)
                end

                return list_methods
            end
            function section_tbl:new_textbox(tbcfg)
                local flag = tbcfg.flag or nextFlag()
                local current = tbcfg.default or ""
                
                local holder = create("Frame", {
                    Parent = content, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, 32), 
                    ZIndex = 15
                })
                
                create("TextLabel", {
                    Parent = holder, 
                    Text = tbcfg.name, 
                    TextColor3 = library.theme.Text, 
                    TextSize = 13, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, 13), 
                    TextXAlignment = 0
                })

                local background = create("Frame", {
                    Parent = holder,
                    BackgroundColor3 = library.theme.ObjectBackground,
                    Size = UDim2.new(1, 0, 0, 16),
                    Position = UDim2.new(0, 0, 0, 16),
                    ZIndex = 16
                })
                outline(background, library.theme.SectionInnerBorder, 1)

                local box = create("TextBox", {
                    Parent = background,
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    FontFace = customFont,
                    Text = current,
                    PlaceholderText = tbcfg.placeholder or "Type here...",
                    PlaceholderColor3 = Color3.fromRGB(100, 100, 110),
                    TextColor3 = library.theme.Text,
                    TextSize = 12,
                    TextXAlignment = 0,
                    ClearTextOnFocus = tbcfg.clear or false,
                    ZIndex = 17
                })

                local function update(val)
                    library.flags[flag] = val
                    if tbcfg.callback then tbcfg.callback(val) end
                end

                box.FocusLost:Connect(function(enterPressed)
                    update(box.Text)
                end)

                
                library.flags[flag] = current

                return {
                    set = function(val)
                        box.Text = val
                        update(val)
                    end,
                    get = function()
                        return box.Text
                    end
                }
            end
            function section_tbl:new_keybind(kbcfg)
                local flag = kbcfg.flag or nextFlag()
                local current_key = kbcfg.default or Enum.KeyCode.End
                local binding = false
                
                local holder = create("Frame", {
                    Parent = content, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, 16), 
                    ZIndex = 15
                })
                
                create("TextLabel", {
                    Parent = holder, 
                    Text = kbcfg.name, 
                    TextColor3 = library.theme.Text, 
                    TextSize = 13, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 1, 0), 
                    TextXAlignment = 0
                })

                local kb_btn = create("TextButton", {
                    Parent = holder,
                    BackgroundColor3 = library.theme.ObjectBackground,
                    Size = UDim2.new(0, 45, 0, 12),
                    Position = UDim2.new(1, -45, 0.5, -6),
                    Text = current_key.Name,
                    TextColor3 = library.theme.Text,
                    TextSize = 10,
                    ZIndex = 16
                })
                outline(kb_btn, library.theme.SectionInnerBorder, 1)

                local function update(key)
                    current_key = key
                    kb_btn.Text = key.Name
                    library.flags[flag] = key
                    if kbcfg.callback then kbcfg.callback(key) end
                end

                kb_btn.MouseButton1Click:Connect(function()
                    kb_btn.Text = "..."
                    binding = true
                end)

                services.InputService.InputBegan:Connect(function(input)
                    if binding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode ~= Enum.KeyCode.Escape then
                                update(input.KeyCode)
                            else
                                update(Enum.KeyCode.End) 
                            end
                            binding = false
                        end
                    end
                end)

                library.flags[flag] = current_key
                return {
                    set = function(key) update(key) end
                }
            end
            function section_tbl:new_label(lcfg)
                local cp_count = 0
                local holder = create("Frame", {
                    Parent = content, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 0, 16), 
                    ZIndex = 15
                })
                
                local label_obj = create("TextLabel", {
                    Parent = holder, 
                    Text = lcfg.name, 
                    TextColor3 = lcfg.color or library.theme.Text, 
                    TextSize = 13, 
                    BackgroundTransparency = 1, 
                    Size = UDim2.new(1, 0, 1, 0), 
                    TextXAlignment = 0,
                    ZIndex = 16
                })

                local label_methods = {}

                function label_methods:add_colorpicker(cpcfg)
                    cp_count = cp_count + 1
                    local cp_flag = cpcfg.flag or nextFlag()
                    local cp_current = cpcfg.default or Color3.fromRGB(255, 255, 255)
                    local h, s, v = cp_current:ToHSV()
                    local opened = false

                    
                    local cp_preview = create("TextButton", {
                        Parent = holder,
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        Size = UDim2.new(0, 20, 0, 10),
                        Position = UDim2.new(1, -(cp_count * 25), 0.5, -5),
                        Text = "",
                        ZIndex = 17
                    })
                    outline(cp_preview, Color3.new(0, 0, 0), 1)
                    
                    local icon_gradient = Instance.new("UIGradient")
                    icon_gradient.Rotation = 90
                    icon_gradient.Parent = cp_preview

                  
                    local picker_gui = create("Frame", {
                        Parent = screenGui,
                        BackgroundColor3 = library.theme.SectionBackground,
                        Size = UDim2.new(0, 150, 0, 170),
                        Visible = false,
                        ZIndex = 2500
                    })
                    outline(picker_gui, library.theme.WindowBorder, 1)
                    outline(picker_gui, Color3.new(0, 0, 0), 2)

                    
                    local sat_val_bg = create("Frame", {
                        Parent = picker_gui,
                        Size = UDim2.new(0, 130, 0, 130),
                        Position = UDim2.new(0, 10, 0, 10),
                        BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                        ZIndex = 2501
                    })
                    
                    local w_grad = create("Frame", {Parent = sat_val_bg, Size = UDim2.new(1, 0, 1, 0), ZIndex = 2502})
                    local g1 = Instance.new("UIGradient", w_grad)
                    g1.Color = ColorSequence.new(Color3.new(1, 1, 1))
                    g1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
                    
                    local b_grad = create("Frame", {Parent = sat_val_bg, Size = UDim2.new(1, 0, 1, 0), ZIndex = 2503})
                    local g2 = Instance.new("UIGradient", b_grad)
                    g2.Color = ColorSequence.new(Color3.new(0, 0, 0))
                    g2.Rotation = 90
                    g2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})

                    local cursor = create("Frame", {
                        Parent = sat_val_bg,
                        Size = UDim2.new(0, 4, 0, 4),
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        ZIndex = 2505
                    })
                    outline(cursor, Color3.new(0, 0, 0), 1)

                    
                    local hue_bar = create("Frame", {
                        Parent = picker_gui,
                        Size = UDim2.new(0, 130, 0, 12),
                        Position = UDim2.new(0, 10, 1, -22),
                        ZIndex = 2501
                    })
                    local h_grad = Instance.new("UIGradient", hue_bar)
                    h_grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
                    })

                    local function updateCP()
                        local color = Color3.fromHSV(h, s, v)
                        
                        icon_gradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, color),
                            ColorSequenceKeypoint.new(1, Color3.new(color.R * 0.65, color.G * 0.65, color.B * 0.65))
                        })
                        sat_val_bg.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        cursor.Position = UDim2.new(s, -2, 1 - v, -2)
                        library.flags[cp_flag] = color
                        if cpcfg.callback then cpcfg.callback(color) end
                    end

                    local function handleInput(input, frame, is_hue)
                        local pos = input.Position
                        local size = frame.AbsoluteSize
                        local fPos = frame.AbsolutePosition
                        local relX = math.clamp((pos.X - fPos.X) / size.X, 0, 1)
                        local relY = math.clamp((pos.Y - fPos.Y) / size.Y, 0, 1)
                        if is_hue then h = relX else s = relX v = 1 - relY end
                        updateCP()
                    end

                    local dragging_sv, dragging_h = false, false
                    sat_val_bg.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                            dragging_sv = true handleInput(i, sat_val_bg, false)
                        end
                    end)
                    hue_bar.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                            dragging_h = true handleInput(i, hue_bar, true)
                        end
                    end)
                    services.InputService.InputChanged:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                            if dragging_sv then handleInput(i, sat_val_bg, false)
                            elseif dragging_h then handleInput(i, hue_bar, true) end
                        end
                    end)
                    services.InputService.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                            dragging_sv, dragging_h = false, false
                        end
                    end)

                    cp_preview.MouseButton1Click:Connect(function()
                        opened = not opened
                        if opened then
                            picker_gui.Position = UDim2.new(0, cp_preview.AbsolutePosition.X - 155, 0, cp_preview.AbsolutePosition.Y)
                            picker_gui.Visible = true
                        else
                            picker_gui.Visible = false
                        end
                    end)

                    updateCP()
                    return label_methods
                end

                return label_methods
            end
            
            function section_tbl:add_button(bcfg)
                local name = bcfg.name or "Button"
                local callback = bcfg.callback or function() end

                local button_holder = create("TextButton", {
                    Parent = content,
                    BackgroundColor3 = library.theme.ObjectBackground,
                    Size = UDim2.new(1, 0, 0, 20),
                    Text = "",
                    ZIndex = 15
                })
                outline(button_holder, library.theme.SectionInnerBorder, 1)
                addGradient(button_holder)

                local button_text = create("TextLabel", {
                    Parent = button_holder,
                    Text = name,
                    TextColor3 = library.theme.Text,
                    TextSize = 13,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 16
                })

                button_holder.MouseButton1Down:Connect(function()
                    button_text.TextColor3 = library.theme.Accent
                end)

                button_holder.MouseButton1Up:Connect(function()
                    button_text.TextColor3 = library.theme.Text
                end)

                button_holder.MouseButton1Click:Connect(function()
                    callback()
                end)

                return {
                    set = function(new_name) button_text.Text = new_name end
                }
            end

            return section_tbl
        end

        return page_tbl
    end

    return window_tbl
end

return library
