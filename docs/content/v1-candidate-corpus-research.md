# V1 Candidate Corpus Research

Status: discussion proposal only. This document does not approve content, create runtime records, or authorize implementation.

Date: 2026-09-02

## Recommendation in brief

V1 should contain no fewer than 100 and no more than 200 symbols. The final number is deliberately open: it should be the number of candidates that clear the historical, language, usage, visual-teaching, and asset-quality gates within that range. A release of 137 strong symbols is preferable to padding the corpus to 200, while a release of 173 is appropriate if 173 candidates genuinely pass review.

This document is therefore a candidate bank, not a final corpus approval. The current V1 design target is the separate 126-character ZDIC-complete selection. This broader bank currently contains 173 candidates: the 120 candidates from the initial screen plus 53 additional candidates that should be investigated next. The number 173 is an inventory of research, not a target or quota.

The bank should prioritize simple pictographs with secure early forms as the museum's foundation: a recognizable referent, a teachable early form, a defensible historical journey, useful modern recognition across the four focus tracks, and a distinct place in a collection. Meaningful indicators and advanced multi-component characters can then show how writing evolved. Simplicity is a useful advantage, but a simple modern shape is not by itself evidence that an early form exists or that the historical interpretation is secure.

The current 11 pilot records are included and marked with `*`.

## Research basis

The allowed-character boundary is now documented separately in [`shared-cjk-allowed-character-universe.md`](shared-cjk-allowed-character-universe.md). The V1/V2/V3 candidate bank must be a subset of that shared universe; the bank is not allowed to introduce Japanese-only, Korean-only, or Chinese-only character identities. The current 173-entry bank is pre-gate research material: 158 entries match the allowed universe after obvious form normalization, while 15 are explicitly excluded in the boundary document.

The shortlist was screened against these public reference sets:

