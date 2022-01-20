#by eriedaberrie (this is horrible coding practice but its a mod and it works so who cares)
class << Input
  alias_method :_trigger?, :trigger?

  def trigger?(a)
    _trigger?(a) || ((Keys.press?(Keys::A) && (a == Input::C))) || ((Keys.press?(Keys::B) && (a == Input::B)))
  end
end

class Scene_Map
  alias_method :_call_menu, :call_menu
  alias_method :_update, :update

  # B doesn't open the menu
  def call_menu
    if !Keys.press?(Keys::B)
      _call_menu
    end
    $game_temp.menu_calling = false
  end
  
  def update
    _update
    if Keys.press?(Keys::U)
      $Trainer.party.each { |mon| mon.heal }
      Kernel.pbMessage(_INTL("Your Pokemon were healed."))
    end
    if Keys.press?(Keys::I)
      PokemonPCList.callCommand(0)
      $PokemonTemp.dependentEvents.refresh_sprite
      Kernel.pbMessage("Closed the PC.")
    end
  end
end