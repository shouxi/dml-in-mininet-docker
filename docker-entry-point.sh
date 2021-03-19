#!/bin/bash
set -e

usage() {
  echo "docker run ciena/mininet [options]"
  echo "    -h                         display help information"
  echo "    /path/file ARG1 .. ARGn    execute the specfified local file"
  echo "    URL ARG1 .. ARGn           download script from URL and execute it"
  echo "    --ARG1 .. --ARGn           execute mininet with these arguments"
}

launch() {
  # If no options are given or if only a single option is given and it is "-h"
  # display help infformation
  if [ $# -eq 0 -o $1 == "-h" ]; then
    usage
  else

    # If first argument is a URL then download the script and execute it passing
    # it the rest of the arguments
    if [[ $1 =~ ^(file|http|https|ftp|ftps):// ]]; then
      curl -s -o ./script $1
      chmod 755 ./script
      shift
      exec ./script $@

    # If first argument is an absolute file path then execute that file passing
    # it the rest of the arguments
    elif [[ $1 =~ ^/ ]]; then
      exec $@

    # If first argument looks like an argument then execute mininet with all the
    # arguments
    elif [[ $1 =~ ^- ]]; then
      exec mn $@
   
    # Unknown argument
    else
      usage
    fi
  fi
}

# Start the Open Virtual Switch Service
service openvswitch-switch start
ovs-vsctl set-manager ptcp:6640

launch $@
