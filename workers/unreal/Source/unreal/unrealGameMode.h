// Copyright 1998-2016 Epic Games, Inc. All Rights Reserved.
#pragma once
#include "GameFramework/GameMode.h"
#include "GameFramework/GameUserSettings.h"
#include "SpatialOS/Public/WorkerConnection.h"
#include "SpatialOS/Public/EntitySpawner.h"
#include "unrealGameMode.generated.h"

UCLASS(minimalapi)
class AunrealGameMode : public AGameMode
{
	GENERATED_BODY()

public:
	AunrealGameMode();

private:
	void StartPlay() override;
	void Tick(float DeltaTime) override;

	TAutoPtr<improbable::unreal::core::FWorkerConnection> Connection;
	TAutoPtr<improbable::unreal::entity_spawning::FEntitySpawner> Spawner;

	static void AunrealGameMode::ConfigureWindowSize();
	void AunrealGameMode::CreateWorkerConnection();
	void AunrealGameMode::RegisterEntityBlueprints();

	static void AunrealGameMode::MakeWindowed(int32 Width, int32 Height);
	static UGameUserSettings* AunrealGameMode::GetGameUserSettings();
};



