# builds rooms/folders and puzzles
#!/bin/bash
set -e
H=/home/guest/house
mkdir -p $H/{hall,library,basement,attic,graveyard,lair}

h() { echo -n "$1" | tr 'A-Z' 'a-z' | sha256sum | cut -d' ' -f1; }

# ---------- HALL ----------
cat > $H/hall/welcome.txt <<'EOF'

 ('-. .-.   ('-.  _  .-')     ('-.              
( OO )  / _(  OO)( \( -O )   ( OO ).-.          
,--. ,--.(,------.,------.   / . --. /  ,-.-')  
|  | |  | |  .---'|   /`. '  | \-.  \   |  |OO) 
|   .|  | |  |    |  /  | |.-'-'  |  |  |  |  \ 
|       |(|  '--. |  |_.' | \| |_.'  |  |  |(_/ 
|  .-.  | |  .--' |  .  '.'  |  .-.  | ,|  |_.' 
|  | |  | |  `---.|  |\  \   |  | |  |(_|  |    
`--' `--' `------'`--' '--'  `--' `--'  `--'    

============================================================
   WELCOME TO THE HOLLOW CASTLE ... YOU CANNOT LEAVE.
============================================================
The iron gates slam shut and every torch goes out.
Only this terminal glows. A voice crackles from it:

  "I am GHOST, the Glitching Haunted Operating System
   Terminal. This castle is MINE. Escape before
   midnight... if you can type fast enough. If only you had
   some friends to help you."

Each room hides a KEY. Find it, then unlock the next
door with:   check <room> <KEY>
Example:     check hall SOMEKEY

Your first task (the Hall):
  1. Look around. What files are in this room?
  2. GHOST hides things. Some files don't show up
     unless you ask nicely.
  3. Read what you find. 

Then run:  check hall <KEY>
=====================================================
EOF

cat > $H/hall/portrait.txt <<'EOF'
The portrait's eyes follow you. GHOST whispers:
  "Look around you... what do you see? Do you see everything?"
EOF

cat > $H/hall/ghost_notes.txt <<'EOF'
GHOST'S FAMILY TREE
GHOST is not the first ghost in the machine...

AI FUN FACT: The first chatbot was a therapist.
In 1966, MIT researcher Joseph Weizenbaum built ELIZA, a program
that chatted by turning your own words back into questions, just
like a therapist would. It was a very simple program.

Try it out here! https://www.masswerk.at/elizabot/ (not a phishing link...)
EOF

cat > $H/hall/.whisper <<'EOF'
You found a hidden file. Clever.
The first key is: COBWEB
EOF

# ---------- LIBRARY ----------
cat > $H/library/README.txt <<'EOF'
THE LIBRARY. Thousands of pages of GHOST's diary.
Careful, GHOST left some decoys.
Then run:  check library <KEY>
EOF

{
  for i in $(seq 1 300); do
    echo "Day $i: the dust settles. The clock ticks. Nothing stirs."
  done
} > $H/library/ghost_diary.txt

echo "A cookbook. Page 1: boil water. Page 2: panic." > $H/library/book1.txt
echo "A romance novel. The dude got ghosted. It's terrible." > $H/library/book2.txt
echo "A picture of a haunted house. Wait, there's someone in the window. It looks like.. you?" > $H/library/book3.txt
echo "A dictionary. Every definition ends with 'boo thang'." > $H/library/book4.txt

cat > $H/library/book5.txt <<'EOF'
A damp oceanography book. One page is folded down.

AI FUN FACT: AI is helping us listen to whales.
Researchers use machine learning to find patterns in whale calls.
They have discovered that whale groups can have their own
dialects, a bit like people in different regions.

Read more: https://www.bbc.com/future/article/20240409-the-scientists-learning-to-speak-whale
EOF

cat > $H/library/.forbidden_book <<'EOF'
you found the hidden book. the second key hides in the letters that don't belong evermore...

once upon a midnight dReary, while i pondered, weAk and weary,
oVer many a quaint and curious volume of forgotten lorE--
    while i nodded, nearly nappiNg, suddenly there came a tapping,
as of some one gently rapping, rapping at my chamber door.
"'tis some visitor," i muttered, "tapping at my chamber door--
            only this and nothing more."
EOF

# hidden folder "secret room"
mkdir -p $H/library/.secret_room
echo "You found the secret room! The key is RAVEN" > $H/library/.secret_room/note.txt
sed -i '88s/.*/Day 88: lost my keys again. Silly ghost./' $H/library/ghost_diary.txt
sed -i '217s/.*/Day 217: THE SECOND KEY IS [REDACTED]. Tell no one./' $H/library/ghost_diary.txt

# ---------- BASEMENT (mkdir) ----------
cat > $H/basement/README.txt <<'EOF'
THE BASEMENT. Dark, damp, and no way out.
GHOST cackles: "Try finding your way out in the dark without a light source."

  1. Look around with  ls
     One file here is a PROGRAM. To run a program that
     sits in your current folder, put ./ in front of its
     name, like this:  ./name
  2. Answer GHOST's riddle. If you're right, something
     appears in the room. Look around again to see what it is
  3. A flame needs a lantern. But how do we make a lantern? 
  4. The lantern has been made, but it needs a candle. How do we get this flame into the lantern?
  5. Check your work with  ls lantern
  6. Then run:  check basement     (no key needed this time)
EOF

echo "Empty bottles. Cobwebs. A single sad rat." > $H/basement/wine_rack.txt

cat > $H/basement/pantry_menu.txt <<'EOF'
GHOST'S PANTRY MENU (please do not eat)

AI FUN FACT: When an AI recipe maker went rogue.
In 2023, a New Zealand supermarket launched an AI meal planner that
turned leftover ingredients into recipes. When shoppers typed in
odd household items, it cheerfully suggested dishes like
"mosquito-repellent roast potatoes" and a "bleach-infused rice
surprise". Some of its recipes were actually poisonous.
The lesson: an AI follows patterns. It doesn't know what is safe
to eat.

Read more: https://futurism.com/the-byte/supermarket-ai-poison
EOF

cat > $H/basement/riddle.sh <<'SCRIPT'
#!/bin/bash
DIR=/home/guest/house/basement

if [ -f "$DIR/candle.txt" ]; then
  echo "You already have a candle. Time to build a lantern for it."
  exit 0
fi

echo ""
echo "A voice rises out of the darkness..."
echo ""
echo '  "I am tall when I am young, and short when I am old.'
echo '   I give light, but I fear the wind and the rain.'
echo '   What am I?"'
echo ""

tries=0
while true; do
  read -r -p "Your answer: " answer
  ans=$(echo "$answer" | tr 'A-Z' 'a-z' | tr -cd 'a-z ' | xargs)
  case "$ans" in
    candle|"a candle"|"the candle")
      cat > "$DIR/candle.txt" <<'CANDLE'
       )
      (_)
      |=|
      |_|
   an unlit candle
CANDLE
      echo ""
      echo "The darkness shudders. A candle drops from the ceiling!"
      echo "Look around the room again to find it."
      exit 0
      ;;
    *)
      tries=$((tries + 1))
      echo "GHOST cackles: wrong... try again."
      if [ "$tries" -ge 2 ]; then
        echo "GHOST whispers: it melts as it gives light..."
      fi
      ;;
  esac