- [Trilateral Cooperation Secretariat: 808 Commonly Used Chinese Characters](https://www.tcs-asia.org/en/cooperation/mechanism.php?topics=4). This is the strongest direct anchor for shared China/Japan/Korea character coverage. TCS describes the set as compiled from contemporary frequently-used-character tables in the three countries and notes that it contains 808 traditional characters.
- [Japan Ministry of Education: grade-assigned kanji table](https://www.mext.go.jp/a_menu/shotou/cs/1320015.htm). This supplies an official early-literacy and everyday-use signal; the first six grades cover 1,026 characters.
- [National Institute of Korean Language: educational basic Hanja discussion](https://www.korean.go.kr/nkview/nklife/1999_4/1999_0415.pdf). This documents the Korean educational basic set of 1,800 Hanja and also warns that a classical-education list is not identical to a modern Korean-frequency list.
- [Taiwan Ministry of Education: frequently used character teaching resources](https://stroke-order.learningweb.moe.edu.tw/page.jsp?ID=33&la=0) and its [4,808-character reference PDF](https://ws.moe.edu.tw/001/Upload/6/relfile/6490/38921/d190213c-7af8-45bf-b70e-48b4469aad72.pdf). These help preserve Traditional Chinese coverage and standard-form awareness.
- [Chinese Test official download center](https://admin.chinesetest.cn/godownload.do), which provides the official HSK vocabulary-list resource used as a Mandarin learning/usefulness cross-check. HSK vocabulary is a word list rather than a character-history list, so it is only one input here.

These sources establish candidate coverage, not historical approval. Oracle-bone availability, interpretation, and provenance must still be checked symbol by symbol.

## Screening criteria and provisional priority bands

Each candidate should be scored before entering the final corpus. The score is an editorial triage tool, not a historical claim:

1. Historical story (`H`): source-backed early evidence, a defensible interpretation, and a meaningful journey through later stages.
2. Visual teaching value (`V`): the referent and early structure can be explained clearly; visual simplicity helps, but must not be confused with evidence.
3. Four-track usefulness (`L`): verified membership in both Japanese Kanji and Korean Hanja, plus meaningful modern recognition in Simplified Chinese and Traditional Chinese usage communities. This is a hard V1 eligibility gate, not merely a bonus score. Korean coverage means Hanja recognition and lexical/cultural context; it does not imply common use in ordinary Hangul-only writing.
4. Usage potential (`U`): at least three reviewed modern words or phrases can be shown without forcing unnatural examples; the modern-form screen should eventually provide 3–4 examples per selected track where appropriate.
5. Distinctness and collection fit (`D`): the symbol adds a different idea, visual lesson, or historical transition rather than duplicating an existing entry.
6. Source and asset feasibility (`A`): historical assets are source-backed, licensed, bundled, or explicitly marked missing; educational reconstructions are clearly separated from historical evidence.

Each factor can be rated 0–3. A provisional approval rule for discussion is `H >= 2`, `A >= 2`, and a total of at least 12/18. This rule should be tested against real editorial reviews before it is treated as policy. A candidate with a weak historical story should not be rescued by high modern frequency.

The bank uses three provisional priority bands:

- `Anchor`: strong candidates for the core Symbol Journey—usually concrete referents with a clear visual teaching opportunity and broad usefulness.
- `Journey builder`: candidates that explain abstraction, relationships, movement, society, or language and make the overall museum coherent, even when their early image is less immediately pictographic.
- `Conditional`: candidates with good use or collection value but a higher burden of historical, source, language, or illustration review. They may enter V1 if they pass; they are not automatic expansion content.

History codes used during review:

- `A` — strong pictographic or visually teachable candidate; source verification still required.
- `B` — promising historical or structural story, but interpretation/source availability needs specialist review.
- `C` — primarily a modern-use or language anchor; include only if it earns its place in the museum journey.

The codes below are screening judgments, not published historical claims.

## Shared-language eligibility — discussion rule

The project's defining corpus requirement should be: a candidate must belong to the shared inherited Han-character tradition, be present as a recognized Japanese Kanji and Korean Hanja, and retain a meaningful contemporary role in the Chinese tracks. Historical age alone is not enough, and teaching usefulness alone is not enough. If a candidate is not present in both Kanji and Hanja, it is disqualified regardless of how attractive its history or teaching potential is.

There is no single clean calendar date when Chinese, Japanese, and Korean “split apart” for purposes of character creation. The practical test is historical provenance: was the character part of the shared written repertoire before modern regional standards, or was it created locally after the traditions had differentiated? Later local creations with no shared ancestor should be excluded even if they are useful in one language. Japan-made characters such as kokuji are the clearest exclusion case; Japan has continued creating local characters after adopting Han writing. [National Diet Library reference on kokuji](https://crd.ndl.go.jp/reference/entry/index.php?id=1000371586&page=ref_view)

Later standard forms are different from new character identities. A Simplified Chinese or Japanese form may be a later regional glyph for an older shared character. In that case, the Shared Character can use the historically shared form as its lineage anchor and show each language's current form at Today. The candidate is excluded only when the character identity itself is a later regional creation, not merely because one endpoint glyph was standardized later.

For this project, “belongs to both Kanji and Hanja” should be checked against authoritative character inventories, not inferred from a shared meaning or a dictionary translation. We should separately record at least one authentic modern lexical, educational, historical, or cultural context in each track. It should not mean equal frequency or equal writing-system prominence: Korean is predominantly written in Hangul today, so Korean Hanja relevance will often be recognition, compounds, names, formal vocabulary, or cultural context rather than ordinary daily spelling.

The audit should use the Japanese Jōyō Kanji / official educational inventories and the Korean educational basic Hanja inventory as the minimum membership checks. The existing TCS common-character set remains a useful cross-country filter, but it does not replace checking each local inventory. Japan's Jōyō Kanji standard is 2,136 characters, while Korean references use an educational basic set of 1,800 Hanja. [Japan MEXT reference](https://www.mext.go.jp/content/20231116-mxt_tokubetu01-000032539_45.pdf) · [National Institute of Korean Language reference](https://www.korean.go.kr/nkview/nklife/1996_3/6_13.html)

This rule makes historical inheritance the floor and teaching value the ranking mechanism. Among eligible candidates, we should first prefer simple pictographs, then meaningful indicators and assembled meanings that show increasing structural complexity. Meaning-plus-sound structures should not be default V1 candidates when a component contributes only pronunciation.

## Initial candidate bank — first screened group

These ten groups are an editorial organization of the bank, not ten quotas of ten. Their provisional priority is noted in each section. The entries are suggested starting points for review, not approved runtime content.

### 1. Nature foundations

History screen: `A` for the elemental/natural referents; `B` for compound or later-developed forms. Usage potential: high. Primary collection: Nature & Elements.

`火*` Fire · `水*` Water · `山*` Mountain · `木*` Tree/Wood · `林` Woods · `森` Forest · `土` Earth/soil · `石` Stone · `川` River · `田` Field

### 2. Sky, weather, and time

History screen: `A` for Sun and Moon; `B` for most atmospheric/time forms. Usage potential: high. Primary collection: Sky & Time.

`日*` Sun/Day · `月*` Moon · `天` Sky/heaven · `雨` Rain · `雲` Cloud · `風` Wind · `星` Star · `光` Light · `明` Bright · `年` Year

### 3. Plants, animals, and food

History screen: `A` for many concrete animal/plant forms; `B` where the modern form is more abstract or compound. Usage potential: high to medium. Primary collection: Living World.

`花` Flower · `草` Grass · `竹` Bamboo · `禾` Grain · `米` Rice · `牛` Ox/cow · `馬` Horse · `羊` Sheep · `犬` Dog · `鳥` Bird

### 4. People and immediate perception

History screen: `A` for human/body pictographs; `B` for later abstractions. Usage potential: high. Primary collection: People & Body.

`人*` Person · `女` Woman · `子` Child · `男` Man · `口*` Mouth · `目*` Eye · `耳` Ear · `手` Hand · `足` Foot · `心` Heart/mind

### 5. Body and material form

History screen: `A` or `B`, with careful specialist review for body-part interpretation. Usage potential: medium to high. Primary collection: People & Body.

`身` Body · `首` Head · `面` Face · `肉` Flesh/meat · `毛` Hair/fur · `骨` Bone · `齒` Tooth · `皮` Skin · `血` Blood · `體` Body/form

### 6. Position and movement

History screen: mostly `B`; these are important for explaining how visual signs become abstract written language. Usage potential: high. Primary collection: Place & Movement; secondary lens: Dramatic Changes.

`上` Above · `下` Below · `中` Center · `內` Inside · `外` Outside · `前` Before/front · `後` After/back · `出` Exit · `入` Enter · `行` Go/walk

### 7. Action, perception, and language

History screen: `B` to `C`; include only where the historical story is defensible. Usage potential: high. Primary collection: Action & Language; secondary lens: Components.

`走` Walk · `立` Stand · `坐` Sit · `見` See · `聞` Hear/learn · `言` Speech · `說` Speak/explain · `來` Come · `去` Go · `生` Life/birth

### 8. Family and society

History screen: `A` for selected kinship forms, otherwise `B` or `C`. Usage potential: high. Primary collection: People & Society.

`父` Father · `母` Mother · `兄` Older brother · `弟` Younger brother · `友` Friend · `家` Home/family · `王` King · `主` Master/main · `民` People · `國` Country/state

### 9. Objects, tools, and exchange

History screen: `A` for concrete objects; `B` for later standardizations. Usage potential: medium to high. Primary collection: Objects & Making.

`門` Gate · `戶` Door/household · `車` Vehicle · `舟` Boat · `刀` Knife · `弓` Bow · `矢` Arrow · `玉` Jade · `金` Metal/gold · `貝` Shell/money

### 10. Size, color, and contrast

History screen: `A` for visually clear contrasts; `B` for abstracted qualities. Usage potential: high. Primary collection: Qualities & Contrast; secondary lens: Dramatic Changes.

`大*` Big · `小*` Small · `長` Long/elder · `高` High/tall · `多` Many · `少` Few · `白` White · `赤` Red · `青` Blue/green · `黑` Black

## Initial candidate bank — conditional group

These are not an “expansion set.” They belong in the same candidate review as the other entries, but currently carry a higher evidence or teaching burden.

### 11. Language and learning

History screen: mostly `B` to `C`. Usage potential: high, but these symbols should not crowd out concrete museum stories. Primary collection: Language & Learning; secondary lens: Components.

`文` Writing/culture · `字` Character · `書` Book/writing · `學` Learn/study · `名` Name · `話` Speech/story · `問` Ask · `答` Answer · `讀` Read · `章` Chapter/mark

### 12. Built world and shared places

History screen: `B` to `C`; verify period-specific evidence carefully. Usage potential: medium to high. Primary collection: Places & Built World.

`城` City wall · `市` Market/city · `村` Village · `道` Way/road · `橋` Bridge · `店` Shop · `寺` Temple · `宮` Palace · `間` Interval/space · `開` Open

## Additional candidates to screen next — 53

The following candidates enlarge the research bank beyond the first 120. They are included because they may improve category coverage, four-language usefulness, or the explanation of how concrete signs become broader vocabulary. They are not being selected merely to reach a number.

### 13. Landscape and weather — conditional until evidence is checked

`地` Earth/ground · `海` Sea · `江` River · `河` River · `湖` Lake · `泉` Spring · `雪` Snow · `雷` Thunder · `電` Electricity

### 14. Animals, food, and growth — anchor or journey builder depending on sources

`魚` Fish · `虎` Tiger · `鹿` Deer · `象` Elephant · `兔` Rabbit · `蟲` Insect · `果` Fruit/result · `菜` Vegetable · `食` Eat/food · `飲` Drink

### 15. Body, condition, and change — mostly journey builders

`頭` Head · `腹` Belly · `臉` Face · `病` Illness · `死` Death · `老` Old/age · `牙` Tooth

### 16. Everyday actions and relations — journey builders with high usage potential

`作` Make/do · `用` Use · `休` Rest · `取` Take · `受` Receive · `送` Send · `帶` Carry/bring · `回` Return

### 17. Direction, number, and time — useful anchors but lower museum distinctness

`東` East · `西` West · `南` South · `北` North · `一` One · `二` Two · `三` Three · `十` Ten · `百` Hundred · `千` Thousand · `時` Time/hour

### 18. Clothing, documents, and built spaces — conditional

`衣` Clothing · `服` Clothes/obey · `冊` Volume/book · `屋` House/room · `房` Room · `室` Room · `園` Garden · `堂` Hall

## Why this is not yet a final V1 corpus

The candidate bank should not be converted into a final corpus by taking the first 100, the first 120, or all 200. The final count should emerge after we see:

- which candidates have real, usable early evidence;
- which candidates can support four-track modern examples without awkward or misleading language;
- which candidates produce distinct, worthwhile Symbol Journeys;
- which candidates can be grouped into coherent collections without repeating the same artwork or lesson pattern;
- which candidates can be illustrated in the approved educational style while keeping historical assets visibly separate; and
- how many candidates remain after native-speaker, historical, and editorial review.

The decision procedure should be:

1. Score and source-check the full bank.
2. Remove hard failures and resolve duplicate or weak candidates.
3. Draft the learner-facing historical explanation and 3–4 modern examples for each surviving candidate.
4. Map each survivor to a primary collection and any useful cross-cutting lens.
5. Count the survivors. If the result is between 100 and 200, that is the proposed V1 size. If fewer than 100 survive, the corpus needs another research pass before release; if more than 200 survive, retain the strongest 200 and document the carryover.

The Trilateral 808 set gives us a large, defensible expansion pool. It should be filtered by our product's historical/visual story rather than adopted wholesale.

## Proposed collection structure for later discussion

The current bank suggests seven semantic collections:

1. Nature & Elements
2. Sky & Time
3. Living World
4. People & Body
5. People & Society
6. Objects & Making
7. Places & Built World

`Pictographs`, `Components`, and `Dramatic Changes` may work better as cross-cutting lenses or curated views. They describe how a symbol teaches, not necessarily what kind of collection it belongs to. This keeps collection artwork specific and avoids using the same symbol art as a generic cover.

These seven are a working taxonomy, not an approved final collection count. Collection membership should follow the surviving corpus and lesson structure; no collection should be padded to make the category totals look even.

## Review fields to add before approval

For every candidate, the editorial review sheet should eventually record:

- canonical character and all four modern forms/readings;
- oracle-bone availability and source URL/license;
- Bronze, Seal, Clerical, Regular, and Today availability states;
- historical confidence separately from asset availability;
- one-sentence learner explanation of the visual transformation;
- numeric teaching order (`1 → X`) and prerequisite component concepts, so simple pictographs are introduced before compounds that depend on them;
- three or four reviewed modern word examples per selected track;
- proposed primary collection and any secondary lenses;
- illustration brief and whether the image is historical evidence or educational reconstruction;
- native-speaker and specialist review status.
