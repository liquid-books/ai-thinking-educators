#!/bin/bash
# Physically correct 3D book mockup using ImageMagick perspective distortion
# 
# Strategy:
#   1. Perspective-distort the flat cover onto the front face quad
#   2. Create the spine as a darkened sliver with the same top vanishing point
#   3. Create the page edges (right side)
#   4. Composite all onto a white canvas with drop shadow

set -e

FLAT="/home/node/openclaw/books/ai-thinking-educators/images/cover-flat.png"
OUTPUT="/home/node/openclaw/books/ai-thinking-educators/images/cover.png"
TMP="/tmp/book3d"
mkdir -p "$TMP"

# Get flat cover dimensions
FLAT_W=$(identify -format "%w" "$FLAT")
FLAT_H=$(identify -format "%h" "$FLAT")

echo "Flat cover: ${FLAT_W}x${FLAT_H}"

# ── Canvas and book geometry ──────────────────────────────────────────
# Output canvas
CW=1200
CH=1600

# Front face corners (bottom-left book placement)
# Slight perspective: top is shifted right (book tilts back slightly)
# Bottom-left, Bottom-right, Top-left, Top-right of front face
FL_BL_X=200;  FL_BL_Y=1480   # front left bottom
FL_BR_X=980;  FL_BR_Y=1480   # front right bottom
FL_TL_X=230;  FL_TL_Y=120    # front left top
FL_TR_X=1010; FL_TR_Y=120    # front right top

# Spine corners (left of front face, same vanishing point at top)
# Spine width visible ~80px at bottom, ~65px at top (perspective compression)
SP_BR_X=$FL_BL_X; SP_BR_Y=$FL_BL_Y   # = front left bottom
SP_TR_X=$FL_TL_X; SP_TR_Y=$FL_TL_Y   # = front left top
SP_BL_X=115;  SP_BL_Y=1490           # spine outer bottom
SP_TL_X=155;  SP_TL_Y=130            # spine outer top

# Page edges (right of front face)
PE_BL_X=$FL_BR_X; PE_BL_Y=$FL_BR_Y
PE_TL_X=$FL_TR_X; PE_TL_Y=$FL_TR_Y
PE_BR_X=1000; PE_BR_Y=1490
PE_TR_X=1030; PE_TR_Y=125

# ── Step 1: Perspective-distort the flat cover onto front face ────────
# ImageMagick +distort Perspective maps:
#   src_x,src_y -> dst_x,dst_y  (4 point pairs)
# Source corners of flat image -> destination quad corners on canvas

convert "$FLAT" \
  -alpha set \
  +distort Perspective \
    "0,0 ${FL_TL_X},${FL_TL_Y}  \
     ${FLAT_W},0 ${FL_TR_X},${FL_TR_Y}  \
     0,${FLAT_H} ${FL_BL_X},${FL_BL_Y}  \
     ${FLAT_W},${FLAT_H} ${FL_BR_X},${FL_BR_Y}" \
  -crop ${CW}x${CH}+0+0 +repage \
  "$TMP/front.png"

echo "Front face distorted"

# ── Step 2: Create spine (dark navy gradient rectangle, perspective) ──
# Create a spine-colored rectangle and distort it the same way
convert -size ${FLAT_W}x${FLAT_H} \
  gradient:"#0d1f3c-#1e3560" \
  +distort Perspective \
    "0,0 ${SP_TL_X},${SP_TL_Y}  \
     ${FLAT_W},0 ${SP_TR_X},${SP_TR_Y}  \
     0,${FLAT_H} ${SP_BL_X},${SP_BL_Y}  \
     ${FLAT_W},${FLAT_H} ${SP_BR_X},${SP_BR_Y}" \
  -crop ${CW}x${CH}+0+0 +repage \
  "$TMP/spine.png"

echo "Spine created"

# ── Step 3: Add spine text ────────────────────────────────────────────
# Calculate spine center for text placement
SP_CX=$(( (SP_TL_X + SP_BL_X) / 2 + 10 ))
SP_CY=$(( (SP_TL_Y + SP_BL_Y) / 2 ))

convert "$TMP/spine.png" \
  -font DejaVu-Sans-Bold -pointsize 18 -fill white \
  -gravity None \
  -annotate 270x270+${SP_CX}+${SP_CY} "AI THINKING FOR EDUCATORS  ·  Dr. Ernesto Lee" \
  "$TMP/spine_text.png"

echo "Spine text added"

# ── Step 4: Create page edges (cream/off-white gradient) ─────────────
convert -size ${FLAT_W}x${FLAT_H} \
  gradient:"#f0ece3-#ddd8ce" \
  +distort Perspective \
    "0,0 ${PE_TL_X},${PE_TL_Y}  \
     ${FLAT_W},0 ${PE_TR_X},${PE_TR_Y}  \
     0,${FLAT_H} ${PE_BL_X},${PE_BL_Y}  \
     ${FLAT_W},${FLAT_H} ${PE_BR_X},${PE_BR_Y}" \
  -crop ${CW}x${CH}+0+0 +repage \
  "$TMP/pages.png"

echo "Page edges created"

# ── Step 5: Composite all layers on white canvas ──────────────────────
# Order: white bg → spine → front → pages → shadow overlay

convert -size ${CW}x${CH} xc:white \
  "$TMP/spine_text.png" -composite \
  "$TMP/front.png" -composite \
  "$TMP/pages.png" -composite \
  "$TMP/composite.png"

echo "Composite done"

# ── Step 6: Add drop shadow under the book ───────────────────────────
# Shadow ellipse under the book base
SHADOW_CX=$(( (FL_BL_X + FL_BR_X) / 2 ))
SHADOW_CY=$(( FL_BL_Y + 25 ))

convert "$TMP/composite.png" \
  \( -size ${CW}x${CH} xc:none \
     -fill "rgba(0,0,0,0.25)" \
     -draw "ellipse ${SHADOW_CX},${SHADOW_CY} 380,20 0,360" \
     -blur 0x12 \
  \) \
  -gravity None -geometry +0+0 \
  -composite \
  "$TMP/with_shadow.png"

# Flatten shadow BEHIND the book by recompositing
convert -size ${CW}x${CH} xc:white \
  \( -size ${CW}x${CH} xc:none \
     -fill "rgba(0,0,0,0.22)" \
     -draw "ellipse ${SHADOW_CX},${SHADOW_CY} 380,20 0,360" \
     -blur 0x15 \
  \) -composite \
  "$TMP/spine_text.png" -composite \
  "$TMP/front.png" -composite \
  "$TMP/pages.png" -composite \
  "$OUTPUT"

echo "Shadow composited"

# ── Step 7: Trim and add padding ─────────────────────────────────────
convert "$OUTPUT" \
  -trim \
  -bordercolor white -border 50x50 \
  "$OUTPUT"

SIZE=$(wc -c < "$OUTPUT")
echo "{\"success\":true,\"path\":\"$OUTPUT\",\"size\":$SIZE}"
