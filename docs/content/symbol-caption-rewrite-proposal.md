# Symbol Caption Rewrite Proposal (Historical Draft)

> This is a historical partial proposal. Its Oracle section and its earlier approval labels are superseded by [the full symbol caption manual review](symbol-oracle-manual-review.md), which is the current 126-symbol / 630-caption proposal.

This proposal records the current runtime caption, the agreed editorial method, and suggested replacements. It is a review document only: the corpus JSON files are not changed by this proposal.

## 1. Origin field used by the UI

Current UI expression:

```swift
record.history.originAnchor
```

Proposed UI expression:

```swift
record.history.origin?.explanation ?? record.history.originAnchor
```

Status: implemented in `CharacterEvolutionView.swift` and covered by the visual content contract. This makes the learner-facing Origin page use the full approved component/interpretation explanation, while retaining the legacy field only as a fallback.

## 2. Origin captions

Historical draft status: earlier labels are superseded; no current caption approval is recorded here. Sky remains unchanged by request.

### Sky — retain current

Current:

> Ancient forms vary in whether they emphasize a great person, the head, or what is above; the shared idea of height or supremacy led to the sky/heaven meaning.

Decision:

> Keep the current caption. The uncertainty and shared idea of height are important here.

### Bean

Current:

> This picture shows a high-footed lidded vessel, not a bean. The vessel’s name sounded like the word for beans, so its picture was borrowed to write that word; this sound-based meaning became dominant, while the vessel meaning survived mainly in historical contexts.

Proposed:

> This picture shows a high-footed lidded vessel, not a bean. Its name sounded like “bean,” so the graph was borrowed for that word; the vessel sense survived mainly in historical contexts.

### Work

Current:

> A bladed working tool, used for working the ground or making boundaries. Some scholars instead see a carpenter’s square for measuring and marking, so the exact tool is uncertain; the character later came to mean “work” or “craft.”

Proposed:

> A working tool, perhaps for cutting ground or marking boundaries; some scholars instead see a carpenter’s square. The exact object is uncertain, but the later meaning is “work/craft.”

## 3. OBSOLETE Oracle Bone captions

This section is superseded. Do not approve or use its Oracle wording. The “compare with the illustration” approach was incorrect. Use [symbol-oracle-bone-corrected-proposals.md](symbol-oracle-bone-corrected-proposals.md) for the new Oracle review.

<!--

Origin is where the learner is told what the illustration shows: the component or components, how they combine to express the meaning, and any sound borrowing or serious uncertainty.

Oracle is not a second explanation of those components. It is a visual comparison with the illustration. Use only what the learner needs to understand the selected Oracle form: what remains recognizable, what is compressed, distorted, rearranged, or difficult to see, and a concise uncertainty note when the identification itself is disputed. Do not repeat why the components mean the word. For example:

> As you can see, the eye is shown clearly inside the person, emphasizing it.

The full audit covered all 126 Oracle captions. The 73 entries below need revision because they repeat the Origin explanation or introduce later semantic history. The remaining 53 entries were checked and remain unchanged; their wording already focuses on visible form, alignment, or a necessary uncertainty.

### Bean

Current:

> The early graph depicts a high-footed food/ritual vessel, not a bean.

Proposed:

> The selected form clearly looks like a vessel rather than the bean illustration.

### Beautiful

Current:

> A front-facing human figure wears an elaborate feathered or horn-like headdress. The decorated person directly represents fine appearance and beauty.

Proposed:

> The decorated figure remains recognizable, though the headdress and body are more stylized than in the illustration.

### Before

Current:

> A foot/movement element is placed ahead of or above a person, visually expressing “first/ahead.”

Proposed:

> The upper and lower marks remain arranged as in the illustration, but the moving figure is more compact.

### Blessing

Current:

> The early graph combines spoken prayer (mouth/opening sign), a kneeling ritual person, and in many forms a spirit tablet ritual-tablet sign; some variants show raised hands.

Proposed:

> The selected form is denser than the illustration, but its separate upper, middle, and lower areas remain visible.

### Bright

