local P = game:GetService("Players")
local L = P.LocalPlayer
local G = L:WaitForChild("PlayerGui")
local C = L.Character or L.CharacterAdded:Wait()
local H = C:WaitForChild("Humanoid")

local old = G:FindFirstChild("KnSkinUI")
if old then old:Destroy() end

-- 保存当前套用的外观描述，重生自动复用
local savedDescription = nil

-- 圆形悬浮按钮
local Circle = Instance.new("TextButton")
Circle.Name = "KnSkinUI"
Circle.Size = UDim2.new(0, 50, 0, 50)
Circle.Position = UDim2.new(0, 20, 0.5, -25)
Circle.BackgroundColor3 = Color3.new(0, 0, 0)
Circle.Text = "kn"
Circle.TextColor3 = Color3.new(1, 1, 1)
Circle.TextSize = 18
Circle.BorderSizePixel = 0
Circle.Parent = G

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = Circle

-- 展开后的方形面板
local Panel = Instance.new("Frame")
Panel.Name = "Panel"
Panel.Size = UDim2.new(0, 220, 0, 200)
Panel.Position = UDim2.new(0.5, -110, 0.5, -100)
Panel.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
Panel.Visible = false
Panel.Parent = G

local pCorner = Instance.new("UICorner")
pCorner.CornerRadius = UDim.new(0, 10)
pCorner.Parent = Panel

-- 关闭叉
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -34, 0, 6)
Close.BackgroundColor3 = Color3.new(0.75, 0.15, 0.15)
Close.Text = "×"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.TextSize = 20
Close.BorderSizePixel = 0
Close.Parent = Panel

local cCorner = Instance.new("UICorner")
cCorner.CornerRadius = UDim.new(1, 0)
cCorner.Parent = Close

-- 输入框
local Box = Instance.new("TextBox")
Box.Size = UDim2.new(0, 190, 0, 40)
Box.Position = UDim2.new(0, 15, 0, 45)
Box.PlaceholderText = "输入对方 UserId"
Box.Text = ""
Box.ClearTextOnFocus = false
Box.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Box.TextColor3 = Color3.new(1, 1, 1)
Box.Parent = Panel

local bCorner = Instance.new("UICorner")
bCorner.CornerRadius = UDim.new(0, 8)
bCorner.Parent = Box

-- 提示文本
local Tip = Instance.new("TextLabel")
Tip.Size = UDim2.new(0,190,0,22)
Tip.Position = UDim2.new(0,15,0,90)
Tip.BackgroundTransparency = 1
Tip.Text = ""
Tip.TextColor3 = Color3.new(1,1,1)
Tip.TextSize =14
Tip.Parent = Panel

-- 红色确定按钮
local Confirm = Instance.new("TextButton")
Confirm.Size = UDim2.new(0, 190, 0, 38)
Confirm.Position = UDim2.new(0, 15, 0, 120)
Confirm.BackgroundColor3 = Color3.new(0.8, 0.15, 0.15)
Confirm.Text = "确定"
Confirm.TextColor3 = Color3.new(1, 1, 1)
Confirm.TextSize = 16
Confirm.BorderSizePixel = 0
Confirm.Parent = Panel

local fCorner = Instance.new("UICorner")
fCorner.CornerRadius = UDim.new(0, 8)
fCorner.Parent = Confirm

-- 圆点点击：展开
Circle.MouseButton1Click:Connect(function()
    Panel.Visible = true
    Circle.Visible = false
end)

-- 叉点击：缩回圆形
Close.MouseButton1Click:Connect(function()
    Panel.Visible = false
    Circle.Visible = true
end)

-- 确定：按 UserId 穿戴
Confirm.MouseButton1Click:Connect(function()
    local id = tonumber(Box.Text)
    if not id then
        Tip.Text = "⚠️ 请输入数字 UserId"
        task.wait(2)
        Tip.Text = ""
        return
    end
    Tip.Text = "🔄 正在加载..."
    local ok, desc = pcall(function()
        return P:GetHumanoidDescriptionFromUserId(id)
    end)
    if ok and desc then
        savedDescription = desc
        H:ApplyDescription(savedDescription)
        Tip.Text = "✅ 外观套用成功！UGC饰品可能不显示"
    else
        Tip.Text = "❌ 加载失败，UserId无效/限流"
        warn("外观加载失败，UserId 可能无效或触发请求限制")
    end
    task.wait(2)
    Tip.Text = ""
end)

-- 重生后更新引用，并且自动重新套用保存的外观
L.CharacterAdded:Connect(function(n)
    task.wait(0.3)
    C = n
    H = C:WaitForChild("Humanoid")
    -- 如果保存了外观，重生自动应用
    if savedDescription then
        task.wait(0.2)
        local applyOk,_ = pcall(function()
            H:ApplyDescription(savedDescription)
        end)
    end
end)
