# builds rooms/folders and puzzles
#!/bin/bash
set -e
H=/home/guest/house
mkdir -p $H/{foyer,library,cellar,attic,lair}

h() { echo -n "$1" | tr 'A-Z' 'a-z' | sha256sum | cut -d' ' -f1; }

# ---------- FOYER ----------
cat > $H/foyer/welcome.txt <<'EOF'
============================================================
   WELCOME TO HUNTED STUDENTS CASTLE ... YOU CANNOT LEAVE.
============================================================
The doors slam shut. A cold voice hisses from the walls:

  "I am GHOST, the Glitching Haunted Operating System
   Terminal. This castle is MINE. Escape before
   midnight... if you can type."

Each room hides a KEY. Find it, then unlock the next
door with:   check <room> <KEY>
Example:     check foyer SOMEKEY

Your first task (the Foyer):
  1. Look around. What files are in this room?  (ls)
  2. GHOST hides things. Some files don't show up
     unless you ask nicely.  (hint: ls -a)
  3. Read what you find.  (cat)

Then run:  check foyer <KEY>
=====================================================
EOF

cat > $H/foyer/.whisper <<'EOF'
You found a hidden file. Clever.
The first key is: COBWEB
EOF

# ---------- LIBRARY ----------
cat > $H/library/README.txt <<'EOF'
THE LIBRARY. Thousands of pages of GHOST's diary.
Somewhere in ghost_diary.txt is the second key.
Reading every line would take all night. Let the
computer search for you.
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
echo "You found the hidden book! The second key is here... " > $H/library/.forbidden_book

cat > $H/library/blank_page.txt <<'EOF'
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
THE ATTIC. Something is rattling around up here.
A ghost is running as a process on this machine.
  1. Find it.  (hint: ps aux, and maybe grep)
  2. Make it stop.  (hint: kill)
Be polite about it. Rough methods leave nothing
behind. When it fades, check this room for a file.
Then run:  check attic <KEY>
EOF

# ---------- LAIR ----------
cat > $H/lair/README.txt <<'EOF'
GHOST'S LAIR. The final room.
GHOST's memory is corrupted. sightings.log is full of
junk lines (CORRUPTED#...), blank lines, and repeated
words. Hidden among them is the ONE entry that
appears exactly once: GHOST's shutdown phrase.

Clean the data and count what is left.
Hints: grep -v, sort, uniq -c, and sort -n
Pipes (|) let you chain commands together.

Then run:  check lair <SHUTDOWN PHRASE>
EOF

words=(CREAK WHISPER SHADOW MOAN CHILL)
{
  for i in $(seq 1 400); do echo "${words[RANDOM % 5]}"; done
  for i in $(seq 1 40);  do echo "CORRUPTED#$RANDOM"; done
  echo "MIDNIGHT-EMBER"
} | shuf > $H/lair/sightings.log

# ---------- CHECK COMMAND (stores hashes only) ----------
cat > /usr/local/bin/check <<EOF
#!/bin/bash
room="\$1"
guess=\$(echo -n "\$2" | tr 'A-Z' 'a-z' | sha256sum | cut -d' ' -f1)
case "\$room" in
  foyer)   want="$(h cobweb)";         next="library" ;;
  library) want="$(h raven)";          next="cellar"  ;;
  cellar)  want="$(h lantern)";        next="attic"   ;;
  attic)   want="$(h specter)";        next="lair"    ;;
  lair)    want="$(h midnight-ember)"; next=""        ;;
  *) echo "Usage: check <room> <key>   e.g. check foyer SOMEKEY"; exit 1 ;;
esac
if [ "\$guess" != "\$want" ]; then
  echo "The door rattles but does not open... wrong key."
  exit 1
fi
if [ -z "\$next" ]; then
  echo ""
  echo "*** GHOST SHUTS DOWN. THE DOORS SWING OPEN. YOU ESCAPED HUNTED STUDENTS CASTLE! ***"
  echo ""
else
  echo "Click! The door unlocks. Next stop: cd ~/house/\$next  (then read README.txt)"
fi
EOF
chmod 755 /usr/local/bin/check

# ---------- SPOOKY SHELL ----------
cat >> /home/guest/.bashrc <<'EOF'
export PS1='\[\e[35m\]guest@hollow-manor\[\e[0m\]:\[\e[33m\]\w\[\e[0m\]\$ '
cd ~/house/foyer
cat welcome.txt
EOF

chown -R guest:guest /home/guest