Current:

> The selected ancient form combines light-bearing elements—here the sun and moon—to evoke dawn or brightness. Other Oracle variants use a window or eye with the moon.

Proposed:

> The selected form remains a two-part light image, though the shapes are more compact; other early variants differ.

### Evening

Current:

> The moon shape marks the time around dusk; early forms were not yet consistently separated from the graph for moon.

Proposed:

> The moon-like shape remains visible, but early forms are not yet consistently distinguished from the related moon graph.

### Exit

Current:

> A foot/footprint moves out from a cave/opening; the encoded mover is the foot, not a generic person.

Proposed:

> The selected form keeps a movement-outside-opening arrangement, though it is more compact than the illustration.

### Light

Current:

> Fire/light appears above a kneeling human figure; the person is not necessarily holding the flame.

Proposed:

> The flame-like upper shape remains separate from the kneeling figure, closely matching the illustration.

### Mother

Current:

> A woman sign-derived female figure carries two added body marks that distinguish the mother graph.

Proposed:

> The female figure remains recognizable, while the added body marks are smaller and less obvious than in the illustration.

### Older-brother

Current:

> A human figure is paired with a prominent mouth/speech element; the exact semantic motivation for “older brother” is not fully secure.

Proposed:

> The figure and prominent opening remain separate, though the selected form is more abstract than the illustration.

### Official

Current:

> A roof/building encloses an old administrative/group element in the leading analysis, pointing first to an official office/building.

Proposed:

> The enclosing structure remains visible, but the inner shape is more compressed and difficult to identify than in the illustration.

### White

Current:

> The selected simple early form has been interpreted as a thumb/finger in a leading account, but the pictorial identity is disputed.

Proposed:

> The selected simple form is difficult to identify from the illustration; the thumb-or-finger reading remains disputed.

### After

Current:

> The earliest form shows a foot held back by a thread-like element, expressing lagging behind; some analyses treat the thread-like element as phonetic.

Proposed:

> A small connecting mark makes the selected form less immediately recognizable than the illustration.

### Altar

Current:

> The early sign is interpreted as a sacred/spirit tablet or ritual marker in a leading account; the exact origin remains debated.

Proposed:

> The selected form is more abstract than the illustration, and its exact identification remains debated.

### Ancestor

Current:

> A roofed shrine contains a sacred/spirit tablet ritual-tablet sign, directly depicting an ancestral temple.

Proposed:

> The roofed outer shape and inner mark remain visible, though the selected form is more compact than the illustration.

### Auspicious

Current:

> A lower mouth/opening sign is combined with an upper ritual/authority object whose exact identity is debated.

Proposed:

> The upper and lower shapes remain separate, but the selected form is more abstract than the illustration and the upper object remains uncertain.

### Benefit

Current:

> Grain and a knife/cutting tool combine in a harvesting/cutting image.

Proposed:

> The two main shapes remain distinct, although the selected form is more compact and less pictorial than the illustration.

### Big

Current:

> A front-facing adult human figure is shown with arms and legs spread; the figure itself, not a deliberate “big gesture,” is the pictorial source.

Proposed:

> The spread-limbed figure remains recognizable and closely matches the illustration; the proportions vary slightly across forms.

### Black

Current:

> A leading account reads the early form as a human/head with a dark facial mark; this interpretation is disputed and should be illustrated non-graphically.

Proposed:

> The selected form is more abstract than the illustration; the marked-face interpretation remains disputed.

### Body

Current:

> A human body/profile has the abdominal area emphasized; this is safer than treating the figure as certainly pregnant.

Proposed:

> The selected profile remains recognizable, but the emphasized middle is less obvious than in the illustration.

### Book

Current:

> Parallel writing slips are tied by binding cords to form a bound text; it is not a rolled scroll.

Proposed:

> The selected form keeps the parallel-strip arrangement, though the binding is more compact than in the illustration.

### Center

Current:

> A front-facing person carries an element centered around the neck or shoulders. A neck restraint is one leading interpretation, but the ancient scene remains disputed.

Proposed:

