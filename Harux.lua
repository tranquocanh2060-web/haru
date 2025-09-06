-- 🌱 Grow a Garden Auto Pet Mutation (Level 50+)
-- UI đẹp bằng OrionLib

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "🌱 Grow a Garden Hub",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = false
})

-- Biến chính
local autoMutation = false
local delayTime = 5

-- Remotes
local RS = game:GetService("ReplicatedStorage")
local Events = RS:WaitForChild("GameEvents")
local MutationMachine = Events:WaitForChild("PetMutationMachineService_RE")
local MutationClaim = Events:WaitForChild("PetMutationClaimAnimation")

-- Hàm mutation
local function mutatePet(pet)
    local petId = pet:GetAttribute("PetId") or pet.Name
    MutationMachine:FireServer("StartMutation", petId)
    task.wait(1)
    MutationClaim:FireServer(petId)
    print("⚡ Đã mutation pet:", pet.Name)
end

-- Thread auto
task.spawn(function()
    while true do
        if autoMutation then
            local petsFolder = game.Players.LocalPlayer:FindFirstChild("Pets") or game.Players.LocalPlayer:FindFirstChild("PetFolder")
            if petsFolder then
                for _, pet in ipairs(petsFolder:GetChildren()) do
                    local levelVal = (pet:FindFirstChild("Level") and pet.Level.Value) or pet:GetAttribute("Level") or 0
                    if levelVal >= 50 then
                        mutatePet(pet)
                    end
                end
            end
        end
        task.wait(delayTime)
    end
end)

-- Tab chính
local Tab = Window:MakeTab({
    Name = "⚙️ Auto Pet",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddToggle({
    Name = "Auto Mutation (Lv.50+)",
    Default = false,
    Callback = function(value)
        autoMutation = value
    end
})

Tab:AddSlider({
    Name = "⏱️ Delay giữa mỗi lần (giây)",
    Min = 1,
    Max = 60,
    Default = 5,
    Color = Color3.fromRGB(0,255,0),
    Increment = 1,
    ValueName = "s",
    Callback = function(value)
        delayTime = value
    end
})

OrionLib:Init()

