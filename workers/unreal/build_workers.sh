#/bin/
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

BUILD_TOOL="C:/Program Files (x86)/Epic Games/4.12/Engine/Build/BatchFiles/RunUAT.bat"
PROJECT_PATH=$SCRIPTPATH"/"
PROJECT_NAME="unreal"

OUTPUT_DIR=$PROJECT_PATH"temp_worker_builds/"
FSIM_DIR=$OUTPUT_DIR"fsim/"
CLIENT_DIR=$OUTPUT_DIR"client/"

rm -rf $OUTPUT_DIR # remove the output directory if already exists

echo "Building Unreal Fsim..."

eval \"$BUILD_TOOL\" BuildCookRun -project=\"$PROJECT_PATH$PROJECT_NAME.uproject\" -noP4 -platform=Win64 -clientconfig=Shipping -cook -allmaps -build -stage -pak -archive -archivedirectory=\"$FSIM_DIR\"

echo "Building Unreal Client..."

eval \"$BUILD_TOOL\" BuildCookRun -project=\"$PROJECT_PATH$PROJECT_NAME.uproject\" -noP4 -platform=Win64 -clientconfig=Development -cook -allmaps -build -stage -pak -archive -archivedirectory=\"$CLIENT_DIR\"

WORKER_ASSEMBLY_DIR=$PROJECT_PATH"../../build/assembly/worker/"
FSIM_NAME="UnrealFsim@Windows"
CLIENT_NAME="UnrealClient@Windows"
GENERATED_FOLDER="WindowsNoEditor/"
GENERATED_EXE=$PROJECT_NAME".exe"

echo "Zipping up Fsim..."

pushd $FSIM_DIR$GENERATED_FOLDER
mv $GENERATED_EXE $FSIM_NAME".exe"
zip -r $FSIM_NAME".zip" "."
popd

pushd $CLIENT_DIR$GENERATED_FOLDER
mv $GENERATED_EXE $CLIENT_NAME".exe"
# zip -r $CLIENT_NAME".zip" "."
popd

mkdir -p $WORKER_ASSEMBLY_DIR

pushd $WORKER_ASSEMBLY_DIR
rm -rf . # clean the worker assembly directory if not empty
popd

mv $FSIM_DIR$GENERATED_FOLDER$FSIM_NAME".zip" $WORKER_ASSEMBLY_DIR$FSIM_NAME".zip"

cp -r $CLIENT_DIR$GENERATED_FOLDER $WORKER_ASSEMBLY_DIR
pushd $WORKER_ASSEMBLY_DIR
mv $GENERATED_FOLDER $CLIENT_NAME
popd

rm -rf $OUTPUT_DIR # remove the output directory as no longer need it

echo "Finished building workers"

# mv $CLIENT_DIR$GENERATED_FOLDER$CLIENT_NAME".zip" $WORKER_ASSEMBLY_DIR$CLIENT_NAME".zip"
