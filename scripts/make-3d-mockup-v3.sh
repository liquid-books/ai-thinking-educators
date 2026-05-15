#!/bin/bash
# Physically correct 3D book mockup — v3
# Proper 2-point perspective: book tilted ~35 degrees, camera slightly above
# Uses ImageMagick +distort Perspective for correct projective transform

set -e

FLAT="/home/node/openclaw/books/ai-thinking-educators/images/cover-flat.png"
OUTPUT="/home/node/openclaw/books/ai-thinking-educators/images/cover.png"
TMP="/tmp/book3d_v3"
mkdir -p "$TMP"

FLAT_W=$(identify -format "%w" "$FLAT")
FLAT_H=$(identify -format "%h" "$FLAT")
echo "Flat cover: ${FLAT_W}x${FLAT_H}"

# ── Canvas ────────────────────────────────────────────────────────────
CW=1400
CH=1700

# ── Front face (strong 3/4 tilt — book rotated ~35° from frontal) ────
# Camera is slightly above and to the right of the book.
# The front face is a trapezoid: narrower at top (top recedes away).
# Right edge is nearly vertical. Left edge angles inward at top.
#
#  TL(420,110)────────────────────TR(1050,80)
#   |                               |
#   |   (front cover face)          |
#   |                               |
#  BL(280,1520)───────────────────BR(1070,1520)

FL_TL_X=440;  FL_TL_Y=110
FL_TR_X=1060; FL_TR_Y=80
FL_BL_X=280;  FL_BL_Y=1540
FL_BR_X=1070; FL_BR_Y=1540

# ── Spine (left of front face, same top vanishing point) ─────────────
# Top of spine converges toward same left vanishing point as front top-left edge.
# Spine bottom is wider (closer to viewer), spine top is narrower.
#
#  SP_TL(210,120)──SP_TR=FL_TL(440,110)
#   |                    |
#  SP_BL(100,1550)──SP_BR=FL_BL(280,1540)

SP_TL_X=210;  SP_TL_Y=120
SP_TR_X=$FL_TL_X; SP_TR_Y=$FL_TL_Y
SP_BL_X=100;  SP_BL_Y=1552
SP_BR_X=$FL_BL_X; SP_BR_Y=$FL_BL_Y

# ── Page edges (right of front, thin strip) ──────────────────────────
PE_TL_X=$FL_TR_X; PE_TL_Y=$FL_TR_Y
PE_TR_X=1100; PE_TR_Y=95
PE_BL_X=$FL_BR_X; PE_BL_Y=$FL_BR_Y
PE_BR_X=1110; PE_BR_Y=1550

# ── Step 1: Perspective-distort flat cover onto front face ────────────
convert "$FLAT" -alpha set \
  +distort Perspective \
    "0,0             ${FL_TL_X},${FL_TL_Y}  \
     ${FLAT_W},0     ${FL_TR_X},${FL_TR_Y}  \
     0,${FLAT_H}     ${FL_BL_X},${FL_BL_Y}  \
     ${FLAT_W},${FLAT_H} ${FL_BR_X},${FL_BR_Y}" \
  -crop ${CW}x${CH}+0+0 +repage \
  "$TMP/front.png"
echo "Front distorted"

# ── Step 2: Spine face (dark navy gradient) ───────────────────────────
convert -size ${FLAT_W}x${FLAT_H} gradient:"#0b1a30-#1a3060" \
  +distort Perspective \
    "0,0             ${SP_TL_X},${SP_TL_Y}  \
     ${FLAT_W},0     ${SP_TR_X},${SP_TR_Y}  \
     0,${FLAT_H}     ${SP_BL_X},${SP_BL_Y}  \
     ${FLAT_W},${FLAT_H} ${SP_BR_X},${SP_BR_Y}" \
  -crop ${CW}x${CH}+0+0 +repage \
  "$TMP/spine_base.png"

# Add lighting: left side of spine is darker (facing away from light)
convert "$TMP/spine_base.png" \
  \( +clone -fill "rgba(0,0,0,0.3)" -colorize 100 \) \
  -compose Multiply -composite \
  "$TMP/spine_dark.png"

# Spine title text (rotated 90 degrees)
SP_CX=$(( (SP_TL_X + SP_BL_X) / 2 + 25 ))
SP_CY=$(( (SP_TL_Y + SP_BL_Y) / 2 ))
convert "$TMP/spine_dark.png" \
  -font DejaVu-Sans-Bold -pointsize 20 -fill "rgba(255,255,255,0.85)" \
  -gravity None \
  -annotate 270x270+${SP_CX}+${SP_CY} "AI THINKING FOR EDUCATORS  ·  Dr. Ernesto Lee" \
  "$TMP/spine.png"
echo "Spine done"

# ── Step 3: Page edges (cream tones) ─────────────────────────────────
convert -size ${FLAT_W}x${FLAT_H} gradient:"#f2ede4-#ccc8be" \
  +distort Perspective \
    "0,0             ${PE_TL_X},${PE_TL_Y}  \
     ${FLAT_W},0     ${PE_TR_X},${PE_TR_Y}  \
     0,${FLAT_H}     ${PE_BL_X},${PE_BL_Y}  \
     ${FLAT_W},${FLAT_H} ${PE_BR_X},${PE_BR_Y}" \
  -crop ${CW}x${CH}+0+0 +repage \
  "$TMP/pages.png"
echo "Page edges done"

# ── Step 4: Ground shadow ellipse ────────────────────────────────────
SHADOW_CX=$(( (FL_BL_X + FL_BR_X + SP_BL_X) / 3 ))
SHADOW_CY=$(( FL_BL_Y + 30 ))

convert -size ${CW}x${CH} xc:none \
  -fill "rgba(0,0,0,0.30)" \
  -draw "ellipse ${SHADOW_CX},${SHADOW_CY} 450,22 0,360" \
  -blur 0x18 \
  "$TMP/shadow.png"
echo "Shadow done"

# ── Step 5: Composite layers (order: white → shadow → spine → pages → front) ──
convert -size ${CW}x${CH} xc:white \
  "$TMP/shadow.png"  -composite \
  "$TMP/spine.png"   -composite \
  "$TMP/pages.png"   -composite \
  "$TMP/front.png"   -composite \
  "$TMP/composite.png"

# ── Step 6: Add subtle top edge of book (thin bright strip) ──────────
# Top edge: a thin bright strip connecting FL_TL to SP_TL to FL_TR
# (the top page block visible from slightly above)
convert "$TMP/composite.png" \
  -fill "rgba(240,235,225,0.9)" \
  -draw "polygon ${SP_TL_X},${SP_TL_Y} ${FL_TL_X},${FL_TL_Y} ${FL_TR_X},${FL_TR_Y} $(( FL_TR_X + 5 )),$(( FL_TR_Y - 18 )) $(( FL_TL_X + 10 )),$(( FL_TL_Y - 18 )) $(( SP_TL_X - 15 )),$(( SP_TL_Y - 12 ))" \
  "$TMP/composite2.png"

# ── Step 7: Trim + pad ────────────────────────────────────────────────
convert "$TMP/composite2.png" \
  -trim \
  -bordercolor white -border 60x60 \
  "$OUTPUT"

SIZE=$(wc -c < "$OUTPUT")
echo "{\"success\":true,\"path\":\"$OUTPUT\",\"size\":$SIZE}"
