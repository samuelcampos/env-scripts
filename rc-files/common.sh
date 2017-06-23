
function yesNoQuestion () {
  QUESTION=$1;

  while true
  do
    echo "$QUESTION (y/n) "
    read choice
    echo ""
    case "$choice" in 
      y|Y ) 
        return 0
        ;;
      n|N )
        return 1
        ;;
      * ) echo "invalid option";;
    esac
  done
}


# GIT Helpers

function gitPR () {
    if yesNoQuestion "Pull a rebased branch ($1), discarding ALL local changes?"; then
        git reset --hard $1
    fi
}