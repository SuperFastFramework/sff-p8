#!/usr/bin/python3
'''
    This file is part of SFF.

    SFF is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SFF is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with SFF.  If not, see <http://www.gnu.org/licenses/>.

    Written by Iber Parodi Siri 2018
'''
import os, sys, shutil
import argparse
import tempfile, subprocess

INJECT_KEYWORD = "--<*"
TEMP_FILENAME  = "tmp.sff"

parser = argparse.ArgumentParser(description='Command line utility for the SuperFastFramework - ROMBOSAUR STUDIOS BRANCH.')
parser.add_argument('-p', '--path', help='Path of the SFF project. Defaults to \'.\' ')
parser.add_argument('-g', '--generate', choices=['project','state','entity','gamepad', 'movement', 'shake'], help='Generates boilerplate code.')
parser.add_argument('-n', '--name', help='Name of the file to be generated. Use this with --generate flag')
parser.add_argument('-c', '--compile' , metavar='OUTPUT', help='Takes main.lua and all the files it references and generates a .p8 file.')
parser.add_argument('--version', action='version', version='%(prog)s 1.0 - Feb 2018 - ROMBOSAUR STUDIOS BRANCH')

args = parser.parse_args()

# extension must include the .
# like so: '.lua', '.p8'
def _add_extension(name, extension):
    tmp=name
    if not tmp.endswith(extension):
        tmp+=extension

    return tmp

def compile(path, name):
    os.chdir(path)

    # Add correct extension to the output file name
    out_p8=_add_extension(name, '.p8')

    print("Compiling... ")
    # Generates a tmp.sff with all the code
    with open(path+os.sep+TEMP_FILENAME, 'wb') as out_file:          # Opens the temp file for writing
        with open(path+os.sep+'main.lua', encoding='utf8') as in_file:    # Opens the main SFF lua file
            line = in_file.readline()
            print("Importing code... ")
            while line:
                # Check for file to inject keyword
                if line.startswith(INJECT_KEYWORD): 
                    filename_to_inject = line.split(INJECT_KEYWORD, 1)[1].strip()

                    try:
                        # Copy the refered file into the out_file
                        with open(filename_to_inject, encoding='utf8') as file_to_inject:
                            for line in file_to_inject:
                                if line.lstrip().startswith("--") or not line.strip(' \t\n\r'):
                                    continue
                                else:
                                    try:
                                        idx = line.index("--")
                                        out_file.write((line[:idx]+"\n").encode("utf-8"))
                                    except ValueError:
                                        out_file.write(line.encode("utf-8"))

                        out_file.write("\n".encode("utf-8")) # Avoid pico8 file generation errors
                    except FileNotFoundError:
                        print("ERR - Specified path ('"+path+os.sep+filename_to_inject+"') doesn't exists.", file=sys.stderr)
                        sys.exit(1)

                # Copy line directly into out_file
                else:
                    out_file.write(line.encode("utf-8"))

                line = in_file.readline()
            

        # Copy all assets (music, art, map, sfx) from the .p8 file into TEMP_FILENAME
        try:
            discard=True
            with open(path+os.sep+out_p8, encoding='utf8') as in_file:
                print("Importing assets... ")
                line = in_file.readline()
                while line:
                    if line.startswith("__gfx__"): # Everything after this tag is an asset
                        discard=False

                    if not discard:
                        out_file.write(line.encode("utf8"))

                    line = in_file.readline()
        except FileNotFoundError:
            # The .p8 file doesn't exists, so I don't have to copy assets from. I don't care
            print("No previous .p8 file. No assets imported")

    # moves the tmp.sff to the <name>.p8
    os.rename(path+os.sep+TEMP_FILENAME, path+os.sep+out_p8)
    print("Done!")

def generate_state(path, name):
    template="""-- state
function """+name+"""()
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
            d:draw()
        end
    end

    return s
end"""
    # Add correct extension to the output file name
    out_lua=_add_extension(name, '.lua')
    
    print("Generating state...")

    # Check if file exists
    file=path + os.sep + out_lua

    if os.path.isfile(file):
        text = input("File '"+file+"' already exists. Overwrite? [y/n] N: ")
        if not text == 'y':
            print("Abort")
            sys.exit(0)

    with open(path+os.sep+out_lua, 'w') as out_file: # Creates the file
        out_file.write(template)

    print("Done!")
    print("Don't forget to add  --<*"+name+".lua  to the main.lua file.")

