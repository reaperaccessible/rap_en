-- Speak Selected Items Length 
-- Version 1.0 - April 2021
-- Announces the sum of all selected item lengths items
-- Chris Goodwin, taking from a script by Pete Torpey 
-- @provides [main=main] .

function Speak( str )
 if reaper.osara_outputMessage then
    reaper.osara_outputMessage(str)
  end
end


function main()
 local oItem, nLength, output

nLength = 0
output = ""
NumTot = reaper.CountSelectedMediaItems()
for i = 0, NumTot-1 do
  oItem = reaper.GetSelectedMediaItem( 0, i)
  nLength = nLength + reaper.GetMediaItemInfo_Value( oItem, "D_LENGTH")
end
  -- convert to project default time mode
   nLength = reaper.format_timestr_len( nLength, nLength, 0, -1 )

Speak ( nLength )
end
main()