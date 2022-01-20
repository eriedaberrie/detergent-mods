# detergent mods
 by eriedaberrie
 
 *why am I using github when I could just link a google drive folder? idk im lazy*
 
 To use, download the ones you want and put them in Data/Mods, open the game, and it should work.
 
 You're probably looking for QOL/, where you can find the quality-of-life mods and their descriptions.
## individual mod descriptions
### classic mode.rb
- for insane people/people that genuinely want to have a bad time
- triples the EVs of AI pokemon that have defined EVs and also makes them really really stupid
### custom trainers.rb
- define custom trainer fights
- define trainers in here like you would in the PBS

        TRAINERTYPE (eg FIREBREATHER, HIKER, etc)
        trainername,teamnumber (if the trainer has more than 1 team)
        partycount
- afterwards, list each pokemon in the party

        SPECIES,level,ITEM,MOVE,MOVE,MOVE,MOVE,abilityslot (0-2 or blank for random),gender (0 or 1 or blank for random),formnumber,shininess (true or false),NATURE,ivs (a single number 0-31),happiness,nickname,mutant (true or false),ev,ev,ev,ev,ev,ev,prestatus (if any)
- for things in all caps you need to enter the internal name, which is usually just the normal name but in all caps an no spaces or dashes
- you can access these trainers from "Test Trainer Battle" in the debug menu, or you can match the trainer type, trainer, and team number of an existing trainer to replace their fight.
### mutant sprites.rb
- ok this one was really lazy, but basically its lets you add custom sprites for mutant Pokemon by putting `_SHADOW` at the end of the name of the sprite
- it might break some things (definitely the party screen) if the player obtains any mutant Pokemon but thankfully those aren't legally available for now
 
