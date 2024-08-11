# Voices of Azeroth

**Voices of Azeroth** is a World of Warcraft addon designed to play custom audio clips when interacting with quest-related NPCs. This addon enhances the questing experience by providing audio cues for specific quests.

## Features

- **Play Custom Audio**: Automatically plays specific audio files associated with quests when interacting with NPCs.
- **Stop Audio**: Stops the currently playing audio when the quest detail window is closed or when a new quest is selected.
- **Event Handling**: Responds to various quest-related events to manage audio playback.

## Installation

1. **Download the Addon**: Download the latest version of the Voices of Azeroth addon.
2. **Extract the Files**: Extract the downloaded ZIP file into your World of Warcraft addons folder. This is usually located at `World of Warcraft/_retail_/Interface/AddOns/`.
3. **Verify File Structure**: Ensure that the addon folder structure looks like this:
    ```
    World of Warcraft/
    └── _retail_/
        └── Interface/
            └── AddOns/
                └── voices_of_azeroth/
                    ├── voices_of_azeroth.lua
                    └── voices/
                        └── [Your Audio Files].mp3
    ```
4. **Launch World of Warcraft**: Start the game and enable the Voices of Azeroth addon from the AddOns menu on the character selection screen.

## Configuration

1. **Add Quest Audio**:
    - Open the `voices_of_azeroth.lua` file located in the `voices_of_azeroth` folder.
    - Locate the `questAudioMap` table in the file.
    - Add the quest IDs and corresponding audio file names for the quests you want to provide audio for. The format should be:
      ```lua
      local questAudioMap = {
          [QuestID] = "audio_file_name.mp3",
          -- Add more quests and their audio files here
      }
      ```
    - To get the quest IDs:
        - Visit [Wowhead's Quest Database](https://www.wowhead.com/quests).
        - Search for the quest you want to add audio for.
        - Find the quest ID in the URL of the quest page. For example, if the URL is `https://www.wowhead.com/quest=29941`, the quest ID is `29941`.
        - Add this quest ID and the corresponding audio file name to the `questAudioMap` table in the format shown above.

2. **Audio Files**:
    - Place your audio files in the `voices` directory within the addon folder.
    - Ensure the file names and paths match those defined in the `questAudioMap` table.

## Usage

- **Viewing Quest Details**: When interacting with an NPC that has a quest, the addon will automatically play the associated audio file if configured.
- **Stopping Audio**: Audio playback stops when the quest detail window is closed or when a new quest is selected.

## Troubleshooting

- **Audio Not Playing**: Ensure the audio file paths are correct and the files are in the MP3 format. Verify that the file names match those specified in `questAudioMap`.
- **Errors on Stopping Audio**: If you encounter errors related to stopping audio, verify that the `StopMusic` function is being called correctly and that no other addon conflicts are causing issues.

## Development

- **Contributions**: Contributions to the addon are welcome. If you find any bugs or have feature requests, please submit an issue or pull request on the project's repository.
- **Debugging**: The addon includes debug statements that print information about events and audio playback. These can be useful for troubleshooting issues.

## License

This addon is released under the [MIT License](LICENSE).
