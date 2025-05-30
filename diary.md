# Final Year Project Diary

### 30/09/2024

The inital ideas for this game are that it is to be built in a game engine such as Unreal or GoDot. Research into both of these have been doen but more thorough work is to be done. 
Ideas for the game are a FPS, drawing inspiration from titles such as Doom or Halflife. Other ideas do include topdowm dungeon crawlers with puzzle based elements. 


### 02/10/2024

With much consideration to the ideas and functionaltiy of both engines i have decided on using GoDot. This engine is more suitable for me and this proejct and alligns with the skills i posses to excel with some of the concepts. The documentation for this engine has been read and tutorials provided have been attempted.
Further with this the project plan will be started, finding relavent books and papers to aid in my work.


### 04/10/2024

On the 3rd of october i had met with my supervisor and discussd the project ideas that i had come up with and talked about any relavent help with the project plan. Following this a draft plan has been started.


### 07/10/2024

The plan timeline has been drafted up and the abstarct has been partially drafted too. Research into relavent papers has also been conducted with papers such as 'Designing procedurally generated levels' - Linden, R., Lopes, R., & Bidarra, R. (2021). Designing Procedurally Generated Levels. Proceedings of the AAAI Conference on Artificial Intelligence and Interactive Digital Entertainment, 9(3), 41-47. https://doi.org/10.1609/aiide.v9i3.12592. Risks and mitigations for those risks have been drafted into the day book.


### 08/10/2024

The risks and mitigations section of the project plan has been completed. Once other parts of the plan are complete a draft will be sent to my supervisor for any final comments and tweaks and will be changed. with this, the timeline will now be started, building upon the initial draft i did for it. Abstract is still to be finished as the bibliography for it is still limited.


### 09/10/2024

The timeline for the project has been completed, with specified milestone and mapped to the term weeks. The abstarct still needs work and further research is being conducted. Once a rough abstarct is complete, i will send it to my supervisor for comments, and with these, on the 10th the plan will be completed, ready for submission on the 11th.
<br /> <br /> I have sent what i have done of the plan so far to my supervisor for further guidance, once feedback is recived from them, i will continue in the correct direction.


### 10/10/2024
I have recived positive feedback about my plan from my supervisor with further tips to finish off the abstract and bibliography. Work on this is underway and should be completed by tonight. Further research on papers have also been done.
<br /> <br /> The project plan is pretty much finished. The timeline, risks and bibliography is done, the abstract is almost finished, it needs a touch up and a bit more writing and the plan will be ready for the submission. Once done, the IDE will be setup and coding will begin.


### 11/10/2024

The project plan has been completed and uploaded to moodle. Now that it is complete, the coding for the game will begin.
<br /> <br /> The file has also been uploaded to the Gitlab documents directory.
<br /> <br /> The interim report will be drafted once the coding starts.


### 13/10/2024

The Godot IDE is setup, linked with the gitlab, a master branch has been created for the inital work to begin, this is the first objective met that was proposed in the timeline. I wil start,a s stated in the project plan, with the games menu screens. I have created the buttons with a control node, and have attched a script to allow for fucntionality of these menu buttons, this is not finished yet. 


### 14/10/2024

I have created placeholder menu screens such as the main menu, game screen, and the options menu. I have partially scripted the menu buttons to be connected to each screen when they are pressed, this is another objective completed from the plan from week 4-5.
<br /> <br />I am facing an error while getting the buttons to correspond to their appropriate screen, the change_Screen functions.
<br /> <br />I have relalised the documentation i was using was for Godot v3 and not v4 which is the version i am using. in v3 they used just change_scene, whereas in v4 they chnaged it to change_scene_to_file("..."), which now works. i will now refer to using the v4 documentation, opposed to the v3 which i wrongly opened. The buttons for the main menu screen now have functionality and take the me to the correct screen. I will now begin on creating a back button for the menus and visually sort them out.
<br /> <br />I have centred the main menu buttons and gave them lables.
<br /> <br />I have added a back button to options menu, created a scrpit in the options menu to add functionality to get the player back to the main menu.


### 15/10/2024

