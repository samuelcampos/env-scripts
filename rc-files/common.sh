

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

if [[ $OSTYPE == linux* ]]; then
    alias ll="ls -lh"
fi
