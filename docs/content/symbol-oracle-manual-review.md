# Full Symbol Caption Manual Review

> Final implementation update — 2026-10-01: the individual Origin/Oracle image audit is complete for all 126 records. The current release records now contain a concise Oracle visible-form caption for every selected image, and the final Regular Script endpoint corrections are applied. The historical proposal tables below remain an audit trail; use the canonical release records and `Tools/Apply-FinalEditorialCaptionPass.ps1` for current runtime content.

Review ID: `AL-ORACLE-126-MANUAL-REVIEW`

Status: approved caption set applied to canonical source and runtime corpus. Artwork is unchanged; this document is retained as the review record for future minor adjustments.

## Confirmed editorial ruleset

### Illustration / Origin

The Illustration / Origin stage explains what the real-world image represents, why it represents that meaning, which visible components support the interpretation, and any important uncertainty. The illustration is educational context, not a historical glyph, and this stage is complete and frozen.

### Oracle Bone

Oracle Bone is the first historical drawing. It must not repeat the Illustration / Origin explanation.

- If the selected Oracle form visibly resembles the intended meaning, leave the caption empty.
- If it does not, describe only why recognition is difficult: compression, abstraction, orientation, missing recognizable features, unusual marks, or uncertain components.
- If a visible line, dot, enclosure, or component affects recognition, identify what is visible and its visual role, without inventing a historical reason.
- Do not explain again why the illustration represents the meaning.

### Bronze, Small Seal, Clerical, and Regular Script

Each destination stage is compared only with the immediately preceding historical stage. Every meaningful addition, removal, retention, restoration, merger, separation, relocation, or reorganization must be stated. “Becomes more regular” is not sufficient when a meaningful feature changes. If there is no meaningful structural change, use a short factual no-change caption rather than inventing history.

Regular Script describes the settled visible endpoint and the components that remain or disappear. It does not become a separate essay about later meanings, language history, or rejected etymologies.

### Global constraints

Captions describe the selected form, stay within 25 words, preserve genuine uncertainty, and do not override the completed Illustration / Origin text. Existing wording is retained when it already follows these rules; only inconsistent, incomplete, or structurally incomplete rows are changed.

## Scope and evidence

This review covers all 126 symbols and all 630 historical-stage captions: Origin context, Oracle Bone, Bronze, Small Seal, Clerical, and Regular Script. Every Oracle Bone decision was checked individually against the paired Origin illustration, the completed illustration text, the selected local Oracle asset, and the Symbol folder's visual-teaching notes. Every later-stage caption was checked against its destination asset, its preceding stage record, and the detailed current caption.

There are two caption-related data sets in the repository. `Resources/Corpus/*.json` contains the approved learner-facing runtime captions and is the source used by the app. `content/research/v1-symbols/transition-notes-v1.json` is retained as an audit/source package with legacy generated wording and cleared review flags; it is not the learner-facing source of truth. Future caption changes must update the canonical release Symbol, regenerate the runtime package, and preserve this review document as the audit trail.

The earlier empty-by-default proposal is discarded. An empty Oracle caption is appropriate only when the first historical form is genuinely recognizable as the illustrated meaning, or when the visible components are already plainly explained and remain plainly present. Oracle Bone is the first historical drawing; the Origin illustration is an educational comparison, not an earlier historical stage.

## Audit method

- The paired Illustration / Origin text is treated as fixed context, not as a historical predecessor.
- Each Oracle decision asks whether the selected first historical form is recognizable as the illustrated meaning; only failed recognition receives a caption.
- Each later decision compares adjacent historical forms and checks for meaningful visible additions, removals, retentions, and reorganizations.
- A historical uncertainty caption describes the visible form and identifies uncertainty without inventing a secure interpretation.
- `Remove` means the Oracle `transitionNote` should be empty. `Replace` gives the proposed replacement text.
- Proposed captions are deliberately short and remain under the runtime's 25-word caption limit.

## Review summary

- 74 captions: `Remove`; the selected form is directly recognizable or its explained components are plainly visible.
- 52 captions: `Replace`; the selected form needs a visual bridge, a component clarification, or an uncertainty note.
- No Oracle caption is marked `Keep current`: all 126 Oracle destinations are explicitly classified as empty or replaced after the individual image review.
- Of the 504 later-stage captions, 446 are retained from the detailed runtime corpus and 58 are replaced below for omitted structural deltas, incomplete wording, contract length, or clearer visual wording.

## Complete symbol-by-symbol proposal

