-- entity -----------------------------------------------
-- implements drawable interface
function bbox(w,h,xoff1,yoff1,xoff2,yoff2)
    local bb ={
        offsets={ xoff1 or 0, yoff1 or 0, xoff2 or 0, yoff2 or 0},
        w=w,
        h=h,
    }
    -- this values will be overwritten with setx(n) and sety(n)
    bb.xoff1= bb.offsets[1]
    bb.yoff1= bb.offsets[2]
    bb.xoff2= bb.offsets[3]
    bb.yoff2= bb.offsets[4]
    -----------------------------------------------------------
-- public    
    function bb:setx(x)
        bb.xoff1=x+bb.offsets[1]
        bb.xoff2=x+bb.w-bb.offsets[3]
    end
    function bb:sety(y)
        bb.yoff1=y+bb.offsets[2]
        bb.yoff2=y+bb.h-bb.offsets[4]
    end
    function bb:printbounds()
        rect(bb.xoff1, bb.yoff1, bb.xoff2, bb.yoff2, 8)
    end

    return bb
end

function anim()
    local a={
        list={},
        current=false,
        tick=0,
    }
-- private
    function a:_get_fr(one_shot, callback)
		local anim=a.current
		local aspeed,fq,st,step, new_step = anim.speed, anim.fr_cant, anim.first_fr, flr(a.tick)*anim.w, flr(flr(a.tick)*anim.w)

		a.tick+=aspeed
		if st+new_step >= st+(fq*anim.w) then
		    if one_shot then
		        a.tick-=aspeed
		        callback()
		    else
		        a.tick=0
		    end
		end
		
		return st+step
    end
    
-- public
    function a:set_anim(idx)
        if (a.currentidx == nil or idx ~= a.currentidx) a.tick=0 -- avoids sharing ticks between animations
        a.current=a.list[idx]
        a.currentidx=idx
    end

	function a:add(first_fr, fr_cant, speed, zoomw, zoomh, one_shot, callback)
		local an={
            first_fr=first_fr,
            fr_cant=fr_cant,
            speed=speed,
            w=zoomw,
            h=zoomh,
            callback=callback or function()end,
            one_shot=one_shot or false,
        }

		add(a.list, an)
	end
    
    -- this must be called in the _draw() function
	function a:draw(x,y,flipx,flipy)
		local anim=a.current
		if not anim then
			rectfill(0,117, 128,128, 8)
			print("err: obj without animation!!!", 2, 119, 10)
			return
		end
		
		spr(a:_get_fr(a.current.one_shot, a.current.callback),x,y,anim.w,anim.h,flipx,flipy)
    end

	return a
end

function entity(anim_obj)
    local e={
        -- use setx(n) and sety(n) to set this values
        x=0,
        y=0,
        anim_obj=anim_obj,
        debugbounds=false,
        flipx=false,
        flipy=false,
        bounds=nil,
    -- private
        -- flickering---------\\
        -- all private here...
        flkr={
            timer=0,
            duration=0,     -- this value will be overwritten
            slowness=3,
            isflikrng=false -- change this flag to start flickering
        }
    }

    function e.flkr:flicker()
        if e.timer > e.duration then
            e.timer=0
            e.isflikrng=false
        else
            e.timer+=1
        end
    end
    -- end flickering ----//

-- public:
    function e:setx(x)
        e.x=x
        if(e.bounds ~= nil) e.bounds:setx(x)
    end
    function e:sety(y)
        e.y=y
        if(e.bounds ~= nil) e.bounds:sety(y)
    end
    function e:setpos(x,y)
        e:setx(x)
        e:sety(y)
    end
    function e:set_anim(idx)
		e.anim_obj:set_anim(idx)
    end
    function e:set_bounds(bounds)
        e.bounds = bounds
        e:setpos(e.x, e.y)
    end
    function e:flicker(duration)
        if not e.flickerer.isflikrng then
            e.flickerer.duration=duration
            e.flickerer.isflikrng=true
            e.flickerer:flicker()
        end
        return e.flickerer.isflikrng
    end

    -- this must be called in the _draw() function
    function e:draw()
        if e.flickerer.timer % e.flickerer.slowness == 0 then
            e.anim_obj:draw(e.x,e.y,e.flipx,e.flipy)
        end
        if(e.flickerer.isflikrng) e.flickerer:flicker()
		if(e.debugbounds) e.bounds:printbounds()
    end

    return e
end
-- end entity -------------------------------------------
