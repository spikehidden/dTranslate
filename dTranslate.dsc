## LICENSE - DO NOT REMOVE!!##

#- MIT License

#- Copyright (c) 2022 Spikehidden

#- Permission is hereby granted, free of charge, to any person obtaining a copy
#- of this software and associated documentation files (the "Software"), to deal
#- in the Software without restriction, including without limitation the rights
#- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#- copies of the Software, and to permit persons to whom the Software is
#- furnished to do so, subject to the following conditions:

#- The above copyright notice and this permission notice shall be included in all
#- copies or substantial portions of the Software.

#- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#- SOFTWARE.

## LICENSE END ##

# +---------------------------------+
# |                                 |
# | dTranslate                      |
# |                                 |
# | Does translate chat and stuff.  |
# |                                 |
# +---------------------------------+
#
# @author Spikehidden
# @date 2022/09/25
# @denizen-build REL-1765
# @script-version 1.0
#
# + REQUIREMENTS + Incorrect
# - PlaceholderAPI      | https://placeholderapi.com
# - Denizen             | https://github.com/DenizenScript/Denizen
# - Depenizen           | https://github.com/DenizenScript/Depenizen
# - Vault               | https://www.spigotmc.org/resources/34315/
#
# + Required or recommended for some features +
# - NONE
#
# + CONTACT +
#
# If you need help with the setup
# or want me to add a feature please
# contact me via Twitter or Discord
#
# - Twitter:    https://spikey.biz/twitter
# - Discord:    https://spikey.biz/discord
# - Twitch:     https://spikey.biz/twitch
# - Ko-Fi:      https://spikey.biz/kofi

dTranslate:
    type: data
    api:
        #- Set the base url with "http://" or "https://" but without "/" at the end.
        # url: https://libretranslate.de
        url: https://translate.terraprint.co
        #- Your API key if you need one. If none is neceserry use "none".
        key: none
        # Ratelimit is not used at the moment.
        ratelimit: 20
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
        - da
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

dTranslateFormat:
    type: format
    format: <[name]><&sq>s chat translated<&co> <[text]>

dTranslateTranstask:
    type: task
    debug: true
    definitions: chat|target|source
    script:
        # Get Cache Config
        - define cache <script[dTranslate].data_key[translate.cache.enabled].if_null[true]>
        - define cacheTime <script[dTranslate].data_key[translate.cache.enabled].if_null[7d].as[duration]>
        # Get API stuff
        - define uri <script[dTranslate].data_key[api.url]>
        - define endpoint translate
        - define url <[uri]>/<[endpoint]>

        - if <[cache]> && <server.has_flag[dTranslate.cache.<[chat]>.<[target]>]>:
            - define <[target]>_txt <server.flag[dTranslate.cache.<[chat]>.<[target]>]>
        - define s_lang <[source].url_encode>
        - define t_lang <[target].url_encode>
        - define format text
        - define q <[chat].url_encode>
        - definemap headers:
            Content-Type: application/x-www-form-urlencoded
        - define data q=<[q]>&source=<[s_lang]>&target=<[t_lang]>
        - ~webget <[url]> data:<[data]> headers:<[headers]> save:temp_json
        - if <entry[temp_json].failed>:
            - if <entry[temp_json].status.is_empty>:
                - define error "Could not connect to <[url]>"
            - else:
                - define error "The server returned an error<&co> <&dq><entry[temp_json].result><&dq> | <entry[temp_json].status>"
            - debug error "<&lb>dTranslate<&rb> <[error].if_null[An error occured!]>"
        - define trans_txt <entry[temp_json].result.as[map].get[translatedText]>
        - if <[cache]>:
            - flag server dTranslate.cache.<[chat]>.<[target]>:<[trans_txt]> expire:<[cacheTime]>


