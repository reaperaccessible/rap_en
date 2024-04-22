-- @description Opens a menu containing the resources offered by ReaperAccessible.
-- @version 1.1
-- @author Lee JULIEN for Reaper Accessible
-- @provides [main=main] .


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
   {name = "ReaperAccessible Home Page Here.", url = "https://reaperaccessible.fr/index.php/en-us/"}
  }
 },
 {
  name = "ReaperAccessible KeyMaps",
  actions = {
   {name = "KeyMaps log changes here.", url = "https://reaperaccessible.fr/archives/Log/ReaperAccessible%20KeyMap%20Log.html"},
   {name = "Download the ReaperAccessible KeyMaps here.", url = "https://reaperaccessible.fr/archives/KeyMap%20et%20scripts%20ReaperAccessible.zip"},
   {name = "KeyMaps keyboard shortcuts page here.", url = "https://reaperaccessible.fr/archives/Log/KeyMap%20ReaperAccessible%20keyboard%20shortcuts%20list%20ENUS.html"},
   {name = "Download S-W-S extension here.", url = "https://reaperaccessible.fr/archives/S%20W%20S%2064-bit.zip"},
   {name = "Learn how to install the KeyMaps, S-W-S extension and scripts here.", url = "https://reaperaccessible.fr/archives/Log/How%20to%20install%20S_W_S,%20ReaperAccessible%20scripts%20and%20KeyMap.html"}
  }
 },
 {
  name = "Audio Samples for Metronome",
  actions = {
   {name = "Download Audio Samples for Metronome Here", url = "https://reaperaccessible.fr/archives/Dossier%20d'%C3%A9chantillons%20pour%20le%20m%C3%A9tronome.zip"},
  }
 },
 {
  name = "LBL Add-on for NVDA",
  actions = {
   {name = "Clic here to learn more about LBL", url = "https://reaperaccessible.fr/index.php/en-us/lbl-for-nvda"},
  }
 },
 {
  name = "DrumAccess",
  actions = {
   {name = "DrumAccess Overview Here", url = "https://reaperaccessible.fr/drumaccess/tutoriels/english/DrumAccess%20-%20Free%20Kit%20Demo%20-%20English.mp3"},
   {name = "Create an account Here", url = "https://reaperaccessible.fr/index.php/en-us/register"},
   {name = "Subscribe to the DrumAccess newsletter Here", url = "https://reaperaccessible.fr/index.php/en-us/news-letter"},
   {name = "How to install a DrumAccess library Here", url = "https://reaperaccessible.fr/drumaccess/tutoriels/english/DrumAccess%20-%20How%20to%20install%20DrumAccess.mp3"},
   {name = "How to install and use DrumAccess Scripts. Here", url = "https://reaperaccessible.fr/drumaccess/tutoriels/english/DrumAccess%20-%20How%20to%20Install%20and%20use%20DrumAccess%20Scripts.mp3"},
   {name = "How to install and use Hard Link Software Here", url = "https://reaperaccessible.fr/drumaccess/tutoriels/english/DrumAccess%20-%20How%20to%20install%20and%20use%20HardLink%20software.mp3"},
   {name = "DrumAccess - Free Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drumaccess-free-kit-en"},
   {name = "DrumAccess - C&C - Player Date II Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumacces-candc-player-date-ii-kit-en"},
   {name = "DrumAccess - Camco - Oaklawn Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-camco-oaklawn-kit-en"},
   {name = "DrumAccess - Canopus - Maple Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumacces-canopus-maple-kit-en"},
   {name = "DrumAccess - Craviotto - Solid Shell Walnut Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-craviotto-solid-shell-walnut-kit-en"},
   {name = "DrumAccess - DW - Collectors Maple Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-dw-collectorsmaplekit-en"},
   {name = "DrumAccess - Fibes - Maple Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-fibes-maple-kit-en"},
   {name = "DrumAccess - Gretsch - Broadkaster Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/da-gretsch-broadkaster-kit-en"},
   {name = "DrumAccess - Ludwig - Calfskin 1930s Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-ludwig-calfskin-1930s-kit-en"},
   {name = "DrumAccess - Ludwig - Stainless Steel Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-ludwig-stainlesssteelkit-en"},
   {name = "DrumAccess - Ludwig - Superclassic 70s Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-ludwig-superclassic-70s-kit-en"},
   {name = "DrumAccess - Mayer - Bros Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-mayer-bros-kit-en"},
   {name = "DrumAccess - Pearl - Masters Extra Maple Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumacces-pearl-masters-extra-maple-kit-en"},
   {name = "DrumAccess - Percussions Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-percussions-kit-en"},
   {name = "DrumAccess - Q Drum Co. - Copper Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-q-drum-co-copper-kit-en"},
   {name = "DrumAccess - Slingerland - Radio King 1940s Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-slingerland-radio-king-1940s-kit-en"},
   {name = "DrumAccess - Tama - Starclassic Performer Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-tama-starclassic-performer-kit-en"},
   {name = "DrumAccess - Yamaha - Recording Custom Kit Page Here", url = "https://reaperaccessible.fr/index.php/en-us/drumaccessen/drum-access-english/drumaccess-yamaha-recording-custom-kit-en"},
   {name = "DrumAccess - Gretsch - Broadkaster Kit Damped", url = "https://reaperaccessible.fr/index.php/fr/drumaccess-librairies-de-batterie/drumaccess/da-gretsch-broadkaster-kit-damped-fr"},
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