Today i looked at some potential free assets that i can use for the UI, however still undecided on which to go for. I have created a 3D player with a mesh and collison nodes, I will now add functonalilty to these. I also attempt to do the player movement and try to attempt the above style camera.
<br /> <br />I have created a basic rudimentary movement script for the player and mapped the physical buttons on the keyboard to work with the script. I will work on the camera and test to see if it works.
<br /> <br />I have created a test environment, basic plane with collision, the movement for the player works along with collision, the camera however is not working as expected. Therefore i need to work on fixing that.
<br /> <br />I have sorted the camera angle out but now the controls seem to be inverted, i will need to look into this and fix it.
<br /> <br />I have had to do a temporary inversion of the controls which has seem to do the job, i have sorted out the camera angle as well. i have replaced the placeholder game menu with the current screen with the player and environment.


### 21/10/2024

After a few days off to work on other univeristy work and commitments, it is the start of week and i will start the next stages of the work required. This week i am to implement the plaer HUD, implement the eneimes and a basic combat system.


### 22/10/2024

I have created a 2D scene for the players HUD, with a placeholder health bar. The rest of the HUD will be added soon. I have also linked and overlayed it on the main game screen, having tested it, it is functional. I cannot test this health bar till i create some enemies, so my next goal is to create a simple enemy factory.


### 23/10/2024

I have worked on the enemey 3D model and given it a script, which lets it move randomly and have speed and health. I then created a spawn factory in the main game state which will spawn the enemey randomly on the map. This is al tested and works as needs be. One error encountered was the enemey kept spawning into the map then falling below, this was a simple fix by changing its y coords higher.
<br /> <br />I had some time to work on the assets, i added textures to the buttons and gave them a slight animation of hovered and pressed. I also added some basic lighting to the main game state along with some colour differentiations.
<br /> <br />I had a look at some further assets such as animations for the player. Im still yet to decide on one but i may get a free animated one and just use it as a placeholder and use it to understand how to implement the animations in the project.


### 24/10/2024

I implemented a very basic combat system where the player presses the space bar near an enemy and they take damage, once zero they are killed and taken off the screen. Here many of the early objectives and deliverables i had in the plan have been ticked off, requirng furthr refinement with time. i will continue to improve and work on this combat system, but this very basic system will suffice for now.



### 28/10/2024

 To start off the new week i spent some time refelcting on what had been done and what needs doing, consulting the timeline i created in the project plan. I have realsied that functionality wise i am ahead on what i had predicted which is a good sign, which means i can spend some time on finding and implementing assets and animations into the game.
<br /> <br />I have visted webisted such as Kenney and itch.io for free assets to use.


### 28/10/2024

I have started to work on the enemy attack script.


### 12/11/2024
Coming back to the project i have finished the enemy attacks fucntion and their pathfinding. Fixed errors that arsied such as the players attack mechanism affetcing the players health instead of the enemies. Also removed redundant comments left for myself when starting off as they no longer serve any purpose.
<br /> <br />The next steps to follow is to work on the procedural generation of the dungeon itself and finalise and apply the assets.


### 18/11/2024
I have been spending my time researching procedural map generation these past few days and watching youtube videos on it. Im gaining a better understadning of how to implement it and the usage of it.


### 28/11/2024
I have been making separate projects to test the procedural generation. so far, its very simple and not exaclty how i want it and figuring out how to implement it into my code and project is difficult.


### 04/12/2024

I have found some assets and animations to use as placeholder for now for my game. i have imported them and tested to see if they are compatible, which they are.
<br /> <br />I have added simple animation and the model to the player, which are functional and work, only thing that isnt is the attack animation. Once this is done i will continue work on my separate file on procedural map generation.


### 11/12/2024
Today i had my project demonstration for the interim submission. 


### 12/12/2024
The interim report is all written and the creation of the video demo will be done as well. All ready for the submission date on the 13th.


### 16/2/2025
Milestone one was achieved as stated in the project plan, but a a alot more work is to be done, many of the basic features stated however are funcitonal. 
<br /> <br />During the Christmas break i conducted in house play testing to gather inital feedback on my game, this helped identify key areas for improvement and things that are working well so far, this is going to guide me for developemen the next few weeks.


### 17/2/2025
Today the main goal was to get the procedural generation sorted.I ensured that rooms spawn dynamically without overlapping, and linked doors correctly between them, so rooms can be travered, this was a big objective to get sroted that was stated in the dveelopment plan, ticking this off is a huge goal. I also implemented a player camera system with zoom functionality to improve visibility in the isometric view.
<br /> <br />
I also rebuilt the main menu, restructuring the button layout using VBoxContainer for better organization. To improve UI polish, I added a fade-in animation for the menu using AnimationPlayer and the Modulate property, making transitions feel smoother, alogn with a background image for the main menu.


