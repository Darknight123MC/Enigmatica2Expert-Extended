import crafttweaker.liquid.ILiquidDefinition;
import mods.nuclearcraft.melter;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;

# Remove Weak Conduits and unused alloys
for s in [
  "block_alloy_endergy",
  "item_alloy_endergy_nugget",
  "item_alloy_endergy_ingot",
  "item_alloy_endergy_ball"
] as string[] {
  for i in [0, 5, 6] as int[] {
    val it = itemUtils.getItem("enderio:"~s,i);
    if (!isNull(it)) utils.rh(it, false);
  }
}

for n in [144, 16, 144*9] as int[] {
  mods.nuclearcraft.melter.removeRecipeWithOutput([<liquid:crude_steel> * n]);
  mods.nuclearcraft.melter.removeRecipeWithOutput([<liquid:vivid_alloy> * n]);
  mods.nuclearcraft.melter.removeRecipeWithOutput([<liquid:energetic_silver> * n]);
}

utils.rh(<enderio:item_endergy_conduit>);
utils.rh(<enderio:item_endergy_conduit:1>);
utils.rh(<enderio:item_endergy_conduit:2>);
utils.rh(<enderio:item_endergy_conduit:3>);
utils.rh(<enderio:item_endergy_conduit:4>);
utils.rh(<enderio:item_endergy_conduit:5>);
utils.rh(<enderio:item_endergy_conduit:6>);
utils.rh(<enderio:item_endergy_conduit:7>);
utils.rh(<enderio:item_capacitor_grainy>);
utils.rh(<enderio:item_capacitor_silver>);
utils.rh(<enderio:item_capacitor_energetic_silver>);
utils.rh(<enderio:item_capacitor_vivid>);
recipes.removeByRecipeName("enderio:capacitor_crystalline_alt");

# Remove liquids of removed alloys
mods.tconstruct.Melting.removeRecipe(<liquid:crude_steel>);
mods.tconstruct.Melting.removeRecipe(<liquid:energetic_silver>);
mods.tconstruct.Melting.removeRecipe(<liquid:vivid_alloy>);

# Add harder stepped alloys
scripts.process.alloy([<ore:itemPulsatingPowder>   , <ore:ingotVibrantAlloy>        , <ore:ingotSentientMetal>], <ore:ingotCrystallineAlloy>.firstItem    , "no exceptions");
scripts.process.alloy([<ore:itemEnderCrystalPowder>, <ore:ingotCrystallineAlloy>    , <industrialforegoing:pink_slime_ingot>], <ore:ingotCrystallinePinkSlime>.firstItem, "no exceptions");
scripts.process.alloy([<ore:itemVibrantPowder>     , <ore:ingotCrystallinePinkSlime>, <ore:ingotUUMatter>     ], <ore:ingotMelodicAlloy>.firstItem        , "no exceptions");
scripts.process.alloy([<ore:itemPrecientPowder>    , <ore:ingotMelodicAlloy>        , <ore:ingotWyvernMetal>  ], <ore:ingotStellarAlloy>.firstItem        , "no exceptions");

# Stepped conduit recipes
# Stellar alloy is exception - it have only 1 ingot in recipe
val BDR = <ore:itemConduitBinder>;
val eAlloys = [<ore:ingotCrystallineAlloy>, <ore:ingotCrystallinePinkSlime>, <ore:ingotMelodicAlloy>/* , <ore:ingotStellarAlloy> */] as IIngredient[];
val eCndts  = [
  <enderio:item_power_conduit:2>,
  <enderio:item_endergy_conduit:8>,
  <enderio:item_endergy_conduit:9>,
  <enderio:item_endergy_conduit:10>, 
  // <enderio:item_endergy_conduit:11>, 
] as IItemStack[];

for i in 0 to eAlloys.length {
  recipes.addShaped("Cheaper " ~ getItemName(eCndts[i+1]), eCndts[i+1] * 8, [[BDR, BDR, BDR], [eAlloys[i], eCndts[i], eAlloys[i]], [BDR, BDR, BDR]]);
}
