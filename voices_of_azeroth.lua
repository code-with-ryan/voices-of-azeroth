-- Table mapping quest IDs to their audio files
local questAudioMap = {
    [29941] = "quest_29941_objective.mp3",
    -- Add more quests and their audio files here
}

-- Variable to store the current quest ID being played
local currentQuestID = nil
local currentAudioFile = nil

-- Function to play the quest audio
local function PlayQuestAudio(questID)
    if not questID or questID == 0 then
        print("No valid quest ID provided.")
        return
    end

    -- Stop any currently playing audio for the previous quest
    if currentQuestID and currentQuestID ~= questID then
        print("Stopping audio for previous quest ID:", currentQuestID)
        StopQuestAudio()  -- Custom function to stop the current audio
    end

    local audioFile = questAudioMap[questID]
    if audioFile then
        local filePath = "Interface\\AddOns\\voices_of_azeroth\\voices\\" .. audioFile
        print("Attempting to play audio file for quest ID:", questID)
        print("File path:", filePath)
        PlayMusic(filePath)
        currentQuestID = questID
        currentAudioFile = audioFile
    else
        print("No audio file found for quest ID:", questID)
    end
end

-- Function to stop the current audio
local function StopQuestAudio()
    if currentAudioFile then
        print("Stopping audio file:", currentAudioFile)
        StopMusic()  -- Stop the currently playing music
        currentQuestID = nil
        currentAudioFile = nil
    else
        print("No audio file is currently playing.")
    end
end

-- Function to handle quest events
local function OnEvent(self, event, ...)
    print("Event triggered:", event) -- Debug message

    if event == "QUEST_DETAIL" then
        -- Play audio when viewing the quest detail screen (this triggers when clicking an NPC with a quest)
        print("QUEST_DETAIL event triggered.") -- Debug message
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
            PlayQuestAudio(selectedQuestID)
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
