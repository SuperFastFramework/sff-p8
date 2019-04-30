-- Functions to create clickable buttons.

-- This only creates a rectangle button shaped with a callback when clicked
-- x,y, width,height, regular_color, hover_color, callback function
function raw_btn(x,y, w,h, fg,bg, callback)
    local b={
        bounds=bbox(w,h),
        debounce=1,
    }
    b.bounds:setx(x)
    b.bounds:sety(y)

    function b:draw()
        local colfg=fg
        if point_collides(mousex, mousey, self) then
            if lclick then
                if b.debounce then
                    b.debounce = nil
                    callback()
                end
            else
                b.debounce = 1
            end

            colfg=bg
        end

        rectfill(x,y, x+w,y+h+2, bg)
        rectfill(x,y, x+w,y+h, colfg)
    end

    return b
end

function text_btn(tutils, x,y, fg, bg, callback)
                 -- width of text
    local w,h = (#tutils.text * 4)+2, 8
    tutils._x=x+2
    tutils._y=y+2

    local rbtn=raw_btn(x,y,w,h,fg,bg,callback)
    rbtn._draw=rbtn.draw

    function rbtn:draw()
        self:_draw()
        tutils:draw()
    end

    return rbtn
end
