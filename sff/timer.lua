-- timers -----------------------------------------------
-- implements updatable interface -----------------------
function timer(updatables, step, ticks, max_runs, func)
    local t={}
    t.tick=0
    t.step=step
    t.trigger_tick=ticks
    t.func=func
    t.count=0
    t.max=max_runs
    t.timers=updatables

-- public    
    function t:update()
        self.tick+=self.step
        if(self.tick >= self.trigger_tick)then
            self.func()
            self.count+=1
            if(self.max>0 and self.count>=self.max and self.timers ~= nil)then
                del(self.timers,self) -- removes this timer from the table
            else
                self.tick=0
            end
        end
    end

    function t:kill()
        del(self.timers, self)
    end

    add(updatables,t) -- adds this timer to the table
    return t
end
-- end timers -------------------------------------------