# macOS Device Testing

This project is developed on Windows, but iPhone testing requires macOS because Apple signing, packaging, and device install are handled by Xcode.

## Goal

Use macOS only as a build/sign/install station for testing the app on a real iPhone.

## What Must Be On macOS

Xcode needs the complete project folder, not just a compiled executable, because it must:

- compile the Swift sources
- bundle local resources
- create the iOS app package
- sign the app with an Apple development team
- install the signed app on the connected iPhone

## One-Time Setup

1. Install Xcode from the Mac App Store.
2. Open Xcode once and accept any first-run setup prompts.
3. Add your Apple ID in `Xcode > Settings > Accounts`.
4. Copy or clone this repo onto the Mac.

If using git:

```bash
git clone <repo-url> AsianLanguage
cd AsianLanguage
open AsianLanguage.xcodeproj
```

If using a copied folder, copy the whole repo folder, including:

- `AsianLanguage.xcodeproj`
- `Sources`
- `Resources`
- `Tests`
- project docs and tool files

## First Phone Run

1. Connect the iPhone to the Mac by USB.
2. Trust the Mac on the iPhone if prompted.
3. Open `AsianLanguage.xcodeproj` in Xcode.
4. Select the `AsianLanguage` scheme.
5. Select the connected iPhone as the run destination.
6. In the app target signing settings, choose your Apple development team.
7. Press `Cmd+R` or choose `Product > Run`.

Xcode will build, sign, install, and launch the app on the phone.

## Repeat Testing After Windows Changes

After making changes on Windows:

1. Push or copy the updated project to the Mac.
2. On the Mac, update the repo.

```bash
cd AsianLanguage
git pull
open AsianLanguage.xcodeproj
```

3. Press `Cmd+R` in Xcode with the iPhone selected.

## What To Report Back

When a phone build fails, bring back the first real error, especially:

- Swift compiler error with file and line number
- signing or provisioning error text
- runtime crash message
- screenshot of incorrect app behavior

Do not paste the full Xcode log unless the first error is unclear.

## Notes

- A standalone iOS executable cannot be copied to an iPhone and run directly.
- A signed `.ipa` can be distributed through TestFlight or other Apple-supported signing flows, but creating that package still requires macOS/Xcode or Apple build infrastructure.
- Development remains Windows-first; macOS is only required for iOS build, signing, simulator, and device testing.



# Notes from Testing
# Prototype 1 - First test
- App is working on iphone, no errors.
- Some of the functionality is there.
- The app does go through the different progress (Although visually and text wise very wrong). But it's not possible to continue to next symbol. "Mark as Learned" is not possible, and the app does not automatically bring up the next symbol once done.
- As mentioned, some of the functionality is here. but this is incredibly far from what we've agreed on, and what I believed was done at this point.
- The visuals are very far from the examples listed and included in the project brief (Reference pictures).
- Bugs : 1. When selecting a "Focus Language", it only allows "All", or "1 specific langauge". It should allow multiple (Such as - Korean & Japanese). You don't even need an "All" button. Once all are selected, that does the same thing. It should allow for multiple selections, with all selection being "on" as default. Remove the "all" option. 2. Visuals are completely off. 3. Lesson : "Restart Lesson" and "Mark as Learned" are not working.
- The text included, and the pictures for the symbols, this is far from complete.
- The other pages other than Home are very different than what we initially agreed on, and what is in the Project Brief. Why?


#New Notes from Design - Notes Design 1
- I realized many symbols changed their meaning, or components over time. In an example - Learning : https://www.dong-chinese.com/wiki/%E5%AD%A6 - You can see that in Bone script it was just a house with hands components, and later (I believe in Bronze) they included a child inside the house. This is crucial to include in the evolution of the symbols. Is it possible for you to find this information? Or would I personally need to double check every symbol for similar evolutions? - Here is Chatgpt's answer from this evolution - Oracle-bone 學:
hands + counting/divination marks
= learning / being taught / handling counting rods

