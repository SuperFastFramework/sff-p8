function game_state()
    local s={}
    local updateables={}
    local drawables={}

    s.update=function()
        for u in all(updateables) do
            u:update()
        end
    end

    s.draw=function()
        for d in all(drawables) do
            d:update()
        end
    end

    return s
end