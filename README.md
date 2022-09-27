# **dTranslate**
> A translation script that makes use of [LibreTranslate](https://github.com/LibreTranslate/LibreTranslate)

 <!-- ![Logo Placeholder](/Logo/logo%400%2C25x.png) -->

[![GitHub release](https://img.shields.io/github/release/Spikehidden/dTranslate?&sort=semver&color=blue)](https://github.com/Spikehidden/dTranslate/releases/)
[![License](https://img.shields.io/github/license/Spikehidden/dTranslate?logo=Creative%20commons)](#LICENSE)
[![issues - dTranslate](https://img.shields.io/github/issues/Spikehidden/dTranslate)](https://github.com/Spikehidden/dTranslate/issues)

[![Discord](https://img.shields.io/discord/731894292557201529?label=Discord&logo=Discord)](https://spikey.biz/discord)
[![Ko-Fi - Donate](https://img.shields.io/badge/Ko--Fi-Donate-FF5E5B?logo=Ko-Fi&logoColor=white&color=blue)](https://spikey.biz/kofi)
[![Twitch - Subscribe](https://img.shields.io/badge/Twitch-Subscribe-9146FF?logo=Twitch&logoColor=white)](https://spikey.biz/twitch)

[![Spiget Stars](https://img.shields.io/spiget/stars/105498?label=spigotmc.org&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8%2F9hAAAAmklEQVQ4jaVTORKAIAzcOD6CRt9AbWPHv%2F2Bb9CGX8RGHCQHzrgVQ5LdTQgECVbuWpA4GKjJ1NyhJ8W7H%2FcI2lbU1lwHRd1z0W0BAM6wmjFtMFyr1sVz2ETNCKU3rXjK20ugEI29KWvEAEARDICodWCpU5TDpGjM4Miy%2BLbMjQtzE7U3L7kPiUfg4ctf8bGkzEvKDHxcJA%2B%2FCS5YrDUokhVf1AAAAABJRU5ErkJggg%3D%3D&style=flat)](https://www.spigotmc.org/resources/105498/)
[![GitHub all releases](https://img.shields.io/github/downloads/Spikehidden/dTranslate/total?logo=github&style=flat)](https://github.com/spikehidden/dTranslate/releases/latest)
[![GitHub stars](https://img.shields.io/github/stars/spikehidden/dTranslate)](https://github.com/spikehidden/dTranslate/stargazers)

# **Config**

<details>
  <summary>Config in dtranslate.dsc</summary>

  ```yaml
dTranslate:
    type: data
    api:
        #- Set the base url with "http://" or "https://" but without "/" at the end.
        # Here are two possible APIs that do not need a key but have their downsites.
        # I recommend using your own liberetranslate server.
        # "libretranslate.de" has a very low ratelimit of 20!
        # url: https://libretranslate.de
        # "translate.terraprint.co" has often server errors.
        url: https://translate.terraprint.co
        # A list of other servers that can be used can be found on their GitHub: https://github.com/LibreTranslate/LibreTranslate

        #- Your API key if you need one. If none is neceserry use "none".
        key: none
        # Ratelimit is not used at the moment.
        # ratelimit: 20
    translate:
        cache:
            enabled: true
            time: 7d
        lang:
        #- Set which language shall be translated.
        # English
        - en
        # Arabic
        - ar
        # Azerbaijani
        - az
        # Chinese
        - zh
        # Czech
        - cs
        # Danish
        #- da
        # Dutch
        - nl
        # Esperanto
        - eo
        # Finnish
        - fi
        # French
        - fr
        # German
        - de
        # Greek
        - el
        # Hebrew
        - he
        # Hindi
        - hi
        # Hungarian
        - hu
        # Indonesian
        - id
        # Irish
        - ga
        # Italian
        - it
        # Japanese
        - ja
        # Korean
        - ko
        # Persian
        - fa
        # Polish
        - pl
        # Portuguese
        - pt
        # Russian
        - ru
        # Slovak
        - sk
        # Spanish
        - es
        # Swedish
        - sv
        # Turkish
        - tr
        # Ukranian
        - uk

#-- ADVANCED CONFIG --#
#- Edit the format of how Auto-Translated messages are shown.
dTranslateChatFormat:
    type: format
    format: <aqua><[name]><white><&sq>s translated<&co> <gray><[text]><reset>
```

</details>

## **API**
<details>
    <summary>code</summary>

```yml
api:
    url: https://translate.terraprint.co
    key: none
```
</details>

### **api.url**
Set the base URI of the server the requests shall be sent to.\
Don't forget the `https://` or `http://` at the beginning.

### **api.key**
*It's not possible to add secret data from the [secret.secrets](https://meta.denizenscript.com/Docs/ObjectTypes/SecretTag) file in mapTags. This is why you need to put it in the config. If I'm mistaken please tell me, also tell me if I don't notice when this is changing in the future.*\
\
Set it to either `none` or the key that you get provided from the libretranslate server owner.

## **Translate**
<details>
    <summary>code</summary>

```yml
translate:
        cache:
            enabled: true
            time: 7d
        lang:
        - en
        - ar
        - az
        - zh
        - cs
        - da
        - nl
        - eo
        - fi
        - fr
        - de
        - el
        - he
        - hi
        - hu
        - id
        - ga
        - it
        - ja
        - ko
        - fa
        - pl
        - pt
        - ru
        - sk
        - es
        - sv
        - tr
        - uk
```
</details>

### **translate.cache.enabled**
Default: `true`\
\
It is recommend to set it to true especially if you use one of the free to use servers as the either hav very low ratelimits or sometimes cause other trouble.\
To avoid that you should activate caching.

### **translate.cache.time**
Default: `7d`\
\
If caching is enabled how long shall it be cached.

### **translate.lang**
A list of language codes that shall be enabled for translation.\
Beware that the list is what actually is supposed to be supported by LibreTranslate but some servers might disable language support by themselve.\
There will be a command in the future which can get you a list of all supported languages of the chosen server and also to choose which one you want to enbable.

<details>
    <summary>Language Codes</summary>

| Language    | Code |
| :---------- | :--: |
| Arabic      | ar   |
| Azerbaijani | az   |
| Chinese     | zh   |
| Czech       | cs   |
| Danish      | da   |
| Dutch       | nl   |
| English     | en   |
| Esperanto   | eo   |
| Finnish     | fi   |
| French      | fr   |
| German      | de   |
| Greek       | el   |
| Hebrew      | he   |
| Hindi       | hi   |
| Hungarian   | hu   |
| Indonesian  | id   |
| Irish       | ga   |
| Italian     | it   |
| Japanese    | ja   |
| Korean      | ko   |
| Persian     | fa   |
| Polish      | pl   |
| Portuguese  | pt   |
| Russian     | ru   |
| Slovak      | sk   |
| Spanish     | es   |
| Swedish     | sv   |
| Turkish     | tr   |
| Ukranian    | uk   |

</details>

# Permissions & Commands

## Permissions

<!-- **`dtranslate.admin`**
Access to all commands of the script.

`dtranslate.setlang`
Gives acces to the `/setlang` command

`dtranslate.setlang.other`
Let's the player set the language of another player.

`dtranslate.toggle`
Gives acces to the `/toggletranslation` command to toggle if chat messages shall be followed by an translation.

`dtranslate.toggle.other`
Lets the player toggle the translating status of another player.

`dtranslate.translate`
Gives access to the `/translation` command. -->

| Permission                     | Description                                                                                                      |
| :----------------------------: | :--------------------------------------------------------------------------------------------------------------- |
| `dtranslate.admin`             | Access to all commands of the script.                                                                            |
| `dtranslate.setlang`           | Gives access to the `/setlang` command                                                                           |
| `dtranslate.setlang.other`     | Lets the player set the language of another player.                                                              |
| `dtranslate.toggle`            | Gives access to the `/toggletranslation` command to toggle if chat messages shall be followed by an translation. |
| `dtranslate.toggle.other`      | Lets the player toggle the translating status of another player.                                                 |
| `dtranslate.translate.command` | Gives access to the `/translation` command.                                                                      |
| `dtranslate.translate.send`    | Messages sent by those player gets translated.                                                                   |
| `dtranslate.translate.recieve` | To those players translated chat messages will be shown.                                                         |

## Commands

| Command             | Alias                                                                 | Usage                                  | Permission           | Description                 |
| :-----------------: | :-------------------------------------------------------------------: | :------------------------------------- | :------------------: | :-------------------------- |
| `setlang`           | `setlanguage` <br> `changelanguage`    | /\<command\> \<langCode\> (\<player\>) | dtranslate.setlang   | Used to set your/\<player\>'s language to \[\<langCode\>\] |
| `toggletranslation` | `translationtoggle` <br> `toggletrans` | /\<command\> (\<player\>)              | dtranslate.toggle    | Used to set your/\<player\> translation status to off/on.  |
| `translate`         | `trans` | /\<command\> \<fromLangCode\>\|auto \<toLangCode\> \<text\>           | dtranslate.translate.command | Used to translate \<text\> from \<fromLangCode\> to \<toLangCode\>. <br> Use auto instead of \<fromLangCode\> to automaticly determine the language. |

# Planned Features

- [ ] Economy Feature
- [ ] Implemenation other Translation APIs *maybe*
- [ ] Passthrough Webserver API
- [ ] Auto language set up command for admin.

# **LICENSE**
Licensed under [MIT License](/LICENSE) by [@Spikehidden](https://github.com/spikehidden)
