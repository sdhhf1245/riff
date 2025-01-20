local UI = game:GetObjects("rbxassetid://133215015127433")[1]:Clone()
local Objects = UI.Objects

local riff = {
    Toggled = false,
    ToggleKey = Enum.KeyCode.LeftControl
}

riff.__index = riff

local SelectedTab;

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Tabs = {}
local TabIndex = 1;
local TweenService = game:GetService("TweenService")
local Old;
local Size = workspace.CurrentCamera.ViewportSize


local ti = {
    ["in"] = TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
    ["out"] = TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
    ["inout"] = TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
}


local function padding(height)
    return (-18 + (height-2) * (-24)) + height
end

function notchPos(index)
    return 0.222 + (index - 1) * 0.133
end

local function uiscale(size)
    local scales = {
        {Vector2.new(1920, 1080), 1.6},
        {Vector2.new(1366, 768), 1},
        {Vector2.new(780, 360), 0.65},
        {Vector2.new(568, 320), 0.57},
        {Vector2.new(3840, 2160), 3.5},
    }
    
    local width = size.X
    local minWidth = scales[#scales][1].X
    local maxWidth = scales[1][1].X

    return scales[#scales][2] + (scales[1][2] - scales[#scales][2]) * (width - minWidth) / (maxWidth - minWidth)
end

function riff:Create(settings) 

    settings = settings or {
        Name = "riff"
    }

    local gui = Instance.new("ScreenGui")
    gui.Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui) or (gethui and gethui()) or CoreGui:FindFirstChild("RobloxGui")
    gui.Name = settings.Name
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Enabled = true
    
    local Main = UI.Main:Clone()
    Main.Position = UDim2.new(0.5, 0, 1.5, 0)
    task.wait()
    Main.Parent = gui
    
    -- // Initalization;
    Main.Title.Text = settings.Name
    Main.Visible = true
    
    TweenService:Create(Main, ti["out"], {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()

    local Window = {
        Root = Main,
        OriginalPosition = UDim2.new(0.5, 0, 0.5, 0),
        Screen = Vector2.new(Size.X, Size.Y)
    }
    print(uiscale(Window.Screen))
    Main.UIScale.Scale = uiscale(Window.Screen);

    function Window:Toggle() 
        if not self.Toggled then
            self.OriginalPosition = Main.Position
        end
    
        self.Toggled = not self.Toggled
        local goal
    
        if self.Toggled then
            goal = {
                Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset, 1.5, 0)
            }

            local t1 = TweenService:Create(Main, ti["inout"], goal)
            t1:Play()
        else
            goal = {
                Position = self.OriginalPosition
            }

            local t1 = TweenService:Create(Main, ti["out"], goal)
            t1:Play()
        end
    end
    

    Main.Close.MouseButton1Click:Connect(function()
        Window:Toggle()
    end)

    if self.ToggleKey then
        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == self.ToggleKey then
                Window:Toggle()
            end
        end)
    end
    
    function Window:Tab(settings)
        settings = settings or {
            Name = "Tab",
            Icon = "rbxassetid://1"
        }
        
        local TabRoot = Objects.Tab:Clone()
        TabRoot.Name = settings.Name
        TabRoot.Visible = true
        TabRoot.Parent = self.Root.Tabs
        TabRoot.Icon.Image = settings.Icon
        TabRoot.Button.Text = settings.Name
        
        local TabContainer = Objects.TabContainer:Clone()
        TabContainer.Name = settings.Name
        TabContainer.Parent = self.Root.Container
        TabContainer.Title.TextLabel.Text = settings.Name
        
        local Tab = {
            Root = TabRoot,
            Container = TabContainer,
        }
        
        table.insert(Tabs, TabRoot)
        Main.Notch.Visible = true
        -- // Tabs
        function Tab:Activate()
            if SelectedTab then
                TweenService:Create(SelectedTab.Root.Button, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                -- SelectedTab.Root.Button.BackgroundTransparency = 1
                SelectedTab.Root.Button.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                SelectedTab.Container.Visible = false
            end
            TweenService:Create(self.Root.Button, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0.9}):Play()
            -- self.Root.Button.BackgroundTransparency = 0.9
            self.Root.Button.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            self.Container.Visible = true
    
            SelectedTab = self
            if table.find(Tabs, SelectedTab.Root) then
                TabIndex = table.find(Tabs, SelectedTab.Root)
                local t2 = TweenService:Create(Main.Notch, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0.007, 0, 0.12, 0)})
                if Old then 
                    Old.Visible = false;
                end
                Main.Notch.Visible = true;
                t2:Play()

                local t1 = TweenService:Create(Main.Notch, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Position = UDim2.new(0.012, 0, notchPos(TabIndex), 0)})
                t1:Play()


                local t3 = TweenService:Create(Main.Notch, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0.007, 0, 0.05, 0)})

                t2.Completed:Connect(function()
                    task.delay(0.04, function()
                        t3:Play()
                        t3.Completed:Connect(function()
                            Old =  Tabs[TabIndex].Notch
                            Old.Visible = true
                            Main.Notch.Visible = false;
                        end)
                    end)
                end)

                
            end
        end

        if not SelectedTab then
            Tab:Activate()
        end

        TabRoot.Button.MouseButton1Click:Connect(function()
            Tab:Activate()
        end)
        -- // Start Items

        function Tab:Button(settings)
            settings = settings or {
                Name = "Button",
                Callback = function() print("button pressed!") end
            }

            local Button = Objects.Button:Clone()
            Button.Parent = TabContainer.Items
            Button.Name = settings.Name
            Button.Visible = true
            Button.TextButton.Text = settings.Name

            Button.TextButton.MouseButton1Click:Connect(settings.Callback)
        end

        function Tab:Toggle(settings) 
            settings = settings or {
                Name = "Toggle",
                Callback = function(v) if v then print("on") else print("off") end end,
                DefaultState = false
            }

            local Toggle = Objects.Toggle.Toggle:Clone()
            Toggle.Parent = TabContainer.Items
            Toggle.Name = settings.Name
            Toggle.Visible = true
            Toggle.Title.Text = settings.Name

            local Part = Objects.Toggle.Part:Clone()
            Part.Parent = Toggle
            Part.Visible = true

            local state = settings.DefaultState

            local function upd()
                if state then
                    local goal = {
                        Head = {
                            AnchorPoint = Vector2.new(0.9, 0.5),
                            Position = UDim2.new(0.9, 0, 0.5, 0),
                        },
                        BackgroundColor3 = Color3.fromRGB(5, 194, 58)
                    }

                    local t1 = TweenService:Create(Part.Button.Head, ti["out"], goal.Head)
                    local t2 = TweenService:Create(Part.Button, ti["out"], {BackgroundColor3 = goal.BackgroundColor3})

                    t1:Play()
                    t2:Play()
                else
                    
                    local goal = {
                        Head = {
                            AnchorPoint = Vector2.new(0.1, 0.5),
                            Position = UDim2.new(0.1, 0, 0.5, 0),
                        },
                        BackgroundColor3 = Color3.fromRGB(43, 43, 43)
                    }

                    local t1 = TweenService:Create(Part.Button.Head, ti["out"], goal.Head)
                    local t2 = TweenService:Create(Part.Button, ti["out"], {BackgroundColor3 = goal.BackgroundColor3})
                    t1:Play()
                    t2:Play()
                end
            end

            upd()

            Part.Button.MouseButton1Click:Connect(function()
                state = not state
                upd()
                settings.Callback(state)
            end)
        end

        function Tab:Slider(settings)
            settings = settings or {
                Name = "Slider",
                Default = 30,
                Min = 0,
                Max = 100,
                Callback = function(val) print(val) end
            }

            local Slider = Objects.Slider.Slider:Clone()
            Slider.Visible = true
            Slider.Parent = TabContainer.Items
            Slider.Name = settings.Name
            Slider.Title.Text = settings.Name

            local Part = Objects.Slider.Part:Clone()
            Part.Parent = Slider
            Part.Visible = true

            local down = false

            Part.Track.Head.MouseButton1Down:Connect(function()
                down = true
                while RunService.RenderStepped:Wait() and down do
                    local percentage = math.clamp((LocalPlayer:GetMouse().X - Part.Track.AbsolutePosition.X) / (Part.Track.AbsoluteSize.X), 0, 1.00)
                    local value = ((settings.Max - settings.Min) * percentage) + settings.Min
                    local pos = math.clamp(percentage, -0.2, 1.1)
                    Part.Track.Head.AnchorPoint = Vector2.new(pos, 0.5)
                    Part.Track.Head.Position = UDim2.new(pos, 0, 0.5, 0)
                    value = math.floor(value)
                    Part.Value.Text = value

                    settings.Callback(value)
                end
            end)

            UIS.InputEnded:Connect(function(key)
                if key.UserInputType == Enum.UserInputType.MouseButton1 then
                    down = false
                end
            end)
        end
        
        function Tab:Dropdown(settings)
            settings = settings or {
                Name = "Dropdown",
                Items = {"Option 1", "Option 2", "Option 3", "4", "5", "6", "7", "8"},
                Default = "Option 1",
                Callback = function(selected)
                    print("Selected: " .. selected)
                end
            }

            local IdxItem = #settings.Items
            
            local SelectedItem = settings.Default
            
            local Dropdown = Objects.Dropdown.Dropdown:Clone()
            Dropdown.Visible = true
            Dropdown.Parent = TabContainer.Items
            Dropdown.Name = settings.Name
            Dropdown.Title.Text = settings.Name
            
            local Part = Objects.Dropdown.Part:Clone()
            Part.Parent = Dropdown
            Part.Visible = true
            Part.Text = SelectedItem
            Part.Items.Size = UDim2.new(1.214, 0, 0, 0)
            local UIPageLayout = Part.Items.UIPageLayout
            local UIListLayout = Objects.UIListLayout:Clone()

            UIPageLayout.Padding = UDim.new(0.03, padding(IdxItem))
            
            for idx, item in pairs(settings.Items) do
                local button = Objects.Dropdown.Button:Clone()
                button.Parent = Part.Items
                button.Size = UDim2.new(0.95, 0, 1/IdxItem, 0)
                button.Text = item
                button.Name = item
                button.Visible = true

                if settings.Default == item then 
                    SelectedItem = button
                    Part.Text = item
                    button.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                    button.Notch.Visible = true
                end

                button.MouseButton1Click:Connect(function()
                    if SelectedItem then
                        SelectedItem.Notch.Visible = false;
                        SelectedItem.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                    end

                    SelectedItem = button
                    SelectedItem:WaitForChild("Notch").Visible = true;
                    SelectedItem.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                    -- SelectedItem:WaitForChild("Notch").Position = UDim2.new(padding(IdxItem)/100, 0, 0.5, 0)
                    Part.Text = item

                    settings.Callback(item)
                end)
            end

            UIPageLayout.Parent = nil;
            UIListLayout.Parent = Part.Items

            local vis = false

            Part.MouseButton1Click:Connect(function()
                Part.Items.Visible = true
                task.wait()
                vis = not vis


                UIPageLayout.Parent = nil;
                UIListLayout.Parent = Part.Items
                if vis then
                    local t = TweenService:Create(Part.Items, ti["out"], {Size = UDim2.new(1.214, 0, IdxItem, 0)})
                    t:Play()
                    t.Completed:Connect(function()
                        UIListLayout.Parent = nil
                        UIPageLayout.Parent = Part.Items;
                    end)
                else
                    UIPageLayout.Parent = nil;
                    UIListLayout.Parent = Part.Items
                    local t = TweenService:Create(Part.Items, ti["out"], {Size = UDim2.new(1.214, 0, 0, 0)})
                    t:Play()
                end
            end)
        end

        function Tab:Section(settings)
            settings = settings or {
                Text = "Section"
            }

            local Section = Objects.Section:Clone()
            Section.Text = settings.Text
            Section.Visible = true
            Section.Parent = TabContainer.Items
        end

        return Tab
    end

    return Window
end

return riff
