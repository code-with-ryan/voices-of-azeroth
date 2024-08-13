-- Table mapping quest IDs to their audio files and wait times
local questAudioMap = {
    [29730] = {file = "quest_29730_description.mp3", waitTime = 4},
    [29731] = {file = "quest_29731_description.mp3", waitTime = 3},
    [29941] = {file = "quest_29941_description.mp3", waitTime = 1},
    [29937] = {file = "quest_29937_description.mp3", waitTime = 1},
    [29939] = {file = "quest_29939_description.mp3", waitTime = 1},
    [29942] = {file = "quest_29942_description.mp3", waitTime = 1},
    [31239] = {file = "quest_31239_description.mp3", waitTime = 1}
    -- Add more quests and their audio files and wait times here
}

-- Table to track if audio for a quest has been played
local questPlayedMap = {}
for questID in pairs(questAudioMap) do
    questPlayedMap[questID] = false
end

-- Variable to store the current quest ID and audio file being played
local currentQuestID = nil
local currentAudioFile = nil

-- Function to play the quest audio using PlayMusic after a delay
local function PlayQuestAudio(questID)
    if not questID or questID == 0 then
        print("Error: No valid quest ID provided.")
        return
    end

    local questData = questAudioMap[questID]
    if questData then
        local filePath = "Interface\\AddOns\\voices_of_azeroth\\voices\\" .. questData.file
        print("Attempting to play audio file for quest ID:", questID)
        print("File path:", filePath)

        -- Set a timer to delay the audio playback
        local delayInSeconds = questData.waitTime or 2 -- Use the specific delay time or default to 2 seconds
        C_Timer.After(delayInSeconds, function()
            
            -- Play the audio file 
            PlaySoundFile(filePath, "Master")  

            -- Track the current audio file
            currentQuestID = questID
            currentAudioFile = questData.file
            questPlayedMap[questID] = true  -- Mark this quest as played
            print("Playing audio after delay:", filePath)
        end)
    else
        print("Warning: No audio file found for quest ID:", questID)
    end
end

-- Function to handle quest events
local function OnEvent(self, event, ...)
    print("Event triggered:", event) -- Debug message

    if event == "QUEST_DETAIL" then
        -- Play audio when viewing the quest detail screen (this triggers when clicking an NPC with a quest)
        local questID = GetQuestID()
        print("QUEST_DETAIL detected quest ID:", questID) -- Debug message
        if questID and questID > 0 then
            PlayQuestAudio(questID)
        else
            print("No valid quest ID found in QUEST_DETAIL event.")
        end
    end
end

-- Create a frame to listen for quest events
local frame = CreateFrame("Frame")
frame:RegisterEvent("QUEST_DETAIL")
frame:SetScript("OnEvent", OnEvent)

-- Test script to manually verify quest ID
local function TestGetQuestID()
    local questID = GetQuestID()
    print("Test GetQuestID() returns quest ID:", questID)
    local selectedQuestID = C_QuestLog.GetSelectedQuest()
    print("Test GetSelectedQuest() returns quest ID:", selectedQuestID)
end
-- Use /run TestGetQuestID() in chat to verify
