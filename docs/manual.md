<div align="center">
    <h1>Super Fast Framework</h1>
    <i>For Pico-8, by Rombosaur Studios</i>
</div>  
<br><br><br>

__SFF__ is a collection of lua objects, functions and a CLI app that allows for rapid development of games using Pico-8.
It allows for and provides the following features:  
- Divide your code into multiple .lua files.
- Divide your game into "States".
- Entities with animations, bounding boxes and flickering.
- Text object with support for centering, bold, shadow and blinking.
- Timers for schedulling and repeating code.
- A CLI app that generates boilerplate code and snippets.

Install
=======

## Windows / Mac
You should add the file ```cli/sff-cli.py``` to the systems path preferably by the name __"sff"__.

## Linux
Simply execute the file ```cli/installer.sh``` and the CLI will be installed on the system path by the name __"sff"__.

Create Project
==============

To create a new SFF project, move into the desired directory and execute the following command:

```bash
sff -g project -n my_new_proj
```
where 'my_new_proj' is the name of the project to generate.

# Importing Files

To import a file you have to add a line with the following prefix __--<*__ and following the name of the file to import. Here's an example:  

```
--<*my_file.lua
```
This only works on the ```main.lua``` file at the moment.

# Compile

To compile all your files into a functioning _.p8_ file, issue the following command:  
```bash
sff -c game_name
```  
It will generate a _game\_name.p8_ file that you can load on Pico-8.  
Only the code is overwritten, all the assets are kept exactly as saved within Pico-8.

# Snippets

Currently _SFF_ provides snippets for controller input and screen shake:

```bash
sff -g gamepad  # generates the input buttons snippet
sff -g shake    # generates screen shake snippet
```

----

States Template
================
To generate a states you need to issue the following command:

```bash
sff -g new_state --name new_state
```

It will generate a file named "new_state.lua" with the following code inside:  

```lua
function new_state()
    local s={}

    s.update=function()

    end

    s.draw=function()

    end

    return s
end
```

To use the state you need to import the file into your main.lua. See _Importing Files_ on how to do that.

Put all your _\_update()_ code inside the _s.update_ function and all your _\_draw()_ code inside the _s.draw_ function.

To change states, simply use the global _curstate_ variable:

```lua
curstate=new_state()
```


----

Entities Template
=================

You can generate entities by issuing the following command:

```bash
sff -g entity --name new_entity
```

The code will be outputed to the terminal and it will have an animation and bounding box objects.

I'll proceed descibing the Entity object firts with only an animation object attached:  

```lua
function new_entity(x,y)
    local anim_obj=anim() -- creates animation object
    anim:add(1,2,0.5,1,1) -- adds one animation to the animation object

    local e=entity(anim_obj)
    e:setpos(x,y)
    e:set_anim(1)   -- sets the current animation to the #1 on the added animations list
    
    return e
end
```
**NOTE!!!**
- Entities are drawables. This means that you MUST call draw() on every frame for each entity.
- When changing x,y values you MUST do it by using the setx(x), sety(y) or setpos(x,y) methods, otherwise the bounding box positions will not update.

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

**NOTE!!!** 
- This version of **SFF** requires animations to have all frames consecutive in the x axis of the sprite sheet.

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
Collision Detection
===================

A simlpe collision detection function is provided in __sff/collision.lua__ file.  
It operates with Entity objects, here's it's use:  

```lua
    collition = collides(ent1, ent2)
```

Returns true if the entities collide, false otherwise.


----

Text Utils
==========
Text utils is a function that returns a configured object that will "draw" the specified text.  
It supports bordered text, center on x and/or y axis, blink with configurable on and off times and also the hability to add a shadow. All colors (foreground, background and shadow) are confiugurable.  

**tutils** function accepts only one argument that it's an object with the following structure:
```lua
{
   text="", 
   x=1, 
   y=1, 
   fg=1, 
   bg=1, 
   sh=1,
   bordered=false, 
   shadowed=false, 
   centerx=false, 
   centery=false,
   blink=false, 
   on_time=5, 
   off_time=5
}
```

**text** property is mandatory, the rest have default values as described above.  
**on_time** allows to configure the "showing" time, **off_time** configures the "hidden" time.

Example:
```lua
function _init()
    game_name=tutils({text="super game", bordered=true, fg=5, bg=6})
end

function _draw()
    game_name:draw()
end
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
