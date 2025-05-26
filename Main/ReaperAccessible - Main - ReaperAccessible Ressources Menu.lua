-- @description ReaperAccessible Ressources Menu
-- @version 1.5
-- @author Lee JULIEN for ReaperAccessible
-- @provides [main=main] .
-- @changelog
--   # 2024-09-18 - Adding log
--   # 2025-05-26 - Link Corection


-- Fonction pour ouvrir une page web
local function openURL(url)
 local OS = reaper.GetOS()
 if OS == "OSX32" or OS == "OSX64" then
  os.execute('open "" "' .. url .. '"')
 else
  os.execute('start "" "' .. url .. '"')
 end
end

-- Liste des noms de sous-menus
local subMenus = {
 {
  name = "ReaperAccessible Web Site.",
  actions = {
   {name = "ReaperAccessible Home Page Here.", url = "https://reaperaccessible.com"}
  }
 },
 {
  name = "ReaperAccessible KeyMaps",
  actions = {
   {name = "Download the ReaperAccessible KeyMaps here.", url = "https://reaperaccessible.fr/archives/KeyMaps%20ReaperAccessible.zip"},
   {name = "KeyMaps log changes here.", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=540&Itemid=297&lang=en-us"},
   {name = "KeyMaps keyboard shortcuts page here.", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=541&Itemid=298&lang=en-us"},
   {name = "Download S-W-S extension here.", url = "https://reaperaccessible.fr/archives/S%20W%20S%2064-bit.zip"},
   {name = "Learn how to install the KeyMaps, S-W-S extension and scripts here.", url = "https://reaperaccessible.fr/tutoriels/01.7%20How%20to%20install%20S%20W%20S,%20the%20ReaperAccessible%20scripts%20with%20ReaPack%20and%20KeyMap.mp3"}
  }
 },
 {
  name = "Audio Samples for Metronome",
  actions = {
   {name = "Download Audio Samples for Metronome Here", url = "https://reaperaccessible.fr/archives/Dossier%20d'%C3%A9chantillons%20pour%20le%20m%C3%A9tronome.zip"},
  }
 },
 {
  name = "DrumAccess",
  actions = {
   {name = "DrumAccess Overview Here", url = "https://reaperaccessible.fr/drumaccess/tutoriels/english/DrumAccess%20-%20Free%20Kit%20Demo%20-%20English.mp3"},
   {name = "Create an account Here", url = "https://reaperaccessible.fr/index.php?option=com_users&view=registration&Itemid=233&lang=en-us"},
   {name = "Subscribe to the DrumAccess newsletter Here", url = "https://reaperaccessible.fr/index.php?option=com_phocaemail&view=newsletter&Itemid=260&lang=en-us"},
   {name = "How to install a DrumAccess library Here", url = "https://reaperaccessible.fr/drumaccess/tutoriels/english/DrumAccess%20-%20How%20to%20install%20DrumAccess.mp3"},
   {name = "How to install and use DrumAccess Scripts. Here", url = "https://reaperaccessible.fr/drumaccess/tutoriels/english/DrumAccess%20-%20How%20to%20Install%20and%20use%20DrumAccess%20Scripts.mp3"},
   {name = "How to install and use Hard Link Software Here", url = "https://reaperaccessible.fr/drumaccess/tutoriels/english/DrumAccess%20-%20How%20to%20install%20and%20use%20HardLink%20software.mp3"},
   {name = "DrumAccess - Free Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=393:drumaccess-free-kit-en&catid=67&lang=en-us&Itemid=219"},
   {name = "DrumAccess - C&C - Player Date II Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=407:drumacces-candc-player-date-ii-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Camco - Oaklawn Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=409:drumaccess-camco-oaklawn-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Canopus - Maple Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=386:drumacces-canopus-maple-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Craviotto - Solid Shell Walnut Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=382:drumaccess-craviotto-solid-shell-walnut-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - DW - Collectors Maple Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=379:drumaccess-dw-collectorsmaplekit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Fibes - Maple Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=389:drumaccess-fibes-maple-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Gretsch - Broadkaster Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=413:da-gretsch-broadkaster-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Ludwig - Calfskin 1930s Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=390:drumaccess-ludwig-calfskin-1930s-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Ludwig - Stainless Steel Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=381:drumaccess-ludwig-stainlesssteelkit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Ludwig - Superclassic 70s Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=415:drumaccess-ludwig-superclassic-70s-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Mayer - Bros Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=417:drumaccess-mayer-bros-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Pearl - Masters Extra Maple Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=384:drumacces-pearl-masters-extra-maple-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Percussions Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=396:drumaccess-percussions-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Q Drum Co. - Copper Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=400:drumaccess-q-drum-co-copper-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Slingerland - Radio King 1940s Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=402:drumaccess-slingerland-radio-king-1940s-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Tama - Starclassic Performer Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=419:drumaccess-tama-starclassic-performer-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Yamaha - Recording Custom Kit Page Here", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=423:drumaccess-yamaha-recording-custom-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Gretsch - Broadkaster Kit Damped", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=436:drumaccess-gretsch-usa-custom-kit-damped-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Gretsch - 60s Round Badge Kit Damped", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=429:drumaccess-gretsch-60s-round-badge-kit-damped-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - DW - Deep Blue Oyster Kit", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=434:drumaccess-dw-deep-blue-oyster-kit-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Gretsch - USA Custom Kit - Damped", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=436:drumaccess-gretsch-usa-custom-kit-damped-en&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Mapex - Velvetone Kit", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=439:drumaccess-mapex-velvetone-kit&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Mapex - Mars Birtch Shell Kit", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=444:drumaccess-mapex-mars-birtch-shell-kit&catid=61&lang=en-us&Itemid=219"},
   {name = "DrumAccess - Ludwig - 1950s Kit", url = "https://reaperaccessible.fr/index.php?option=com_content&view=article&id=520:drumaccess-ludwig-1950s-kit&catid=61&lang=en-us&Itemid=219"},
  }
 },
}

-- Fonction pour afficher le menu principal
local function showMainMenu()
 local menu_str = ""
 for i, subMenu in ipairs(subMenus) do
  menu_str = menu_str .. subMenu.name .. "|"
 end
 local selection = gfx.showmenu(menu_str)
 if selection > 0 then
  local selectedSubMenu = subMenus[selection]
  local actions = selectedSubMenu.actions
  local actions_str = ""
  for i, action in ipairs(actions) do
   actions_str = actions_str .. action.name .. "|"
  end
  local actionSelection = gfx.showmenu(actions_str)
  if actionSelection > 0 then
   openURL(actions[actionSelection].url)
  end
 end
end

-- Appel de la fonction pour afficher le menu principal
showMainMenu()