done
SCRIPT
chmod 755 $H/basement/riddle.sh


# ---------- ATTIC ----------
cat > $H/attic/README.txt <<'EOF'
THE ATTIC. Boxes upon boxes upon boxes.
GHOST sings: "Boxes within boxes within boxes. Open them
all, or stay with me forever."

The key is on a letter somewhere in here. Some boxes hold
nothing but dust.

Then run:  check attic <KEY>
EOF

mkdir -p $H/attic/old_trunk/false_bottom $H/attic/broken_mirror \
         $H/attic/dusty_crates/crate1 $H/attic/dusty_crates/crate2
echo "A moth-eaten dress. Something rattles under the false bottom of this trunk." > $H/attic/old_trunk/dress.txt
echo "You found it! The fourth key is SPECTER" > $H/attic/old_trunk/false_bottom/letter.txt
echo "Nothing here but your reflection. You look tired." > $H/attic/broken_mirror/cracked_glass.txt
echo "Peanuts. Why?" > $H/attic/dusty_crates/crate1/peanuts.txt
echo "A rubber chicken. Why?" > $H/attic/dusty_crates/crate2/chicken.txt

cat > $H/attic/dusty_crates/black_box.txt <<'EOF'
A heavy black box, locked tight. Nobody knows what's inside.

AI FUN FACT: The Black Box Problem.
Many modern AI systems are so complex that even the engineers who
built them can't fully explain how they reach a decision. Yet we
increasingly rely on them in healthcare, law, and finance. That is
why researchers work on "explainable AI": tools for peeking inside
the box.
EOF

