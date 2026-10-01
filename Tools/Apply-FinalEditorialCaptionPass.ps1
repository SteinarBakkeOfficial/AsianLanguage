param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"

function Read-Json([string]$Path) {
    Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
}

function Write-Json([object]$Value, [string]$Path) {
    $Value | ConvertTo-Json -Depth 80 | Set-Content -LiteralPath $Path -Encoding utf8
}

function Remove-ModernCharacterFromCaption([string]$Text, [string]$Character) {
    $escaped = [regex]::Escape($Character)
    $Text = $Text -replace "modern $escaped form", "the standard form"
    $Text = $Text -replace "$escaped form", "the standard form"
    $Text = $Text -replace "the $escaped structure", "the standard structure"
    $Text = $Text -replace "regular graph $escaped", "the regular graph"
    $Text = $Text -replace "as $escaped", "as the standard form"
    $Text = $Text -replace "into $escaped", "into the standard form"
    $Text = $Text -replace "in $escaped", "in the standard form"
    $Text = $Text -replace "over $escaped", "over the standard form"
    $Text = $Text -replace "becomes $escaped", "becomes the standard form"
    $Text = $Text.Replace($Character, "the standard form")
    $Text = $Text -replace "the standardized form the standard form", "the standardized form"
    $Text = $Text -replace "the standardized form the form", "the standardized form"
    $Text = $Text -replace "the compact the standard form form", "the compact standard form"
    $Text = $Text -replace "the standard form form", "the standard form"
    $Text = $Text -replace "the standard form structure", "the standard structure"
    $Text = $Text -replace "the regular the standard form", "the regular form"
    # Normalize captions already produced by an earlier pass of this script so
    # rerunning the importer cannot accumulate awkward phrases.
    $Text = $Text -replace "the compact the form form", "the compact standard form"
    $Text = $Text -replace "compact the form", "compact standard form"
    $Text = $Text -replace "the form form", "the standard form"
    $Text = $Text -replace "the form structure", "the standard structure"
    $Text = $Text -replace "the form frame", "the standard frame"
    $Text = $Text -replace "as the form", "as the standard form"
    $Text = $Text -replace "into the form", "into the standard form"
    $Text = $Text -replace "in the form", "in the standard form"
    $Text = $Text -replace "over the form", "over the standard form"
    $Text = $Text -replace "becomes the form", "becomes the standard form"
    $Text = $Text -replace "regular graph the form", "regular graph"
    $Text = $Text -replace "^the form", "The standard form"
    return $Text
}

