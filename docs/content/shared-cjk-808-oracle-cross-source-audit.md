# Shared CJK 808 Oracle-Bone Cross-Source Audit

Status: discussion research artifact. This is an evidence gate, not a V1 approval list.

Date: 2026-09-03

## The museum gate

The Symbol Journey requires a reviewable visual chain:

`real object or meaningful scene → actual earliest documented glyph → later script stages → modern forms`

A dataset row, filename, etymology note, or generated illustration is not an actual historical image. A stage is counted as locally evidenced only when a reviewable source image and provenance are present.

## Why published counts differ

There is no single universal count called “the number of Oracle Bone symbols.” Sources count different things:

| Source or unit | Count | What it means |
|---|---:|---|
| Broad historical estimate | about 4,500 distinct characters | Characters reported as found in surviving oracle-bone material; identity and decipherment are not uniform. |
| EVOBC paper | about 1,600 deciphered out of more than 4,500 extant characters | Scholarly estimate of deciphered oracle-bone characters, not a complete image-asset count. |
| HUST-OBC | 1,588 deciphered categories / 77,064 images | A dedicated deciphered OBC dataset; its 9,411 undeciphered categories / 62,989 images may contain duplicate categories. |
| Xiaoxuetang Oracle database | 2,548 character heads / 24,701 glyph forms | A large specialist database maintained by Academia Sinica; a character head may have many individual forms. |
| EVOBC overall | 13,714 categories / 229,170 images | Six historical stages combined, not 13,714 Oracle Bone characters. |

Sources: [EVOBC paper](https://arxiv.org/abs/2401.12467), [HUST-OBC paper](https://doi.org/10.1038/s41597-024-03807-x), [Xiaoxuetang Oracle database](https://xiaoxue.iis.sinica.edu.tw/jiaguwen), [Academia Sinica database overview](https://ascdc.sinica.edu.tw/en/resources.jsp), and [Tencent’s summary of surviving oracle-bone discoveries](https://www.tencent.com/en-us/articles/2201854.html).

## Intersection with the shared 808

The shared 808 is already the four-language eligibility universe: the identities were selected from the China–Japan–Korea common-character publication and normalized across local forms. The relevant question is therefore how many of those 808 have evidence, not how many modern characters exist in total.

### EVOBC indexed evidence

After matching the 808 identities against EVOBC with Simplified/Traditional variant normalization:

| EVOBC result | Count |
|---|---:|
| Shared identities matched to an EVOBC row | 801–800, depending on the final variant-normalization edge cases |
| Oracle Bone stage indexed | **404** |
| Bronze stage indexed | 590 |
| Seal stage indexed | 799–800 |
| Spring/Autumn stage indexed | 433 |
| Warring States stage indexed | 740 |
| Clerical stage indexed | 755–756 |
| Oracle + Bronze + Seal + Clerical indexed | **369** |
| All six EVOBC stages indexed | **306** |

The small one-character variation in the total and Seal/Clerical counts comes from unresolved regional-variant normalization edge cases. It does not change the key conclusion: 404 is an indexed candidate pool, not a count of downloaded proof images.

EVOBC contains 1,762 Oracle Bone categories and 75,681 Oracle Bone image references across its complete 13,714-category dataset. The 404 figure is the intersection with our shared 808, not the size of EVOBC’s complete OBC collection.

### Locally reviewable Dong Chinese evidence

The downloaded Hanzi/Kanji Etymology Dictionary repository contains Dong Chinese historical SVGs for 578 characters overall. Matching its actual `*_oracle.svg` files against the normalized shared 808 produces:

- **146 / 808** with an actual local Oracle Bone SVG;
- 662 / 808 without an actual local Dong Oracle SVG;
- 253 historical SVGs copied into the current research package for the 137 expansion symbols, but only 84 of those are local Oracle files.

This is the conservative “we can open and inspect an actual local file today” count. It is not proof that the remaining 662 never existed; it only proves that this particular open SVG source does not currently provide them locally.

Source: [Hanzi/Kanji Etymology Dictionary repository](https://github.com/lbm364dl/hanzi-etymology-dict), whose documentation states that its historical SVG collection contains 578 Dong Chinese characters and 3,638 Wikimedia seal entries.

### Xiaoxuetang / Academia Sinica evidence

Xiaoxuetang is a second specialist source, independent of EVOBC and Dong Chinese. Its Oracle Bone database currently reports 2,548 character heads and 24,701 glyph forms. It is therefore a major source for filling the 662-image gap, but its web interface does not provide a ready-made bulk intersection with our 808 list. Each candidate still needs an identity-level query and rights/download decision.

## Decision under the agreed rule

We must not reduce the candidate universe merely because the first downloaded source has only 146 local Oracle SVGs. That would confuse incomplete acquisition with historical absence.

The correct order is:

1. Start with the 404 shared identities having an EVOBC Oracle index reference.
2. Acquire and verify actual Oracle images for those identities from EVOBC, Xiaoxuetang, Dong Chinese, or another source with suitable rights.
3. Cross-check identity, interpretation, and provenance across multiple sources.
4. Count the genuinely full visual journeys.
5. Only if that verified pool exceeds 200, optimize it for pictographic simplicity, reusable meaningful components, visual storytelling, and collection balance.
6. Use non-full historical journeys only after the full-history pool has been exhausted.

Until step 2 is complete, the project has a **404 indexed pool**, but only a **146-image local proof floor**. Neither number should be presented as the final V1 count.
