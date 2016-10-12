#!/bin/bash
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

if [ -z $UNREAL_HOME ]; then
	echo "ERROR: you must set the environment variable UNREAL_HOME to the location of your Unreal Engine source directory"
	exit 1
fi

BUILD_TOOL=$UNREAL_HOME"/Engine/Build/BatchFiles/RunUAT.bat"
PROJECT_PATH=$SCRIPTPATH"/"
PROJECT_NAME="unreal"

TEMP_DIR=$PROJECT_PATH"temp_worker_builds/"

if [ -d $TEMP_DIR ]; then
	rm -rf $TEMP_DIR # remove the output directory if already exists
fi

echo "Building unreal client and server..."

eval \"$BUILD_TOOL\" BuildCookRun -project=\"$PROJECT_PATH$PROJECT_NAME.uproject\" -noP4 -platform=Win64 -clientconfig=Development -serverconfig=Development -cook -server -serverplatform=Win64 -allmaps -build -stage -pak -archive -archivedirectory=\"$TEMP_DIR\"

WORKER_ASSEMBLY_DIR=$PROJECT_PATH"../../build/assembly/worker/"

FSIM_NAME="UnrealFsim@Windows"
FSIM_FOLDER="WindowsServer/"
FSIM_EXE=$PROJECT_NAME"Server.exe"

CLIENT_NAME="UnrealClient@Windows"
CLIENT_FOLDER="WindowsNoEditor/"
CLIENT_EXE=$PROJECT_NAME".exe"

echo "Zipping up Fsim..."

pushd $TEMP_DIR$FSIM_FOLDER
mv $FSIM_EXE $FSIM_NAME".exe"
jar -cMf $FSIM_NAME".zip" "."
popd

pushd $TEMP_DIR$CLIENT_FOLDER
mv $CLIENT_EXE $CLIENT_NAME".exe"
# jar -cMf $CLIENT_NAME".zip" "."
popd

# create and clean the build assembly worker directory

mkdir -p $WORKER_ASSEMBLY_DIR

pushd $WORKER_ASSEMBLY_DIR

if [ -f $FSIM_NAME".zip" ]; then
	rm -rf $FSIM_NAME".zip"
fi

if [ -d $CLIENT_NAME ]; then
	rm -rf $CLIENT_NAME
fi

popd

# move fsim zip file into build assembly worker folder

mv $TEMP_DIR$FSIM_FOLDER$FSIM_NAME".zip" $WORKER_ASSEMBLY_DIR$FSIM_NAME".zip"

# copy the client folder into build assembly worker folder

cp -r $TEMP_DIR$CLIENT_FOLDER $WORKER_ASSEMBLY_DIR
pushd $WORKER_ASSEMBLY_DIR
mv $CLIENT_FOLDER $CLIENT_NAME
popd

rm -rf $TEMP_DIR # remove the temp directory as no longer need it

echo "Finished building workers"

# mv $CLIENT_DIR$GENERATED_FOLDER$CLIENT_NAME".zip" $WORKER_ASSEMBLY_DIR$CLIENT_NAME".zip"
