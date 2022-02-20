class PokeBattle_Battle
  alias_method :_pbCanSwitch?, :pbCanSwitch?
  
  def pbCanSwitch?(idxpokemon, *args)
    mon = @battlers[idxpokemon].pokemon
    ismutant = mon.MUTANT
    mon.MUTANT = false
    ret = _pbCanSwitch?(idxpokemon, *args)
    mon.MUTANT = ismutant
    return ret
  end
end
