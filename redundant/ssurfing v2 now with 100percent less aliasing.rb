class Game_Player
  def move_down(turn_enabled = true)
    if turn_enabled
      turn_down
    end
    if !$PokemonGlobal.surfing && pbIsSurfableTag?(Kernel.pbFacingTerrainTag) && ($PokemonBag.pbQuantity(PBItems::LAPRAS) > 0) &&
    $game_map.passable?($game_player.x, $game_player.y, 2, true)
      pbStartSurfing
    else
      if passable?(@x, @y, 2)
        return if pbLedge(0,1)
        return if pbEndSurf(0,1)
        turn_down
        @y += 1
        $PokemonTemp.dependentEvents.pbMoveDependentEvents
        increase_steps
      else
        if !check_event_trigger_touch(@x, @y+1)
          if !@bump_se || @bump_se<=0
  if $game_switches[186] 
              pbSEPlay("bump"); @bump_se=10
            end        end
        end
      end
    end
  end

  def move_left(turn_enabled = true)
    if turn_enabled
      turn_left
    end
    if !$PokemonGlobal.surfing && pbIsSurfableTag?(Kernel.pbFacingTerrainTag) && ($PokemonBag.pbQuantity(PBItems::LAPRAS) > 0) &&
    $game_map.passable?($game_player.x, $game_player.y, 4, true)
      pbStartSurfing
    else
      if passable?(@x, @y, 4)
        return if pbLedge(-1,0)
        return if pbEndSurf(-1,0)
        turn_left
        @x -= 1
        $PokemonTemp.dependentEvents.pbMoveDependentEvents
        increase_steps
      else
        if !check_event_trigger_touch(@x-1, @y)
          if !@bump_se || @bump_se<=0
            if $game_switches[186] 
              pbSEPlay("bump"); @bump_se=10
            end
            
          end
        end
      end
    end
  end

  def move_right(turn_enabled = true)
    if turn_enabled
      turn_right
    end
    if !$PokemonGlobal.surfing && pbIsSurfableTag?(Kernel.pbFacingTerrainTag) && ($PokemonBag.pbQuantity(PBItems::LAPRAS) > 0) &&
    $game_map.passable?($game_player.x, $game_player.y, 6, true)
      pbStartSurfing
    else
      if passable?(@x, @y, 6)
        return if pbLedge(1,0)
        return if pbEndSurf(1,0)
        turn_right
        @x += 1
        $PokemonTemp.dependentEvents.pbMoveDependentEvents
        increase_steps
      else
        if !check_event_trigger_touch(@x+1, @y)
          if !@bump_se || @bump_se<=0
  if $game_switches[186] 
              pbSEPlay("bump"); @bump_se=10
            end        end
        end
      end
    end
  end

  def move_up(turn_enabled = true)
    if turn_enabled
      turn_up
    end
    if !$PokemonGlobal.surfing && pbIsSurfableTag?(Kernel.pbFacingTerrainTag) && ($PokemonBag.pbQuantity(PBItems::LAPRAS) > 0) &&
    $game_map.passable?($game_player.x, $game_player.y, 8, true)
      pbStartSurfing
    else
    if passable?(@x, @y, 8)
        return if pbLedge(0,-1)
        return if pbEndSurf(0,-1)
        turn_up
        @y -= 1
        $PokemonTemp.dependentEvents.pbMoveDependentEvents
        increase_steps
      else
        if !check_event_trigger_touch(@x, @y-1)
          if !@bump_se || @bump_se<=0
  if $game_switches[186] 
              pbSEPlay("bump"); @bump_se=10
            end        end
        end
      end
    end
  end
  
  def update
    if !moving? && !@move_route_forcing && $PokemonGlobal
      if $PokemonGlobal.surfing
        @move_speed = 4.3
      elsif $PokemonGlobal.bicycle
        @move_speed = $RPGVX ? 8 : 5.8
     #   @move_speed = (@move_speed*1.5)
        
        elsif pbCanRun? && !$game_switches[136]
        @move_speed = $RPGVX ? 6.5 : 4.8
      elsif $game_switches[136]
        @move_speed = $RPGVX ? 5 : 4.2
      else
        @move_speed = $RPGVX ? 4.5 : 3.8
      end
    end
    if $game_map.map_id==397 && $PokemonGlobal.bicycle && $game_map.terrain_tag($game_player.x,$game_player.y)==PBTerrain::SuperFastBike
        @move_speed *= 1.75
    end
    if $game_map.map_id==676 || $game_map.map_id==749
        @move_speed *= 1.2
    end
    
    if $game_switches[136] && pbIsGrassTag?($game_map.terrain_tag($game_player.x,$game_player.y))
      @move_speed=3.3
    end
    if $game_switches[136] && $game_variables[63].is_a?(Array) && $game_variables[63][0]>0
      @move_speed*=1.25
    end
    
    if $game_map.map_id==272 && $game_player.y>36 && $game_player.y<50
      if $game_player.direction==2
        @move_speed *=1.25
      elsif $game_player.direction==8
        @move_speed *= 0.88
      end
      
    end
    
    if $game_map.map_id==272 && $game_player.y<62 && $game_player.y>51
      if $game_player.direction==2
       @move_speed *=0.88
        
      elsif $game_player.direction==8
        @move_speed *= 1.25
      end
    end
    
    @move_speed
    update_old
  end
end





#=====================================
# bike

def pbStartSurfing()
  Kernel.pbCancelVehicles(nil,false)
  Kernel.pbChangeBackToNormal
  $PokemonEncounters.clearStepCount
  $PokemonGlobal.surfing=true
  Kernel.pbUpdateVehicle
  Kernel.pbJumpToward
  Kernel.pbUpdateVehicle
  $game_player.check_event_trigger_here([1,2])
  $PokemonTemp.dependentEvents.refresh_sprite
end

def pbEndSurf(xOffset,yOffset)
  return false if !$PokemonGlobal.surfing || $PokemonGlobal.diving
  x=$game_player.x
  y=$game_player.y
  currentTag=$game_map.terrain_tag(x,y)
  facingTag=Kernel.pbFacingTerrainTag
  if !pbIsSurfableTag?(facingTag) && facingTag!=PBTerrain::StillWater && (pbIsSurfableTag?(currentTag) || currentTag==PBTerrain::StillWater)
    if Kernel.pbJumpToward
      Kernel.pbCancelVehicles(nil,false)
      $game_map.autoplayAsCue
      $game_player.increase_steps
      result=$game_player.check_event_trigger_here([1,2])
      Kernel.pbOnStepTaken(result)
      $PokemonTemp.dependentEvents.Come_back(true)
    end
    return true
  end
  return false
end

def Kernel.pbCancelVehicles(destination=nil,biketoo=true)
  $PokemonGlobal.surfing=false
  $PokemonGlobal.diving=false
  notNormalAry=[42,69,70,71,278,383,432,433]
  Kernel.pbChangeBackToNormal if !notNormalAry.include?($game_map.map_id)
  if !destination || !pbCanUseBike?(destination)
    $PokemonGlobal.bicycle=false if biketoo || !pbCanUseBike?($game_map.map_id)
  end
  Kernel.pbUpdateVehicle
  if $Trainer && $Trainer.party
    $PokemonTemp.dependentEvents.refresh_sprite
  end
end
