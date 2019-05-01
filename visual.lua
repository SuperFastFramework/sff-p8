-- prints 4 blocks in the entire screen that dances
-- implements drawable interface
local tick_dance,step_dance=0,0

function dance_bkg(delay,color)
    local sp,pat=delay,0b1110010110110101
    tick_dance+=1
    if tick_dance>=sp then
        tick_dance=0
        step_dance+=1
        if(step_dance>=16) step_dance = 0
    end
    fillp(bxor(shl(pat,step_dance), shr(pat,16-step_dance)))
    rectfill(0,0,64,64,color)
    rectfill(64,64,128,128,color)

    fillp(bxor(shr(pat,step_dance), shl(pat,16-step_dance)))
    rectfill(64,0,128,64,color)
    rectfill(0,64,64,128,color)
    
    fillp() -- resets fill pattern
end