### 18/2/2025
Today i plan on revamnping the enemy spwning and AI to work with the procedurally generated dungeon.
<br /> <br />I worked on this and have got it partially working however it is highly bugegd right now enemys are spawning outside the allocated dunegeon rooms.


### 20/2/2025
Today i plan to fix the enemy spawn issue, then work on actually finding assets for the game, build different rooms and get a proper UI implemented.
<br /> <br />I have added a loading screen to my game with my logo at the start.


### 11/3/2025
I have got assets for my game and have created dungeon rooms with the assets, i now need to implement that room with the procedural generation code that i have, after that i will work on the UI before proceeding with further features.


### 12/3/2025
The procedural generation with the new asseted dungeon now works. time to fix and improve the player asset and movemtn and animations.
<br /> <br />I have improved the player movement by having them face the correct way they are moving. I have also implemented a player sprint by pressing the shift button. I tried to get the attack animation to work when spcae is pressed bu this is bugged, and have pushed it to the side to work on it when i get to working on the attacking and enemies. Next i need to improve the camera as it  is a bit jittery when moving and set a zoom limit. then work on the  main menus along with the options menu.
<br /> <br />I have been havign serious probelms with the camera so have reverted back to standard and will now focus on UI.
<br /> <br />I have created a new menu background and introduction animation, i will now add assets to my buttons.
<br /> <br />I have added the button assets to my main menu with some decent effects. i will next work on soritng out the wall colission and make sure the doors in the dungeon are functional.



### 13/3/2025
Today was a mix of progress and frustration while working on the dungeon generation. I focused on refining how rooms spawn, making sure they align properly and connect through doors without gaps. I spent a lot of time trying to get trap rooms to generate correctly, ensuring they only have one entrance, but they kept getting rejected due to a lack of valid placements so i reverted back to them having 4 rooms. At one point, the dungeon was only spawning rooms in a straight line, which I had to fix by shuffling the placement directions. Another issue popped up where only one room would spawn, forcing me to roll back to a previous working version. Despite the setbacks, I managed to get the dungeon generator functioning again, though there are still some alignment issues with doors and occasional room clipping. Tomorrow, I’ll refine the trap room placement, work on adding more room variety like puzzle and loot rooms, and start planning the loot and inventory system.


### 19/3/2025
Today I was working on getting the dungeon geenration to finally work as intended. I discovered that the doors weren’t being recognized properly because the Area3D nodes were children of the door assets instead of being directly referenced. Fixing that allowed rooms to start linking correctly. I also experimented with different approaches to trap rooms, trying to restrict them to one entrance, limit their count, and ensure they linked properly, but these changes kept breaking the system, either causing clipping, floating rooms, or failing to spawn at all.
<br /> <br />Eventually, I decided to match the trap room size to the standard dungeon room and allow them to spawn like regular rooms, which finally worked. So now i will move onto getting the enemy and HUD with inventory sorted.



### 22/3/2025
So far i have found good assets to use for my enemies and have implemented a basic spawning routine for them in the dunegeon, along with fixign their AI, next i need to polish the player hud and add it so i can attack enemies and enemeis can attack the player.
<br /> <br />I polished the enemy AI and animation system. I fixed the rotation so they now properly face the player, and got all the animations working in sync — including the floor idle pose, the wake-up animation, walking, attacking, dying, and the new idle combat pose when the player leaves their vision range. I also refined their behavior so they stop chasing when out of range but re-engage properly when the player returns, and prevented them from constantly walking into the player during combat.
<br /> <br />I implemented proper melee combat for the player, starting with hit detection and damage dealing using a proximity-based check. I ran into some issues with the attack animation not playing correctly, but after some debugging, I realized the idle animation was cutting it off. I fixed it by waiting for the attack animation to finish before returning to idle, and now it all works smoothly.