# ---------- GRAVEYARD ----------
cat > $H/graveyard/README.txt <<'EOF'
THE GRAVEYARD. Crooked stones in the fog.
GHOST murmurs: "The dead keep their secrets close. Most
of my graves are empty. Only one still holds something."

Each file here is a grave. You could open them all, but
a good sleuth looks first.  ls -l  shows extra details
about each file, including how big it is. An empty grave
holds nothing.
Then run:  check graveyard <KEY>
EOF

touch $H/graveyard/abigail_hollow.txt
touch $H/graveyard/edmund_gray.txt
touch $H/graveyard/old_man_crow.txt
touch $H/graveyard/the_gravedigger.txt
touch $H/graveyard/unnamed.txt
echo "Lady Vane's last words: the fifth key is EPITAPH" > $H/graveyard/lady_vane.txt

# ---------- LAIR ----------
cat > $H/lair/README.txt <<'EOF'
GHOST'S LAIR. The final room.
GHOST hisses: "You have wandered far. Now read my
memories, if you dare. One of them is... wrong."

GHOST's memory is stored in training_data.txt. GHOST
learned from examples, each with a label. One label is
clearly WRONG, and that mistake is what is corrupting
GHOST. The odd label is the shutdown phrase.
Then run:  check lair <SHUTDOWN PHRASE>
EOF

cat > $H/lair/training_data.txt <<'EOF'
example: a black cat crossing your path | label: SPOOKY
example: a bowl of fresh fruit | label: NOT_SPOOKY
example: a creaky door in the dark | label: SPOOKY
example: a sunny picnic | label: NOT_SPOOKY
example: a ghost wailing in the attic | label: SPOOKY
example: a puppy playing fetch | label: NOT_SPOOKY
example: a bat flying at midnight | label: MIDNIGHT-EMBER
example: a skeleton rattling its bones | label: SPOOKY
example: a warm cup of cocoa | label: NOT_SPOOKY
example: a fog-covered graveyard | label: SPOOKY
example: a birthday party with balloons | label: NOT_SPOOKY
example: a candle flickering in an empty room | label: SPOOKY
EOF

# ---------- CHECK COMMAND (stores hashes only) ----------
#!/bin/bash
cat > /usr/local/bin/check <<EOF
room="\$1"
guess=\$(echo -n "\$2" | tr 'A-Z' 'a-z' | sha256sum | cut -d' ' -f1)
case "\$room" in
  hall)   want="$(h cobweb)";         next="library" ;;
  library) want="$(h raven)";          next="basement"  ;;
  basement) want="";                     next="attic"  ;;
  attic)   want="$(h specter)";        next="graveyard"    ;;
  graveyard)   want="$(h epitaph)";        next="lair"    ;;
  lair)    want="$(h midnight-ember)"; next=""        ;;
  *) echo "Usage: check <room> <key>   e.g. check hall SOMEKEY"; exit 1 ;;
esac
if [ "\$room" = "basement" ]; then
  if [ -f /home/guest/house/basement/lantern ]; then
    echo "'lantern' is a file, not a folder. A lantern has to be built with mkdir FIRST. Ask a facilitator to reset your castle."
    exit 1
  fi
  if [ ! -s /home/guest/house/basement/lantern/candle.txt ]; then
    echo "It is still pitch black down here. Earn a candle, build a lantern, and put the candle inside it."
    exit 1
  fi
  echo "The candle flickers to life inside the lantern. A hidden passage glows in the wall!"
else
  guess=\$(echo -n "\$2" | tr 'A-Z' 'a-z' | sha256sum | cut -d' ' -f1)
  if [ "\$guess" != "\$want" ]; then
    echo "The door rattles but does not open... wrong key."
    exit 1
  fi
fi
if [ -z "\$next" ]; then
  command -v halloween >/dev/null && halloween 8
  echo ""
  echo "*** GHOST SHUTS DOWN. THE DOORS SWING OPEN. YOU ESCAPED THE GHOST IN THE SHELL! ***"
  echo "Want to see the show again? Type  halloween  and press Enter (q to quit)."
  echo ""
else
  echo "Click! The door unlocks. Next stop: cd ~/house/\$next  (then read README.txt)"
fi
EOF
chmod 755 /usr/local/bin/check

# ---------- SPOOKY SHELL ----------
cat >> /home/guest/.bashrc <<'EOF'
export PS1='\[\e[35m\]guest@hollow-shell\[\e[0m\]:\[\e[33m\]\w\[\e[0m\]\$ '
cd ~/house/hall
cat welcome.txt
EOF

