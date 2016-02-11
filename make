#!/bin/sh
set -e


: "${SIMULATE:=0}"

CMDS='build tag push'
VARIATIONS='base onbuild'


main() {
  local cmds=$1 variations=${2:-$VARIATIONS}
  if ! one_of "$cmds" $CMDS all; then
    echo >&2 "ERROR: unknown command '$cmds'."
    echo >&2 "Must be one of: $CMDS all."
    return 1
  fi
  if [ "$cmds" = 'all' ]; then
    cmds=$CMDS
  fi
  local img=$(cat .image)
  local variation cmd; for variation in $variations; do
    for cmd in $cmds; do
      "$cmd" "$img" "$variation"
    done
  done
}


with_variations() { # cmd img variation...
  local cmd=$1; shift
  local img=$1; shift
  local variation; for variation in "$@"; do
    "$cmd" "$img" "$variation"
  done
}


build() { # img variation
  local img=$1 variation=$2
  info "Building variation '$variation'"
  q docker rmi "$img:$variation-build-new"
  n docker build -t "$img:$variation-build-new" "$variation"
  q docker rmi "$img:$variation-build"
  q docker tag "$img:$variation-build-new" "$img:$variation-build"
  q docker rmi "$img:$variation-build-new"
}


tag() { # img variation
  local img=$1 variation=$2
  info "Tagging variation: $variation"
  local tag name; while read tag; do
    name=$(image_name "$img" "$tag" "$variation")
    q docker rmi "$name"
    n docker tag -f "$img:$variation-build" "$name"
  done < .tags
}


push() { # img variation
  local img=$1 variation=$2 suffix=$(tag_suffix_for "$variation")
  info "Pushing variation: $variation"
  local tag name; while read tag; do
    n docker push "$(image_name "$img" "$tag" "$variation")"
  done < .tags
}


image_name() { # img tag variation
  local img=$1 tag=$2 variation=$3
  if [ "$variation" != 'base' ]; then
    if [ "$tag" = 'latest' ]; then
      tag=$variation
    else
      tag=$tag-$variation
    fi
  fi
  printf '%s\n' "$img:$tag"
}


tag_suffix_for() { # variation
  if [ "$1" != 'base' ]; then
    printf -- '-%s\n' "$1"
  fi
}


info() {
  printf '\n==> %s\n\n' "$*"
}


one_of() { # item items...
  local item=$1; shift
  local i; for i in "$@"; do
    if [ "$item" = "$i" ]; then
      return
    fi
  done
  return 1
}


if [ "$SIMULATE" = 1 ]; then
  q() { echo "- $*"; }
  n() { echo "+ $*"; }
else
  q() {
    local cmd=$1; shift
    "$cmd" "$@" >/dev/null 2>&1 || true
  }
  n() {
    local cmd=$1; shift
    printf '+ %s %s\n' "$cmd" "$*"
    "$cmd" "$@"
  }
fi


main "$@"
