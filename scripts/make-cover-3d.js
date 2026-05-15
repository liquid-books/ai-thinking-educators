#!/usr/bin/env node
/**
 * Physically correct 3D book cover using sharp compositing.
 * 
 * Physics: A hardcover book standing upright, rotated ~32 degrees from frontal.
 * - Front face: rectangle compressed to cos(32°) ≈ 85% of original width (correct!)
 * - Spine: rectangle showing at sin(32°) ≈ 53% of spine thickness, on the left
 * - Page edges: thin cream strip on the right
 * - Top edge: thin strip visible from slightly above
 * - Drop shadow beneath
 * 
 * Since vertical edges of a standing book are truly vertical in 2-point perspective,
 * the front face IS a rectangle — no perspective keystone. This is correct physics.
 */

const sharp = require('sharp');
const { createCanvas, loadImage } = require('canvas');
const fs = require('fs');
const path = require('path');

const BOOK_DIR  = '/home/node/openclaw/books/ai-thinking-educators';
const FLAT_IN   = path.join(BOOK_DIR, 'images/cover-flat.png');
const OUTPUT    = path.join(BOOK_DIR, 'images/cover.png');

async function main() {
  const meta = await sharp(FLAT_IN).metadata();
  const srcW = meta.width;   // 848
  const srcH = meta.height;  // 1264
  console.log(`Source: ${srcW}x${srcH}`);

  // ── Book geometry ───────────────────────────────────────────────
  const ANGLE_DEG = 32;                              // rotation from frontal
  const ANGLE_RAD = ANGLE_DEG * Math.PI / 180;
  const SPINE_REAL_PX = 44;                          // book thickness in pixels

  const coverW  = Math.round(srcW * Math.cos(ANGLE_RAD));  // 718
  const coverH  = srcH;                                     // 1264
  const spineW  = Math.round(SPINE_REAL_PX * Math.sin(ANGLE_RAD)); // 23px visible
  const spineWDisplay = Math.max(spineW, 50);               // min 50px for visibility
  const pageW   = 18;                                       // page edge strip width
  const topH    = 22;                                       // top edge strip height

  // Canvas dimensions
  const PAD     = 80;
  const CANVAS_W = coverW + spineWDisplay + pageW + PAD * 2;
  const CANVAS_H = coverH + topH + PAD * 2 + 60; // 60 for shadow

  console.log(`Book face: ${coverW}x${coverH}, spine: ${spineWDisplay}px`);
  console.log(`Canvas: ${CANVAS_W}x${CANVAS_H}`);

  // ── Resize flat cover to foreshortened width ────────────────────
  const frontBuf = await sharp(FLAT_IN)
    .resize(coverW, coverH, { fit: 'fill' })
    .png()
    .toBuffer();

  // ── Build each face on canvas ───────────────────────────────────
  const canvas = createCanvas(CANVAS_W, CANVAS_H);
  const ctx = canvas.getContext('2d');

  // White background
  ctx.fillStyle = '#ffffff';
  ctx.fillRect(0, 0, CANVAS_W, CANVAS_H);

  // Positions
  const spineX  = PAD;
  const coverX  = PAD + spineWDisplay;
  const pagesX  = coverX + coverW;
  const bookTopY  = PAD + topH;
  const bookBotY  = bookTopY + coverH;

  // ── Ground shadow (ellipse under the book) ──────────────────────
  const shadowCX = PAD + (spineWDisplay + coverW) / 2 + 10;
  const shadowCY = bookBotY + 28;
  const shadowGrad = ctx.createRadialGradient(shadowCX, shadowCY, 0, shadowCX, shadowCY, (coverW + spineWDisplay) * 0.55);
  shadowGrad.addColorStop(0, 'rgba(0,0,0,0.30)');
  shadowGrad.addColorStop(0.5, 'rgba(0,0,0,0.12)');
  shadowGrad.addColorStop(1, 'rgba(0,0,0,0)');
  ctx.save();
  ctx.scale(1, 0.2);
  ctx.beginPath();
  ctx.arc(shadowCX, shadowCY * 5, (coverW + spineWDisplay) * 0.55, 0, Math.PI * 2);
  ctx.fillStyle = shadowGrad;
  ctx.fill();
  ctx.restore();

  // ── Spine face ──────────────────────────────────────────────────
  // Dark navy, left edge darker (facing away from light source on right)
  const spineGrad = ctx.createLinearGradient(spineX, 0, spineX + spineWDisplay, 0);
  spineGrad.addColorStop(0,   '#050d1a');
  spineGrad.addColorStop(0.4, '#0a1a30');
  spineGrad.addColorStop(1,   '#102440');
  ctx.fillStyle = spineGrad;
  ctx.fillRect(spineX, bookTopY, spineWDisplay, coverH);

  // Spine-front seam highlight (thin bright line)
  ctx.fillStyle = 'rgba(255,255,255,0.08)';
  ctx.fillRect(spineX + spineWDisplay - 2, bookTopY, 2, coverH);

  // Spine title (rotated text)
  ctx.save();
  ctx.translate(spineX + spineWDisplay / 2, bookTopY + coverH / 2);
  ctx.rotate(-Math.PI / 2);
  ctx.fillStyle = 'rgba(255,255,255,0.75)';
  ctx.font = `bold ${Math.max(10, Math.floor(spineWDisplay * 0.28))}px Arial, sans-serif`;
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  ctx.fillText('AI THINKING FOR EDUCATORS  ·  DR. ERNESTO LEE', 0, 0);
  ctx.restore();

  // ── Top edge (page block seen from slightly above) ───────────────
  // Slight trapezoid: spine side slightly narrower (correct perspective)
  ctx.save();
  ctx.beginPath();
  ctx.moveTo(spineX,                bookTopY);                    // top-left of spine
  ctx.lineTo(spineX + spineWDisplay, bookTopY);                   // top of cover
  ctx.lineTo(pagesX + pageW,        bookTopY - topH * 0.6);       // top-right of pages
  ctx.lineTo(spineX - topH * 0.2,   bookTopY - topH);             // back-left corner
  ctx.closePath();
  const topGrad = ctx.createLinearGradient(0, bookTopY - topH, 0, bookTopY);
  topGrad.addColorStop(0, '#e0dbd0');
  topGrad.addColorStop(1, '#f0ebe0');
  ctx.fillStyle = topGrad;
  ctx.fill();
  ctx.restore();

  // ── Front cover ──────────────────────────────────────────────────
  const frontImg = await loadImage(frontBuf);
  ctx.drawImage(frontImg, coverX, bookTopY, coverW, coverH);

  // Left-edge shadow on front cover (seam between spine and front)
  const frontShadowGrad = ctx.createLinearGradient(coverX, 0, coverX + 60, 0);
  frontShadowGrad.addColorStop(0,    'rgba(0,0,0,0.28)');
  frontShadowGrad.addColorStop(0.5,  'rgba(0,0,0,0.05)');
  frontShadowGrad.addColorStop(1,    'rgba(0,0,0,0)');
  ctx.fillStyle = frontShadowGrad;
  ctx.fillRect(coverX, bookTopY, 80, coverH);

  // ── Page edges (right side) ──────────────────────────────────────
  const pagesGrad = ctx.createLinearGradient(pagesX, 0, pagesX + pageW, 0);
  pagesGrad.addColorStop(0,   '#f2ece0');
  pagesGrad.addColorStop(0.5, '#ede6d8');
  pagesGrad.addColorStop(1,   '#d8d0c4');
  ctx.fillStyle = pagesGrad;
  ctx.fillRect(pagesX, bookTopY, pageW, coverH);

  // Horizontal page lines
  ctx.strokeStyle = 'rgba(180,172,158,0.35)';
  ctx.lineWidth = 0.6;
  for (let y = bookTopY; y < bookBotY; y += 2.5) {
    ctx.beginPath();
    ctx.moveTo(pagesX, y);
    ctx.lineTo(pagesX + pageW, y);
    ctx.stroke();
  }

  // ── Overall book drop shadow (right side, simulate 3D depth) ────
  const rightShadow = ctx.createLinearGradient(pagesX + pageW, 0, pagesX + pageW + 40, 0);
  rightShadow.addColorStop(0, 'rgba(0,0,0,0.12)');
  rightShadow.addColorStop(1, 'rgba(0,0,0,0)');
  ctx.fillStyle = rightShadow;
  ctx.fillRect(pagesX + pageW, bookTopY, 40, coverH);

  // ── Save + trim ──────────────────────────────────────────────────
  const buf = canvas.toBuffer('image/png');
  await sharp(buf)
    .trim({ background: '#ffffff', threshold: 8 })
    .extend({ top: 50, bottom: 70, left: 50, right: 60, background: '#ffffff' })
    .png({ compressionLevel: 8 })
    .toFile(OUTPUT);

  const size = fs.statSync(OUTPUT).size;
  console.log(JSON.stringify({ success: true, path: OUTPUT, size, coverW, coverH, spineW: spineWDisplay }));
}

main().catch(e => { console.error(e.message); process.exit(1); });
