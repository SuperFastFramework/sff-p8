-- collision detection between bboxes

-- expects entities objects as arguments
function collides(ent1, ent2)
    local e1b=ent1.bounds
    local e2b=ent2.bounds
    
    if  ((e1b.xoff1 <= e2b.xoff2 and e1b.xoff2 >= e2b.xoff1)
    and (e1b.yoff1 <= e2b.yoff2 and e1b.yoff2 >= e2b.yoff1)) then 
        return true
    end

    return false
end

-- expects ent to be an entity object
function point_collides(x,y, ent)
    local eb=ent.bounds
    
    if  ((eb.xoff1 <= x and eb.xoff2 >= x)
    and (eb.yoff1 <= y and eb.yoff2 >= y)) then 
        return true
    end

    return false
end