| Rank | Symbol | Action | Proposed Oracle caption |
|---:|---|---|---|
| 001 | one | Remove | *(empty)* |
| 002 | day | Replace | The enclosure is squared and a horizontal stroke crosses its center; the original round sun silhouette is not retained. |
| 003 | moon | Replace | The moon remains a crescent-like outline, but its open interior is angular rather than a smooth lunar curve. |
| 004 | evening | Replace | A short interior mark appears inside the crescent-like enclosure, making evening less distinct from the related moon form. |
| 005 | mountain | Remove | *(empty)* |
| 006 | water | Remove | *(empty)* |
| 007 | river | Replace | Three long channels remain, with detached marks interrupting the spaces between them; a single river course is not obvious. |
| 008 | tree | Remove | *(empty)* |
| 009 | bamboo | Replace | Two mirrored stalk-like clusters compress into angular branches; the form lacks enough distinctive leaves or joints to read clearly as bamboo. |
| 010 | earth | Remove | *(empty)* |
| 011 | stone | Replace | A slanted outer edge encloses an irregular opening; the compact angular form does not clearly read as a separate stone. |
| 012 | rain | Replace | A straight upper line and hanging strokes remain, but no clear cloud or individual raindrops make rain immediately recognizable. |
| 013 | cloud | Replace | Two upper bands and a curling lower form create an abstract outline, but no rounded cloud mass remains. |
| 014 | field | Remove | *(empty)* |
| 015 | well | Remove | *(empty)* |
| 016 | spring | Replace | A broad upper enclosure narrows into long descending strokes; no clear spring opening or flowing water remains. |
| 017 | life | Remove | *(empty)* |
| 018 | person | Remove | *(empty)* |
| 019 | big | Remove | *(empty)* |
| 020 | woman | Replace | Crossed upper lines and a long angled stroke preserve a compact bent human figure. |
| 021 | child | Replace | A long upper stroke rises from a low rectangular body, leaving only a few child-like proportions. |
| 022 | mother | Replace | The female figure retains two added chest-area marks that distinguish it from the related woman form. |
| 023 | eye | Remove | *(empty)* |
| 024 | ear | Remove | *(empty)* |
| 025 | mouth | Remove | *(empty)* |
| 026 | tongue | Remove | *(empty)* |
| 027 | self | Remove | *(empty)* |
| 028 | head | Replace | An angular enclosure contains interior marks and loose upper strokes, but a recognizable face or complete head is not clear. |
| 029 | body | Replace | An enclosed mass narrows into one long stroke; the torso is compressed and its human outline is difficult to recognize. |
| 030 | heart | Remove | *(empty)* |
| 031 | old | Replace | A bent human figure remains beneath several long hair-like strokes. |
| 032 | long | Replace | A side-facing figure carries a large upper mass with long trailing strokes below. |
| 033 | sky | Replace | Early forms vary between an enlarged person, marked head, and sign above a figure; the reference remains interpretive. |
| 034 | ox | Remove | *(empty)* |
| 035 | sheep | Remove | *(empty)* |
| 036 | dog | Remove | *(empty)* |
| 037 | tiger | Remove | *(empty)* |
| 038 | horn | Remove | *(empty)* |
| 039 | knife | Remove | *(empty)* |
| 040 | bow | Remove | *(empty)* |
| 041 | clothing | Replace | A peaked upper line and long side strokes form an open garment-like outline, but the full robe is not clearly recognizable. |
| 042 | bean | Remove | *(empty)* |
| 043 | work | Remove | *(empty)* |
| 044 | book | Remove | *(empty)* |
| 045 | jade | Remove | *(empty)* |
| 046 | king | Replace | A central person-like figure stands on a base with arms extending sideways; the original referent remains debated. |
| 047 | altar | Remove | *(empty)* |
| 048 | strength | Remove | *(empty)* |
| 049 | two | Remove | *(empty)* |
| 050 | three | Remove | *(empty)* |
| 051 | ten | Remove | *(empty)* |
| 052 | above | Remove | *(empty)* |
| 053 | below | Remove | *(empty)* |
| 054 | middle | Remove | *(empty)* |
| 055 | small | Remove | *(empty)* |
| 056 | few | Remove | *(empty)* |
| 057 | many | Replace | Two small box-like forms are stacked, preserving a repeated-mass idea rather than an abstract numeral. |
| 058 | high | Remove | *(empty)* |
| 059 | enter | Replace | Only the pointed opening remains; the person and entering movement are not visible. |
| 060 | exit | Replace | A U-shaped enclosure contains rising strokes, but no foot or person leaving is recognizable. |
| 061 | stand | Remove | *(empty)* |
| 062 | center | Remove | *(empty)* |
| 063 | south | Remove | *(empty)* |
| 064 | north | Remove | *(empty)* |
| 065 | west | Replace | A dense enclosure divided by inner strokes no longer clearly identifies the original nest-like object. |
| 066 | forest | Remove | *(empty)* |
| 067 | rest | Remove | *(empty)* |
| 068 | follow | Replace | Two narrow figure-like forms lean together, but separate bodies and the act of following are not clearly distinguishable. |
| 069 | good | Replace | A child-like figure stands beside a bent woman-like figure, though the relationship is compressed. |
| 070 | man | Remove | *(empty)* |
| 071 | bright | Remove | *(empty)* |
| 072 | beautiful | Remove | *(empty)* |
| 073 | older-brother | Remove | *(empty)* |
| 074 | things-goods | Remove | *(empty)* |
| 075 | tell | Replace | A horned upper form sits directly over a mouth-like enclosure; the two visible parts are more important than the later meaning. |
| 076 | join | Remove | *(empty)* |
| 077 | take | Replace | A long reaching stroke meets a large enclosed form; the hand, ear, and act of taking are not individually recognizable. |
| 078 | gather | Remove | *(empty)* |
| 079 | stop | Remove | *(empty)* |
| 080 | step | Remove | *(empty)* |
| 081 | walk | Replace | A person-like upper body and spread legs rise over a lower crossing or foot form. |
| 082 | go | Remove | *(empty)* |
| 083 | upright | Replace | A strong upper marker sits above a separate foot-like lower form. |
| 084 | before | Replace | A thin forward-moving figure or foot-like form keeps several projecting limbs. |
| 085 | reach | Replace | An upper hooked shape bends toward a smaller lower figure, preserving a reaching gesture. |
| 086 | meet | Remove | *(empty)* |
| 087 | turn-back | Replace | A cliff-like frame surrounds a small hand or bent stroke, with a long arm descending outside it. |
| 088 | friend | Remove | *(empty)* |
| 089 | direction | Remove | *(empty)* |
| 090 | divide | Replace | Two outer strokes spread around a central dividing line, making separation visible. |
| 091 | benefit | Replace | A plant-like stalk stands beside a separate blade-like form, preserving the harvesting compound. |
| 092 | martial | Remove | *(empty)* |
| 093 | obtain | Replace | A walking-like stroke and dense hand/object cluster remain, but the hand taking an object is not clearly separable. |
| 094 | after | Replace | The form becomes a tall twisted sequence of linked curves rather than a recognizable walking scene. |
| 095 | gather-u96c6 | Remove | *(empty)* |
| 096 | speech | Remove | *(empty)* |
| 097 | public | Replace | Two long strokes diverge above a small enclosure; the original vessel interpretation is not obvious. |
| 098 | people | Replace | A broad eye- or lid-like top is crossed by angular marks and a long descending stroke; the identity remains disputed. |
| 099 | classic | Replace | A dense upper cluster with several openings sits over long side strokes and a lower bar; the slips and stand are not clearly recognizable. |
| 100 | soldier | Replace | Several long angular forms surround a central stroke; the axe and surrounding hands are not clearly separable. |
| 101 | command | Replace | A pointed upper enclosure sits above a bent lower form; neither mouth nor kneeling person is clearly recognizable. |
| 102 | each | Remove | *(empty)* |
| 103 | same | Replace | Two separated structures—an upper frame and lower box—remain; their shared enclosure or covered-object relation is not visible. |
| 104 | wife | Replace | Branching strokes rise above an enclosed lower figure-like form; neither woman nor hand-at-hair action is clear. |
| 105 | old-u53e4 | Remove | *(empty)* |
| 106 | auspicious | Remove | *(empty)* |
| 107 | journey | Replace | A long central stroke carries branching side marks; the flag and group movement are not clearly recognizable. |
| 108 | group | Replace | A tall angular stroke stands beside a smaller clustered form; the flag-and-arrow components are not clearly separable. |
| 109 | guard | Remove | *(empty)* |
| 110 | official | Replace | A peaked enclosure surrounds a central elongated form; the building and officials shown in the illustration are not clearly recognizable. |
| 111 | stretch | Replace | Two opposing curls form a loose S-shaped line, with no obvious lightning or modern enclosure. |
| 112 | light | Remove | *(empty)* |
| 113 | white | Replace | A pointed oval enclosure is divided by one strong band; its original thumb, vessel, or light reading remains uncertain. |
| 114 | black | Replace | A human-like body has a dark enclosed top and branching limbs; the tattooing interpretation remains uncertain. |
| 115 | red | Remove | *(empty)* |
| 116 | year | Remove | *(empty)* |
| 117 | summer | Remove | *(empty)* |
| 118 | winter | Replace | A broad arch with hooked ends does not clearly show ice, snow, or a cord's original meaning. |
| 119 | look-toward | Replace | A thin standing profile has a small eye-like projection near the top; the act of looking toward something is not visible. |
| 120 | sweet | Remove | *(empty)* |
| 121 | fragrance | Remove | *(empty)* |
| 122 | increase | Remove | *(empty)* |
| 123 | sacrifice | Replace | Dense upper marks, separated strokes, and a long right form obscure the offered object and hand; the sacrifice scene is not readily recognizable. |
| 124 | ancestor | Remove | *(empty)* |
| 125 | lodging | Remove | *(empty)* |
| 126 | blessing | Remove | *(empty)* |