def generate_entity(name):
    print("Printing entity boilerplate to stdout...")
    print("")

    template="function "+name+"""(x,y)
    local anim_obj=anim()
    anim_obj:add(first_fr,fr_count,speed,tilesw,tilesh)

    local e=entity(anim_obj)
    e:setpos(x,y)
    e:set_anim(1)

    local bounds_obj=bbox(8,8)
    e:set_bounds(bounds_obj)
    -- e.debugbounds=true
    
    function e:update()
    end
    
    -- overwrite entity's draw() function
    -- e._draw=e.draw
    -- function e:draw()
    --     self:_draw()
    --     ** your code here **
    -- end

    return e
end
"""
    print(template)

def generate_gamepad():
    print("Printing gamepad boilerplate to stdout...")
    print("")

    template="""
if(btn(0))then 	   --left

elseif(btn(1))then --right

end

if(btn(2))then 		--up

elseif(btn(3))then  --down

end

if(btnp(4))then -- "O"

end

if(btnp(5))then -- "X"

end
"""
    print(template)

def generate_movement():
    print("Printing movement boilerplate to stdout...")
    print("")

    template="""
local vel=1
if(btn(0))then 	   --left
    self:setx(self.x-vel)
elseif(btn(1))then --right
    self:setx(self.x+vel)
end

if(btn(2))then 		--up
    self:sety(self.y-vel)
elseif(btn(3))then  --down
    self:sety(self.y+vel)
end
"""
    print(template)


def generate_screen_shake():
    print("Printing screen-shake boilerplate to stdout...")
    print("")

    template="""-- setup shake to a value > 0 and call this func on every update
function cam_shake()
    if (shake>0) then
        if (shake>0.1) then
            shake*=0.9
        else
            shake=0
        end
        camera(rnd()*shake,rnd()*shake)
    end
end
"""
    print(template)


def check_name_arg(args):
    if not args.name:
        print("ERR - Name is mandatory: -n/--name NAME", file=sys.stderr)
        sys.exit(1)

def generate_new_project(path, name):
    # check if proj_name exists
    proj_name=path+os.sep+name
    if os.path.isdir(proj_name):
        print("Project "+proj_name+"already exists! Aborting...")
        sys.exit(1)
    else:
        os.makedirs(proj_name)

    tmp_dir=os.path.join(tempfile.gettempdir(), "sff")
    if os.path.isdir(tmp_dir):
        shutil.rmtree(tmp_dir)

    process = subprocess.Popen(["git", "clone", "-b", "rombosaur", "https://github.com/Rombusevil/sff.git", tmp_dir])
    process.communicate()

    # Copy states
    for file in os.listdir(tmp_dir):
        if file.endswith(".lua"):
            os.rename(os.path.join(tmp_dir, file), os.path.join(proj_name, file))
    
    # Copy libs
    os.rename(os.path.join(tmp_dir,"sff"), os.path.join(proj_name, "sff") )

    print("New project generated at "+proj_name)


if __name__ == '__main__':
    if not len(sys.argv) > 1:
        parser.print_help()

    if(args.generate and args.compile):
        print("ERR - You can't choose to generate a file and compile at the same time.\nRemove either the -c or -g flags.", file=sys.stderr)
        sys.exit(1)

    args.path=args.path or '.'

    if(args.compile):
        try:
            compile(args.path, args.compile)
        except FileNotFoundError:
            print("ERR - Specified path ('"+args.path+"') doesn't exists.", file=sys.stderr)

    elif(args.generate):
        if args.generate == "state":
            check_name_arg(args)
            generate_state(args.path, args.name)

        elif args.generate == "entity":
            check_name_arg(args)
            generate_entity(args.name)

        elif args.generate == "gamepad":
            generate_gamepad()

        elif args.generate == "movement":
            generate_movement()

        elif args.generate == "shake":
            generate_screen_shake()

        elif args.generate == "project":
            check_name_arg(args)
            generate_new_project(args.path, args.name)