Bronze 學:
hands + marks + added child 子
= a child learning / being educated

Later seal / regular 學:
hands + 爻 + roof/enclosure + child
= teaching a child under a roof / in a school

- I am using CHATGPT to explain the evolution of EACH symbol. And since you are built with/upon chatgpt, are you able to analyze the evolution from Dong Chinese and explain what is happening? - Of course use internet if needed. 
- I am also using CHATGPT to analyze and write a short description of the symbol and how it evolved, see the example I gave you for Dog. You can follow along the text with the images from this https://www.dong-chinese.com/wiki/%E7%8A%AC 
- I made a collumn for Components, but many pictographs or symbol (especially the easy ones), will not have more than 1 component. If only 1 component, Don't include the components, and rather move the text box further up. (I think they're caleld Pictograph)
- This would be best for our app to start with mostly Pictographs before getting into symbols with more advanced components
- If the components change or get added at a later stage in the symbol evolution, include it then. 
- We already talked a lot about the amterial we are using. And we came across trying to figure out what symbols to include. Here is a list from dong-chinese with 1000 most used symbols for movie subtitles. https://www.dong-chinese.com/dictionary/topMovieChars - This may or may not be the best list for us, as we prefer to use symbols still in use in all our targeted focus languages, but, it's a good reference.

Design explained :
The "images" are referring to actual assets/images stored, we already know which ones.
The squares are referring to area for the content.
I'm using "dog" as an example


##Home Page explained
70% will basically be a reference to the next (or current if didn't finish) symbol specifically the Oracle Bone pictures. - The real picture (In this example a dog), compared with the Oracle Bone picture of the dog (This is very similar to our Bone Script page), with Sound "quan" and "Dog" (Example). Press this and you will go to the Symbol page (The 1st page, or to the page you exited from last time)
30% beneath the Symbol, (and above Menu/navigation) - Will for now just have a empty space/box. Not sure what to put here. Could be Study Progress, Streak, etc. Could be a reference to History or some new knowledge. Again, not sure. We can keep the Study progress as is already

##New Symbol Pages explained
1st page : 
- Headline (eg DOG ) - English name
- Oracle Bone Script
- Square + Image of actual Dog/generated or found
- Square + Image 2 = Pictograph of the oracle bone symbol
- Optional - Component squares and images
- Text. Every paragraph should be easily made as a pointer. Try to stay within the height of the screen - If not possible, we can scroll within this page. 

2nd Page - 5th page.
- Name of Script
- Square + Image of the symbol
- Sound (If possible)
- Optional - Components (If they were introduced in this step)
- Text. Every paragraph should be easily made as a pointer. Try to stay within the height of the screen - If not possible, we can scroll within this page. 

Focus Languages pages 
- We don't need pictures anymore, as we will use the actual characters instead. 
- In all four languages I showed how it's written, and alternatives. This was a pretty bad example, because 1. Dog was the same in Traditional and Simplified. 2. Most languages (Except Japanese) actually use a more modern version of "dog" more often (See picture). This may happen, or they may be alternatives that are commopnly used. Then, as you can see in the pictures, I explained in the text, and showed a square with both alternatives
- Sound for each - Always
- In Japanese and Korean I showed the Korean way and the "Hanja" way, and for Japanese both the symmbol and the Hiragano version. 

Transition from 1 page to another either with Arrows, or Swipe function (Iphone) (Swipe preferred). 

Menu always Visible

##Browse page explained
Top of Page - Search - The search we have works fine. Character, Gloss, or reading. 
- Our entire Search currently works fine. But where we now have "Search Shared Characters", we will instead have our saved collection, and our Learned collection etc. If we SELECT any of these collecctions, we will enter a page with (just like how our search results look), of all the symbols in that "collection". (And if you press a specific symbol from the list, goes to Symbol page - Just like our Search) - The Browse All should be identical to how our "browse" is right now. The Saved and History should also be identical to how our Browse is right now, just different lists

##History page explained

##Settings page explained