## Full later-stage caption audit

The Origin illustration and its explanatory text are complete and are not being rewritten here. The later-stage captions are destination-stage visual comparisons: they describe what changed in the selected glyph, not a second explanation of the Origin scene.

### Bronze — 126 checked

Retain the detailed `Resources/Corpus` caption for 123 symbols. Replace the following three captions:

| Symbol | Current issue | Proposed Bronze caption |
|---|---|---|
| look-toward | Overlong and repeats disputed component history | Bronze reorganizes the earlier figure-and-eye arrangement into a tighter, more compact component structure. |
| one | Generic wording | The single horizontal mark remains unchanged. |
| sacrifice | Speculates about later forms instead of describing the selected transition | The offering cluster gains a more distinct ritual-tablet-like lower element while the upper hand/object marks remain separate. |

### Small Seal — 126 checked

Retain the detailed `Resources/Corpus` caption for 121 symbols. Replace the following five captions:

| Symbol | Current issue | Proposed Small Seal caption |
|---|---|---|
| cloud | Repeats semantic history instead of describing the visible change | Adds the rain-and-weather element above the older graph, making the cloud form more explicit. |
| fragrance | Too assertive and too long for the selected visual comparison | The grain-like upper part joins a taste-related lower element in a new stacked structure. |
| obtain | Repeats the older scene instead of describing the stage change | The hand-taking and path elements settle into a more formal, compact structure. |
| walk | Incomplete sentence | Stacks a broad upper body over a rounded foot-like lower element, establishing the basic structure of the later form. |
| one | Generic wording | The same one-line form continues without a new structural change. |

