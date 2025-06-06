#===============================================================================
# Icons over Footprints in Pokedex
# Replaces Pokémon footprints in the Pokédex with their corresponding Pokémon icons.
#===============================================================================
#-------------------------------------------------------------------------------
# Replaces the footprint over the icon on the basic Pokedex page.
#-------------------------------------------------------------------------------
class PokemonPokedexInfo_Scene
  def drawPageInfo
    @sprites["background"].setBitmap(_INTL("Graphics/UI/Pokedex/bg_info"))
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(88, 88, 80)
    shadow = Color.new(168, 184, 184)
    imagepos = []
    imagepos.push([_INTL("Graphics/UI/Pokedex/overlay_info"), 0, 0]) if @brief
    species_data = GameData::Species.get_species_form(@species, @form)

    indexText = "???"
    if @dexlist[@index][:number] > 0
      indexNumber = @dexlist[@index][:number]
      indexNumber -= 1 if @dexlist[@index][:shift]
      indexText = sprintf("%03d", indexNumber)
    end

    textpos = [
      [_INTL("{1}{2} {3}", indexText, " ", species_data.name),
       246, 48, :left, Color.new(248, 248, 248), Color.black]
    ]

    if @show_battled_count
      textpos.push([_INTL("Number Battled"), 314, 164, :left, base, shadow])
      textpos.push([$player.pokedex.battled_count(@species).to_s, 452, 196, :right, base, shadow])
    else
      textpos.push([_INTL("Height"), 314, 164, :left, base, shadow])
      textpos.push([_INTL("Weight"), 314, 196, :left, base, shadow])
    end

    if $player.owned?(@species)
      textpos.push([_INTL("{1} Pokémon", species_data.category), 246, 80, :left, base, shadow])
      if !@show_battled_count
        height = species_data.height
        weight = species_data.weight
        if System.user_language[3..4] == "US"
          inches = (height / 0.254).round
          pounds = (weight / 0.45359).round
          textpos.push([_ISPRINTF("{1:d}'{2:02d}\"", inches / 12, inches % 12), 460, 164, :right, base, shadow])
          textpos.push([_ISPRINTF("{1:4.1f} lbs.", pounds / 10.0), 494, 196, :right, base, shadow])
        else
          textpos.push([_ISPRINTF("{1:.1f} m", height / 10.0), 470, 164, :right, base, shadow])
          textpos.push([_ISPRINTF("{1:.1f} kg", weight / 10.0), 482, 196, :right, base, shadow])
        end
      end

      drawTextEx(overlay, 40, 246, Graphics.width - 80, 4,
                 species_data.pokedex_entry, base, shadow)

      # Always use icon (no footprint option)
      icon_file = GameData::Species.icon_filename(@species, @form)
      if icon_file
        split = icon_file.split("/")
        path  = split[0...split.length - 1].join("/")
        name  = split[-1]
        icon  = RPG::Cache.load_bitmap(path + "/", name)
        min_width  = (((icon.width >= icon.height * 2) ? icon.height : icon.width) - 64)/2
        min_height = [(icon.height - 56)/2 , 0].max
        overlay.blt(210, 130, icon, Rect.new(min_width, min_height, 64, 56))
      end

      imagepos.push(["Graphics/UI/Pokedex/icon_own", 212, 44])

      species_data.types.each_with_index do |type, i|
        type_number = GameData::Type.get(type).icon_position
        type_rect = Rect.new(0, type_number * 32, 96, 32)
        overlay.blt(296 + (100 * i), 120, @typebitmap.bitmap, type_rect)
      end
    else
      textpos.push([_INTL("????? Pokémon"), 246, 80, :left, base, shadow])
      if !@show_battled_count
        if System.user_language[3..4] == "US"
          textpos.push([_INTL("???'??\""), 460, 164, :right, base, shadow])
          textpos.push([_INTL("????.? lbs."), 494, 196, :right, base, shadow])
        else
          textpos.push([_INTL("????.? m"), 470, 164, :right, base, shadow])
          textpos.push([_INTL("????.? kg"), 482, 196, :right, base, shadow])
        end
      end
    end

    pbDrawTextPositions(overlay, textpos)
    pbDrawImagePositions(overlay, imagepos)
  end
end
