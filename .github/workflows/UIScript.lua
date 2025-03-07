local Catdzs1vnLib = {}

-- Dịch vụ cần thiết
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Hàm tạo Window
function Catdzs1vnLib:CreateWindow(config)
    local windowConfig = {
        Title = config.Title or "Catdzs1vn UI",
        SubTitle = config.SubTitle or "",
        TabWidth = config.TabWidth or 160,
        Size = config.Size or UDim2.fromOffset(580, 460),
        Acrylic = config.Acrylic or false,
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
    MainFrame.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(25, 25, 35) or Color3.fromRGB(240, 240, 240)
    MainFrame.Position = UDim2.new(0.5, -windowConfig.Size.X.Offset / 2, 0.5, -windowConfig.Size.Y.Offset / 2)
    MainFrame.Size = windowConfig.Size
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(200, 200, 200)
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.Parent = MainFrame
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

    local TitleText = Instance.new("TextLabel")
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.Size = UDim2.new(1, -80, 1, 0)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = windowConfig.Title .. " " .. windowConfig.SubTitle
    TitleText.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar

    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    MinimizeButton.Position = UDim2.new(1, -30, 0, 5)
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Font = Enum.Font.Gotham
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 14
    MinimizeButton.Parent = TitleBar
    Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 5)

    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.Size = UDim2.new(0, windowConfig.TabWidth, 1, -55)
    TabContainer.Parent = MainFrame

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, windowConfig.TabWidth + 20, 0, 45)
    ContentContainer.Size = UDim2.new(1, -windowConfig.TabWidth - 30, 1, -55)
    ContentContainer.Parent = MainFrame

    -- Tab Management
    local Tabs = {}
    local currentTab = nil

    -- Hàm tạo Tab
    local function CreateTab(tabName)
        local Tab = {}
        Tab.Name = tabName

        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(200, 200, 200)
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 0, 0, #Tabs * 45)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabName
        TabButton.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        TabButton.TextSize = 14
        TabButton.Parent = TabContainer
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 5)

        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 5
        TabContent.Visible = false
        TabContent.Parent = ContentContainer

        -- Chuyển đổi tab
        TabButton.MouseButton1Click:Connect(function()
            if currentTab ~= Tab then
                if currentTab then
                    currentTab.Content.Visible = false
                    currentTab.Button.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(200, 200, 200)
                end
                TabContent.Visible = true
                TabButton.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(180, 180, 180)
                currentTab = Tab
            end
        end)

        Tab.Button = TabButton
        Tab.Content = TabContent
        table.insert(Tabs, Tab)

        -- Hàm tạo Section trong Tab
        function Tab:CreateSection(sectionName)
            local Section = Instance.new("Frame")
            Section.Name = sectionName
            Section.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(220, 220, 220)
            Section.Size = UDim2.new(1, -10, 0, 100)
            Section.Position = UDim2.new(0, 5, 0, TabContent.CanvasSize.Y.Offset + 10)
            Section.Parent = TabContent
            Instance.new("UICorner", Section).CornerRadius = UDim.new(0, 5)

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 5, 0, 5)
            SectionTitle.Size = UDim2.new(1, -10, 0, 20)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = Section

            local SectionContent = Instance.new("Frame")
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 5, 0, 30)
            SectionContent.Size = UDim2.new(1, -10, 1, -35)
            SectionContent.Parent = Section

            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.CanvasSize.Y.Offset + 110)

            -- Hàm tạo Toggle trong Section
            function Tab:CreateToggle(toggleConfig)
                local toggleName = toggleConfig.Name or "Toggle"
                local defaultValue = toggleConfig.Default or false
                local callback = toggleConfig.Callback or function() end

                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
                ToggleFrame.Position = UDim2.new(0, 0, 0, #SectionContent:GetChildren() * 35)
                ToggleFrame.Parent = SectionContent

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame

                local ToggleButton = Instance.new("TextButton")
                ToggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                ToggleButton.Position = UDim2.new(0.7, 0, 0, 5)
                ToggleButton.Size = UDim2.new(0.2, 0, 0, 20)
                ToggleButton.Font = Enum.Font.Gotham
                ToggleButton.Text = defaultValue and "ON" or "OFF"
                ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleButton.TextSize = 12
                ToggleButton.Parent = ToggleFrame
                Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 5)

                ToggleButton.MouseButton1Click:Connect(function()
                    defaultValue = not defaultValue
                    ToggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                    ToggleButton.Text = defaultValue and "ON" or "OFF"
                    callback(defaultValue)
                end)

                Section.Size = UDim2.new(1, -10, 0, Section.Size.Y.Offset + 35)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.CanvasSize.Y.Offset + 35)
            end

            -- Hàm tạo Button trong Section
            function Tab:CreateButton(buttonConfig)
                local buttonName = buttonConfig.Name or "Button"
                local callback = buttonConfig.Callback or function() end

                local Button = Instance.new("TextButton")
                Button.BackgroundColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(200, 200, 200)
                Button.Size = UDim2.new(1, 0, 0, 30)
                Button.Position = UDim2.new(0, 0, 0, #SectionContent:GetChildren() * 35)
                Button.Font = Enum.Font.Gotham
                Button.Text = buttonName
                Button.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
                Button.TextSize = 14
                Button.Parent = SectionContent
                Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)

                Button.MouseButton1Click:Connect(callback)

                Section.Size = UDim2.new(1, -10, 0, Section.Size.Y.Offset + 35)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.CanvasSize.Y.Offset + 35)
            end

            -- Hàm tạo Paragraph trong Section
            function Tab:CreateParagraph(paragraphConfig)
                local title = paragraphConfig.Title or "Title"
                local text = paragraphConfig.Text or "Description"

                local ParagraphFrame = Instance.new("Frame")
                ParagraphFrame.BackgroundTransparency = 1
                ParagraphFrame.Size = UDim2.new(1, 0, 0, 50)
                ParagraphFrame.Position = UDim2.new(0, 0, 0, #SectionContent:GetChildren() * 35)
                ParagraphFrame.Parent = SectionContent

                local ParagraphTitle = Instance.new("TextLabel")
                ParagraphTitle.BackgroundTransparency = 1
                ParagraphTitle.Size = UDim2.new(1, 0, 0, 20)
                ParagraphTitle.Font = Enum.Font.GothamBold
                ParagraphTitle.Text = title
                ParagraphTitle.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
                ParagraphTitle.TextSize = 14
                ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphTitle.Parent = ParagraphFrame

                local ParagraphText = Instance.new("TextLabel")
                ParagraphText.BackgroundTransparency = 1
                ParagraphText.Position = UDim2.new(0, 0, 0, 20)
                ParagraphText.Size = UDim2.new(1, 0, 0, 30)
                ParagraphText.Font = Enum.Font.Gotham
                ParagraphText.Text = text
                ParagraphText.TextColor3 = windowConfig.Theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(50, 50, 50)
                ParagraphText.TextSize = 12
                ParagraphText.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphText.TextWrapped = true
                ParagraphText.Parent = ParagraphFrame

                Section.Size = UDim2.new(1, -10, 0, Section.Size.Y.Offset + 55)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.CanvasSize.Y.Offset + 55)
            end

            return Tab
        end

        return Tab
    end

    -- Minimize Functionality
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        MainFrame.Size = minimized and UDim2.new(0, windowConfig.Size.X.Offset, 0, 35) or windowConfig.Size
        TabContainer.Visible = not minimized
        ContentContainer.Visible = not minimized
    end)

    -- Trả về đối tượng Window với hàm tạo Tab
    return {
        CreateTab = CreateTab
    }
end

return Catdzs1vnLib
