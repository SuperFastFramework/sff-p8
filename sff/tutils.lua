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
		if self._centerx then self._x =  64-flr((#self.text*4)/2) end
		if self._centery then self._y = 64-(4/2) end

		-- Blink related stuff
		if self._blink then 
			self.private.tick+=1
			local offtime=self._blink_on+self._blink_off -- for internal use
			if(self.private.tick>offtime) then self.private.tick=0 end
			local blink_enabled_on = false
			if(self.private.tick<self._blink_on)then
				blink_enabled_on = true
			end
			-- If it's supposed to blink, but it's on a off position, then return
			if(not blink_enabled_on) then
				return
			end
		end

		local yoffset=1
		if self._bordered then 
			yoffset=2
		end

		if self._bordered then
			local x=max(self._x,1)
			local y=max(self._y,1)

			if(self._shadowed)then
				for i=-1, 1 do	
					print(self.text, x+i, self._y+2, self._sh)
				end
			end

			for i=-1, 1 do
				for j=-1, 1 do
					print(self.text, x+i, y+j, self._bg)
				end
			end
		elseif self._shadowed then
			print(self.text, self._x, self._y+1, self._sh)
		end

		print(self.text, self._x, self._y, self._fg)
    end

	return s
end
