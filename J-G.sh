#!/bin/bash

action=$1

START="start"
RESTART="restart"
STOP="stop"
application="G-A"

PROJECT_FOLDER=$(cd "$(dirname "$0")";pwd)

echo "项目路径: $PROJECT_FOLDER"

SOURCE_DIR="$PROJECT_FOLDER/src"

function get_num() {
  num=$(ps -ef | grep -w "./main" | grep -v grep | wc -l)
  return $num
}


function start() {
  if [[ -f $PROJECT_FOLDER ]]; then
    rm -rf "$PROJECT_FOLDER/main"
  fi

  echo "编译中"
  go build "$SOURCE_DIR/main.go"
  echo "编译完成"

  echo "$application starting~~~~~~"
  nohup $PROJECT_FOLDER/main &
  sleep 3
  rm -rf $PROJECT_FOLDER/nohup.out
  get_num
  num=$?

  if [[ num -eq 0 ]]; then
    echo "$application failed!!!!!!"
  else
    echo "$application started!!!!!!"
    rm -rf "$PROJECT_FOLDER/main"
  fi
  
}

function stop() {
  rm -rf "$PROJECT_FOLDER/main"
  ps -ef | grep "./main" | grep -v grep | awk '{print $2}' | xargs kill -9

  echo "$application is stopping~~~~~~"
  sleep 2

  get_num
  num=$?
  if [[ $num -eq 0 ]]; then
    echo "$application stopped!!!!!!"
  else
    echo "$application stop failed"
  fi

}

function restart() {
  get_num
  num=$?
  echo "num: $num"
  if [[ $num -gt 0 ]]; then
    stop
  fi
  start
}

if [[ "$action" == "$START" ]]; then
  start
elif [[ "$action" == "$RESTART" ]]; then
  restart
elif [[ "$action" == "$STOP" ]]; then
  stop
fi
