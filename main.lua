pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
-- made with super-fast-framework

------------------------- Start Imports
--<*sff/entity.lua
--<*sff/timer.lua
--<*sff/tutils.lua
--  --<*sff/collision.lua
--  --<*sff/explosions.lua
--  --<*sff/buttons.lua

--<*visual.lua
--<*menu_state.lua
--<*game_state.lua
--<*gameover_state.lua
--<*win_state.lua
--------------------------- End Imports

-- To enable MOUSE support uncomment ALL of the following commented lines:
-- poke(0x5F2D, 1) -- enables mouse support
function _init()
    curstate=menu_state()
end

function _update()
    -- mouse utility global variables
    -- mousex=stat(32)
    -- mousey=stat(33)
    -- lclick=stat(34)==1
    -- rclick=stat(34)==2
    -- mclick=stat(34)==4
	curstate.update()
end

function _draw()
    curstate.draw()
    -- pset(mousex,mousey, 12) -- draw your pointer here
end
