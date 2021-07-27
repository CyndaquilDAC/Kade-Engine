![Funkin Forever Logo](https://user-images.githubusercontent.com/26305836/110529589-4b4eb600-80ce-11eb-9c44-e899118b0bf0.png)

**Download the latest release [here](https://github.com/KadeDev/Kade-Engine/releases/latest)**

# Funkin' Forever

This is the repository for Funkin' Forever, a game originally made for Ludum Dare 47 "Stuck In a Loop" with a completely reworked engine based on Kade Engine by KadeDeveloper.

This is a **MOD**. This is not Vanilla and should be treated as a **MODIFICATION**. This will probably never be official, so don't get confused.

# Compilation

For this mod, you're gonna need to have the development versions of every HaxeFlixel library due to some features not supported by release HaxeFlixel.
To do this, run:
```
haxelib git flixel https://github.com/HaxeFlixel/flixel
haxelib git flixel-demos https://github.com/HaxeFlixel/flixel-demos
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons
haxelib git flixel-ui https://github.com/HaxeFlixel/flixel-ui
```
in your command prompt. Don't worry, you don't need to undo this to work with any other version of FNF, and I highly recommend you keep these changes installed for simplicity's sake.

Other installations you'll need are the additional libraries, of which a fully updated list will be in `Project.xml` in the project root. Currently, these are all of the things you need to run:
```
haxelib install hxcpp-debug-server
haxelib git hscript-ex https://github.com/ianharrigan/hscript-ex
haxelib install hscript
haxelib install newgrounds
haxelib install tjson
haxelib install json2object
haxelib install uniontypes
haxelib install markdown
haxelib git flixel-studio https://github.com/Dovyski/flixel-studio.git
haxelib install git djFlixel https://github.com/john32b/djFlixel.git
```