# These captions were checked against the local Origin/Oracle image pairs. They describe
# the visible carved form and its recognition difficulty; they do not repeat the Origin
# explanation or invent an unseen historical narrative.
$oracleCaptions = @{
    "one" = "A single rough horizontal stroke remains almost direct, though its carved irregularity is less clean than the simple illustration."
    "day" = "A rough enclosure with a central mark preserves the sun's rounded body and visible center, but the carved form is already angular."
    "moon" = "A crescent-like outline remains visible, though its angular inner opening is more like a carved frame than a natural moon."
    "evening" = "The crescent remains visible beside a narrow companion form, but the night scene is reduced to an abstract carved arrangement."
    "mountain" = "Three uneven rising peaks remain grouped together, but the rough carved strokes no longer look like a natural mountain."
    "water" = "Several separated descending strokes suggest flowing water, though the carved marks are too angular to resemble a stream directly."
    "river" = "Long parallel strokes preserve a central flow, but the separated lines make the river scene difficult to recognize."
    "tree" = "A central trunk with branching strokes remains visible, but the sparse carved outline does not show a leafy tree."
    "bamboo" = "Two tall, mirrored clusters suggest paired bamboo stalks, but the few angular marks do not clearly show leaves or joints."
    "earth" = "A pointed raised mound over a base suggests earth or a marker, but the carved shape is not a natural mound."
    "stone" = "An upright stone-like mass remains beside a rough vertical form, preserving the object only as an abstract pointed shape."
    "rain" = "A broad upper cover with repeated descending strokes preserves cloud and falling rain, but the drops are reduced to rigid marks."
    "cloud" = "Separate rounded clusters suggest clouds, though the carved strokes are sparse and flattened rather than soft or airy."
    "field" = "A boxed cross divides the space into plots, making the field layout unusually clear despite rough, angular carving."
    "well" = "A large crossed frame preserves the well's opening and rails, but the thick irregular strokes make the object hard to read at first."
    "spring" = "A rock-like upper form and long downward strokes suggest a source and flowing water, though the spring scene is not obvious."
    "life" = "A central sprout-like form rises from a base, but the few dark strokes do not clearly resemble a growing plant."
    "person" = "Two long leaning strokes preserve a standing human posture, although the simplified figure is reduced to an abstract profile."
    "big" = "A spread-eagle human figure remains recognizable through its arms and legs, despite the rough and elongated carved strokes."
    "woman" = "A seated or kneeling figure is suggested by the bent outline, but the carved form no longer looks clearly human."
    "child" = "A small hanging body with outstretched limbs suggests a child, though the compact strokes are difficult to read as a person."
    "mother" = "A large figure with an emphasized chest area suggests a mother, but the carved outline is highly abstract."
    "eye" = "An almond-shaped enclosure with inner marks still suggests an eye, though its heavy outline resembles a leaf or mask."
    "ear" = "A long outer contour and inner marks preserve the ear's hanging shape, but the carved form is not immediately recognizable."
    "mouth" = "A broad enclosed opening remains visible, making this one of the clearer pictographic forms despite its rough edges."
    "tongue" = "The long central shape and lower opening suggest a tongue in a mouth, but the carved parts are not easy to connect."
    "self" = "A tall central shape with enclosing strokes echoes a nose or face, but the intended self-reference is not visually obvious."
    "head" = "A profile-like face sits within a larger head outline, preserving the body part only as an angular carved figure."
    "body" = "A long human profile with a rounded middle suggests the body, but the sparse outline does not resemble the illustration directly."
    "heart" = "A central pointed form with side lobes echoes an anatomical heart, though the angular carving is difficult to identify."
    "old" = "A bent elder-like figure remains in a few tall strokes, but the human posture is no longer immediately obvious."
    "long" = "A tall, narrow figure with a trailing lower stroke preserves length or a long person-like form, but the meaning is indirect."
    "sky" = "A broad human-like figure with long limbs remains, but its connection to the sky depends on the Origin explanation."
    "ox" = "A horned animal-like outline remains visible, but the heavy carved strokes no longer show a complete ox clearly."
    "sheep" = "A central body with two curved upper strokes suggests horns and a sheep, though the animal is reduced to a few marks."
    "dog" = "A small animal profile with a tail-like stroke remains, but the carved form is too angular to read as a dog immediately."
    "tiger" = "A tall striped or segmented animal figure is preserved, but the carving is difficult to recognize as a tiger."
    "horn" = "A long curved horn-like outline remains strong, though the isolated shape no longer shows the whole animal."
    "knife" = "A long blade with a small side projection remains visible, but the carved silhouette is too narrow to read as a knife at once."
    "bow" = "The curved outer shape and inner string preserve a bow's profile, although the thick carved outline is simplified."
    "clothing" = "A hanging garment-like outline with a central opening suggests clothing, but the carved strokes do not show sleeves clearly."
    "bean" = "A small lidded vessel shape remains visible, but the thick angular strokes make the bean-like container difficult to recognize."
    "work" = "A tool-like vertical form with a crosspiece suggests an implement, though the carved shape does not resemble a modern tool directly."
    "book" = "Several vertical slips joined by horizontal bindings preserve a bound bundle, but the marks are too heavy to read as a book immediately."
    "jade" = "A vertical string of small jade pieces remains visible, though the carved marks are simplified into an abstract hanging form."
    "king" = "A stacked blade-like or ritual form remains, but the relation to the three levels of a king's symbol is not visually obvious."
    "altar" = "A raised ritual object on a stand is preserved in angular strokes, but its altar function is difficult to recognize."
    "strength" = "A hand tool or digging implement is reduced to a tall vertical outline, making the idea of strength indirect."
    "two" = "Two separated rough horizontal forms clearly preserve the quantity two, though their irregular edges are strongly carved."
    "three" = "Three stacked marks preserve the quantity three directly, even though the carved strokes are thick and uneven."
    "ten" = "A single tall line remains, while the earlier tool-and-cross scene is no longer visible in this selected carved form."
    "above" = "A small mark is placed above a horizontal reference, so the relation is visible even though the scene is highly abstract."
    "below" = "A small mark sits below a horizontal reference, preserving the spatial relation but not a literal scene."
    "middle" = "A central vertical line passes through a surrounding form, making the idea of a marked center relatively clear."
    "small" = "A few narrow marks are grouped together, suggesting smallness only through their reduced size and separation."
    "few" = "Several small separated marks preserve the idea of few, but the quantity is not immediately obvious from the carving."
    "many" = "Repeated irregular blocks suggest more than one object, but the carved forms do not clearly show a group."
    "high" = "A tall roofed structure rises above a lower base, preserving height but resembling a building more than an abstract idea."
    "enter" = "Two tall pointed forms frame an opening, suggesting movement into a space, but the entrance scene is only indirectly visible."
    "exit" = "A foot-like form emerges from an opening, preserving the action of leaving even though the carved strokes are abstract."
    "stand" = "A human figure stands above a ground line, making the upright posture fairly clear despite the elongated carving."
    "center" = "A vertical line runs through a framed center, but the surrounding human-like shape makes the intended middle difficult to see."
    "south" = "A bell-like hanging form with an enclosed middle is preserved, but its connection to the direction south is not visible from the image."
    "north" = "Two opposing human-like forms remain side by side, though the directional meaning is not visible without the Origin explanation."
    "west" = "A woven nest-like enclosure is reduced to a few angular marks, making the source scene difficult to recognize."
    "forest" = "Two tree-like vertical clusters are repeated side by side, but the sparse carving does not look like a forest."
    "rest" = "A person-like form appears beside a tree-like cluster, preserving the scene only as two rough neighboring shapes."
    "follow" = "Two figures or vertical forms are arranged in sequence, but the relationship of following is not immediately clear."
    "good" = "A large figure and smaller figure are combined in a compact form, but the intended relationship is not visually obvious."
    "man" = "A framed field-like upper part and lower force-like strokes are visible, but the human meaning is not pictorial."
    "bright" = "Sun-like and moon-like rounded forms are placed together, preserving the bright composition but not a literal scene."
    "beautiful" = "A decorated human-like figure remains within an enclosing outline, but the carved form does not explain beauty by itself."
    "older-brother" = "A mouth-like upper form sits over a human-like lower form, but the relationship to an older brother is not visible."
    "things-goods" = "Three repeated vessel-like forms are compressed into a clustered pattern, suggesting multiple objects without showing separate goods clearly."
    "tell" = "Mouth and tongue-like forms are combined, but the speaking action is difficult to recognize in the heavy carving."
    "join" = "A covering or meeting shape sits over a lower enclosed form, preserving contact but not an obvious joining scene."
    "take" = "An ear-like form joins a hand-like shape, preserving the act of taking only as a compact relationship."
    "gather" = "A hand reaches toward a tree-like form, but the gathering action is reduced to a few intersecting strokes."
    "stop" = "A footprint-like form remains visible, though the toes and heel are reduced to angular strokes."
    "step" = "Two footprint-like forms appear in sequence, preserving movement but not a clearly readable pair of feet."
    "walk" = "An upright figure moves above foot-like strokes, but the walking action is difficult to recognize in the carving."
    "go" = "A cross-like path or movement form is preserved, but the direction of travel is not immediately obvious."
    "upright" = "A tall upright figure or staff-like form remains, though the relation to standing straight is indirect."
    "before" = "A figure stands above a pair of foot-like marks, but the spatial relation to before is not visible by itself."
    "reach" = "A standing figure and an outstretched hand suggest reaching, though the action is compressed into narrow strokes."
    "meet" = "Two facing human-like outlines preserve an encounter, but their meeting is only indirectly visible in the angular form."
    "turn-back" = "A hand-like stroke reaches toward a cliff or boundary, preserving return or reversal only as an abstract gesture."
    "friend" = "Two hand-like forms cross or support one another, but the friendship relationship is not obvious from the carving."
    "direction" = "A roofed or framed opening contains a lower form, but no compass direction is visible in the selected glyph."
    "divide" = "A split central line separates two lower strokes, making division visible as a structural separation rather than a scene."
    "benefit" = "A cutting tool stands beside a grain-like form, but the useful or beneficial result is not shown directly."
    "martial" = "A weapon-like central form stands over a base, preserving armed action but not the later meaning of martial."
    "obtain" = "A hand reaches toward a small object, making the act of obtaining more visible than the modern abstract form."
    "after" = "A foot-like form follows a larger enclosing shape, but the sequence implied by after is difficult to read."
    "gather-u96c6" = "Bird-like forms appear around a tree or perch, preserving a gathering scene but not a clearly readable flock."
    "speech" = "A mouth-like enclosure combines with an upper marker, but speaking is only indirectly visible in the carved structure."
    "public" = "A large vessel-like outline is preserved, but the public or shared meaning is not visible from the object alone."
    "people" = "An eye-like enclosure and a long lower stroke form a human-related sign, but the people scene is not obvious."
    "classic" = "A bound stack or framed text object is reduced to heavy angular marks, making the book-like source difficult to read."
    "soldier" = "Hands and a weapon-like object combine in a compact form, but the soldier is not immediately recognizable."
    "command" = "A kneeling figure appears beneath a mouth-like mark, preserving an addressed command only indirectly."
    "each" = "A foot-like upper element sits over a box-like form, but the meaning each is not visually recoverable."
    "same" = "A covered vessel or enclosed form is preserved, but sameness or shared identity is not visible in the carving."
    "wife" = "A kneeling female figure with a hand-like upper mark is suggested, but the relationship to wife is indirect."
    "old-u53e4" = "A shield-like or ancient object shape remains, but the connection to old is not immediately visible."
    "auspicious" = "A ritual vessel-like form stands above a lower base, but the auspicious meaning depends on the Origin explanation."
    "journey" = "A group with a banner or travel marker preserves movement and expedition, but the journey scene is highly abstract."
    "group" = "A banner and upright forms suggest a gathered group, though the people and flag are reduced to sparse strokes."
    "guard" = "A roofed structure sits above a hand-like mark, but the guarding action is not obvious in the carved form."
    "official" = "A roofed or enclosed human scene remains, but the role of an official cannot be read from the glyph alone."
    "stretch" = "A long lightning-like stroke preserves extension or length, but stretching is not visible as a human action."
    "light" = "A flame-like form rises above a human-like lower shape, preserving light as an abstract person-and-fire arrangement."
    "white" = "A rounded pointed enclosure with an inner mark remains, but its connection to white is not pictorially obvious."
    "black" = "A dense upper form and lower figure-like marks are preserved, but the dark or black meaning is not visible."
    "red" = "A human-like form stands above flame-like marks, preserving the person-and-fire arrangement without making red immediately obvious."
    "year" = "A grain-bearing figure is suggested by upper and lower strokes, but the separate grain and person are difficult to distinguish."
    "summer" = "A human-like figure combines with a sun-like mark, but the seasonal meaning summer is not visible without the Origin."
    "winter" = "A hanging cord-like form is reduced to paired marks, leaving the winter scene difficult to recognize."
    "look-toward" = "An eye-like form and a distant figure or object are combined, but the act of looking afar is only indirect."
    "sweet" = "A mouth-like enclosure with a central horizontal mark remains, but the taste of sweetness is not pictorially visible."
    "fragrance" = "Grain-like marks combine with a mouth or taste-like form, but fragrance is not recognizable from the carved shape alone."
    "increase" = "A hand or pouring form appears above a vessel-like base, but the idea of increase is not visible without the illustration."
    "sacrifice" = "Hands or offering marks combine with a ritual sign, preserving an offering scene but not making sacrifice immediately clear."
    "ancestor" = "A roofed shrine and tall ritual marker are reduced to a narrow enclosure, so ancestor is not visually obvious."
    "lodging" = "A person rests beside a woven mat under a roof-like outline, but lodging is compressed into angular strokes."
    "blessing" = "A worshipper, speech-like mark, and ritual object are combined, but blessing is not recognizable from the carved form alone."
}

