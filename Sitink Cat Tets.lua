local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

local sitinklib = {}

function sitinklib:Start(GuiConfig)
    local GuiConfig = GuiConfig or {}
    GuiConfig.Name = GuiConfig.Name or "sitink Hub"
    GuiConfig.Color = GuiConfig.Color or Color3.fromRGB(127, 146, 242)

    local SitinkGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Top = Instance.new("Frame")
    local TopTitle = Instance.new("TextLabel")

    SitinkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SitinkGui.Name = "SitinkGui"
    SitinkGui.Parent = CoreGui

    Main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.Parent = SitinkGui

    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Main

    Top.BackgroundTransparency = 1
    Top.Size = UDim2.new(1, 0, 0, 34)
    Top.Parent = Main

    TopTitle.Font = Enum.Font.GothamBold
    TopTitle.Text = GuiConfig.Name
    TopTitle.TextColor3 = GuiConfig.Color
    TopTitle.TextSize = 14
    TopTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopTitle.BackgroundTransparency = 1
    TopTitle.Position = UDim2.new(0, 12, 0, 10)
    TopTitle.Size = UDim2.new(0, 0, 0, 14)
    TopTitle.Parent = Top

    local function MakeDraggable(topbar, frame)
        local Dragging, DragInput, DragStart, StartPos
        topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                DragStart = input.Position
                StartPos = frame.Position
            end
        end)
        topbar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                DragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == DragInput and Dragging then
                local Delta = input.Position - DragStart
                local pos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
                TweenService:Create(frame, TweenInfo.new(0.2), {Position = pos}):Play()
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
            end
        end)
    end
    MakeDraggable(Top, Main)

    local Tabs = {}
    local CountTab = 0

    function Tabs:MakeTab(NameTab)
        local NameTab = NameTab or "Tab"
        local ScrollTab = Instance.new("ScrollingFrame")
        local UIListLayout = Instance.new("UIListLayout")

        ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
        ScrollTab.ScrollBarThickness = 3
        ScrollTab.BackgroundTransparency = 1
        ScrollTab.Position = UDim2.new(0, 10, 0, 34)
        ScrollTab.Size = UDim2.new(1, -20, 1, -44)
        ScrollTab.Parent = Main

        UIListLayout.Padding = UDim.new(0, 4)
        UIListLayout.Parent = ScrollTab

        local function UpdateSize()
            local OffsetY = 0
            for _, child in ScrollTab:GetChildren() do
                if child:IsA("Frame") then
                    OffsetY = OffsetY + child.Size.Y.Offset + UIListLayout.Padding.Offset
                end
            end
            ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
        end
        ScrollTab.ChildAdded:Connect(UpdateSize)
        ScrollTab.ChildRemoved:Connect(UpdateSize)

        local Items = {}
        local CountItem = 0

        function Items:Toggle(ToggleConfig)
            local ToggleConfig = ToggleConfig or {}
            ToggleConfig.Title = ToggleConfig.Title or "Toggle"
            ToggleConfig.Default = ToggleConfig.Default or false
            ToggleConfig.Callback = ToggleConfig.Callback or function() end
            local ToggleFunc = {Value = ToggleConfig.Default}

            local Toggle = Instance.new("Frame")
            local ToggleTitle = Instance.new("TextLabel")
            local ToggleButton = Instance.new("TextButton")
            local ToggleCircle = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")

            Toggle.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
            Toggle.Size = UDim2.new(1, 0, 0, 30)
            Toggle.Parent = ScrollTab

            ToggleTitle.Font = Enum.Font.GothamBold
            ToggleTitle.Text = ToggleConfig.Title
            ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleTitle.TextSize = 12
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
            ToggleTitle.Size = UDim2.new(1, -40, 1, 0)
            ToggleTitle.Parent = Toggle

            ToggleButton.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
            ToggleButton.Position = UDim2.new(1, -36, 0.5, -6)
            ToggleButton.Size = UDim2.new(0, 28, 0, 12)
            ToggleButton.Text = ""
            ToggleButton.Parent = Toggle

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = ToggleButton

            ToggleCircle.BackgroundColor3 = ToggleConfig.Default and GuiConfig.Color or Color3.fromRGB(120, 120, 120)
            ToggleCircle.Position = ToggleConfig.Default and UDim2.new(1, -12, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)
            ToggleCircle.Size = UDim2.new(0, 8, 0, 8)
            ToggleCircle.Parent = ToggleButton

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(0, 4)
            CircleCorner.Parent = ToggleCircle

            local function UpdateToggle(Value)
                ToggleFunc.Value = Value
                TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                    Position = Value and UDim2.new(1, -12, 0.5, -4) or UDim2.new(0, 2, 0.5, -4),
                    BackgroundColor3 = Value and GuiConfig.Color or Color3.fromRGB(120, 120, 120)
                }):Play()
                ToggleConfig.Callback(Value)
            end

            ToggleButton.MouseButton1Click:Connect(function()
                UpdateToggle(not ToggleFunc.Value)
            end)

            function ToggleFunc:Set(Value)
                UpdateToggle(Value)
            end

            CountItem = CountItem + 1
            UpdateSize()
            return ToggleFunc
        end

        function Items:Slider(SliderConfig)
            local SliderConfig = SliderConfig or {}
            SliderConfig.Title = SliderConfig.Title or "Slider"
            SliderConfig.Min = SliderConfig.Min or 0
            SliderConfig.Max = SliderConfig.Max or 100
            SliderConfig.Increment = SliderConfig.Increment or 1
            SliderConfig.Default = SliderConfig.Default or 0
            SliderConfig.Callback = SliderConfig.Callback or function() end
            local SliderFunc = {Value = SliderConfig.Default}

            local Slider = Instance.new("Frame")
            local SliderTitle = Instance.new("TextLabel")
            local SliderFrame = Instance.new("Frame")
            local SliderDrag = Instance.new("Frame")
            local SliderNumber = Instance.new("TextLabel")

            Slider.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
            Slider.Size = UDim2.new(1, 0, 0, 45)
            Slider.Parent = ScrollTab

            SliderTitle.Font = Enum.Font.GothamBold
            SliderTitle.Text = SliderConfig.Title
            SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderTitle.TextSize = 12
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 10, 0, 10)
            SliderTitle.Size = UDim2.new(1, -150, 0, 12)
            SliderTitle.Parent = Slider

            SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderFrame.BackgroundTransparency = 0.8
            SliderFrame.Position = UDim2.new(1, -110, 0.5, 0)
            SliderFrame.Size = UDim2.new(0, 100, 0, 2)
            SliderFrame.Parent = Slider

            SliderDrag.BackgroundColor3 = GuiConfig.Color
            SliderDrag.Position = UDim2.new(0, 0, 0, 0)
            SliderDrag.Size = UDim2.new(0, 0, 1, 0)
            SliderDrag.Parent = SliderFrame

            SliderNumber.Font = Enum.Font.GothamBold
            SliderNumber.Text = tostring(SliderConfig.Default)
            SliderNumber.TextColor3 = Color3.fromRGB(230, 230, 230)
            SliderNumber.TextSize = 12
            SliderNumber.TextXAlignment = Enum.TextXAlignment.Right
            SliderNumber.BackgroundTransparency = 1
            SliderNumber.Position = UDim2.new(1, -60, 0.5, -6)
            SliderNumber.Size = UDim2.new(0, 40, 0, 13)
            SliderNumber.Parent = Slider

            local Dragging = false
            local function Round(Number, Factor)
                local Result = math.floor(Number/Factor + 0.5) * Factor
                return Result
            end

            function SliderFunc:Set(Value)
                Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)
                SliderFunc.Value = Value
                SliderNumber.Text = tostring(Value)
                TweenService:Create(SliderDrag, TweenInfo.new(0.3), {
                    Size = UDim2.fromScale((Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 1)
                }):Play()
                SliderConfig.Callback(Value)
            end

            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                end
            end)
            SliderFrame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local SizeScale = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                    SliderFunc:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale))
                end
            end)

            SliderFunc:Set(SliderConfig.Default)
            CountItem = CountItem + 1
            UpdateSize()
            return SliderFunc
        end

        CountTab = CountTab + 1
        return Items
    end

    return Tabs
end

return sitinklib