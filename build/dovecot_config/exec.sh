safeRunCommand(){
  typeset cmnd="$*"
  typeset ret_code

  eval $cmnd
  ret_code=$?
  if [ $ret_code ]; then
    exit 0
  else
     printf "$ret_code"
     exit 1
  fi
}

command="$1"
safeRunCommand "$command"

exit 0

