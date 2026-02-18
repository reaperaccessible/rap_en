-- @description Select Next Chord
-- @version 1.1
-- @author Lee JULIEN pour ReaperAccessible augmented by Chessel
-- @provides [main=midi_editor] .
-- @changelog
--   #2026-02-17 - New script
--   #2026-02-18 - Bug fix


local tolerance = 15 

function Announce(message)
    reaper.osara_outputMessage(message)
end

local editor = reaper.MIDIEditor_GetActive()
if not editor then return end
local take = reaper.MIDIEditor_GetTake(editor)
if not take or not reaper.TakeIsMIDI(take) then return end

-- Get current cursor position in PPQ
local currentPos = reaper.MIDI_GetPPQPosFromProjTime(take, reaper.GetCursorPosition())
local _, noteCount = reaper.MIDI_CountEvts(take)
local starts = {}
local groups = {}

-- 1. Analyze positions (searching forwards)
for i = 0, noteCount - 1 do
    local _, _, _, s = reaper.MIDI_GetNote(take, i)
    -- Look for notes AFTER the cursor (with a small 5 PPQ safety margin)
    if s > currentPos + 5 then
        -- Rounding for tolerance
        local key = math.floor(s / tolerance + 0.5) * tolerance
        if not groups[key] then
            groups[key] = 0
            table.insert(starts, key)
        end
        groups[key] = groups[key] + 1
    end
end

-- Sort ascending to find the next chord in time
table.sort(starts)

local targetStart = nil
for _, s in ipairs(starts) do
    if groups[s] >= 2 then
        targetStart = s
        break
    end
end

if not targetStart then
    Announce("No more chords found")
    return
end

-- 2. Update Selection
-- Disable auto-sorting during modification for better performance
reaper.MIDI_DisableSort(take)

for i = 0, noteCount - 1 do
    local _, sel, muted, startppq, endppq, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
    
    -- If the note starts within our tolerance zone
    if math.abs(startppq - targetStart) <= tolerance then
        reaper.MIDI_SetNote(take, i, true, muted, startppq, endppq, chan, pitch, vel, false)
    else
        reaper.MIDI_SetNote(take, i, false, muted, startppq, endppq, chan, pitch, vel, false)
    end
end

-- Re-enable sorting and refresh
reaper.MIDI_Sort(take)
reaper.SetEditCurPos(reaper.MIDI_GetProjTimeFromPPQPos(take, targetStart), true, false)
reaper.UpdateArrange()

Announce("Chord with " .. groups[targetStart] .. " notes selected")