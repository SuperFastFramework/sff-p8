pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
-- a game by rombosaur studios

--<*entity.lua
--<*timer.lua
--<*tutils.lua
--<*collision.lua
--<*game_state.lua

-- states management
function _init()
	curstate=game_state()
end

function _update()
	curstate.update()
end

function _draw()
	curstate.draw()
end
