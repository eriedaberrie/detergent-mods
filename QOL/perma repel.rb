alias _pbBattleOnStepTaken pbBattleOnStepTaken

def pbBattleOnStepTaken(repel=false)
  _pbBattleOnStepTaken(repel) if Keys.press?(Keys::SPACE)
end