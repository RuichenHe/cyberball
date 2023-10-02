# About
A project for *CSCI 5611: Animation and Planning in Games*. Cyberball is a 2d pinball game. Same as real-world pinball game, player can control a pair of flipper to kick the pinballs to prevent them from falling to the ground. By touching the ball, rectangle, and line segment obstacles, player will get different scores. It is cyberpunk world, so you will hear sounds, see lights when the ball interact with other obstacles. Ready for an advanture?
# Gameplay Demo

# Features
![](https://github.com/RuichenHe/cyberball/blob/main/doc/demo1.gif)

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

In the second demo gif, a different scene has been presented. In the game, we have a scene structure reading system to load the scene setup from a Scene.txt file. Currently, two scenes have been designed. But with the current system, multiple scenes can be design and crafted easily. 
Cliamed feature:
+ **Loading Scenes from Files** (10)

# Code
The source code is available to download [here](https://github.com/RuichenHe/cyberball/)


