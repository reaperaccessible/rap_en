-- @description Select every other note of same pitch in of selected items
-- @version 1.0
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=midi_editor] .
-- @changelog
--   # 2024-09-24 - New script


-- Function to speak a message
local function speak(message)
    reaper.osara_outputMessage(message)
end

function Main()
  local items = reaper.CountSelectedMediaItems(0)
  if items == 0 then
    speak("No item selected. Please select at least one MIDI item.")
    return
  end

  local total_selected_notes = 0
  for i = 0, items - 1 do
    local item = reaper.GetSelectedMediaItem(0, i)
    local take = reaper.GetActiveTake(item)
    if reaper.TakeIsMIDI(take) then
      total_selected_notes = total_selected_notes + ProcessMIDITake(take)
    end
  end

  if total_selected_notes == 0 then
    speak("No notes have been selected. Make sure you have selected at least two notes of the same pitch.")
  else
    speak(string.format("%d notes have been selected.", total_selected_notes))
  end
end

function ProcessMIDITake(take)
  local _, notecnt, _, _ = reaper.MIDI_CountEvts(take)
  local selected_notes = {}
  local pitch_to_process = nil

  -- Find the first selected note and its pitch
  for i = 0, notecnt - 1 do
    local _, selected, _, _, _, _, pitch, _ = reaper.MIDI_GetNote(take, i)
    if selected then
      pitch_to_process = pitch
      break
    end
  end

  if not pitch_to_process then
    return 0  -- No note selected in this item
  end

  -- Collect all notes of the same pitch
  for i = 0, notecnt - 1 do
    local _, selected, _, startppqpos, _, _, pitch, _ = reaper.MIDI_GetNote(take, i)
    if pitch == pitch_to_process then
      table.insert(selected_notes, {index = i, startppqpos = startppqpos, selected = selected})
    end
  end

  if #selected_notes < 2 then
    speak("Only one note is selected. You need to select 2 or more notes of the same pitch to use this script.")
    return 0
  end

  -- Sort notes by position
  table.sort(selected_notes, function(a, b) return a.startppqpos < b.startppqpos end)

  -- Find the index of the initially selected note
  local initial_selected_index = 1
  for i, note in ipairs(selected_notes) do
    if note.selected then
      initial_selected_index = i
      break
    end
  end

  -- Select every other note, starting from the note following the initially selected one
  local count_selected = 0
  for i = initial_selected_index + 1, #selected_notes, 2 do
    reaper.MIDI_SetNote(take, selected_notes[i].index, true, nil, nil, nil, nil, nil, nil, false)
    count_selected = count_selected + 1
  end

  -- Select every other note before the initially selected note
  for i = initial_selected_index - 1, 1, -2 do
    reaper.MIDI_SetNote(take, selected_notes[i].index, true, nil, nil, nil, nil, nil, nil, false)
    count_selected = count_selected + 1
  end

  -- Deselect the initially selected note
  reaper.MIDI_SetNote(take, selected_notes[initial_selected_index].index, false, nil, nil, nil, nil, nil, nil, false)

  reaper.MIDI_Sort(take)
  return count_selected
end

-- Main function
reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()
Main()
reaper.Undo_EndBlock("Select every other note of same pitch in selected items", -1)
reaper.PreventUIRefresh(-1)
reaper.UpdateArrange()