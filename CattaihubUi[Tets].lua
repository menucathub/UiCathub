
--[[ Cat Hub Library V2 ]]--

local CatHub = {}
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Constants
local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quint)
local CORNER_RADIUS = UDim.new(0, 8)

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function AddCorner(parent)
    local corner = Create("UICorner", {
        CornerRadius = CORNER_RADIUS,
        Parent = parent
    })
    return corner
end

local function AddStroke(parent, color)
    local stroke = Create("UIStroke", {
        Color = color or Color3.fromRGB(60, 60, 60),
        Thickness = 1,
        Parent = parent
    })
    return stroke
end

-- Main Window Creator
function CatHub.new(config)
    local window = {}
    
    -- Default Config
    config = config or {}
    config.Title = config.Title or "Cat Hub"
    config.Theme = config.Theme or "Dark"
    config.Size = config.Size or UDim2.new(0, 600, 0, 400)
    
    -- Theme Colors
    local theme = {
        Dark = {
            Background = Color3.fromRGB(25, 25, 25),
            Secondary = Color3.fromRGB(35, 35, 35),
            Accent = Color3.fromRGB(0, 162, 255),
            Text = Color3.fromRGB(255, 255, 255),
            DarkText = Color3.fromRGB(175, 175, 175)
        }
    }
    
    local colors = theme[config.Theme]
    
    -- Create Main GUI
    local ScreenGui = Create("ScreenGui", {
        Name = "CatHubV2",
        Parent = CoreGui
    })
    
    local Main = Create("Frame", {
        Name = "Main",
        Size = config.Size,
        Position = UDim2.new(0.5, -config.Size.X.Offset/2, 0.5, -config.Size.Y.Offset/2),
        BackgroundColor3 = colors.Background,
        Parent = ScreenGui
    })
    AddCorner(Main)
    
    -- Title Bar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = colors.Secondary,
        Parent = Main
    })
    AddCorner(TitleBar)
    
    local Title = Create("TextLabel", {
        Name = "Title",
        Text = config.Title,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = colors.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })
    
    -- Tab Container
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 140, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = colors.Secondary,
        Parent = Main
    })
    
    local TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        Parent = TabContainer
    })
    
    local TabListLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = TabList
    })
    
    -- Content Area
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -150, 1, -50),
        Position = UDim2.new(0, 145, 0, 45),
        BackgroundColor3 = colors.Secondary,
        Parent = Main
    })
    AddCorner(ContentContainer)
    
    -- Tab System
    local tabs = {}
    local selectedTab = nil
    
    -- Window Methods
    function window:AddTab(name, icon)
        local tab = {}
        
        -- Create Tab Button
        local TabButton = Create("TextButton", {
            Name = name,
            Size = UDim2.new(1, -10, 0, 35),
            Position = UDim2.new(0, 5, 0, #tabs * 40),
            BackgroundColor3 = colors.Secondary,
            Text = name,
            TextColor3 = colors.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = TabList
        })
        AddCorner(TabButton)
        
        -- Create Tab Content
        local TabContent = Create("ScrollingFrame", {
            Name = name.."Content",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            Visible = false,
            Parent = ContentContainer
        })
        
        local ContentLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            Parent = TabContent
        })
        
        -- Tab Selection Logic
        TabButton.MouseButton1Click:Connect(function()
            if selectedTab then
                selectedTab.Content.Visible = false
                TweenService:Create(selectedTab.Button, TWEEN_INFO, {
                    BackgroundColor3 = colors.Secondary
                }):Play()
            end
            
            selectedTab = {
                Button = TabButton,
                Content = TabContent
            }
            
            TabContent.Visible = true
            TweenService:Create(TabButton, TWEEN_INFO, {
                BackgroundColor3 = colors.Accent
            }):Play()
        end)
        
        -- Tab Component Methods
        function tab:AddButton(text, callback)
            local Button = Create("TextButton", {
                Name = "Button",
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = colors.Secondary,
                Text = text,
                TextColor3 = colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                Parent = TabContent
            })
            AddCorner(Button)
            
            Button.MouseButton1Click:Connect(callback)
            return Button
        end
        
        function tab:AddToggle(text, default, callback)
            local toggle = {Value = default or false}
            
            local Toggle = Create("Frame", {
                Name = "Toggle",
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = colors.Secondary,
                Parent = TabContent
            })
            AddCorner(Toggle)
            
            local Title = Create("TextLabel", {
                Text = text,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Toggle
            })
            
            local ToggleButton = Create("Frame", {
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = toggle.Value and colors.Accent or colors.Background,
                Parent = Toggle
            })
            AddCorner(ToggleButton)
            
            local ToggleCircle = Create("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(toggle.Value and 1 or 0, toggle.Value and -18 or 2, 0.5, -8),
                BackgroundColor3 = colors.Text,
                Parent = ToggleButton
            })
            AddCorner(ToggleCircle)
            
            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggle.Value = not toggle.Value
                    
                    TweenService:Create(ToggleButton, TWEEN_INFO, {
                        BackgroundColor3 = toggle.Value and colors.Accent or colors.Background
                    }):Play()
                    
                    TweenService:Create(ToggleCircle, TWEEN_INFO, {
                        Position = UDim2.new(toggle.Value and 1 or 0, toggle.Value and -18 or 2, 0.5, -8)
                    }):Play()
                    
                    if callback then
                        callback(toggle.Value)
                    end
                end
            end)
            
            return toggle
        end
        
        function tab:AddSlider(text, config)
            config = config or {}
            config.min = config.min or 0
            config.max = config.max or 100
            config.default = config.default or config.min
            
            local slider = {Value = config.default}
            
            local Slider = Create("Frame", {
                Name = "Slider",
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = colors.Secondary,
                Parent = TabContent
            })
            AddCorner(Slider)
            
            local Title = Create("TextLabel", {
                Text = text,
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Slider
            })
            
            local SliderBar = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 4),
                Position = UDim2.new(0, 10, 0.5, 10),
                BackgroundColor3 = colors.Background,
                Parent = Slider
            })
            AddCorner(SliderBar)
            
            local SliderFill = Create("Frame", {
                Size = UDim2.new((slider.Value - config.min)/(config.max - config.min), 0, 1, 0),
                BackgroundColor3 = colors.Accent,
                Parent = SliderBar
            })
            AddCorner(SliderFill)
            
            local ValueLabel = Create("TextLabel", {
                Text = tostring(slider.Value),
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -60, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = colors.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                Parent = Slider
            })
            
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                slider.Value = math.floor(pos * (config.max - config.min) + config.min)
                
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                ValueLabel.Text = tostring(slider.Value)
                
                if config.callback then
                    config.callback(slider.Value)
                end
            end
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            return slider
        end
        
        function tab:AddDropdown(text, options, callback)
            local dropdown = {Value = options[1]}
            
            local Dropdown = Create("Frame", {
                Name = "Dropdown",
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = colors.Secondary,
                Parent = TabContent
            })
            AddCorner(Dropdown)
            
            local Title = Create("TextLabel", {
                Text = text,
                Size = UDim2.new(1, -160, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Dropdown
            })
            
            local DropButton = Create("TextButton", {
                Size = UDim2.new(0, 140, 0, 25),
                Position = UDim2.new(1, -150, 0.5, -12),
                BackgroundColor3 = colors.Background,
                Text = dropdown.Value,
                TextColor3 = colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                Parent = Dropdown
            })
            AddCorner(DropButton)
            
            local OptionList = Create("Frame", {
                Size = UDim2.new(0, 140, 0, #options * 25),
                Position = UDim2.new(1, -150, 1, 5),
                BackgroundColor3 = colors.Background,
                Visible = false,
                ZIndex = 2,
                Parent = Dropdown
            })
            AddCorner(OptionList)
            
            for i, option in ipairs(options) do
                local Option = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 0, 0, (i-1) * 25),
                    BackgroundTransparency = 1,
                    Text = option,
                    TextColor3 = colors.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    Parent = OptionList
                })
                
                Option.MouseButton1Click:Connect(function()
                    
                    dropdown.Value = option
                    DropButton.Text = option
                    OptionList.Visible = false
                    
                    if callback then
                        callback(option)
                    end
                end)
            end
            
            DropButton.MouseButton1Click:Connect(function()
                OptionList.Visible = not OptionList.Visible
            end)
            
            return dropdown
        end
        
        function tab:AddColorPicker(text, default, callback)
            local colorpicker = {Value = default or Color3.fromRGB(255, 255, 255)}
            
            local ColorPicker = Create("Frame", {
                Name = "ColorPicker",
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = colors.Secondary,
                Parent = TabContent
            })
            AddCorner(ColorPicker)
            
            local Title = Create("TextLabel", {
                Text = text,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ColorPicker
            })
            
            local ColorDisplay = Create("TextButton", {
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -40, 0.5, -15),
                BackgroundColor3 = colorpicker.Value,
                Parent = ColorPicker
            })
            AddCorner(ColorDisplay)
            
            local ColorWheel = Create("ImageButton", {
                Size = UDim2.new(0, 200, 0, 200),
                Position = UDim2.new(1, 10, 0, 0),
                Image = "rbxassetid://4155801252",
                Visible = false,
                ZIndex = 2,
                Parent = ColorPicker
            })
            
            ColorDisplay.MouseButton1Click:Connect(function()
                ColorWheel.Visible = not ColorWheel.Visible
            end)
            
            ColorWheel.MouseButton1Down:Connect(function(input)
                local relativeX = (input.Position.X - ColorWheel.AbsolutePosition.X) / ColorWheel.AbsoluteSize.X
                local relativeY = (input.Position.Y - ColorWheel.AbsolutePosition.Y) / ColorWheel.AbsoluteSize.Y
                
                colorpicker.Value = Color3.fromHSV(relativeX, relativeY, 1)
                ColorDisplay.BackgroundColor3 = colorpicker.Value
                
                if callback then
                    callback(colorpicker.Value)
                end
            end)
            
            return colorpicker
        end
        
        function tab:AddTextbox(text, placeholder, callback)
            local Textbox = Create("Frame", {
                Name = "Textbox",
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = colors.Secondary,
                Parent = TabContent
            })
            AddCorner(Textbox)
            
            local Title = Create("TextLabel", {
                Text = text,
                Size = UDim2.new(1, -160, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Textbox
            })
            
            local Input = Create("TextBox", {
                Size = UDim2.new(0, 140, 0, 25),
                Position = UDim2.new(1, -150, 0.5, -12),
                BackgroundColor3 = colors.Background,
                PlaceholderText = placeholder,
                Text = "",
                TextColor3 = colors.Text,
                PlaceholderColor3 = colors.DarkText,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                Parent = Textbox
            })
            AddCorner(Input)
            
            Input.FocusLost:Connect(function(enterPressed)
                if enterPressed and callback then
                    callback(Input.Text)
                end
            end)
        end
        
        function tab:AddLabel(text)
            local Label = Create("TextLabel", {
                Text = text,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                TextColor3 = colors.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                Parent = TabContent
            })
            return Label
        end
        
        -- Select first tab by default
        if #tabs == 0 then
            TabButton.BackgroundColor3 = colors.Accent
            TabContent.Visible = true
            selectedTab = {
                Button = TabButton,
                Content = TabContent
            }
        end
        
        table.insert(tabs, tab)
        return tab
    end
    
    -- Make window draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Return window
    return window
end

return CatHub
