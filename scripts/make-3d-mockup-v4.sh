#!/bin/bash
# 3D Book mockup v4 — clean approach
# Front face: ImageMagick perspective distort (foreshortened at ~30 degrees)
# Spine + page edges: direct polygon fills (no distort confusion)
# Lighting: gradient overlays per face

set -e
FLAT="/home/node/openclaw/books/ai-thinking-educators/images/cover-flat.png"
OUTPUT="/home/node/openclaw/books/ai-thinking-educators/images/cover.png"
TMP="/tmp/book3d_v4"; mkdir -p "$TMP"

FW=$(identify -format "%w" "$FLAT")
FH=$(identify -format "%h" "$FLAT")
echo "Source: ${FW}x${FH}"

CW=1300; CH=1700

# ── Book geometry: book stands straight, camera front-right, slightly above ──
# Front face: foreshortened ~30° — width compressed to ~87% of full
# Both vertical edges are VERTICAL (correct for 2-point perspective)
# Top edge recedes slightly (right VP far away) — almost horizontal

# Front face corners (trapezoid: very slightly wider at bottom due to camera above)
FTL=350,95    # top-left
FTR=1030,75   # top-right  (left edge is vertical; small taper top→bottom on right)
FBL=350,1560  # bottom-left  (VERTICAL left edge: same x as TL)
FBR=1060,1560 # bottom-right

# Spine corners (to the LEFT of front face, angled away at ~30°)
# Spine width: ~150px at bottom, ~125px at top (slight perspective compression)
STL=195,110   # top-left of spine
STR=350,95    # top-right  = FTL
SBL=195,1570  # bottom-left (VERTICAL left edge of spine)
SBR=350,1560  # bottom-right = FBL

# Page edge corners (thin strip to the RIGHT of front face)
PTL=1030,75   # = FTR
PTR=1065,82   # 
PBL=1060,1560 # = FBR
PBR=1095,1565 # 

# Top edge of book (page block visible from slightly above)
# Connects spine-top to front-top
TETL=195,110  # = STL
TETR=1065,82  # = PTR
TEBL=350,95   # = FTL  (front top-left)
TEBR=1030,75  # = FTR (front top-right)

echo "Geometry defined"

# ── Step 1: Distort flat cover onto FRONT face ────────────────────────
# Source: (0,0) TL, (FW,0) TR, (0,FH) BL, (FW,FH) BR
# Destination: FTL FTR FBL FBR
convert "$FLAT" -alpha set \
  +distort Perspective \
    "0,0       350,95   \
     $FW,0     1030,75  \
     0,$FH     350,1560 \
     $FW,$FH   1060,1560" \
  -background white \
  -crop ${CW}x${CH}+0+0 +repage \
  "$TMP/front_raw.png"
echo "Front distorted"

# Add left-edge shadow on front face (spine seam lighting)
convert "$TMP/front_raw.png" \
  \( -size ${CW}x${CH} xc:none \
     -fill "rgba(0,0,0,0)" -draw "rectangle 0,0 ${CW},${CH}" \
     -sparse-color Barycentric "0,0 rgba(0,0,0,0.35)  400,0 rgba(0,0,0,0)" \
     -blur 0x30 \
  \) -compose Over -composite \
  "$TMP/front.png"
echo "Front lighting done"

# ── Step 2: Spine face (drawn as polygon, dark navy) ─────────────────
convert -size ${CW}x${CH} xc:white \
  -fill "#0c1d38" \
  -draw "polygon 195,110  350,95  350,1560  195,1570" \
  "$TMP/spine_base.png"

# Gradient lighting on spine (left darker, right lighter at seam)
convert "$TMP/spine_base.png" \
  \( -size ${CW}x${CH} xc:none \
     -sparse-color Barycentric "195,0 rgba(0,0,0,0.5)  350,0 rgba(0,0,0,0)" \
     -blur 0x20 \
  \) -compose Multiply -composite \
  "$TMP/spine_lit.png"

# Spine text
convert "$TMP/spine_lit.png" \
  -font DejaVu-Sans-Bold -pointsize 19 -fill "rgba(255,255,255,0.80)" \
  -annotate 270x270+272+830 "AI THINKING FOR EDUCATORS  ·  Dr. Ernesto Lee" \
  "$TMP/spine.png"
echo "Spine done"

# ── Step 3: Page edges (cream strip, right side) ──────────────────────
convert -size ${CW}x${CH} xc:white \
  -fill "#ece6d9" \
  -draw "polygon 1030,75  1065,82  1095,1565  1060,1560" \
  \( -size ${CW}x${CH} xc:none \
     -sparse-color Barycentric "1030,0 rgba(200,195,185,0.6)  1095,0 rgba(160,155,145,0.8)" \
     -blur 0x4 \
  \) -compose Multiply -composite \
  "$TMP/pages.png"
echo "Pages done"

# ── Step 4: Top edge of book (page block from above) ─────────────────
convert -size ${CW}x${CH} xc:white \
  -fill "#f0ebe0" \
  -draw "polygon 195,110  350,95  1030,75  1065,82  350,95  195,110" \
  "$TMP/topedge_base.png"

convert "$TMP/topedge_base.png" \
  -fill "#ddd8cc" \
  -draw "polygon 195,110  350,95  1030,75  1065,82  350,95  195,110" \
  "$TMP/topedge.png"
echo "Top edge done"

# ── Step 5: Ground shadow ─────────────────────────────────────────────
SCTR=$(( (350 + 1060) / 2 ))
convert -size ${CW}x${CH} xc:none \
  -fill "rgba(0,0,0,0.28)" \
  -draw "ellipse ${SCTR},1585 480,26 0,360" \
  -blur 0x20 \
  "$TMP/shadow.png"
echo "Shadow done"

# ── Step 6: Composite all (order: white → shadow → spine → pages → top → front) ──
convert -size ${CW}x${CH} xc:white \
  "$TMP/shadow.png" -composite \
  "$TMP/spine.png"  -compose Multiply -composite \
  "$TMP/pages.png"  -compose Multiply -composite \
  "$TMP/front.png"  -composite \
  "$TMP/topedge.png" -compose Multiply -composite \
  "$TMP/final_raw.png"

# ── Step 7: Trim + border ─────────────────────────────────────────────
convert "$TMP/final_raw.png" \
  -trim +repage \
  -bordercolor white -border 55x55 \
  "$OUTPUT"

SIZE=$(wc -c < "$OUTPUT")
echo "Done. {\"success\":true,\"size\":$SIZE}"
