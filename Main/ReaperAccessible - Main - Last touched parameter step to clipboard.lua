-- @description Last touched parameter step to clipboard
-- @version 1.2
-- @author Ludovic SANSONE for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log
--   # 2024-09-22 - The code is now commented


-- Fonction pour arrondir un nombre
local function round(number)
    local rest = number % 1;
    if (rest < 0.5) then
        return math.floor(number);  -- Arrondir vers le bas si le reste est inférieur à 0.5
    else
        return math.ceil(number);   -- Arrondir vers le haut si le reste est supérieur ou égal à 0.5
    end
end

-- Fonction pour afficher ou parler un message
local function speak(str, showAlert)
    showAlert = showAlert or false;
    if reaper.osara_outputMessage then
        reaper.osara_outputMessage(str);  -- Utiliser OSARA pour la sortie vocale si disponible
    elseif (showAlert) then
        reaper.MB(str, 'Script message', 0);  -- Afficher une boîte de message si OSARA n'est pas disponible
    end
end

-- Fonction pour obtenir les données d'un effet (FX)
local function getFxData(trackId, fxId, paramId)
    trackId = trackId or 0;  -- Utiliser la piste 0 par défaut
    fxId = fxId or 0;        -- Utiliser l'effet 0 par défaut
    paramId = paramId or 9;  -- Utiliser le paramètre 9 par défaut
    
    local track = reaper.GetTrack(0, trackId);
    local _, fxName = reaper.TrackFX_GetFXName(track, fxId);
    local _, paramName = reaper.TrackFX_GetParamName(track, fxId, paramId);
    local _, step, smallstep, largestep, istoggle = reaper.TrackFX_GetParameterStepSizes(
        track,
        fxId,
        paramId
    );
    
    local nbSteps = round(1 / step);  -- Calculer le nombre d'étapes
    local stepslist = '';
    local result = string.format('Fx-Name: %s\nParam: %s\nParamId: %s\n', fxName, paramName, paramId);
    
    if (istoggle) then
        -- Si le paramètre est une bascule (toggle)
        result = result .. 'Param is a toggle';
        stepslist = stepslist .. '[ 0.0 1.0 ]';
        local action = reaper.MB(result, 'Steps for' .. fxName, 1);
        if (action == 1) then
            reaper.CF_SetClipboard(stepslist);  -- Copier la liste des étapes dans le presse-papiers
        end
    elseif (nbSteps > 1 and nbSteps .. '' ~= 'inf' and nbSteps .. '' ~= '1.#INF') then
        -- Si le paramètre a des étapes valides
        result = result .. string.format('Number of Steps: %s', nbSteps);
        stepslist = stepslist .. '[ 0.0'
        for i = 1, nbSteps - 1 do
            stepslist = stepslist .. ' ' .. string.sub((i * step) .. '', 1, 6)  -- Ajouter chaque étape à la liste
        end
        stepslist = stepslist .. ' 1.0 ]';
        local action = reaper.MB(result, 'Steps for' .. fxName, 1);
        if (action == 1) then
            reaper.CF_SetClipboard(stepslist);  -- Copier la liste des étapes dans le presse-papiers
        end
    else
        -- Si le paramètre n'a pas d'étapes
        speak('Param has no steps', true);
    end
end

-- Fonction principale
local function main()
    local retval, tracknumber, fxnumber, paramnumber = reaper.GetLastTouchedFX();
    if (retval) then
        getFxData(tracknumber - 1, fxnumber, paramnumber);  -- Obtenir les données du dernier FX touché
    else
        speak('No parameter selected', true);  -- Aucun paramètre sélectionné
    end
end

-- Exécution de la fonction principale
main()