dTranslateChat:
    type: world
    debug: true
    events:
        after player chats permission:dtranslate.translate.send:
            # Defining stuff
            - define chat <context.message>
            - define to <context.recipients>
            # Get Player's language
            - define lang <player.locale.replace_text[regex:_.*]>
            - define langList <script[dTranslate].data_key[translate.lang]>
            # API stuff
            - define uri <script[dTranslate].data_key[api.url]>
            - define endpoint translate
            - define url <[uri]>/<[endpoint]>
            # Get cache settings
            - define cache <script[dTranslate].data_key[translate.cache.enabled].if_null[true]>
            - define cacheTime <script[dTranslate].data_key[translate.cache.enabled].if_null[7d].as[duration]>
            # Check if player manually set a language.
            - if <player.has_flag[dTranslate.lang]>:
                - define lang <player.flag[dTranslate.lang]>
            - define source <[lang]>
            # Check if language is enabled.
            - if !<[langList].contains_single[<[lang]>]>:
                - stop
            # Get translations
            - foreach <[langList]> as:source:
                # - if <[cache]> && <server.has_flag[dTranslate.cache.<[chat]>.<[value]>]>:
                #     - define <[value]>_txt <server.flag[dTranslate.cache.<[chat]>.<[value]>]>
                # - define s_lang <[lang].url_encode>
                # - define t_lang <[value].url_encode>
                # - define format text
                # - define q <[chat].url_encode>
                # - definemap headers:
                #     Content-Type: application/x-www-form-urlencoded
                # - define data q=<[q]>&source=<[s_lang]>&target=<[t_lang]>
                # - ~webget <[url]> data:<[data]> headers:<[headers]> save:temp_json
                # - if <entry[temp_json].failed>:
                #     - if <entry[temp_json].status.is_empty>:
                #         - define error "Could not connect to <[url]>"
                #     - else:
                #         - define error "The server returned an error<&co> <&dq><entry[temp_json].result><&dq> | <entry[temp_json].status>"
                #     - debug error "<&lb>dTranslate<&rb> <[error].if_null[An error occured!]>"
                #     - foreach next
                - inject dTranslateTranstask
                - if <entry[temp_json].failed>:
                    - foreach next
                - define <[target]>_txt <[trans_txt]>
                - define <[target]>_list <list>
                - if <[cache]>:
                    - flag server dTranslate.cache.<[chat]>.<[value]>:<[<[value]>_txt]> expire:<[cacheTime]>
            # Put recipients in lang groups
            - foreach <[to]>:
                - if !<[value].has_permission[dtranslate.translate.recieve]>:
                    - foreach next
                - if !<[langList].contains_single[<[lang]>]>:
                    - foreach next
                - define tt_lang <[value].locale.replace_text[regex:_.*]>
                - if <[value].has_flag[dTranslate.lang]>:
                    - define tt_lang <[value].flag[dTranslate.lang]>
                - define <[tt_lang]>_list:->:<[value]>
            # Send translations
            - foreach <[langlist]>:
                - if <[<[value]>_list].is_empty>:
                    - foreach next
                - narrate <[<[value]>_txt]> from:<player.uuid> targets:<[<[value]>_list]> format:dTranslateFormat

dTranslateSetlang:
    type: command
    debug: true
    name: setlang
    aliases:
    - setlanguage
    - changelanguage
    - dTranslate:setlang
    - dTranslate:setlanguage
    - dTranslate:changelanguage
    description: Change you language which you use in chat and messages shall be translated to.
    usage: /setlang <&lt>languageCode<&gt>
    permission: dTranslate.admin;dTranslate.setlang
    tab completions:
        1: <script[dTranslate].data_key[translate.lang]>
        2: <server.online_players>
        default: tooManyArguments
    script:
        # Get args
        - define lang <context.args.get[1].if_null[<player.locale.replace_text[regex:_.*]>]>
        - define name <context.args.get[2].if_null[none]>
        - if <[name]> != none:
            - define to_player <server.match_offline_player[<[name]>]>
        # Get Config
        - define langList <script[dTranslate].data_key[translate.lang]>
        - if !<[langList].contains_single[<[lang]>]>:
            - narrate "<&4><[lang]> is not a code of a supported Language!<&r>" format:dTranslateFormat
            - stop
        - if <[to_player].exists>:
            - if <player.has_permission[dTranslate.admin]> || <player.has_permission[dTranslate.setlang.other]>:
                - flag <[to_player]> dTranslate.lang:<[lang]>
                - narrate "The language of <[to_player].name> was succesfully set to <[lang]>!" format:dTranslateFormat
            - else:
                - narrate "<&4>You don't have the permission to change the language of others!<&r>" format:dTranslateFormat
            - stop
        - flag <player> dTranslate.lang:<[lang]>
        - narrate "Your language was succesfully set to <[lang]>!" format:dTranslateFormat


