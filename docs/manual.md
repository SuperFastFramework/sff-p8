States Template
================
All states must comply with this template.  

```lua
function mystate()
    local s={}

    s.update=function()

    end

    s.draw=function()

    end

    return s
end
```
To change states, simply do:

```lua
curstate=some_state()
```
## SFF command
You can generate states by issuing the following command:

```bash
$: sff -g new_state --name new_state
```

----

Entities Template
=================

Abstract the creation of entities on their own function.  
The following template has the minimum code required to create an entity:

```lua
function my_entity(x,y)
    local anim_obj=anim() -- creates animation object
    anim:add(1,2,0.5,1,1) -- adds one animation to the animation object

    local e=entity(anim_obj)
    e:setpos(x,y)
    e:set_anim(1)   -- sets the current animation to the #1 on the added animations list
    
    return e
end
```

**Entities are drawables. This means that you MUST call draw() on every frame for each entity.**

## SFF command
You can generate states by issuing the following command:

```bash
$: sff -g entity --name new_entity
```


## Animations
All entities have an animation object which can have multiple animations.  
To add an animation simple call the **add()** method of the animation object with the following arguments:  

```lua
anim:add(first_frame_idx, total_frames, speed, zoom_width, zoom_height)
```
- **first\_frame\_idx**: the id of the sprite in the sprite sheet of the first frame
- **total_frames**: number of frames in the current animation
- **speed**: speed of frame changing
- **zoom\_width & zoom\_height**: 1=8px, 2=16px, 3=26px, 4=32px

**NOTE:** all frames of an animation must be consecutive in the x axis.

To change the active animation simply call the __set\_anim(n)__ method with the index of the animation on the added animations list.


## Entity with bounding box

Just add a BBox (bounding box) object like so:

```lua
function my_entity(x,y)
    local anim_obj=anim()
    anim:add(1,2,0.5,1,1)

    local e=entity(anim_obj)
    e:setpos(x,y)
    e:set_anim(1)

    -- this is the bounding box part
    local bounds_obj=bbox(8,8)
    e:set_bounds(bounds_obj)
    e.debugbounds=true -- this draws the bounding box for debuging
    --------------------------------

    return e
end
```
### BBox Interface

```lua
function bbox(width, height, x1_offset, y1_offset, x2_offset, y2_offset)
```
- **width**: width of the sprite that this bbox corresponds to
- **height**: height of the sprite that this bbox corresponds to
- **x1_offset**: number of pixels to move from the left side to the right side (default 0)
- **y1_offset**: number of pixels to move from the top side to the bottom side (default 0)
- **x2_offset**: number of pixels to move from the right side to the left side (default 0)
- **y2_offset**: number of pixels to move from the bottom side to the right top (default 0)

Bounding Box function.  
If you have a sprite that's 8x8 pixels, you set the first 2 arguments to 8.  
If you want to have a bounding box that's 1 pixel short on each side (6x6) you'll call the bbox function like so:
```lua
bbox(8,8,1,1,1,1)
```
If you want the bounding box as the same size of the width and height you call it with only the first two arguments, ignoring the offset configuration:  
```lua
bbox(8,8)
```

## Flicker

Entities come with a flicker function built in.  
To use it simply call 
```lua
my_entity:flicker(duration_in_ticks)
```

----

Timers
======

**SFF** comes with a timer that allows the execution of a specified function every N ticks.  
If the number\_of\_times\_to\_run argument is 0 then the timer will repeat infinitely.  
The function returns the timer object, so it can be killed manually at any time by calling __t:kill()__  
It's use is as follows:

```lua
local timers={}

timer(timers, 1, 50, 1,  function() printh("one shot")      end)
timer(timers, 1, 30, 3,  function() printh("three times")   end)
local infinite_t = timer(timers, 1, 15, 0,  function() printh("infinite")      end)
timer(timers, 1, 60, 1,  function() infinite_t:kill() end) -- kills the timer without execution limit

s.update=function()
    for x in all(timers) do
        x:update()
    end
end
```

**NOTE: the update() method of every timer must be called each frame.**

The signature of the function is as follows:

```lua
function timer( timers_global_table,         tick_increase_per_frame, 
                trigger_func_at_tick_number, number_of_times_to_run, func_to_execute)
```