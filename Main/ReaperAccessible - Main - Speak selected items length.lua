-- @description Speak selected items length
-- @version 1.2
-- @author Chris Goodwin for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-17 - The code is now commented


-- Fonction pour faire parler le texte via OSARA
function Speak(str)
  -- Vérifie si la fonction osara_outputMessage est disponible
  if reaper.osara_outputMessage then
    -- Si disponible, utilise OSARA pour lire le message
    reaper.osara_outputMessage(str)
  end
end

-- Fonction principale du script
function main()
  local oItem, nLength, output
  nLength = 0
  output = ""
  -- Compte le nombre total d'objets média sélectionnés
  NumTot = reaper.CountSelectedMediaItems()
  
  -- Boucle à travers tous les objets sélectionnés
  for i = 0, NumTot-1 do
    -- Obtient l'objet média sélectionné
    oItem = reaper.GetSelectedMediaItem(0, i)
    -- Ajoute la longueur de l'objet à la longueur totale
    nLength = nLength + reaper.GetMediaItemInfo_Value(oItem, "D_LENGTH")
  end
  
  -- Convertit la longueur totale au format de temps par défaut du projet
  nLength = reaper.format_timestr_len(nLength, nLength, 0, -1)
  
  -- Utilise la fonction Speak pour lire la longueur totale
  Speak(nLength)
end

-- Appelle la fonction principale
main()