### Clerical — 126 checked

Retain the detailed `Resources/Corpus` caption for 122 symbols. Replace the following four captions:

| Symbol | Current issue | Proposed Clerical caption |
|---|---|---|
| body | Incomplete phrase: “recognizable clerical” | The outline flattens into a recognizable written body form, including the strong rightward sweep. |
| mother | Incomplete phrase ending in “visual logic of” | The crossed Seal outline flattens into a heavy enclosure; the two interior marks remain. |
| tell | Incomplete phrase ending in “making nearly recognizable” | Flattens the upper horns and crossbars and squares the lower mouth, making the two-part structure clearer. |
| winter | Tautological and unclear wording | Compresses the lower marks into two sweeping diagonals and a short center, making the winter form more compact. |

### Regular Script — 126 checked

Retain the detailed `Resources/Corpus` caption for 80 symbols. Replace the following 46 captions. The rows below remove unrelated meaning-history commentary and restore visible endpoint information that the previous text omitted.

| Symbol | Current issue | Proposed Regular Script caption |
|---|---|---|
| after | Describes the traditional/simplified distinction without naming the visible structure | Regular Script preserves the left walking component beside the compact right-side form; the curves and lower marks merge into a stable block. |
| black | Explains competing interpretations without describing the settled visible arrangement | Regular Script settles the dense upper enclosure over four lower marks; the earlier figure and separate interior strokes are no longer distinct. |
| center | Mentions the lost interpretation but omits the retained enclosure and axis | Regular Script retains the enclosing frame and central vertical while flattening the earlier figure-like form into 中. |
| each | Gives the semantic borrowing without naming the retained upper/lower layout | Regular Script keeps the upper foot-like element over a compact lower box; the earlier open lower shape is squared. |
| cloud | Overlong; mixes several modern-language facts into the stage conclusion | Regular Script retains the weather element above the compact lower graph; the earlier separate curls reduce to standard strokes. |
| child | 33 words; exceeds the caption contract | Regular Script reduces the infant to compact 子 strokes: the head, arms, and body merge into an angular form. |
| go | Gives the later borrowed meaning without describing the retained road/intersection structure | Regular Script preserves the paired road sides while compressing their branches into the stable 行 structure. |
| group | Names the compound and meanings but omits the retained banner/arrow arrangement | Regular Script retains the banner component beside compact arrow-like strokes; the earlier separated figures merge into 族. |
| increase | Explains the later overflow character but omits the visible vessel/water arrangement | Regular Script settles the upper marks over the compact lower vessel; the separate waves and basin are no longer distinct. |
| join | Gives the conventionalized character without naming the retained fitted-cover arrangement | Regular Script preserves the fitted cover over the compact lower mouth-like element; the Seal geometry reduces to 合. |
| martial | Discusses the rejected “stop weapons” reading without naming the retained components | Regular Script keeps the weapon-like upper element over the compact foot-like lower element; both components are angular and joined. |
| north | Explains borrowing but omits the retained opposed-figure structure | Regular Script preserves the opposed human-like halves while compressing their central gap and outer curves. |
| old-u53e4 | Rejects a folk explanation without describing the actual upper/lower form | Regular Script settles the upper mark over the compact mouth-like box; the earlier rounded lower enclosure is squared. |
| stand | 26 words; exceeds the caption contract | Regular Script breaks the standing figure into dots, horizontals, and a long base, preserving an upright form grounded below. |
| official | Names the office/building meaning without describing the retained roof and enclosure | Regular Script retains the roof over the enclosed lower element; the inner lobes and side contours compress into 官. |
| public | Discusses the uncertain vessel origin without describing the settled upper/lower form | Regular Script preserves separated upper strokes over a compact lower enclosure; the earlier vessel-like outline is no longer visible. |
| south | Describes borrowing and uncertainty without naming the visible stacked structure | Regular Script settles the upper cross structure over the enclosed lower body; the earlier bell-like proportions compress into 南. |
| strength | Describes semantic abstraction without saying what remains of the tool | Regular Script reduces the long tool-like curves to the compact hooked 力 form; the lower branch is absorbed. |
| stretch | Describes derivative meanings without describing the retained lightning-like graph | Regular Script preserves the central lightning-like frame while standardizing its side strokes; the earlier paired curls are no longer visible. |
| summer | Says the ancient scene is lost but does not describe the final compression | Regular Script compresses the earlier upper sun-like mark and lower figure into the angular 夏 structure. |
| sweet | Gives the meaning without naming the retained mouth-and-mark arrangement | Regular Script preserves the inner horizontal within the compact enclosing form; the Seal’s tall U-shape becomes 甘. |
| upright | Gives later meanings without naming the upper line and foot-like lower component | Regular Script keeps the upper horizontal over the compact foot-like lower element; the earlier travel scene is no longer visible. |
| west | 27 words; exceeds the caption contract | Regular Script settles the pointed enclosure and internal divisions into 西; the earlier oval and crossing are flattened. |
| wife | Avoids an unsupported capture story but omits the visible upper-over-woman arrangement | Regular Script compresses the upper hand-or-hair element over 女; the earlier branching strokes become a stable compact top. |
| year | Explains the semantic extension but omits the final compressed grain/person arrangement | Regular Script compresses the grain-and-person arrangement into 年; the separate stalk and body are no longer distinct. |

