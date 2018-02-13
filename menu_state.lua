-- state
function menu_state()
    local state={}
    local texts={}
    
	add(texts, tutils({text="game title",centerx=true,y=8,fg=8,bg=0,bordered=true,shadowed=true,sh=2}))
	add(texts, tutils({text="rombosaur studios",centerx=true,y=99,fg=9,sh=2,shadowed=true}))
	-- add(texts, tutils({text="shoot: 🅾️   move: ⬅️➡️⬆️⬇️",x=12,y=60, fg=0,bg=1,shadowed=true, sh=7}))
	add(texts, tutils({text="press ❎ to start", blink=true, on_time=15, centerx=true,y=80,fg=0,bg=1,shadowed=true, sh=7}))
	add(texts, tutils({text="v0.1", x=106, y=97}))

	local ypos = 111
	add(texts, tutils({text="🅾️             ❎  ", centerx=true, y=ypos, shadowed=true, bordered=true, fg=8, bg=0, sh=2}))
	add(texts, tutils({text="  buttons  ", centerx=true, y=ypos, shadowed=true, fg=7, sh=0}))
    add(texts, tutils({text="  z         x  ", centerx=true, bordered=true, y=ypos+3, fg=8, bg=0}))
    ypos+=10
	add(texts, tutils({text="  remap  ", centerx=true, y=ypos, shadowed=true, fg=7, sh=0}))
	
	-- controls position
	local x1=28 
	local y1=128-19 
	local x2=128-x1-2 
	local y2=128 
    -- -----------------
    
	-- graphical frame 
	local frbkg=1
	local frfg=6
		
	state.update=function()
        if(btnp(5)) curstate=game_state() -- "X"
	end
	
	cls()
	state.draw=function()
		-- bkg
		dance_bkg(10,frbkg)
		
		-- frame		
		rectfill(3,2, 128-4, 104, 7)
		rectfill(2,3, 128-3, 103, 7)
		
		rectfill(4,3, 128-5, 103, 0)
		rectfill(3,4, 128-4, 102, 0)
		
		rectfill(5,4, 128-6, 102, frfg)
		rectfill(4,5, 128-5, 101, frfg)
		
		-- studio bkg
		rectfill(25,97,  101, 111, frbkg)
		rectfill(24,98,  102, 111, frbkg)
		
		pset(23,104,frbkg)
		pset(103,104,frbkg)

        -- controls
        rectfill(x1,y1-1,  x2,y2+1, 0)
		rectfill(x1-1,y1,  x2+1,y2, 0)
		rectfill(x1,y1,  x2,y2, 6)

		-- arrow to remap button
		local y=122
		rectfill(75-1,y+1-1, 120+1-8,y+1+1, 0)
		rectfill(121-1-8,y+1-1, 121+1-8,128+1, 0)
		
		rectfill(75,y+1, 120-8,y+1, 8)
		rectfill(121-8,y+1, 121-8,128, 8)
        
        -- title
        for t in all(texts) do
            t:draw()
        end
	end

	return state
end