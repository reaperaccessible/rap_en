-- @description Insert 1 measure automation item for the last touched FX parameter on selected track
-- @version 1.3
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log
--   # 2024-09-18 - Support track volume and pan envelopes


-- Titre du script
local script_title = 'Insert 1 measure automation item for the last touched FX parameter on selected track'

-- Importer toutes les fonctions de l'API REAPER dans l'espace global
for key in pairs(reaper) do _G[key]=reaper[key] end 

-- Fonction pour obtenir la dernière enveloppe touchée sur la piste sélectionnée
function GetLastTouchedEnvOnSelectedTrack(act_str)
  local sel_track = GetSelectedTrack(0, 0)
  if not sel_track then
    reaper.osara_outputMessage("No track selected")
    return nil
  end

  if act_str == 'Adjust track volume' then
    return GetTrackEnvelopeByName(sel_track, 'Volume')
  elseif act_str == 'Adjust track pan' then
    return GetTrackEnvelopeByName(sel_track, 'Pan')   
  else
    local retval, tracknum, fxnum, paramnum = GetLastTouchedFX()
    if not retval then
      reaper.osara_outputMessage("No FX parameter touched on the selected track")
      return nil
    end    
    local track = CSurf_TrackFromID(tracknum, false)
    if track ~= sel_track then
      reaper.osara_outputMessage("Last touched FX is not on the selected track")
      return nil
    end
    return GetFXEnvelope(track, fxnum, paramnum, true)       
  end
end

-- Fonction pour insérer un item d'automation
function InsertAI(env) 
  if not env then return end
  local AI_pos = GetCursorPosition()
  local cur_pos_beats, cur_pos_measures = TimeMap2_timeToBeats(0, AI_pos)
  local AI_len = TimeMap2_beatsToTime(0, cur_pos_beats, cur_pos_measures+1) - AI_pos
  local new_ai_index = InsertAutomationItem(env, -1, AI_pos, AI_len)
  
  TrackList_AdjustWindows(false)
  UpdateArrange()
  
  -- Confirmation OSARA
  if new_ai_index >= 0 then
    reaper.osara_outputMessage("Automation item added successfully to selected track")
  else
    reaper.osara_outputMessage("Failed to add automation item to selected track")
  end
end

-- Obtenir la dernière action d'annulation
local last_act = Undo_CanUndo2(0)

-- Obtenir la dernière enveloppe touchée sur la piste sélectionnée
local env = GetLastTouchedEnvOnSelectedTrack(last_act)   

-- Insérer l'item d'automation
if env then
  InsertAI(env)
end