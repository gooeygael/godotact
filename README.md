# Godotact

## Introduction

This project is a tactical game developed in Godot. The battle scene is the current focus, which
will be orthogonal and semi-automatic, with pauses at intervals for player decisions. The current
vision features an overworld with strategic gameplay on a network structure incorporating city-building 
elements, resource management, and customizing player-controlled characters with unique abilities in 
and out of battle.

## Approach

The BattleScene.tscn and its scripts are designed as the core of the turn-based tactical combat system. 
To support the expansion of scope, procedural generation, and (online) multiplayer capabilities, 
consideration will be given to ensure scalability and footprint. Separation between simulation and presentation, 
and an authoritative-server model backed by a simple network facade, should be considered when building 
data pipelines.

The use of composition for battle scene elements is preferred to inheritance when appropriate.

## Style 

The official Godot style guide should be adhered to, including proper indentation with tabs (talking to you codex).
