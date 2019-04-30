-- text utils -------------------------------------------------
-- implements drawable interface ------------------------------

-- args:{
--   text="", x=2, y=2, fg=7, bg=2, sh=3,
--   bordered=false, shadowed=false, centerx=false, centery=false,
--   blink=false, on_time=5, off_time=5
-- }
-- "text" is the only mandatory argument
function tutils(args)
	local s={
		private={
			tick=0,
			blink_speed=1
		},
		height=10, -- "line height" use this to calculate "next line" in a paragraph

		text=args.text or "",
		_x=args.x or 2,
		_y=args.y or 2,
		_fg=args.fg or 7,
		_bg=args.bg or 2,
		_sh=args.sh or 3, 	-- shadow color
		_bordered=args.bordered or false,
		_shadowed=args.shadowed or false,
		_centerx=args.centerx or false,
		_centery=args.centery or false,
		_blink=args.blink or false,
		_blink_on=args.on_time or 5,
		_blink_off=args.off_time or 5
	}

	function s:draw()
		if(s._centerx)s._x =  64-flr((#s.text*4)/2)
		if(s._centery)s._y = 64-(4/2)

		-- Blink related stuff
		if s._blink then
			s.private.tick+=1
			local offtime=s._blink_on+s._blink_off -- for internal use
			if(s.private.tick>offtime)s.private.tick=0
			local blink_enabled_on = false
			if(s.private.tick<s._blink_on)blink_enabled_on = true
			-- If it's supposed to blink, but it's on a off position, then return
			if(not blink_enabled_on) return
		end

		local yoffset=1
		if s._bordered then
			yoffset=2
		end

		if s._bordered then
			local x,y=max(s._x,1),max(s._y,1)

			if(s._shadowed)then
				for i=-1, 1 do	
					print(s.text, x+i, s._y+2, s._sh)
				end
			end

			for i=-1, 1 do
				for j=-1, 1 do
					print(s.text, x+i, y+j, s._bg)
				end
			end
		elseif s._shadowed then
			print(s.text, s._x, s._y+1, s._sh)
		end

		print(s.text, s._x, s._y, s._fg)
    end

	return s
end