The following additional Regular Script rows were also changed in the strict pass. Their previous wording included semantic history or did not state the settled visible endpoint:

| Symbol | Current issue | Proposed Regular Script caption |
|---|---|---|
| altar | Adds later usage history instead of describing the endpoint | Regular Script preserves the compact 示 form with a short upper mark and split lower strokes; the ritual object is no longer pictorial. |
| ancestor | Adds later meaning extensions after a brief structural note | Regular Script retains the roof over the compact ritual-sign element in 宗; the earlier shrine layout is compressed but still legible. |
| bean | Explains sound borrowing instead of the visible endpoint | Regular Script preserves the roofed vessel structure as 豆; the separate lid, bowl, and foot merge into standard strokes. |
| blessing | Adds semantic-component history without describing the final arrangement | Regular Script retains the ritual-sign component beside the compact speech/person-derived side; the earlier offering arrangement is no longer explicit. |
| direction | Adds prehistory instead of describing the settled form | Regular Script settles the outer opening and inner horizontal into 向; the earlier echo-like enclosure is reduced to standard strokes. |
| follow | Names later meanings without describing the retained compound structure | Regular Script compresses the paired figure component beside the walking element into 從; the two-person arrangement remains visible. |
| fragrance | Explains origin history instead of the final visible arrangement | Regular Script settles the grain-like upper element over the compact taste-like lower element in 香; the source components remain merged. |
| gather | Discusses usage distinctions rather than the endpoint form | Regular Script preserves the hand-over-tree arrangement in 采; the upper hand and lower tree compress into compact strokes. |
| king | Adds a mnemonic correction instead of the final structure | Regular Script settles three horizontal bars around a central vertical in 王; the earlier axe-like structure is no longer distinct. |
| long | Mentions traditional/simplified writing instead of the selected endpoint | Regular Script compresses the elder-like figure into the dense 長 structure; the long lower sweep remains dominant. |
| meet | Adds later semantic extensions instead of the visible endpoint | Regular Script preserves the crossed upper strokes over the compact lower element in 交; the meeting scene is no longer pictorial. |
| people | Gives current meaning and interpretation history instead of the final structure | Regular Script settles the eye-like upper enclosure and long lower stroke in 民; the marked-eye scene is no longer distinct. |
| sacrifice | Adds a prohibition about incense instead of describing the endpoint | Regular Script joins the hand/offering component with the ritual-sign lower element in 祭; the offered object is compressed. |
| self | Explains sound borrowing instead of the settled form | Regular Script preserves the nose-like enclosure in 自; the earlier facial placement is no longer shown. |
| stop | Adds a later derivative instead of describing the final pictograph | Regular Script stabilizes the footprint as 止; the toe and heel contours merge into angular strokes. |
| things-goods | Adds later senses after a brief structural description | Regular Script consolidates the three repeated units into 品; the separate objects are no longer individually drawn. |
| turn-back | Adds later meanings instead of describing the final compression | Regular Script compresses the hand-and-cliff arrangement into 反; the cliff frame and returning hand are no longer separate. |
| walk | Gives language-specific meanings instead of the settled endpoint | Regular Script settles the upper body over the compact foot-like lower element in 走; the running figure is no longer pictorial. |
| white | States only the meaning and uncertainty, omitting the visible endpoint | Regular Script preserves the pointed enclosure and inner horizontal in 白; the original object remains uncertain. |
| winter | Gives semantic separation instead of the final structure | Regular Script preserves the capped top and paired lower strokes in 冬; the earlier cord-like form is no longer visible. |
| work | Adds semantic extension after a vague endpoint statement | Regular Script settles the tool outline into the compact 工 frame; the working implement is no longer pictorial. |

