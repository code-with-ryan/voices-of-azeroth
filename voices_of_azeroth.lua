-- Table mapping quest IDs to their audio files
local questAudioMap = {
    [29730] = "quest_29730_description.mp3",
    [29731] = "quest_29731_description.mp3",
    [29941] = "quest_29941_description.mp3",
    [29937] = "quest_29937_description.mp3",
    [29939] = "quest_29939_description.mp3",
    [29942] = "quest_29942_description.mp3",
    [31239] = "quest_31239_description.mp3"
    -- Add more quests and their audio files here
}

-- Table to track if audio for a quest has been played
local questPlayedMap = {}
for questID in pairs(questAudioMap) do
    questPlayedMap[questID] = false
end

-- Variable to store the current quest ID and audio file being played
local currentQuestID = nil
local currentAudioFile = nil

local just_loaded = true

-- Function to stop the current audio
local function StopQuestAudio()
    -- No direct method to stop a sound using PlaySound, so we'll just reset the state
    if currentAudioFile then
        print("Stopping audio file:", currentAudioFile)
        -- Reset the state
        currentQuestID = nil
        currentAudioFile = nil
    else
        print("No audio file is currently playing.")
    end
end

-- Function to play the quest audio
local function PlayQuestAudio(questID)
    if not questID or questID == 0 then
        print("Error: No valid quest ID provided.")
        return
    end

    -- Handle the just loaded case
    if just_loaded then
        just_loaded = false
        return
    end

    -- Check if the audio for this quest has already been played
    -- if questPlayedMap[questID] then
    --    print("Audio for quest ID:", questID, "has already been played.")
    --    return
    -- end

    -- Stop any currently playing audio for the previous quest
    if currentQuestID and currentQuestID ~= questID then
        print("Stopping audio for previous quest ID:", currentQuestID)
        StopQuestAudio()
    end

    local audioFile = questAudioMap[questID]
    if audioFile then
        local filePath = "Interface\\AddOns\\voices_of_azeroth\\voices\\" .. audioFile
        print("Attempting to play audio file for quest ID:", questID)
        print("File path:", filePath)

        -- Play the audio file using PlaySound()
        local soundID = 1  -- Use a unique sound ID for each sound
        PlaySoundFile(filePath, "Master")  -- Play sound on the Master channel

        -- Track the current audio file
        currentQuestID = questID
        currentAudioFile = audioFile
        questPlayedMap[questID] = true  -- Mark this quest as played
        print("Playing audio:", filePath)
    else
        print("Warning: No audio file found for quest ID:", questID)
    end
end

-- Function to check if a quest is in the log
local function IsQuestInLog(questID)
    local logIndex = C_QuestLog.GetLogIndexForQuestID(questID)
    return logIndex ~= nil
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
    elseif event == "QUEST_FINISHED" then
        -- Stop playing audio when the quest detail window is closed
        print("Quest detail window closed, stopping audio.")
        StopQuestAudio()
    elseif event == "QUEST_ACCEPTED" then
        -- Stop playing audio when the quest is accepted
        print("Quest accepted, stopping audio.")
        StopQuestAudio()
    elseif event == "QUEST_REMOVED" then
        -- Stop playing audio when the quest is removed or completed
        print("Quest removed or completed, stopping audio.")
        StopQuestAudio()
    elseif event == "QUEST_LOG_UPDATE" then
        -- Handle quest log updates
        local selectedQuestID = C_QuestLog.GetSelectedQuest()
        print("QUEST_LOG_UPDATE detected selected quest ID:", selectedQuestID) -- Debug message
        if selectedQuestID and selectedQuestID > 0 then
            if IsQuestInLog(selectedQuestID) then
                PlayQuestAudio(selectedQuestID)
            else
                StopQuestAudio()
            end
        else
            StopQuestAudio()
        end
    end
end

-- Create a frame to listen for quest events
local frame = CreateFrame("Frame")
frame:RegisterEvent("QUEST_DETAIL")
frame:RegisterEvent("QUEST_FINISHED")
frame:RegisterEvent("QUEST_ACCEPTED")
frame:RegisterEvent("QUEST_REMOVED")
frame:RegisterEvent("QUEST_LOG_UPDATE")
frame:SetScript("OnEvent", OnEvent)

-- Test script to manually verify quest ID
local function TestGetQuestID()
    local questID = GetQuestID()
    print("Test GetQuestID() returns quest ID:", questID)
    local selectedQuestID = C_QuestLog.GetSelectedQuest()
    print("Test GetSelectedQuest() returns quest ID:", selectedQuestID)
end
-- Use /run TestGetQuestID() in chat to verify
