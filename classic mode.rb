# meme mode by eriedaberrie, this will be made for the sake of being made and then promptly locked away never to be used by anyone ever again

EVMULT = 3

class PokeBattle_Battle
  alias_method :_pbGetMoveScore, :pbGetMoveScore
  
  # not totally random, somewhat higher chance of picking the best move (too lazy to calculate) and 2/3 of the simply time picks the last move used
  def pbGetMoveScore(move, attacker, opponent, skill=0)
    if (move.id == attacker.lastMoveUsed) && (pbAIRandom(3) > 0)
      return 1000
    end
    
    case pbAIRandom(3)
    when 1
      _pbGetMoveScore(move, attacker, opponent, skill)
    when 2
      80 - _pbGetMoveScore(move, attacker, opponent, skill)
    else
      100
    end
  end
  
  
  # switch checks will always prompt a switch to a random pokemon 1/16 of the time after turn 2
  def pbEnemyShouldWithdrawEx?(index, alwaysSwitch)
    return false if (pbAIRandom(16) > 0) || (@turncount < 2)
    list = (0...pbParty(index).length).to_a.select{|i| pbCanSwitch?(index, i, false)}.to_a
    list.empty? ? false : pbRegisterSwitch(index, list[pbAIRandom(list.length)])
  end
end


# hijacks a frankly pretty useless method that i noticed was always called at the end of every trainer mon loaded
# multiplies the evs of every trainer mon with non-default evs with number
# i couldve done an alias here to preserve the initial functionality but nahhh useless method
def changeForPurism(pokemon)
  if pokemon.ev.uniq != [pokemon.level * 2 + 85]
    pokemon.ev.map!{|i| i * EVMULT}
  end
  pokemon
end
