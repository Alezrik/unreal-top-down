# Unreal Top Down C++ SpatialOS Demo

Note: This version of the demo runs the FSim on an unreal dedicated server binary that runs in headless mode, however, it requires that you download the full Unreal Engine source and build it (this takes around 40 mins).

This example project is the Unreal Top Down Character (C++) template project (available from the Epic Unreal Engine launcher) integrated with SpatialOS. With a few easy steps, we've converted this simple single player Unreal project into an online multiplayer game with NPCs attached to AIControllers that run on managed Unreal workers.

To see the demo in action:

## 1. Setup Unreal

- Get the Unreal Engine source by forking and cloning the repo: https://www.unrealengine.com/ue4-on-github
- Set the environment variable `UNREAL_HOME` to the root directory of this repo
- Switch to branch 4.12 in your local repo (this is the version of the Unreal Engine we'll be using): `git checkout 4.12`
- Run: `Setup.bat`
- Run: `GenerateProjectFiles.bat`
- Open `UE4.sln` in Visual Studio and build the project (takes around 40 mins)

## 2. Setup the demo

- Clone the repo: `git clone https://github.com/improbable-public/unreal-top-down.git`
- Open the repo in an explorer window, navigate to `workers/unreal/`, right-click on `unreal.uproject`, select 'Switch Unreal Engine version...' and browse to the location of the Unreal Engine source repo you just cloned
- Move into the root of the repo directory in a shell: `cd unreal-top-down`
- Build the project: `spatial build` (note that the `Build unreal workers` step takes a long time)
- Run: `spatial local start`
- Open the World Viewer to see the NPCs and the spooled up managed Unreal AI worker moving them all about: `http://localhost:5050`
- Connect multiple player clients: `spatial worker launch unreal client`

### Project Structure

Since this project is adapted from the template Top Down C++ project, all of the logic for `Player` entities and the player controller is in C++. However, to exemplify blueprint integration with SpatialOS, the logic for `Npc` entities and NPC controllers is all contained in blueprints.

Important things to note:
- The prefab name of a nature, as defined in the Gsim, must correspond to the name of a blueprint in the `EntityBlueprints` folder in the root of the Content Browser in the Unreal Editor. Note that, even though all of our `Player` logic is in C++, specifically in the `AunrealCharacter` class, we have created a blueprint child of this class called `Player` that resides in the `EntityBlueprints` folder.
- The `TransformSender` (`UTransformSender`) and `TransformReceiver` (`UTransformReceiver`) components can be added to Actors to sync the `Transform` state between Unreal workers and SpatialOS.
- A `TransformReceiver` simply reads values from the `TransformState` and exposes them in public methods for consumption by your game-specific logic.
- A `TransformSender` will read the Actor's location and rotation every frame, and send `TransformState` updates to SpatialOS, but only if it is running on an Unreal worker that is authoritative over the transform of that entity.
- For now, the same code runs on an Unreal Fsim / managed worker and an Unreal Client. When we build our project, both a client and fsim are generated in the `build/assembly/worker` folder, with the only difference being that the former connects to SpatialOS with `WorkerType = "UnrealClient"` and the latter with `WorkerType = "UnrealFsim"`. See the Gsim bridge settings and the player lifecycle manager for how we distinguish between the two in the Gsim.