dTranslateToggle:
    type: command
    debug: true
    name: toggletranslation
    aliases:
    - translationtoggle
    - toggletrans
    - dTranslate:translationtoggle
    - dTranslate:toggletrans
    - dTranslate:toggletranslation
    description: De-/Activate translations.
    usage: /toggletranslation
    permission: dTranslate.admin;dTranslate.toggle
    tab completions:
        1: <server.online_players>
    script:
        # Get args
        - define name <context.args.get[1].if_null[none]>
        # Get playerTag if name is given
        - if <[name]> != none:
            - define to_player <server.match_offline_player[<[name]>]>
        # If for other player check permissions.
        - if <[to_player].exists>:
            - if <player.has_permission[dTranslate.admin]> || <player.has_permission[dTranslate.toggle.other]>:
                # Save executing player for later and change <player> to the targeted one.
                - define exec_player <player>
                - define __player <[to_player]>
                # Add or remove permission based on if they have it or not
                - if <player.has_permission[dTranslate.recieve]>:
                    - permission remove dTranslate.recieve
                    - define msg "<dark_green>Chat translations succesfully <red>deactivated<dark_green> for <aqua><player.name><dark_green>.<reset>"
                - else:
                    - permission add dTranslate.recieve
                    - define msg "<dark_green>Chat translations succesfully <green>activated<dark_green> for <aqua><player.name><dark_green>.<reset>"
                # Send feedback
                - narrate <[msg]> format:dTranslateFormat targets:<[exec_player]>
        # If not change for executing user.
        - else:
            # Add or remove permission based on if they have it or not
            - if <player.has_permission[dTranslate.recieve]>:
                - permission remove dTranslate.recieve
                - define msg "<dark_green>Chat translations succesfully <red>deactivated<dark_green>.<reset>"
            - else:
                - permission add dTranslate.recieve
                - define msg "<dark_green>Chat translations succesfully <green>activated<dark_green>.<reset>"
            # Send feedback
            - narrate <[msg]> format:dTranslateFormat

dTranslateTranslate:
    type: command
    debug: true
    name: translate
    aliases:
    - trans
    - dTranslate:translate
    - dTranslate:trans
    description: De-/Activate translations.
    usage: /translate <&lb><&lt>fromLanguage<&gt>|auto<&rb> <&lb><&lt>toLanguage<&lt><&rb> <&lb><&lt>text<&lt><&rb>
    permission: dTranslate.admin;dTranslate.translate
    tab completions:
        1: <script[dTranslate].data_key[translate.lang].include_single[auto]>
        2: <script[dTranslate].data_key[translate.lang]>
        default: <&lb><&lt>text<&lt><&rb>
    script:
        # Get Args
        - define source <context.args.get[1].if_null[auto]>
        - define target <context.args.get[2].if_null[en]>
        - define txt <context.args.get[3].to[last].if_null[no text]>
        - define chat <[txt].space_separated>
        - inject dTranslateTranstask
        - define msg "<dark_green><bold>Translated Text:<reset> <dark_green><&dq><aqua><[trans_txt]><dark_green><&dq><reset>"
        - narrate <[msg]> format:dTranslateFormat