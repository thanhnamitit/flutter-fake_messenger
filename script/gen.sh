mode="build"

if [ "$1" = "w" ]
then
  mode="watch"
fi

command="flutter pub run build_runner ${mode} --delete-conflicting-outputs"

echo "Run command: ${command}"

${command}

echo "=========== Code gen done ============"