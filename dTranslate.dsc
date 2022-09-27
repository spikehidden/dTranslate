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
# @date 2022/09/27
# @denizen-build 6477-DEV
# @script-version 1.0
#
# + REQUIREMENTS + Incorrect
# - Denizen             | https://github.com/DenizenScript/Denizen
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

### CONFIG ###

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

### CONFIG END ###
### DO NOT EDIT ANYTHING BELOW THIS LINE IF YOU DO NOT KNOW WHAT YOU ARE DOING! ###

dTranslateTranstask:
    type: task
    debug: true
    definitions: chat|target|source
    script:
        # Get Cache Config
        - define cache <script[dTranslate].data_key[translate.cache.enabled].if_null[true]>
        - define cacheTime <script[dTranslate].data_key[translate.cache.time].if_null[7d].as[duration]>

        # Check if a cached result exists.
        - if <[cache]> && <server.has_flag[dTranslate.cache.<[chat]>.<[target]>]>:
            - define trans_txt <server.flag[dTranslate.cache.<[chat]>.<[target]>]>

        # Check if cached result could be found.
        # If not get translation from API
        - if !<[trans_txt].exists>:
            # Get API stuff
            - define uri <script[dTranslate].parsed_key[api.url]>
            - define endpoint translate
            - define url <[uri]>/<[endpoint]>
            # Defining data for the API request
            - define format text
            - define q <[chat]>
            - define key <script[dTranslate].data_key[api.key].if_null[none]>
            # Define headers map
            - definemap headers:
                Content-Type: application/json
            # Define data map
            - definemap data:
                q: <[q]>
                source: <[source]>
                target: <[target]>
            # Add API key to data map if existent.
            - if <[key]> != none:
                - define <[data].with[api_key].as[<[key]>]>
            # Start API request Loop
            - repeat 10 as:loop:
                - ~webget <[url]> data:<[data].to_json> method:post headers:<[headers]> save:temp_json timeout:3s
                # Check for any errors
                - if <entry[temp_json].failed>:
                    # Check if status codes was returned/could connect.
                    - if !<entry[temp_json].status.exists>:
                        # If not try again if loops are not exceeded. Else save Error to definition.
                        - if <[loop]> >= 3:
                            - define error "Could not connect to <[url]>"
                            - repeat stop
                        - repeat next
                    #- HTTP 502
                    - else if <entry[temp_json].status> == 502:
                        # If not try again if loops are not exceeded. Else save Error to definition.
                        - if <[loop]> >= 3:
                            - define error "The server returned a <&dq>502 - BAD GATEWAY<&dq> Error!"
                            - repeat stop
                        - repeat next
                    - else:
                        # If not try again if loops are not exceeded. Else save Error to definition.
                        - if <[loop]> >= 3:
                            - define error "The server returned an error<&co> <&dq><entry[temp_json].result.parse_yaml.get[error]><&dq> | <entry[temp_json].status>"
                            - repeat stop
                        - repeat next
                # When succesfull stop repeat.
                - else:
                    - repeat stop
            # If error exists send saved error message.
            - if <[error].exists>:
                - debug error "<&lb>dTranslate<&rb> <[error].if_null[An error occured!]>"
            # When it was succesfull though extract translated text from json.
            - else:
                - define trans_txt <entry[temp_json].result.parse_yaml.get[translatedText]>
                # If cache is enabled cache the result to a flag.
                - if <[cache]>:
                    - flag server dTranslate.cache.<[chat]>.<[target]>:<[trans_txt]> expire:<[cacheTime]>

dTranslateFormat:
    type: format
    format: <blue><bold>[dTranslate]<reset> <yellow><[text]><reset>

dTranslateChat:
    type: world
    debug: true
    data:
        hover:
            de:
            - <bold><dark_aqua>Automatische Übersetzungen<reset>
            - <yellow>Dieser Text wurde automatisch übersetzt und ist eventuell fehlerhaft!<reset>
            - <yellow>Deswegen kann es eventuell zu missverständissen kommen.<reset>
            - <empty>
            - <green>Powered by <aqua>LibreTranslate<green>, <aqua>Denizen <green>& <aqua>dTranslate<reset>
            en:
            - <bold><dark_aqua>Automatic Translation<reset>
            - <yellow>This text was automaticly translated and could include errors.<reset>
            - <yellow>So beware that in rare circustances sentences could be completly wrong translated!<reset>
            - <empty>
            - <green>Powered by <aqua>LibreTranslate<green>, <aqua>Denizen <green>& <aqua>dTranslate<reset>
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
            # Check if player manually set a language.
            - if <player.has_flag[dTranslate.lang]>:
                - define lang <player.flag[dTranslate.lang]>
            - define source <[lang]>
            # Check if language is enabled.
            - if !<[langList].contains_single[<[lang]>]>:
                - stop
            - define trans_map <map>
            # Put recipients in lang groups
            - define lang_groups <list>
            - foreach <[to]>:
                - if !<[value].has_permission[dtranslate.translate.recieve]>:
                    - foreach next
                - define tt_lang <[value].locale.replace_text[regex:_.*]>
                - if <[value].has_flag[dTranslate.lang]>:
                    - define tt_lang <[value].flag[dTranslate.lang]>
                - if !<[langList].contains_single[<[tt_lang]>]> || <[tt_lang]> == <[lang]>:
                    - foreach next
                - if <[trans_map].deep_get[<[tt_lang]>.users].exists>:
                    - define list <[trans_map].deep_get[<[tt_lang]>.users]>
                - define list:->:<[value]>
                - define trans_map <[trans_map].deep_with[<[tt_lang]>.users].as[<[list]>]>
                - if !<[lang_groups].contains_single[<[tt_lang]>]>:
                    - define lang_groups:->:<[tt_lang]>
            # Get translations
            - foreach <[lang_groups]> as:target:
                - inject dTranslateTranstask
                - if <entry[temp_json].failed>:
                    - foreach next
                - define trans_map <[trans_map].deep_with[<[target]>.txt].as[<[trans_txt]>]>
                - define <[target]>_list <list>
            # Send translations
            - foreach <[lang_groups]> as:txt_lang:
                - define lang_txt <[trans_map].deep_get[<[txt_lang]>.txt]>
                - define users <[trans_map].deep_get[<[txt_lang]>.users]>
                - define hover <script.parsed_key[data.hover.<[txt_lang]>].if_null[<script.parsed_key[data.hover.en]>].separated_by[<&nl>]>
                - define msg "<[lang_txt]> <&chr[24D8].on_hover[<[hover]>].color[aqua]> "
                - narrate <[msg]> from:<player.uuid> targets:<[users]> format:dTranslateChatFormat

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
        - define txt <context.args.get[3].to[last].if_null[<list.include_single[no text]>]>
        - define chat <[txt].space_separated>
        - inject dTranslateTranstask
        - define msg "<dark_green><bold>Translated Text:<reset> <dark_green><&dq><aqua><[trans_txt]><dark_green><&dq><reset>"
        - narrate <[msg]> format:dTranslateFormat