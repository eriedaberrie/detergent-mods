# by eriedaberrie

# makes the exp calc always return the level cap
def PBExperience.pbAddExperience(currexp, expgain, growth)
  return 0 if expgain == 0
  for cap in LEVELCAPS
    if !$game_switches[cap[0]]
      return pbGetExpInternal(cap[1], growth)
    end
  end
  pbGetExpInternal(MAXIMUMLEVEL, growth)
end

# hold X to skip inbattle levelup messages
class PokeBattle_Scene
  alias_method :_pbLevelUp, :pbLevelUp
  alias_method :_pbDisplayPausedMessage, :pbDisplayPausedMessage
  
  def pbLevelUp(*args)
    _pbLevelUp(*args) if !Keys.press?(Keys::X)
  end
  
  def pbDisplayPausedMessage(msg)
    _pbDisplayPausedMessage(msg) if !Keys.press?(Keys::X) || !/ grew to Level \d*!$/.match(msg)
  end
end



alias _pbEvolutionCheck pbEvolutionCheck

# keeps trying to evolve pokemon at the end of a battle until theres species changes
# can technically support 4-stage evolutions since I used a loop for some reason
def pbEvolutionCheck(currentlevels)
  currpartyspecies = Array.new(6)
  loop do
    unchanged = 0
    for i in 0...$Trainer.party.length
      if currpartyspecies[i] == $Trainer.party[i].species
        # prevents canceled evolutions from prompting again on the looparound
        currentlevels[i] = $Trainer.party[i].level
        unchanged += 1
      else
        currpartyspecies[i] = $Trainer.party[i].species
      end
    end
    break if unchanged == $Trainer.party.length
    _pbEvolutionCheck(currentlevels)
  end
end
