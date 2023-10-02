# About
A project for *CSCI 5611: Animation and Planning in Games*. **Cyberball** is a 2d pinball game. Same as real-world pinball game, player can control a pair of flipper to kick the pinballs to prevent them from falling to the ground. By touching the ball, rectangle, and line segment obstacles, player will get different scores. It is cyberpunk world, so you will hear sounds, see lights when the ball interact with other obstacles. Ready for an advanture?
# Gameplay Demo



[<video src='https://github.com/RuichenHe/cyberball/blob/main/pinballGamePlayDemo.mp4'></video>](https://github.com/RuichenHe/cyberball/assets/108921106/c4811ca9-564e-4d27-9ff6-bfc02fcb3e71)
# Features
![](https://github.com/RuichenHe/cyberball/blob/main/doc/demo1.gif)

<img src="{{ "doc/demo1.gif" | prepend: site.baseurl | prepend: site.url}}" alt="demo1" />

In the first demo gif, the following features have been presented:
+ **Basic Pinball Dynamics** (30), where pinball can bounce back when colliding with line segment, circle, or rectagnle obstacles.
+ **Multiple Balls Interacting** (20), where multiple pinballs can colllide with each other
+ **Circular Obstacles** (10)
+ **Line-segment and Polygonal Obstacles** (10)
+ **Plunger/Launcher to shoot balls** (10), where each pinball will be shoot out from the right perpendicular channel with a random initial velocity
+ **Textured Background** (5)
+ **Textured Obstacles** (5), specifically the circle obstacles
+ **Reactive Obstacles** (5), when pinballs collide with line segments or the rectangle obstacles, the obstacles will light up
+ **Score Display** (5), collide with line segment +10, collide with circle obstacles +20, collide with box obstacles +50
+ **Pinball Game** (20)

![](https://github.com/RuichenHe/cyberball/blob/main/doc/demo2.gif)

<img src="{{ "doc/demo2.gif" | prepend: site.baseurl | prepend: site.url}}" alt="demo2" />

In the second demo gif, a different scene has been presented. In the game, we have a scene structure reading system to load the scene setup from a Scene.txt file. Currently, two scenes have been designed. But with the current system, multiple scenes can be design and crafted easily. 
Cliamed feature:
+ **Loading Scenes from Files** (10)

Additional features that claimed in tha game:
+ **Sound Effects** (5), which can be found in the youtube video (since gif cannot record sound effect).

# Technical Detail
For all the collision related code, I use the library I created for my first homework. One optimization I tried and successfully implemented is a BVH tree (spatial structure) to optimize the serach of the collision object. 
For three types of obstacles, they have different physic materials, which means that the coefficient of collisoin is different. In general, for line segment collison, it will decrease the total energy, for the circle obstacle collision, it will increase the total energy and speed up the movement of the pinball, for the box obstacle collision, it will remain the same total energy. 
For all the velocity changes and flipper collison, I use the equitions appears in the slides for references.
For the scene background, I use a AI image generation app (Wonder.AI) to generate them. 

# Game Play

To start a new game, simply press SPACE to shoot out the first pinball. 
If all three pinballs are lost, game will end. Press "R" to restart the game.
To control the left/right flipper, simply use LEFT and RIGHT keys. By default, if there is no pressed, these two flippers will remain stable at the initial location, and have a tendency to move back to the initial locations. 
The current score can be found at the left top corner, while the total pinball left can be found on the right top corner. 

# Code
The source code is available to download [here](https://github.com/RuichenHe/cyberball/)


