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
GHOST cackles: "No way out? Then build one. Only builders
escape my basement."

Dig an escape tunnel: make a new folder called tunnel
right here in the basement.
Confirm it exists with  ls
Then run:  check basement     (no key needed this time)
EOF

echo "Empty bottles. Cobwebs. A single sad rat." > $H/basement/wine_rack.txt


# ---------- CELLAR ----------
cat > $H/cellar/README.txt <<'EOF'
THE CELLAR. A cursed chest sits in the corner:
chest.txt. It is sealed tight.
Check its permissions with  ls -l  and see why you
can't open it. Then change them.  (hint: chmod)
Then run:  check cellar <KEY>
EOF



echo "Inside the chest, a lantern glows. The third key is: LANTERN" > $H/cellar/chest.txt
chmod 000 $H/cellar/chest.txt

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
GHOST's memory is corrupted. sightings.log is full of
junk lines (CORRUPTED#...), blank lines, and repeated
words. Hidden among them is the ONE entry that
appears exactly once: GHOST's shutdown phrase.
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
cat > /usr/local/bin/check <<EOF
#!/bin/bash
room="\$1"
guess=\$(echo -n "\$2" | tr 'A-Z' 'a-z' | sha256sum | cut -d' ' -f1)
case "\$room" in
  hall)   want="$(h cobweb)";         next="library" ;;
  library) want="$(h raven)";          next="basement"  ;;
  basement) want="";                     next="atticr"  ;;
  attic)   want="$(h specter)";        next="graveyard"    ;;
  graveyard)   want="$(h epitaph)";        next="lair"    ;;
  lair)    want="$(h midnight-ember)"; next=""        ;;
  *) echo "Usage: check <room> <key>   e.g. check hall SOMEKEY"; exit 1 ;;
esac
if [ "\$room" = "basement" ]; then
  if [ ! -d /home/guest/castle/basement/tunnel ]; then
    echo "The wall stays solid. Dig a tunnel first: make a folder called 'tunnel' in the basement."
    exit 1
  fi
else
  guess=\$(echo -n "\$2" | tr 'A-Z' 'a-z' | sha256sum | cut -d' ' -f1)
  if [ "\$guess" != "\$want" ]; then
    echo "The door rattles but does not open... wrong key."
    exit 1
  fi
fi
if [ -z "\$next" ]; then
  echo ""
  echo "*** GHOST SHUTS DOWN. THE DOORS SWING OPEN. YOU ESCAPED THE GHOST IN THE SHELL! ***"
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

chown -R guest:guest /home/guest