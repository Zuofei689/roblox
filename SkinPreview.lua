--单件穿搭预览脚本，仅加入 Diwali Sparkler Headband 头饰
print("✅ 单件穿搭脚本加载成功")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ======================== 饰品ID库 ========================
local ItemList = {
    --头发
    Hair = {
    },
    --帽子/头饰
    Hats = {
        {Name = "Diwali Sparkler Headband", AssetID = 81550816889926},
    },
    --上衣
    Shirts = {
    },
    --裤子
    Pants = {
    }
}
-- ==========================================================

-- 创建UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WearPreviewUI"
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Position = UDim2.new(0.02,0,0.3,0)
MainFrame.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
MainFrame.Parent = ScreenGui

local function CreateButton(name,pos,callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.9,0,0,44)
    btn.Position = UDim2.new(0.05,0,pos,0)
    btn.BackgroundColor3 = Color3.new(0.2,0.4,0.85)
    btn.Text = name
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
end

--穿戴饰品函数
local function WearAccessory(assetId)
    local success,model = pcall(function()
        return game:GetService("InsertService"):LoadAsset(assetId)
    end)
    if not success then
        warn("❌ 加载饰品失败 ID:"..assetId)
        return
    end
    for _,v in pairs(model:GetChildren())do
        if v:IsA("Accessory")then
            v.Parent = Character
        end
    end
    model:Destroy()
end

--穿衬衫裤子
local function WearShirt(assetId)
    local shirt = Character:FindFirstChildOfClass("Shirt") or Instance.new("Shirt")
    shirt.Parent = Character
    shirt.ShirtTemplate = "rbxassetid://"..assetId
end
local function WearPants(assetId)
    local pants = Character:FindFirstChildOfClass("Pants") or Instance.new("Pants")
    pants.Parent = Character
    pants.PantsTemplate = "rbxassetid://"..assetId
end

--重置角色
local function ResetChar()
    LocalPlayer:LoadCharacter()
end

--生成按钮
local y = 0.02
for _,item in pairs(ItemList.Hair)do
    CreateButton(item.Name,y,function()WearAccessory(item.AssetID)end)
    y += 0.11
end
for _,item in pairs(ItemList.Hats)do
    CreateButton(item.Name,y,function()WearAccessory(item.AssetID)end)
    y += 0.11
end
for _,item in pairs(ItemList.Shirts)do
    CreateButton(item.Name,y,function()WearShirt(item.AssetID)end)
    y += 0.11
end
for _,item in pairs(ItemList.Pants)do
    CreateButton(item.Name,y,function()WearPants(item.AssetID)end)
    y += 0.11
end
CreateButton("🔄重置角色",y,ResetChar).BackgroundColor3 = Color3.new(0.7,0.15,0.15)

--角色刷新监听
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
end)
print("✅ UI创建完成，可以穿戴单件饰品自由搭配！")
