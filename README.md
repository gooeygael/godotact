# Godotact

This project is a strategy game developed in Godot. The battle scene is the current focus, which is orthogonal and semi-automatic. 

Future scope includes (1) multiplayer capabilities and (2)an overworld component with possible elements including strategic gameplay, network structure, city-building,
resource management, and player-controlled characters with unique abilities in and out of battle.

## Battle Scene

Battle will be largely AI-controlled with pauses at intervals called _battle phases_ (BP) in which battle ensues. In the _commander phase_ (CP), players take actions as the _commander_ character, like deployment of units and use of abilities. Units can be deployed in the furthest row that you occupy, but not on or behind a row occupied by an enemy. Battle phases use a system of "tics" called _battle frames_ (BF) to control the flow of battle. Each basic action, such as moving to an adjacent tile or attacking, will occur during a single BF and have an associated cooldown (i.e., move_adjacent: 1 BF, attack: 3 BF, teleport: 2 BF).

The feasibility of status effects, environmental procedural generation, and destructible environments is actively considered.

### Units

_Basic units_ are entirely autonomous. Basic units can have unique movement patterns, attack ranges, or stealth mechanics, but always act according to clear rules concerning engaging enemies, avoiding battle(stealth), entering channeled states, etc. 

Future scope includes upgrading basic units for enhancements and customization outside of the battle scene.

The _Commander_ is a unit that leads the players' units. The commander unit can be deployed like a basic unit, but can also be given an enemy to target/pursue, a location to move to, and/or an ability to activate during the CP. Along with deployment, this will be the players' primary means of control throughout the battle. 

Future scope includes passive abilities for themselves and allied basic units. 

## Approach

The use of composition for battle scene elements is preferred over inheritance.

An event bus or similar is used to route high-level events rather than direct calls.

A command --> simulation --> event pipeline is preferred to limit the network layer to serializable events.

Data-driven definitions and tiny Behavior Components that register only on the states they need are preferred to prevent tight coupling.

Separation between simulation and presentation, and an authoritative server model, should be considered when building data pipelines.

## Style 

The official Godot style guide should be adhered to, including proper indentation with tabs.
