-- text utils -------------------------------------------------
-- implements drawable interface ------------------------------

-- args:{
--   text="", x=2, y=2, fg=7, bg=2, sh=3,
--   bordered=false, shadowed=false, centerx=false, centery=false,
--   blink=false, on_time=5, off_time=5
-- }
-- "text" is the only mandatory argument
function tutils(args)
	local s={}
	s.private={}
	s.private.tick=0
	s.private.blink_speed=1
	s.height=10 -- "line height" use this to calculate "next line" in a paragraph

	s.text=args.text or ""
	s._x=args.x or 2
	s._y=args.y or 2
	s._fg=args.fg or 7
	s._bg=args.bg or 2
	s._sh=args.sh or 3 	-- shadow color
	s._bordered=args.bordered or false
	s._shadowed=args.shadowed or false
	s._centerx=args.centerx or false
	s._centery=args.centery or false
	s._blink=args.blink or false
	s._blink_on=args.on_time or 5
	s._blink_off=args.off_time or 5
	
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
			local x=max(s._x,1)
			local y=max(s._y,1)

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