# A small set of endpoint captions needed a stronger conclusion than the earlier
# generated wording. The remaining reviewed endpoint captions are preserved.
$regularOverrides = @{
    "one" = "The single horizontal line remains almost unchanged; only the carved irregularity and later writing discipline give way to the clean standard stroke."
    "person" = "The leaning human profile settles into two balanced strokes, preserving the basic standing posture in the modern form."
    "big" = "The spread human figure settles into three balanced strokes; the open arms and legs remain the key visible structure."
    "small" = "The clustered small marks settle into three compact strokes, carrying the idea through reduced size and a standardized arrangement."
    "well" = "The frame remains recognizable. An interior dot appears in Small Seal and is later removed; the crossing lines settle into today's balanced shape."
    "book" = "The bound-slip structure settles into a compact standardized form; the separate slips and bindings merge into regular strokes."
    "few" = "An added stroke distinguishes the few/little form from the related small-mark graph; the final arrangement is compact and standardized."
    "join" = "The fitted cover and lower mouth-like element settle into a compact joined structure; the earlier meeting scene is no longer pictorial."
    "mother" = "The woman-derived body is squared, and two distinguishing marks remain inside the final form."
    "step" = "The paired-foot origin is no longer pictorial; its stacked movement structure settles into the standardized endpoint."
    "speech" = "The mouth-and-marker structure settles into a dense standard form; its components remain visible, but the act of speaking is no longer pictorial."
    "tiger" = "The enclosing head, inner markings, and lower legs settle into a standardized form; the tiger survives as lineage rather than an obvious animal silhouette."
    "fragrance" = "The grain-like upper part and taste-related lower part settle into the standard form; their relationship remains, while the scent is no longer drawn."
    "increase" = "The upper marks settle over a compact lower vessel; the earlier waves and basin merge into a standardized form whose idea is no longer pictorial."
    "blessing" = "The ritual-sign side and compact speech/person-derived side settle into a balanced standard form; the earlier offering scene is no longer explicit."
}

