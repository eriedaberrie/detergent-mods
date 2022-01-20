# scuffed and slightly laggy but working! implementation by eriedaberrie

alias _pbGetRelearnableMoves pbGetRelearnableMoves

def pbGetRelearnableMoves(pokemon)
  moves = _pbGetRelearnableMoves(pokemon)

  if pokemon.isDelta? && !pbIsDitto?(pokemon) && (PBItems.getName(pokemon.item)[-6..-1] == " Plate")
    currmon1 = $PokemonGlobal.daycare[0][0]
	currmon2 = $PokemonGlobal.daycare[1][0]
	
	# make room for the egg
	party1 = $Trainer.party.pop()
	
	$PokemonGlobal.daycare[0][0] = pokemon
	$PokemonGlobal.daycare[1][0] = PokeBattle_Pokemon.new(getConst(PBSpecies, :DELTADITTO), 1)
	# Kernel.pbMessage(PBSpecies.getName($PokemonGlobal.daycare[0][0].species))
	# Kernel.pbMessage(PBSpecies.getName($PokemonGlobal.daycare[1][0].species))
	
	# removes possiblity of inherited moves
	currmoves = Marshal.load(Marshal.dump(pokemon.moves))
	$PokemonGlobal.daycare[0][0].moves.clear()
	
	pbDayCareGenerateEgg()
	# Kernel.pbMessage($Trainer.party[-1].getMoveList.map{|move| move[1]}.join(", "))
	
	if $Trainer.party[-1]
	  # Kernel.pbMessage($Trainer.party[-1].moves.map{|move| move.id}.reject{|moveid| moveid == 0}.length().to_s)
	  # Kernel.pbMessage(moves[0].to_s)
	  newmove = $Trainer.party[-1].moves.map{|move| move.id}.reject{|moveid| moveid == 0}[-1]
	  
	  if !$Trainer.party[-1].getMoveList.any?{|move| move[1] == newmove} && !currmoves.any?{|move| move.id == newmove}
	    # Kernel.pbMessage(newmove.to_s)
		
		# shifts new move to the top for convenience
	    moves.unshift(newmove)
      end
	end
	
	
	pokemon.moves = currmoves
	$PokemonGlobal.daycare[0][0] = currmon1
	$PokemonGlobal.daycare[1][0] = currmon2
	$Trainer.party[-1] = party1
  end
  
  # reject removes preexisting bugged blank moves, uniq fixes when HE move was a starting move so it appeared twice
  moves.reject{|moveid| moveid == 0}.uniq
end