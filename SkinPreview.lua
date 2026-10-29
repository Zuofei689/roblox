-- LocalScript 本地皮肤预览脚本，仅客户端可视，不购买/不永久拥有物品
print("✅ 皮肤预览脚本已加载成功")
local Players = game:GetService("Players")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- 【在这里填入你要预览的皮肤套装ID，自行扩充列表】
local SkinList = {
    {Name = "套装1", OutfitID = 123456},
    {Name = "套装2", OutfitID = 789012},
    {Name = "套装3", OutfitID = 345678}
}

-- 创建手机端UI界面（适配触屏）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SkinPreviewUI"
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,160,0,240)
Frame.Position = UDim2.new(0.02,0,0.3,0)
Frame.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
Frame.BackgroundTransparency = 0.2
Frame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0,8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = Frame

-- 加载套装函数：仅本地预览
local function ApplyOutfitPreview(outfitId)
    local success, desc = pcall(function()
        return Players:GetHumanoidDescriptionFromOutfitIdAsync(outfitId)
    end)
    if not success then
        warn("套装加载失败，ID错误或资源不存在")
        return
    end
    humanoid:ApplyDescription(desc)
end

-- 重置角色回原版
local function ResetCharacter()
    local originalDesc = LocalPlayer:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
    humanoid:ApplyDescription(originalDesc)
end

-- 生成皮肤选择按钮
for _,skinData in ipairs(SkinList) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0,140,0,36)
    Btn.BackgroundColor3 = Color3.new(0.25,0.4,0.7)
    Btn.Text = skinData.Name
    Btn.TextSize = 14
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Parent = Frame
    Btn.MouseButton1Click:Connect(function()
        ApplyOutfitPreview(skinData.OutfitID)
    end)
end

-- 重置按钮
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0,140,0,36)
ResetBtn.BackgroundColor3 = Color3.new(0.7,0.25,0.25)
ResetBtn.Text = "重置角色"
ResetBtn.TextSize =14
ResetBtn.TextColor3 = Color3.new(1,1,1)
ResetBtn.Parent = Frame
ResetBtn.MouseButton1Click:Connect(ResetCharacter)

-- 角色重生自动恢复UI
LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
end)
