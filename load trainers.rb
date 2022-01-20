$customfuncs = [] if !$customfuncs

$customfuncs.push(["Load Trainers", Proc.new {


  types = load_data("Data/trainertypes.dat")
  # Kernel.pbMessage(data[0].join(", "))
  begin
    File.open("actualtrainers.txt", "w") do |file|
      count = 0
      load_data("Data/trainers_hard.dat").each do |trainer|
        file.write("#-------------------\n")
        file.write("#{count} #{getConstantName(PBTrainers, trainer[0])} (#{trainer[0]})\n") rescue nil
        file.write("#{types[trainer[0]][2]}: #{trainer[1]}#{trainer[4] + 1}\n\n") rescue nil
        trainer[3].each do |mon|
          mon[0] = getConstantName(PBSpecies, mon[0])
          mon[2] = (getConstantName(PBItems, mon[2]) rescue nil)
          (3..6).each{ |i| mon[i] = (getConstantName(PBMoves, mon[i]) rescue nil) }
          mon[7] = "abilityslot#{mon[7]}" if mon[7]
          mon[8] = ["M", "F"][8] if mon[8]
          mon[9] = (mon[9] == 0) ? nil : "form#{mon[9]}"
          mon[10] = mon[10] ? "SHINY" : nil
          mon[11] = PBNatures.getName(mon[11]) if mon[11]
          mon[12] = "#{mon[12]}iv"
          mon[13] = "#{mon[13]}happiness"
          mon[14] = "\"" + mon[14] + "\"" if mon[14]
          mon[15] = mon[15] ? "MUTANT" : nil
          file.write(mon.join(",") + "\n")
        end
        count += 1
      end
    end
  rescue Hangup
  end


}]) if !$customfuncs.any? { |i| i[0] == "Load Trainers" }