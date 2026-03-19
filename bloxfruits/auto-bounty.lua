print("🚀 Script injected! Waiting 22 seconds before starting...")
print("   (Check console for countdown)")

for i = 22, 1, -1 do
    print("   ⏳ " .. i .. " seconds remaining...")
    wait(1)
end

print("✅ Delay complete! Loading config & script NOW...")

getgenv().Config = {
    Team = "Pirates",
    HuntConfig = {
        ["Earned Notification Enabled"] = true,
        ["Farm Delay"] = 0.22,
        ["Webhook"] = {
            Enabled = true,
            Url = "https://discord.com/api/webhooks/1483703956017512519/AiCEE2cTisDvnxoJnWIsGQZuWu-B_9uN7cPBHvOUnYdsc9iOVebrtFqcIaMNSoBcuWYY"
        }
    }
}

loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/2ffcdb62773f587bfb9eb0d52bb35b0c.lua"))()

print("🎉 Script fully loaded & running! Happy farming bro! 💰")
