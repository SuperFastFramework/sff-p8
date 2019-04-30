-- timers -----------------------------------------------
-- implements updatable interface -----------------------
function timer(updatables, step, ticks, max_runs, func)
    local t={
        tick=0,
        step=step,
        trigger_tick=ticks,
        func=func,
        count=0,
        max=max_runs,
        timers=updatables,
    }

-- public    
    function t:update()
        t.tick+=self.step
        if t.tick >= self.trigger_tick then
            t.func()
            t.count+=1
            if t.max>0 and t.count>=t.max and t.timers ~= nil then
                del(t.timers,self) -- removes this timer from the table
            else
                t.tick=0
            end
        end
    end

    function t:kill()
        del(t.timers, t)
    end

    add(updatables,t) -- adds this timer to the table
    return t
end
-- end timers -------------------------------------------