$releaseRoot = Join-Path $RepositoryRoot "content/release/symbols"
$regularCaptions = @{}
$records = Get-ChildItem -LiteralPath $releaseRoot -Directory | ForEach-Object {
    $path = Join-Path $_.FullName "symbol.json"
    if (Test-Path -LiteralPath $path) { Read-Json $path }
}

if ($records.Count -ne 126) {
    throw "Expected 126 release records, found $($records.Count)."
}

foreach ($record in $records) {
    if (-not $oracleCaptions.ContainsKey([string]$record.id)) {
        throw "No final Oracle caption is defined for $($record.id)."
    }
    $oracle = @($record.history.stages | Where-Object stage -eq "oracleBone")[0]
    $regular = @($record.history.stages | Where-Object stage -eq "regular")[0]
    if ($null -eq $oracle -or $null -eq $regular) {
        throw "Missing Oracle Bone or Regular Script stage for $($record.id)."
    }

    $oracle.transitionNote = $oracleCaptions[[string]$record.id]
    $oracle.changeNoteFromPrevious = $oracle.transitionNote
    $oracle.transitionNoteNeedsReview = $false

    if ($regularOverrides.ContainsKey([string]$record.id)) {
        $regular.transitionNote = $regularOverrides[[string]$record.id]
        $regular.changeNoteFromPrevious = $regular.transitionNote
    }
    # Museum captions describe visible structure rather than using the modern
    # character as a prose label. Keep the endpoint summary meaningful while
    # enforcing that learner-facing contract consistently across all records.
    $regular.transitionNote = Remove-ModernCharacterFromCaption $regular.transitionNote ([string]$record.coreCharacter)
    if ($record.traditionalForm -and $record.traditionalForm -ne $record.coreCharacter) {
        $regular.transitionNote = Remove-ModernCharacterFromCaption $regular.transitionNote ([string]$record.traditionalForm)
    }
    $regular.changeNoteFromPrevious = $regular.transitionNote
    $regular.transitionNoteNeedsReview = $false
    $regularCaptions[[string]$record.id] = [string]$regular.transitionNote

    Write-Json $record (Join-Path $releaseRoot "$($record.id)\symbol.json")
}

$transitionPath = Join-Path $RepositoryRoot "content/research/v1-symbols/transition-notes-v1.json"
$transition = Read-Json $transitionPath
foreach ($entry in @($transition.records)) {
    if ($entry.stage -eq "oracleBone" -and $oracleCaptions.ContainsKey([string]$entry.recordID)) {
        $entry.transitionNote = $oracleCaptions[[string]$entry.recordID]
        $entry.transitionNoteNeedsReview = $false
        $entry.qaFlags = @()
    }
    if ($entry.stage -eq "regular" -and $regularCaptions.ContainsKey([string]$entry.recordID)) {
        $entry.transitionNote = $regularCaptions[[string]$entry.recordID]
        $entry.transitionNoteNeedsReview = $false
        $entry.qaFlags = @()
    }
    if ($entry.stage -eq "regular") {
        $entry.transitionNote = Remove-ModernCharacterFromCaption $entry.transitionNote ([string]$entry.character)
        $entry.qaFlags = @()
    }
}
Write-Json $transition $transitionPath

Write-Output "OK: applied final captions to $($records.Count) release records and the transition-note source."