### 24/3/2025
I focused on improving the player's HUD and combat feedback. I rewired the HUD to properly reflect the player’s health using heart icons, with each heart representing 20 HP (totaling 5 hearts for 100 HP). I also integrated a score system that updates every time an enemy is killed. Then, I added an animation to the score label — had some hiccups with containers restricting scale edits, but I figured out a workaround. Now the plan is to work on getting all the menus sorted and polished, along with the inventory and music.
<br /> <br /> I implemented a fully functional pause menu in my game. Pressing ESC now pauses gameplay and overlays the menu on top of the scene. The menu includes buttons for resuming, accessing options, and returning to the main menu. Right now, pressing ESC again in the pause menu crashes the game, so i need to fix that.
<br /> <br />I fixed the crash caused by pressing ESC while the pause menu was open, the issue was due to a null reference when trying to call toggle_pause(). I solved it by safely checking if the PauseMenu node exists before calling the method. I also moved the input handling to _unhandled_input() instead of _input() to make sure it only triggers once and doesn't interfere with other input events. 


### 27/3/2025
I focused on rewiring the death screen to fit the current system, it works fine and intended. I am now wokringg on a new feature which is where chests and potions spawn dynamically in the dungeon to aid exploration and to help the player health and get more score.
<br /> <br />I have managed to implement some kind of working chest system, they spawn randomly and in different rooms but there is a bug where they are spawnining outside the rooms. But they work as intended, when the player interacts it addds to their score. Now its time to work on the health potion.


### 28/3/2025
I worked on getting a proper score system in place. I updated the HUD to display both the current score and the high score, and after a bit of trial and error, I got it to save the high score to a file on death. I ran into a weird issue where the high score kept resetting when I pressed retry, but I eventually figured it out by saving the score before reloading the scene. I tested thoroughly by setting  a high score, beating it to see if it updated, and got a lower one to see if it wasnt replaced, then tested by exiting to main menu and playing again to see if it was still there. Next will be to polish a few things then start working on adding music and SFX along with the options menu.
<br /> <br />I added a quick polish where it tells the player using a pop up that they have a new high score.
<br /> <br />Mielstone 2 was achieved later than it was stated in the plan but non the less the game is looking functional with a decent amount of polish.


### 31/3/2025
I am working on adding audio and SFX to the game.
<br /> <br />Today I fully integrated sound into the game, adding audio for both gameplay and UI. The player now has footstep and attack sounds, potions and chests play pickup effects, skeleton enemies have unique wake-up, walking, and death SFX.
<br /> <br />The options menu for the game is now fully functional, it can be accessed in the main menu and the pause maneu of the play state. The settings contain audio and video settings. Now i will work on polishing some things and some refactoring of the code.


### 01/4/2025
I added some simple fade animations to the menus, i have also added shadows to the player and enemy to make them look more natural. I will now work on further polishes. I have implemented a ambeince of fog and light flicker, along with damage feedback in the camera shaking to show the player theyve taken damage.
<br /> <br />Despite minimum time being left, after the play test, players did ask for anotehr enemy, so i added a mage who does ranged attacks.
<br /> <br />I have now added a how to play menu, along with my wall collisions now functional


### 02/4/2025
I added a void death to the player to prevent out of bounds traversal. I have also added a credits scene for all assets used. I also removed some files that were unused, such as assets.
<br /> <br />Refactoring for the code has begun. The camera, chest, control, potion and credits have been done so far.


### 03/4/2025
Ive refactored mageSpell.gd, loading screen, HUD, HowToPlay, game over, flicker, pauseMenu.
<br /> <br />Its now time for the big refactor and comemnts for the imporant sections of code, smaller scripts have been completed. 
<br /> <br />Options and Settings scripts done. Along with player, and mage enemey. Full refactor and comments of code now complete.


### 05/4/2025
A final play test of the game will be conducted and feedback will be taken as usual. With this, lookign back at the project plan and the timelien that was stated. everything had worked out, with some delays here and there, we ultimaltey ended up in the desired path, all objectives ste int the last weeks have been achieved. Now its time to tidy up the codebase and what else and then work on finalising the final report.
<br /> <br />All project files haev been organised, docs needed to be added to explain.
<br /> <br />Documentation for each folder had been added.


### 07/4/2025
I have added the final feature for the game which is a vicotry screen for when the player kills all enemies in the dungeon.
<br /> <br />Working code branch now successfully merged with the main branch. This is now the final stage in the timeline and development for the game has now fully concluded. Time will now be focused on finalising the report and preparing for the final submission. What a journey this has been, this project has helped me significantly grow as a developer.


### 08/4/2025
Finalisation of the report,demo video and game.exe will be ready for submision on the 11th.


## Prithvi S. Veeran - Signing out