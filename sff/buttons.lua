-- Functions to create clickable buttons.

-- This only creates a rectangle button shaped with a callback when clicked
-- x,y, width,height, regular_color, hover_color, callback function
function raw_btn(x,y, w,h, fg,bg, callback)
    local b={}

    b.bounds=bbox(w,h)
    b.bounds:setx(x)
    b.bounds:sety(y)

    function b:draw()
        local colfg=fg
        if point_collides(mousex, mousey, self) then
            if(lclick) callback()
            colfg=bg
        end

        rectfill(x,y, x+w,y+h+2, bg)
        rectfill(x,y, x+w,y+h, colfg)
    end

    return b
end

function text_btn(tutils, x,y, fg, bg, callback)
    local w= (#tutils.text * 4)+2 -- width of text
    local h= 8

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
