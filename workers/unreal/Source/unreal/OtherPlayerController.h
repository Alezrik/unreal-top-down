// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "AIController.h"
#include "OtherPlayerController.generated.h"

/**
 * 
 */
UCLASS()
class UNREAL_API AOtherPlayerController : public AAIController
{
	GENERATED_BODY()
	
public:
	AOtherPlayerController();

protected:
	virtual void BeginPlay() override;
	virtual void Tick(float DeltaTime) override;

	class UTransformReceiver* TransformReceiver;
	void SetNewMoveDestination(const FVector DestLocation);
};
