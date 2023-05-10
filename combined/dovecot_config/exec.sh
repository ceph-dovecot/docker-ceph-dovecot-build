safeRunCommand(){
  typeset cmnd="$*"
  typeset ret_code

  eval $cmnd
#  ret_code=$?
  if [ $? -eq 0 ]; then
    exit 1
  else
    exit 0
  fi
}

command=$1
safeRunCommand "$command"

exit 0

