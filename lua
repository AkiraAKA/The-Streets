-- Define the GamePass ID for the Boombox
local BOOMBOX_GAMEPASS_ID = 1159109 -- Corrected Boombox GamePass ID

-- Define the message to spam
local SPAM_MESSAGES = {"MEOWBUCKS/MISTAKE", "WISE CRASH SCRIPT"}

-- Anti-chat logging function
local function antiChatLog(message)
    -- Obfuscate or alter the message to avoid logging (simple example)
    local scrambledMessage = string.gsub(message, "a", "4")
    scrambledMessage = string.gsub(scrambledMessage, "e", "3")
    scrambledMessage = string.gsub(scrambledMessage, "o", "0")
    return scrambledMessage
end

-- Function to check GamePass ownership
local function checkGamePass(player)
    local success, hasPass = pcall(function()
        return player:HasGamePass(BOOMBOX_GAMEPASS_ID) -- Updated function for broader compatibility
    end)
    return success and hasPass
end

-- Function to equip and unequip the Boombox
local function equipAndSpamBoombox(player)
    local success, result = pcall(function()
        local character = player.Character or player.CharacterAdded:Wait()
        local backpack = player.Backpack
        local boombox

        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == "Boombox" then
                boombox = tool
                break
            end
        end

        if boombox then
            while true do
                local equipSuccess, equipErr = pcall(function()
                    -- Equip Boombox
                    player.Character.Humanoid:EquipTool(boombox)
                    -- Wait and unequip
                    wait(0.1)
                    player.Character.Humanoid:UnequipTools()

                    -- Spam Messages
                    for _, msg in ipairs(SPAM_MESSAGES) do
                        local chatSuccess, chatErr = pcall(function()
                            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(antiChatLog(msg), "All")
                        end)
                        if not chatSuccess then
                            warn("Error sending chat message: " .. tostring(chatErr))
                        end
                        wait(0.1)
                    end
                end)

                if not equipSuccess then
                    warn("Error occurred while equipping and spamming Boombox: " .. tostring(equipErr))
                end

                wait(0.5) -- Wait to prevent flooding
            end
        else
            warn("Boombox tool not found in backpack.")
        end
    end)

    if not success then
        warn("Error in equipAndSpamBoombox: " .. tostring(result))
    end
end

-- Main Execution
local function main()
    local player = game.Players.LocalPlayer

    if checkGamePass(player) then
        -- Notify the player
        local notifySuccess, notifyErr = pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "Boombox Check",
                Text = "Boombox GamePass detected! Starting spam...",
                Duration = 5
            })
        end)
        if not notifySuccess then
            warn("Notification error: " .. tostring(notifyErr))
        end

        -- Additional notification to contact you and send proof
        local additionalNotifySuccess, additionalNotifyErr = pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "Contact Request",
                Text = "Please add my Discord: meowbucks and DM me with proof if the script worked.",
                Duration = 10
            })
        end)
        if not additionalNotifySuccess then
            warn("Additional notification error: " .. tostring(additionalNotifyErr))
        end

        -- Start equipping and spamming
        equipAndSpamBoombox(player)
    else
        -- Notify the player they do not have the Boombox GamePass
        local notifySuccess, notifyErr = pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "Boombox Check",
                Text = "Boombox GamePass not detected.",
                Duration = 5
            })
        end)
        if not notifySuccess then
            warn("Notification error: " .. tostring(notifyErr))
        end
    end
end

-- Error handling wrapper using xpcall
local function errorHandler(err)
    warn("An error occurred: " .. tostring(err))
end

xpcall(main, errorHandler)
