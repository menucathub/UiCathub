local Catdzs1vnLib = {}

-- Dịch vụ cần thiết
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Hàm tạo Window
function Catdzs1vnLib:CreateWindow(config)
    local windowConfig = {
        Title = config.Title or "Catdzs1vn",
        SubTitle = config.SubTitle or "",
        Size = config.Size or UDim2.fromOffset(450, 350), -- Kích thước nhỏ gọn hơn
        Theme = config.Theme or "Dark",
        MinimizeKey = config.MinimizeKey or Enum.KeyCode.LeftControl
    }

    -- Tạo ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Catdzs1vnUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Tạo Main Frame (Window)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(20, 20, 30) or Color3.fromRGB(230, 230, 230)
    MainFrame.Position = UDim2.new(0.5, -windowConfig.Size.X.Offset / 2, 0.5, -windowConfig.Size.Y.Offset / 2)
    MainFrame.Size = windowConfig.Size
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(50, 50, 60)

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(200, 200, 200)
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Parent = MainFrame
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

    local TitleText = Instance.new("TextLabel")
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.Size = UDim2.new(1, -60, 1, 0)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = windowConfig.Title .. " | " .. windowConfig.SubTitle
    TitleText.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    TitleText.TextSize = 14
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar

    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    MinimizeButton.Position = UDim2.new(1, -25, 0, 5)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Font = Enum.Font.Gotham
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 14
    MinimizeButton.Parent = TitleBar
    Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 5)

    -- Tab Container (Thanh tab ngang)
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(25, 25, 35) or Color3.fromRGB(210, 210, 210)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.Size = UDim2.new(1, 0, 0, 40)
    TabContainer.Parent = MainFrame
    Instance.new("UIStroke", TabContainer).Color = Color3.fromRGB(50, 50, 60)

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 10, 0, 80)
    ContentContainer.Size = UDim2.new(1, -20, 1, -90)
    ContentContainer.Parent = MainFrame

    -- Tab Management
    local Tabs = {}
    local currentTab = nil

    -- Hàm tạo Tab
    function MainFrame:CreateTab(tabName)
        local Tab = {}
        Tab.Name = tabName

        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(200, 200, 200)
        TabButton.Size = UDim2.new(0, 100, 0, 30)
        TabButton.Position = UDim2.new(0, #Tabs * 110 + 10, 0, 5)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabName
        TabButton.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        TabButton.TextSize = 12
        TabButton.Parent = TabContainer
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 5)
        Instance.new("UIStroke", TabButton).Color = Color3.fromRGB(60, 60, 70)

        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.Visible = false
        TabContent.Parent = ContentContainer

        -- Chuyển đổi tab với hiệu ứng
        TabButton.MouseButton1Click:Connect(function()
            if currentTab ~= Tab then
                if currentTab then
                    currentTab.Content.Visible = false
                    TweenService:Create(currentTab.Button, TweenInfo.new(0.2), {
                        BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(200, 200, 200)
                    }):Play()
                end
                TabContent.Visible = true
                TweenService:Create(TabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(170, 170, 170)
                }):Play()
                currentTab = Tab
            end
        end)

        Tab.Button = TabButton
        Tab.Content = TabContent
        table.insert(Tabs, Tab)

        -- Nếu là tab đầu tiên, tự động chọn
        if #Tabs == 1 then
            TabButton:MouseButton1Click()
        end

        -- Hàm tạo Section trong Tab
        function Tab:CreateSection(sectionName)
            local Section = Instance.new("Frame")
            Section.Name = sectionName
            Section.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(25, 25, 35) or Color3.fromRGB(210, 210, 210)
            Section.Size = UDim2.new(1, -10, 0, 80)
            Section.Position = UDim2.new(0, 5, 0, TabContent.CanvasSize.Y.Offset + 10)
            Section.Parent = TabContent
            Instance.new("UICorner", Section).CornerRadius = UDim.new(0, 5)
            Instance.new("UIStroke", Section).Color = Color3.fromRGB(50, 50, 60)

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 5, 0, 5)
            SectionTitle.Size = UDim2.new(1, -10, 0, 20)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            SectionTitle.TextSize = 12
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = Section

            local SectionContent = Instance.new("Frame")
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 5, 0, 25)
            SectionContent.Size = UDim2.new(1, -10, 1, -30)
            SectionContent.Parent = Section

            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.CanvasSize.Y.Offset + 90)

            -- Hàm tạo Toggle trong Section
            function Tab:CreateToggle(toggleConfig)
                local toggleName = toggleConfig.Name or "Toggle"
                local defaultValue = toggleConfig.Default or false
                local callback = toggleConfig.Callback or function() end

                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, 25)
                ToggleFrame.Position = UDim2.new(0, 0, 0, #SectionContent:GetChildren() * 30)
                ToggleFrame.Parent = SectionContent

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(50, 50, 50)
                ToggleLabel.TextSize = 12
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame

                local ToggleButton = Instance.new("TextButton")
                ToggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
                ToggleButton.Position = UDim2.new(0.75, 0, 0, 5)
                ToggleButton.Size = UDim2.new(0.2, 0, 0, 15)
                ToggleButton.Font = Enum.Font.Gotham
                ToggleButton.Text = defaultValue and "ON" or "OFF"
                ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleButton.TextSize = 10
                ToggleButton.Parent = ToggleFrame
                Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 5)

                ToggleButton.MouseButton1Click:Connect(function()
                    defaultValue = not defaultValue
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
                    }):Play()
                    ToggleButton.Text = defaultValue and "ON" or "OFF"
                    callback(defaultValue)
                end)

                Section.Size = UDim2.new(1, -10, 0, Section.Size.Y.Offset + 30)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.CanvasSize.Y.Offset + 30)
            end

            -- Hàm tạo Button trong Section
            function Tab:CreateButton(buttonConfig)
                local buttonName = buttonConfig.Name or "Button"
                local callback = buttonConfig.Callback or function() end

                local Button = Instance.new("TextButton")
                Button.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(190, 190, 190)
                Button.Size = UDim2.new(1, 0, 0, 25)
                Button.Position = UDim2.new(0, 0, 0, #SectionContent:GetChildren() * 30)
                Button.Font = Enum.Font.Gotham
                Button.Text = buttonName
                Button.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
                Button.TextSize = 12
                Button.Parent = SectionContent
                Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)

                Button.MouseButton1Click:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
                    wait(0.1)
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(190, 190, 190)}):Play()
                    callback()
                end)

                Section.Size = UDim2.new(1, -10, 0, Section.Size.Y.Offset + 30)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.CanvasSize.Y.Offset + 30)
            end

            -- Hàm tạo Paragraph trong Section
            function Tab:CreateParagraph(paragraphConfig)
                local title = paragraphConfig.Title or "Title"
                local text = paragraphConfig.Text or "Description"

                local ParagraphFrame = Instance.new("Frame")
                ParagraphFrame.BackgroundTransparency = 1
                ParagraphFrame.Size = UDim2.new(1, 0, 0, 40)
                ParagraphFrame.Position = UDim2.new(0, 0, 0, #SectionContent:GetChildren() * 30)
                ParagraphFrame.Parent = SectionContent

                local ParagraphTitle = Instance.new("TextLabel")
                ParagraphTitle.BackgroundTransparency = 1
                ParagraphTitle.Size = UDim2.new(1, 0, 0, 15)
                ParagraphTitle.Font = Enum.Font.GothamBold
                ParagraphTitle.Text = title
                ParagraphTitle.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
                ParagraphTitle.TextSize = 12
                ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphTitle.Parent = ParagraphFrame

                local ParagraphText = Instance.new("TextLabel")
                ParagraphText.BackgroundTransparency = 1
                ParagraphText.Position = UDim2.new(0, 0, 0, 15)
                ParagraphText.Size = UDim2.new(1, 0, 0, 25)
                ParagraphText.Font = Enum.Font.Gotham
                ParagraphText.Text = text
                ParagraphText.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(180, 180, 180) or Color3.fromRGB(70, 70, 70)
                ParagraphText.TextSize = 10
                ParagraphText.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphText.TextWrapped = true
                ParagraphText.Parent = ParagraphFrame

                Section.Size = UDim2.new(1, -10, 0, Section.Size.Y.Offset + 45)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.CanvasSize.Y.Offset + 45)
            end

            return Tab
        end

        return Tab
    end

    -- Minimize Functionality
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = minimized and UDim2.new(0, windowConfig.Size.X.Offset, 0, 30) or windowConfig.Size
        }):Play()
        TabContainer.Visible = not minimized
        ContentContainer.Visible = not minimized
    end)

    -- Minimize bằng phím
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == windowConfig.MinimizeKey then
            MinimizeButton:MouseButton1Click()
        end
    end)

    -- Trả về MainFrame với hàm CreateTab
    return MainFrame
end

return Catdzs1vnLib