# Network-Based Checkers Game

This project is a network-based checkers game consisting of client and server applications. The server follows a microservices architecture, and it includes the following components:
- **Game Service**: Handles the game logic, player moves, and interactions.
- **MS SQL Database Service**: Stores player data, game states, and history.
- **RabbitMQ Message Broker**: Facilitates communication between services.
- **Logging Service**: Tracks system events for monitoring and debugging.

## Project Overview

This checkers game allows players to join and play in real-time, with the game logic managed on the server side. Users must be registered and authorized to access their page, where they can view previous games and their results, or connect to a game with another user

The project is designed to support multiplayer functionality, where players can connect to a central server to create, join, and play checkers games. The game status and player information are stored in the MS SQL database.

This project is based on my previous beginner checkers game project, which was designed as a single application. The network-based version introduces a more scalable architecture by splitting the functionality into microservices, which makes the game more reliable and responsive for multiple players.
