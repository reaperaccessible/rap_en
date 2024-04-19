-- @description Set grid division via a menu
-- @version 1.1
-- @author Ludovic SANSONE for Reaper Accessible
-- @provides [main=main] .


local ret, grid = reaper.GetSetProjectGrid(0, 0)

local dict = {
    {1.0, 4, "4 measures"},
    {2.0, 3, "3 measures"},
    {3.0, 2, "2 measures"},    
    {4.0, 1, "1 measure "},
    {5.0, 1/2, "1/2"},
    {6.0, 1/4, "1/4"},
    {7.0, 1/8, "1/8"},
    {8.0, 1/16, "1/16"},
    {9.0, 1/32, "1/32"},
    {10.0, 1/64, "1/64"},
    {11.0, 1/128, "1/128"},
    {12.0, 2/3, "2/3"},
    {13.0, 1/3, "1/3"},
    {14.0, 1/6, "1/6"},
    {15.0, 1/12, "1/12"},
    {16.0, 1/24, "1/24"},
    {17.0, 1/48, "1/48"},
    {18.0, 1/5, "1/5"},
    {19.0, 1/7, "1/7"},
    {20.0, 1/9, "1/9"},
    {21.0, 1/10, "1/10"},
    {22.0, 1/18, "1/18"}
}

function buildMenu(d, g)
    local menu = ""

    menu = ">Binary"

    for i = 1, 11 do
        menu = menu .. "|"
        if i == 11 then
            menu = menu .. "<"
        end
        if g == d[i][2] then
            menu = menu .. "!"
        end
        menu = menu .. d[i][3]
    end

    menu = menu .. "|>Ternary"

    for i = 12, 17 do
        menu = menu .. "|"
        if i == 17 then
            menu = menu .. "<"
        end
        if g == d[i][2] then
            menu = menu .. "!"
        end
        menu = menu .. d[i][3]
    end

    menu = menu .. "|>Other"

    for i = 18, 22 do
        menu = menu .. "|"
        if i == 22 then
            menu = menu .. "<"
        end
        if g == d[i][2] then
            menu = menu .. "!"
        end
        menu = menu .. d[i][3]
    end
    return menu
end

function getDivision(sel, d)
    for i = 1, 22 do
        if sel == d[i][1] then
            return d[i][2], d[i][3]
        end
    end
    return 0, "invalide"
end

gfx.init('Grille de division', 0, 0, 0, 0, 0)

local selection = gfx.showmenu(buildMenu(dict, grid))

local division, msg = getDivision(selection, dict)

if division > 0 then
    reaper.SetProjectGrid(0, division)
    reaper.SetMIDIEditorGrid(0, division)
    reaper.osara_outputMessage(msg .. " set as division value")
end

gfx.quit()
