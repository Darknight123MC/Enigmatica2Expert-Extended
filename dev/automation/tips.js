/**
 * @file Add tips only into `resources/enigmatica/lang/en_us.lang`
 * And they would be automatically copied to localized files
 * and to `config/tips.cfg`
 * 
 * @author Krutoy242
 * @link https://github.com/Krutoy242
 */

//@ts-check

const fs = require('fs')
const {injectInFile, loadText} = require('../lib/utils.js')

const init = module.exports.init = async function(h=require('../automate').defaultHelper) {

  await h.begin('Loading files')
  function getTips(lang) {
    return [...lang.matchAll(
      /^(?<match>e2ee\.tips\.(?<id>\d+)=(?<text>.*))$/gm
    )].map(m=>m.groups)
  }

  const filePathes = [
    'resources/enigmatica/lang/en_us.lang',
    'resources/enigmatica/lang/ru_ru.lang',
  ]
  const rawFiles = filePathes.map(fp => loadText(fp))
  const rawTips  = rawFiles.map(getTips)
  const mainTips = rawTips[0]

  // cfg
  injectInFile('config/tips.cfg', 
    '    S:customTips <\n',
    '\n     >',
    mainTips.map((_g,i)=>`        e2ee.tips.${i}`).join('\n')
  )

  // English
  replaceTips(0, mainTips)

  // Russian
  const filtered_ru = []
  let unlocalizedCount = 0
  mainTips.forEach(en => 
    filtered_ru.push(
      rawTips[1].find(ru => en.id === ru.id) ??
      (unlocalizedCount++, en)
    )
  )
  replaceTips(1, filtered_ru)

  function replaceTips(fileIndex, newGroups) {
    const oldTipsText = rawFiles[fileIndex]
    let replaced = oldTipsText

    // Get where tips started in file
    const firstOccure = replaced.indexOf(rawTips[fileIndex][0].match)

    // Remove all old tips lines
    rawTips[fileIndex].forEach(g => replaced = replaced.replace('\n'+g.match, ''))

    // Generate new text in place
    replaced = 
      replaced.substring(0, firstOccure) +
      newGroups.map((g,i)=>`e2ee.tips.${i}=${g.text}`).join('\n') + '\n' +
      replaced.substring(firstOccure)
    
    // Write
    fs.writeFileSync(filePathes[fileIndex], replaced)
  }

  h.result(`Total tips: ${mainTips.length}, Unlocalized: ${unlocalizedCount}`)
}

if(require.main === module) init()