> The central mark remains visible on the figure, but the selected form is more abstract than the illustration and the ancient scene remains disputed.

### Classic

Current:

> A bound set of writing slips is placed on a broad support; the lower form is the stand, not a pair of presenting hands.

Proposed:

> The bound strips and lower support remain visible, although their shapes are more compressed than in the illustration.

### Clothing

Current:

> The early graph depicts the garment itself—neck/collar, sleeves, and overlapping front—not a person wearing it.

Proposed:

> The garment outline remains visible, though the selected form is more linear and abstract than the illustration.

### Cloud

Current:

> An upper mark associated with the sky sits above a curling lower element. The lower element mainly carries the sound in the leading analysis, while the complete graph is used for “cloud.”

Proposed:

> The upper and curling lower shapes remain distinct, although the lower shape makes the form less immediately recognizable than the illustration.

### Command

Current:

> An open mouth appears above a kneeling person, representing an order being issued to someone below.

Proposed:

> The upper opening and lower figure remain visibly separate, though the selected form is more compact than the illustration.

### Direction

Current:

> A roofed/house element is combined with a sound/opening element in an early graph connected with echo/resonance.

Proposed:

> The enclosing upper shape and lower opening remain visible, but their relationship is more difficult to read than in the illustration.

### Divide

Current:

> A knife is paired with separating or diverging marks, making division visible in the graph.

Proposed:

> The selected form keeps a strong central cutting shape with marks spreading apart, though it is more compact than the illustration.

### Earth

Current:

> A raised earth/clod form stands on a base line in the leading interpretation; the exact early referent remains debated.

Proposed:

> The raised form and base line remain visible, but the exact early referent is still debated.

### Enter

Current:

> The early pointed form may represent an entrance or an arrow directed inward; the exact origin is uncertain.

Proposed:

> The pointed form does not closely match the illustration; whether it is an entrance or an inward-pointing shape remains uncertain.

### Each

Current:

> A foot moves into/approaches an opening, expressing arrival/coming before the later “each” use.

Proposed:

> The selected form keeps a movement-toward-opening arrangement, but the approaching mark is more compact than in the illustration.

### Few

Current:

> The early few and small forms overlap; their meanings are not yet fully separated.

Proposed:

> The selected form is difficult to distinguish from the related small form; the early shapes overlap visibly.

### Friend

Current:

> Two ancient hand forms are placed together, giving a paired or cooperative-hand image; the repeated hand element may also serve as a sound element.

Proposed:

> The paired shapes remain visible, though the selected form is denser and less immediately recognizable than the illustration.

### Gather

Current:

> A hand reaches into a plant to pick; another early form shows fruit instead of the tree, so the exact original structure varies.

Proposed:

> The selected form is more compact than the illustration; early variants differ in which picked object is shown.

### Gather — transmitted variant

Current:

> The transmitted interpretation shows a bird alighting on a tree; exact Oracle identification and multiplicity should be treated cautiously.

Proposed:

> No secure Oracle identification is shown in this sequence; the transmitted form differs from the illustration and remains uncertain.

### Good

Current:

> The woman and child figures are combined; the components are clear even though the exact cultural motivation for “good” is interpretive.

Proposed:

> The two figures remain visible in the selected form, though their outlines are more compact than in the illustration.

### Group

Current:

> A banner/standard combines with an arrow/weapon element, reflecting organized social/military grouping.

Proposed:

> The upper banner-like shape and lower pointed shape remain distinguishable, but the selected form is more compact than the illustration.

### Guard

Current:

> A roofed dwelling combines with a hand/action element, forming the concrete guarding/keeping relation.

Proposed:

> The enclosing upper shape and lower action mark remain separate, though the Oracle form is more angular than the illustration.

### Jade

Current:

> Shows a central string crossed by three short horizontal jade pieces, with a small top projection.

Proposed:

> The string-and-piece arrangement remains visible, though the pieces are reduced to short strokes.

### Life

Current:

> A sprout rises from a ground line; the early image expresses emerging/growing rather than a separate “seed” object.