## Final proposal boundary

The following boundary describes the earlier proposal state and is retained for audit only. It is superseded by the final 2026-10-01 implementation pass described at the top of this document.

For the 446 later-stage rows marked retained above, the proposed text is the current detailed value in `Resources/Corpus/<symbol>.json`, unchanged. For the 58 listed rows, the table text supersedes the current detailed value. For Oracle Bone, the complete 126-row table above is authoritative for this proposal: `Remove` means an empty destination caption, and `Replace` means the exact proposed text shown.

The historical proposed set therefore contained 630 destination captions: 74 empty Oracle captions, 52 replacement Oracle captions, 446 retained later-stage captions, and 58 replacement later-stage captions. It is no longer the release set.

## Editorial cautions recorded during approval

- These were visual/editorial proposals and have now received the approved V1 source and interpretation review.
- King, Sky, West, People, White, Black, Summer, Winter, and Fragrance are included in the approved V1 review decision.
- Fragrance should not be described as unavailable merely because the selected form is difficult to interpret; the local asset exists and the caption should describe its visible structure cautiously.
- Tiger's earlier empty recommendation is superseded; the final pass explains why the selected animal-like carving is still difficult to recognize as tiger.
- Stone and Sweet received the Origin-artwork consistency check as part of final V1 approval.

## Approval state

The historical 630-row proposal was applied before the final screenshot-driven pass. The current release set is the 126-record caption map in `Tools/Apply-FinalEditorialCaptionPass.ps1`, applied to the canonical Symbol records and regenerated `Resources/Corpus`. The illustration and illustration text remain unchanged.
