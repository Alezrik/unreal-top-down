#/bin/
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

BUILD_TOOL="C:/Program Files (x86)/Epic Games/4.12/Engine/Build/BatchFiles/RunUAT.bat"
PROJECT_PATH=$SCRIPTPATH"/"
PROJECT_NAME="unreal"

OUTPUT_DIR=$PROJECT_PATH"temp_worker_builds/"
FSIM_DIR=$OUTPUT_DIR"fsim/"
CLIENT_DIR=$OUTPUT_DIR"client/"

echo "Removing worker build output directory: " $OUTPUT_DIR " ..."

rm -rf $OUTPUT_DIR # remove the output directory if already exists

WORKER_ASSEMBLY_DIR=$PROJECT_PATH"../../build/assembly/worker/"
FSIM_NAME="UnrealFsim@Windows"
CLIENT_NAME="UnrealClient@Windows"
GENERATED_FOLDER="WindowsNoEditor/"
GENERATED_EXE=$PROJECT_NAME".exe"

echo "Removing worker build assembly directory: " $WORKER_ASSEMBLY_DIR " ..."

rm -rf $WORKER_ASSEMBLY_DIR