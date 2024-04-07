CUSTOMTRAINERSFILENAME = "customtrainers.txt"


def pbCompileTrainersCustom
  lines=[]
  linenos=[]
  lineno=1
  File.open(CUSTOMTRAINERSFILENAME,"rb"){|f|
     FileLineData.file=CUSTOMTRAINERSFILENAME
     f.each_line {|line|
        line=prepline(line)
        if line!=""
          lines.push(line)
          linenos.push(lineno)
        end
        lineno+=1
     }
  }
  nameoffset=0
  trainers=[]
  trainernames = []
  i=0; loop do break unless i<lines.length
    FileLineData.setLine(lines[i],linenos[i])
    trainername=parseTrainer(lines[i])
    FileLineData.setLine(lines[i+1],linenos[i+1])
    nameline=strsplit(lines[i+1],/\s*,\s*/)
    name=nameline[0]
    raise _INTL("Trainer name too long\r\n{1}",FileLineData.linereport) if name.length>=0x10000
    trainernames.push(name)
    partyid=0
    if nameline[1]&&nameline[1]!=""
      raise _INTL("Expected a number for the trainer battle ID\r\n{1}",FileLineData.linereport) if !nameline[1][/^\d+$/]
      partyid=nameline[1].to_i
    end
    FileLineData.setLine(lines[i+2],linenos[i+2])
    items=strsplit(lines[i+2],/\s*,\s*/)
    items[0].gsub!(/^\s+/,"")
    raise _INTL("Expected a number for the number of Pokémon\r\n{1}",FileLineData.linereport) if !items[0][/^\d+$/]
    numpoke=items[0].to_i
    realitems=[]
    for j in 1...items.length # Number of Pokémon and items held by Trainer
      realitems.push(parseItem(items[j]))
    end
    pkmn=[]
    for j in 0...numpoke
      FileLineData.setLine(lines[i+j+3],linenos[i+j+3])
      poke=strsplit(lines[i+j+3],/\s*,\s*/)
      begin
        poke[0]=parseSpecies(poke[0]) # Species
        rescue
        raise _INTL("Expected a species name: {1}\r\n{2}",poke[0],FileLineData.linereport)
      end
      poke[1]=poke[1].to_i # Level
      raise _INTL("Bad level: {1} (must be from 1-{2})\r\n{3}",poke[1],
        PBExperience::MAXLEVEL,FileLineData.linereport) if poke[1]<=0 || poke[1]>PBExperience::MAXLEVEL
      if !poke[2] || poke[2]=="" # Held item
        poke[2]=0
      else
        poke[2]=parseItem(poke[2])
      end
      poke[3]=(!poke[3] || poke[3]=="") ? 0 : parseMove(poke[3]) # Moves
      poke[4]=(!poke[4] || poke[4]=="") ? 0 : parseMove(poke[4])
      poke[5]=(!poke[5] || poke[5]=="") ? 0 : parseMove(poke[5])
      poke[6]=(!poke[6] || poke[6]=="") ? 0 : parseMove(poke[6])
      if !poke[7] || poke[7]=="" # Ability
        poke[7]=nil
      else
        poke[7]=poke[7].to_i
        raise _INTL("Bad abilityflag: {1} (must be 0, 1 or 2)\r\n{2}",poke[7],FileLineData.linereport) if poke[7]<0 || poke[7]>2
      end
      if !poke[8] || poke[8]=="" # Gender
        poke[8]=nil
      else
        poke[8]=poke[8].to_i
        raise _INTL("Bad genderflag: {1} (must be 0 or 1)\r\n{2}",poke[8],FileLineData.linereport) if poke[8]<0 || poke[8]>1
      end
      if !poke[9] || poke[9]=="" # Form
        poke[9]=0
      else
        poke[9]=poke[9].to_i
        raise _INTL("Bad form: {1} (must be 0 or greater)\r\n{2}",poke[9],FileLineData.linereport) if poke[9]<0
      end
      poke[10]=(!poke[10] || poke[10]=="") ? false : csvBoolean!(poke[10].clone) # Shiny
      poke[11]=(!poke[11] || poke[11]=="") ? nil : parseNature(poke[11]) # Nature
      if !poke[12] || poke[12]=="" # IVs
        poke[12]=10
      else
        poke[12]=poke[12].to_i
        raise _INTL("Bad IV: {1} (must be from 0-31)\r\n{2}",poke[12],FileLineData.linereport) if poke[12]<0 || poke[12]>31
      end
      if !poke[13] || poke[13]=="" # Happiness
        poke[13]=70
      else
        poke[13]=poke[13].to_i
        raise _INTL("Bad happiness: {1} (must be from 0-255)\r\n{2}",poke[13],FileLineData.linereport) if poke[13]<0 || poke[13]>255
      end
      if !poke[14] || poke[14]=="" # Nickname
        poke[14]=nil
      else
        poke[14]=poke[14].to_s
 #       raise _INTL("Bad nickname: {1} (must be 1-10 characters)\r\n{2}",poke[14],FileLineData.linereport) if (poke[14].to_s).length>10
      end
      poke[15]=(!poke[15] || poke[15]=="") ? false : csvBoolean!(poke[15].clone) # Shadow
      if !poke[16] || poke[16]=="" # Happiness
        poke[16]=0
      else
        poke[16]=poke[16].to_i
      #  raise _INTL("Bad happiness: {1} (must be from 0-255)\r\n{2}",poke[16],FileLineData.linereport)# if poke[13]<0 || poke[13]>255
      end
      pkmn.push(poke)
    end
    i+=3+numpoke
    MessageTypes.setMessagesAsHash(MessageTypes::TrainerNames,trainernames)
    trainers.push([trainername,name,realitems,pkmn,partyid])
    nameoffset+=name.length
  end
  trainers
end


if File.exist?(CUSTOMTRAINERSFILENAME) && !$newtrainersdat
  $newtrainersdat = (pbCompileTrainersCustom + load_data("Data/trainers_hard.dat")) # .uniq { |trainer| [trainer[0], trainer[1], trainer[4]] }
end


def load_data(filename)
  File.open(filename, "rb") do |f|
    (((filename == "Data/trainers.dat") || (filename == "Data/trainers_hard.dat")) && $newtrainersdat) ? $newtrainersdat : Marshal.load(f)
  end
end

