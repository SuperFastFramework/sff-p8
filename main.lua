pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
-- a game by rombosaur studios

--<*entity.lua
--<*timer.lua
--<*tutils.lua
--  --<*collision.lua
--  --<*explosions.lua

--<*menu_state.lua
--<*game_state.lua
--<*gameover_state.lua
--<*win_state.lua

-- states management
function _init()
    curstate=menu_state()
    tick=0 -- all purpose tick counter
end

function _update()
    tick+=1
	curstate.update()
end

function _draw()
	curstate.draw()
end