Proposed:

> The sprouting shape remains close to the illustration, but the plant and ground are reduced to a few strokes.

### Lodging

Current:

> A person rests on a mat; roof/shelter appears in expanded forms and should not erase the mat from the origin explanation.

Proposed:

> The person-and-mat arrangement remains visible, while the shelter shape is not consistently shown.

### Look-toward

Current:

> A standing person with an emphasized eye looks into the distance. This precedes the later reorganization of the graph and the addition or replacement of sound-bearing and lunar elements.

Proposed:

> The eye remains clearly visible inside the person, closely matching the illustration.

### Martial

Current:

> Weapon combines with the old foot/movement value of foot sign, evoking military advance/action.

Proposed:

> The two main shapes remain visibly separate, but the selected form is more compact than the illustration.

### Middle

Current:

> The selected early form marks a center with a strong central axis/marker. Other ancient variants use a pole with streamers, but both designs make the middle visually explicit.

Proposed:

> The central axis remains clear, although other early variants use a different surrounding shape and can look less like the illustration.

### Moon

Current:

> The graph was already used for both the moon and calendar months, linking the month to the lunar cycle.

Proposed:

> The selected form remains close to the moon illustration, with its curved outline and inner marks still recognizable.

### Mouth

Current:

> A simple open enclosure represents the mouth/opening; it is schematic rather than a detailed pair of lips.

Proposed:

> The open enclosure remains recognizable, though the Oracle form is more angular and schematic than the illustration.

### North

Current:

> Two human figures stand back-to-back, directly expressing the old “back/back-facing” idea.

Proposed:

> The paired back-to-back figures remain visible, though the Oracle outlines are more compressed than in the illustration.

### Obtain

Current:

> A hand takes a cowry shell/valuable object, directly expressing obtaining.

Proposed:

> The taking action remains recognizable, but the selected form is denser than the illustration.

### Old

Current:

> An elderly figure bends beneath long hair; a support/staff appears in many early forms.

Proposed:

> The bent figure and long upper strokes remain visible, though the support is not equally clear in every early form.

### Old — alternate analysis

Current:

> The early form should be described as the selected shield/firmness-related structure; “ten mouths” is a later folk decomposition.

Proposed:

> The selected form is more abstract than the illustration, and the exact upper structure remains disputed.

### People

Current:

> The selected form centers on an eye with a sharp marking element. In the leading account this is connected with an early subordinated population.

Proposed:

> The eye and sharp marking remain visible, but the selected form is more abstract than the illustration; the historical social interpretation remains a separate question.

### Rain

Current:

> A long upper line and several hanging strokes suggest rain beneath a sky or cloud, but without the meaning it is not immediately recognizable as rain.

Proposed:

> The selected form keeps the hanging strokes beneath a long upper line, but it is more abstract than the illustration and not immediately recognizable.

### Red

Current:

> Is a tall person-like figure planted directly over a distinct flame-shaped lower component.

Proposed:

> The person-over-fire arrangement remains visible, although the selected form is more compact than the illustration.

### Rest

Current:

> Places a thin human figure directly beside a clear tree with branches and roots, so both components are still easy to identify.

Proposed:

> The paired forms remain visibly separate and closely match the illustration.

### Sacrifice

Current:

> The earliest core is a hand with a meat offering, often with liquid/blood/juice marks; ritual-tablet sign is not required in every early form.

Proposed:

> The selected form is denser than the illustration; liquid-like marks vary between early examples.

### Same

Current:

> The selected early enclosed/tube-like form does not support a simple modern-component decomposition; its construction remains debated.

Proposed:

> The selected enclosed form does not closely match the illustration, and its original construction remains disputed.

### Self

Current:

> The early form is a nose pictograph; it does not yet depict the abstract idea ‘self.’

Proposed:

> The nose-like outline remains recognizable, although the selected form is more compact than the illustration.

### Sky

Current:

> A front-facing human figure has the head specially marked/enlarged; the original head/top sense precedes the sky/heaven use.

Proposed:

> The marked head remains visible, but the selected form is more abstract than the illustration.

