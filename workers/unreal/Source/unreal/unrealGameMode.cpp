// Copyright 1998-2016 Epic Games, Inc. All Rights Reserved.

#include "unreal.h"
#include "unrealGameMode.h"
#include "unrealPlayerController.h"
#include "unrealCharacter.h"

AunrealGameMode::AunrealGameMode()
{
	// use our custom PlayerController class
	PlayerControllerClass = AunrealPlayerController::StaticClass();

	// set default pawn class to our Blueprinted character
	static ConstructorHelpers::FClassFinder<APawn> PlayerPawnBPClass(TEXT("/Game/TopDownCPP/Blueprints/TopDownCharacter"));
	if (PlayerPawnBPClass.Class != NULL)
	{
		DefaultPawnClass = PlayerPawnBPClass.Class;
	}
}