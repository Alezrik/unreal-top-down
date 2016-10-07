// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "Components/ActorComponent.h"
#include "SpatialEntityStorageComponent.h"
#include "TransformReceiver.h"
#include "TransformSender.generated.h"

UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class UTransformSender : public UActorComponent
{
	GENERATED_BODY()

public:	
	// Sets default values for this component's properties
	UTransformSender();

	// Called when the game starts
	virtual void BeginPlay() override;
	
	// Called every frame
	virtual void TickComponent( float DeltaTime, ELevelTick TickType, FActorComponentTickFunction* ThisTickFunction ) override;

	UFUNCTION(BlueprintCallable, Category = "SpatialOS")
	bool HasAuthority() const;

private:
	USpatialEntityStorageComponent* mSpatialComponent;
	UTransformReceiver *mTransformReceiver;
	void Initialise();
	bool IsInitialised() const;
	worker::Entity* GetEntity() const;

};
