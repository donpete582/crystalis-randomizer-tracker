Crystalis by SNK

Randomizer by
	Steve_Hacks
	Mattrick_
	DragonDarchSDA
	https://crystalisrandomizer.com/

EmoTracker Pack by
	CodeGorilla
	twitch.tv/CodeGorilla
	Discord: CodeGorilla#8571

Maps are from Mike's RPG Center: http://mikesrpgcenter.com/crystalis/index.html

Special Thanks to: 
crossproduct, for the original version of the Crystalis Randomizer EmoTracker pack.
The EmoTracker Discord, for helping me figure out how to work with EmoTracker, and how to make it do things it probably isn't supposed to. :)
The Crystalis Randomizer Discord for entertaining obscure logic questions in my attempt to make this as accurate as possible

Info:
This is a map and item tracker that attempts to account for all possible combinations of flags that affect logic. This is meant for use with the latest branch of the randomizer, found at https://crystalisrandomizer.com/latest/. As such, the logic of the tracker may not match exactly the logic of the game if you are using the stable version of the randomizer. 

Some notes on usage: 
	-in this pack, a yellow location means the tracker does not have enough information to tell you whether or not you can access that location. Generally, this happens because of the Me, We, Wt, or Wu flags. 
	-For the Me and We flags, use the Walls/Bosses/Misc tab to indicate which bosses you can beat and which walls you can clear. 
	-For the Wt and Wu flags, you can right-click on the relevant key items once you know what purpose they actually fill. 
	-If playing without the Rt flag, you can right click on the Sword of Thunder to cycle through all the possible warp points, to show you what you have access to. 
	-If using the Wg flag, you can use the Goa Floor items on the Walls/Bosses/Misc tab to indicate the shape of your Goa Fortress. Left-click to cycle through bosses, and right-click to reverse the floor, indicating the boss of that floor is closer to the entrance than the exit.
	-If using the Wm flag, individual sub-maps will have doors that can be clicked once to indicate that you have found that door, or twice to indicate the door is blocked by the map structure.  When you have the ability necessary to reach that door regardless of the structure, the door locations should disappear from the map.

Flags that show as a red X when selected are currently not implemented in the logic.

Version History:

v1.0.0
	- First release. Implements most flags that affect logic.
v1.0.1
	-Removed the default background colors for better NDI capture support
	-Added negative indicators for key items; the logic will now account for the items in the tracker that you don't have. e.g. if you have an unknown key, and you mark one of the keys you don't have as the Key to Styx, the logic will know that you don't have the Key to Styx, but you might have the Key to Prison or the Windmill Key.
	-commented out some debug statements
	-made the whitespace more consistent
v1.0.2
	-Added logic and tracking for Vampire 2
	-Added hosted item for Sabera 1 location
	-Added hosted item for Karmine location
v1.0.3
	-Added tracking reset for Vampire 2 when finding a new sword
v1.1.0
	-Major Update: added Wm logic.

Future Release Plans:
	Wh flag logic
	Wg logic optimization
	Ww flag logic (if possible)
	Autotracking (if possible)
	Experimental Wa flag logic