### South

Current:

> The early graph represents a bell/chime-like musical instrument in the leading account, not the direction south.

Proposed:

> The selected form is more abstract than the illustration; the leading identification remains a bell- or chime-like object.

### Speech

Current:

> A mouth and added marker indicate an utterance; the tongue-shaped form belongs to later developments.

Proposed:

> The mouth and small marker remain visible, but the upper form is more abstract than the illustration.

### Stop

Current:

> The graph is a foot/sole pictograph; “stop” is the later word written with this graph.

Proposed:

> The selected form remains a recognizable foot outline, closely matching the illustration.

### Strength

Current:

> The graph depicts an ancient agricultural digging tool with a foot tread; using it required force.

Proposed:

> The tool-like form remains visible, but its lower base makes it less immediately recognizable than the illustration.

### Sweet

Current:

> A mouth contains a single internal mark/object, indicating something held in the mouth; there is no encoded candy, honey, or separate tongue.

Proposed:

> The internal mark remains clearly enclosed by the mouth, matching the two-part illustration; the form is more schematic than the picture.

### Take

Current:

> The encoded components are an ear and a hand taking/grasping it; historical trophy-taking gives context without adding a whole body to the graph.

Proposed:

> The ear-and-hand arrangement remains visible, although the Oracle form is more compact than the illustration.

### Things/Goods

Current:

> Three repeated enclosed object/vessel-like forms appear; they should not automatically be read as three mouths.

Proposed:

> Repeated enclosed shapes remain visible, although the selected form is denser and less pictorial than the illustration.

### Tongue

Current:

> The earliest form shows a mouth with a forked tongue; later variants add a base stroke and sometimes extra dots or a stone-like element.

Proposed:

> The mouth and forked tongue remain visible, though the selected form is more compact and less detailed than the illustration.

### Turn-back

Current:

> A hand is associated with a cliff/rock-face element; climbing/clambering is a leading early interpretation.

Proposed:

> The hand-like and rock-face shapes remain distinguishable, though the selected form is more abstract than the illustration.

### Upright

Current:

> A foot points toward a marked destination, expressing long-distance travel rather than ‘correct.’

Proposed:

> The directional foot shape remains visible, but the selected form is more compact than the illustration.

### Walk

Current:

> A running human figure expresses the old core meaning “run,” not a casual walking pose.

Proposed:

> The running figure remains visible, although the selected Oracle form is more compact than the illustration.

### Water

Current:

> A winding central current with detached side marks depicts flowing and splashing water.

Proposed:

> The central current and detached side marks remain visible, closely matching the illustration.

### West

Current:

> One early form resembles a nest or container; another may be a different borrowed form. The sunset explanation is traditional but disputed.

Proposed:

> The selected form is more abstract than the nest-like illustration, and the original object remains disputed.

### Winter

Current:

> The early cord-like form represents an ending in the leading analysis; the lower marks are not yet secure ice signs.

Proposed:

> The selected form is a compact cord-like shape rather than a clear match for the illustration; the lower marks remain uncertain.

### Year

Current:

> The person-and-grain scene shows harvest, not yet an abstract calendar year.

Proposed:

> The person-and-grain arrangement remains visible, though the selected scene is more compact than the illustration.

### Oracle entries retained after re-audit

These entries already follow the revised visual-comparison rule and need no wording change: Above, Bamboo, Below, Bow, Child, Day, Dog, Ear, Eye, Field, Follow, Forest, Fragrance (no secure form), Go, Head, Heart, High, Horn, Increase, Join, Journey, King, Knife, Long, Man, Many, Meet, Mountain, One, Ox, Person, Public, Reach, River, Sheep, Small, Soldier, Spring, Stand, Step, Stone, Stretch, Summer, Tell, Ten, Three, Tiger, Tree, Two, Well, Wife, Woman, Work.
-->

## 4. Bronze, Seal, and Clerical captions

These revisions remove semantic repetition and keep the caption focused on what changed from the preceding stage.

Historical draft status: not approved; superseded by the full symbol caption manual review.

