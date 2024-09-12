-- @description Insert empty space depending time selection (respecting ripple mode
-- @version 1.0
-- @author Lee JULIEN for Reaper Accessible
-- @provides [main=main] .


-- Configuration utilisateur
undo_text = "Insert empty space according to time selection"

-- Fonction pour obtenir le mode ripple actuel
function GetRippleMode()
  return reaper.SNM_GetIntConfigVar("projripedit", -1)
end

-- Fonction pour convertir le temps en mesures, battements et pourcentage de battement
function TimeToMeasuresBeatsPercent(time)
  local retval, measures, cml, fullbeats, cdenom = reaper.TimeMap2_timeToBeats(0, time)
  local whole_beats = math.floor(fullbeats)
  local beat_fraction = fullbeats - whole_beats
  local beat_percent = math.floor(beat_fraction * 100 + 0.5)  -- Arrondi au centième le plus proche
  return measures, whole_beats, beat_percent
end

-- Fonction principale
function Main()
  -- Vérifier le mode ripple
  local ripple_mode = GetRippleMode()
  if ripple_mode == 0 then
    local message = "Ripple mode is disabled. You must set ripple mode per track or all tracks to use this script."
    reaper.ShowMessageBox(message, "Warning", 0)
    reaper.osara_outputMessage(message)
    return
  end

  -- Obtenir les points de début et de fin de la sélection temporelle
  local start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)
  
  -- Calculer la durée de l'espace à insérer
  local duration = end_time - start_time
  
  -- Vérifier si une sélection temporelle valide existe
  if duration <= 0 then
    reaper.ShowMessageBox("Please select a valid time range.", "Error", 0)
    return
  end
  
  -- Début de l'action
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()
  
  -- Insérer l'espace vide
  reaper.Main_OnCommand(40200, 0)  -- Time selection: Insert empty space at time selection (moving later items)
  
  -- Fin de l'action
  reaper.Undo_EndBlock(undo_text, -1)
  reaper.PreventUIRefresh(-1)
  
  -- Actualiser l'interface
  reaper.UpdateArrange()
  
  -- Convertir la durée en mesures, battements et pourcentage de battement
  local measures, beats, beat_percent = TimeToMeasuresBeatsPercent(duration)
  
  -- Préparer le message
  local message = string.format("Empty space inserted: %d.%d.%02d", 
                                measures, beats, beat_percent)
  
  -- Afficher le message pour les utilisateurs non-voyants
  reaper.osara_outputMessage(message)
end

-- Exécution du script
Main()