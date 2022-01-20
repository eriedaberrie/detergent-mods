# professional monke patching here by eriedaberrie

class PokemonDataBox < SpriteWrapper
  alias_method :_animateEXP, :animateEXP
  alias_method :_animateHP, :animateHP
  
  def animateEXP(oldexp, newexp)
    # makes the animation start at the end amount so its basically instant
    _animateEXP(newexp, newexp)
  end
  
  def animateHP(oldhp, newhp)
    # ditto
    _animateHP(newhp, newhp)
  end
end