### Cloud — Seal

Current:

> A rain-and-weather element is added above the older graph, making the cloud meaning explicit after the older form had also been borrowed for “say.”

Proposed:

> A rain-and-weather element is added above the older graph, making the cloud form more explicit.

### Fragrance — Seal

Current:

> The secure early written form combines grain/millet with a pleasant-taste element, linking cooked or ripe grain with a pleasing smell.

Proposed:

> The first secure written form appears as a stacked grain-and-taste structure; the earlier grain-scent association remains visible.

### Obtain — Seal

Current:

> The older taking/obtaining scene is regularized together with a formal walking or path element.

Proposed:

> The hand-taking and path elements settle into a more formal, compact structure.

### Look-toward — Bronze

Current:

> Later forms reorganize the looking graph; sound-bearing element functions phonetically in the developing lineage, while moon sign belongs to moon/lunar-phase-related variants rather than a simple “moon-gazing” origin.

Proposed:

> Bronze forms reorganize the earlier figure-and-eye design and begin the more compact component structure that later becomes standard.

### One — Bronze and Seal

Current Bronze:

> The form remains intact.

Current Seal:

> The form remains intact.

Proposed Bronze:

> The single horizontal mark remains unchanged.

Proposed Seal:

> The same one-line form continues without a new structural change.

## 5. Regular Script conclusions

Chinese characters are permitted in Regular Script conclusions. They are not a problem by themselves; the historical-stage descriptions remain English-only. These four Regular captions are the long entries that should be tightened while preserving their conclusion about how the form settled.

Historical draft status: not approved; superseded by the full symbol caption manual review.

### Cloud — Regular

Current:

> Traditional 雲 preserves the added weather element over the older 云 graph for “cloud.” Literary 云 continues the borrowed “say” use; modern Simplified Chinese later also writes “cloud” as 云.

Proposed:

> Regular Script settles the added weather element above the older graph for “cloud”; the simplified form later keeps only the compact lower structure.

### Child — Regular

Current:

> The infant graph becomes the standard child sign. It was also used for a branch name and for titles; later branch notation used a separate sign for the sixth position to prevent confusion.

Proposed:

> Regular Script reduces the infant figure to the modern child form; later branch and title uses were separated when the same graph could cause confusion.

### Stand — Regular

Current:

> Breaks the old standing figure into a top dot, central horizontals, and a long base, preserving the idea of an upright form planted on the ground.

Proposed:

> Regular Script breaks the standing figure into dots, horizontals, and a long base, preserving an upright form grounded below.

### West — Regular

Current:

> The object graph was later used for ‘west,’ either through a sound borrowing or through an association with birds returning at sunset; the exact path remains disputed.

Proposed:

> Regular Script settles the disputed object graph as “west”; whether this came through sound or sunset association remains uncertain.

## 6. Checked and retained

The following flagged-looking entries were checked and do not need rewriting under the agreed model because they describe the actual structural change at their stage:

- Forest — Clerical
- Follow — Clerical
- Martial — Bronze

The 78 captions marked as requiring review by the existing uncertainty heuristic are not automatically defects. Most correctly preserve a leading interpretation or a serious alternative. They should remain unless a language/content review identifies a factual problem.

## 7. Separate source-of-truth issues

These are implementation/data consistency issues, not caption wording approvals.

### Historical caption source

Current: `content/research/v1-symbols/transition-notes-v1.json` contains stale generic transition copy that differs from the 630 runtime stage captions in `Resources/Corpus/*.json`.

Proposed: use the detailed runtime corpus as the comparison baseline, then regenerate or reconcile `transition-notes-v1.json` from the final approved 630-row proposal in a separately approved data-sync change.

### Corpus generator

Current: `Tools/Import-V1RuntimeCorpus.ps1` still emits `Paper · brush` for Regular Script and has a generic Kai-rendering fallback explanation.

Proposed: emit no historical method caption for Regular Script and use a concluding Regular explanation as the fallback. This should be implemented together with the next approved corpus regeneration, not as an unreviewed mass rewrite.
