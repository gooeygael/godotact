# Godotact

This project is a strategy game developed in Godot. The battle scene is the current focus, which is orthogonal and semi-automatic. 

Future scope includes (1) multiplayer capabilities and (2)an overworld component with possible elements including strategic gameplay, network structure, city-building,
resource management, and player-controlled characters with unique abilities in and out of battle.

## Battle Scene

Battle will be largely AI-controlled with pauses at intervals called _battle phases_ (BP) in which battle ensues, followed by the _commander phase_ where players take actions as the _commander_ character, like deployment of units and use of abilities. Units can be deployed in the furthest row that you occupy, but not on or behind a row occupied by an enemy. Battle phases have a number of "tics" called _battle frames_ to control the flow of battle. Each basic action, such as moving to an adjacent tile or attacking, will occur during a single BF and have an associated cooldown for each action.

_Basic units_ are entirely autonomous. Basic units can have unique movement patterns, attack ranges, or stealth mechanics, but always act according to clear rules concerning engaging enemies, avoiding battle(stealth), entering channeled states, etc. 

The _Commander_ is a unit that leads the players' units. The commander unit can be deployed like a basic unit, but can also be given an enemy to target/pursue, a location to move to, and/or an ability to activate during the CP.  Along with deployment, this will be the players' primary means of control throughout the battle. battle frames in a battle phase should be kept short enough to maintain sufficient control over commander.

Attacks and abilities take priority over movement unless specified e.g. a disengage/parry/teleport ability that leaves your attacker will a failed attack. Even if a unit dies during a frame, they still perform (or fail) any queued attack or ability. Conflicts where units attempt to move to the same tile will be determined by RNG- the loser will also fail their movement attempt. Shutting down an enemy will be called a coup. This could possibly afford a perk or benefit.

The feasibility of status effects, environmental procedural generation, and destructible environments is actively considered. Future scope includes passive abilities for themselves and allied basic units for commander and sugrades and specializations fro basic units.

## Approach

The use of composition for battle scene elements is preferred over inheritance.

An event bus or similar is used to route high-level events rather than direct calls.

A command --> simulation --> event pipeline is preferred to limit the network layer to serializable events.

Data-driven definitions and tiny Behavior Components that register only on the states they need are preferred to prevent tight coupling.

Separation between simulation and presentation, and an authoritative server model, should be considered when building data pipelines.

## Style 

The official Godot style guide should be adhered to, including proper indentation with tabs.