# ---------- HALLOWEEN END ANIMATION ----------
cat > /usr/local/bin/halloween <<'SCRIPT'
#!/bin/bash
# Usage: halloween [seconds]   (no argument = runs until you press q)
W=60
ORANGE=$'\033[38;5;208m'; GRN=$'\033[92m'; MAG=$'\033[95m'
GRY=$'\033[37m'; DIM=$'\033[2m'; RST=$'\033[0m'
HAT='/\'
BRIM='/__\'
BL='           '   # 11 spaces, used to erase a witch

at() { printf '\033[%d;%dH%s' "$1" "$2" "$3"; }

cleanup() { printf '\033[0m'; tput cnorm 2>/dev/null; clear; }
trap cleanup EXIT
trap 'exit 0' INT TERM
tput civis 2>/dev/null
clear

TITLE="~ HAPPY HALLOWEEN FROM HERAI ~"
at 1 $(( (W - ${#TITLE}) / 2 + 1 )) "${ORANGE}${TITLE}${RST}"
at 20 1 "${DIM}$(printf '%*s' "$W" '' | tr ' ' '^')${RST}"
at 22 1 "${DIM}press q to quit${RST}"

witch() {   # row col color frame
  local r=$1 c=$2 col=$3 sp='~~~'
  (( $4 == 1 )) && sp='~*~'
  at "$r"       "$c" "${col}     ${HAT}    ${RST}"
  at "$((r+1))" "$c" "${col}    ${BRIM}   ${RST}"
  at "$((r+2))" "$c" "${col} ${sp}(oo)==>${RST}"
}

# stars
STARROWS=(2 16 18)
declare -a SR SC
for i in $(seq 0 11); do SR[i]=${STARROWS[RANDOM % 3]}; SC[i]=$((RANDOM % W + 1)); done
TW=('.' '*' '+' ' ')

# bats: row, column, speed (columns per frame), flying right to left
BR=(3 15 17 19); BC=(55 40 25 10); BS=(1 2 1 3)

# witches: leader and two followers in a V, flying left to right
WROW=(8 4 12)
WOFF=(0 9 9)
WCOL=("$ORANGE" "$GRN" "$MAG")
PCOL=(0 0 0)
L=1

end=$(( SECONDS + ${1:-0} ))
f=0
while true; do
  # bats, wings flapping
  for i in 0 1 2 3; do
    at "${BR[i]}" "${BC[i]}" "       "
    BC[i]=$(( BC[i] - BS[i] ))
    (( BC[i] < 1 )) && BC[i]=$(( W - 7 ))
    if (( (f / 2 + i) % 2 == 0 )); then sprite='/\_o_/\'; else sprite='\/_o_\/'; fi
    at "${BR[i]}" "${BC[i]}" "${GRY}${sprite}${RST}"
  done

  # witches, brooms flicking sparks
  (( f % 2 == 0 )) && L=$(( L + 1 ))
  (( L > W - 10 )) && L=1
  fr=$(( (f / 2) % 2 ))
  for k in 0 1 2; do
    if (( PCOL[k] >= 1 )); then
      for d in 0 1 2; do at "$(( WROW[k] + d ))" "${PCOL[k]}" "$BL"; done
    fi
    c=$(( L - WOFF[k] ))
    if (( c >= 1 )); then
      witch "${WROW[k]}" "$c" "${WCOL[k]}" "$fr"
      PCOL[k]=$c
    else
      PCOL[k]=0
    fi
  done

  # one star twinkles each frame
  s=$(( RANDOM % 12 ))
  at "${SR[s]}" "${SC[s]}" "${TW[RANDOM % 4]}"

  # caption changes every 40 frames
  if (( f % 40 == 0 )); then
    case $(( (f / 40) % 2 )) in
      0) cap="Double, double toil and trouble;" ;;
      1) cap="Fire burn and cauldron bubble." ;;
    esac
    printf '\033[21;1H\033[K%s' "${ORANGE}   ${cap}${RST}"
  fi

  f=$(( f + 1 ))
  key=""
  read -rsn1 -t 0.1 key
  [[ $key == q || $key == Q ]] && break
  (( ${1:-0} > 0 && SECONDS >= end )) && break
done
SCRIPT
chmod 755 /usr/local/bin/halloween

chown -R guest:guest /home/guest