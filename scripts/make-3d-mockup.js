#!/usr/bin/env node
/**
 * Programmatic 3D book mockup generator.
 * Takes a flat cover PNG and applies correct perspective transforms
 * to produce a physically accurate 3D standing book mockup.
 *
 * Physics:
 *  - Book faces slightly right (3/4 view)
 *  - Spine visible on left, slightly narrower due to perspective
 *  - Page edges visible on right
 *  - Consistent vanishing point for all faces
 *  - Ground shadow beneath
 */

const { createCanvas, loadImage } = require('canvas');
const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

const INPUT  = path.join(__dirname, '../images/cover-flat.png');
const OUTPUT = path.join(__dirname, '../images/cover.png');

// Canvas size
const W = 1400;
const H = 1800;

// Book dimensions in canvas pixels
const BOOK_H = 1400;          // height of book
const COVER_W = 900;          // width of front face
const SPINE_W = 90;           // width of visible spine
const PAGE_EDGE_W = 18;       // page edge on right

// Perspective shear — top of book leans back slightly
const TOP_SHEAR = 40;         // px — how much top corners shift left vs bottom

// Book position (bottom-left corner of front face)
const BX = 280;               // left x of front face (bottom)
const BY = H - 160;           // bottom y

async function main() {
  const canvas = createCanvas(W, H);
  const ctx = canvas.getContext('2d');

  // White background
  ctx.fillStyle = '#ffffff';
  ctx.fillRect(0, 0, W, H);

  // Load flat cover
  const coverImg = await loadImage(INPUT);

  // ── Define the four corners of each face ──────────────────────────
  // Front face (slight perspective — top leans slightly left)
  const front = {
    tl: { x: BX + TOP_SHEAR,           y: BY - BOOK_H },
    tr: { x: BX + COVER_W + TOP_SHEAR, y: BY - BOOK_H },
    br: { x: BX + COVER_W,             y: BY },
    bl: { x: BX,                       y: BY },
  };

  // Spine (left of front face, angled away)
  const spineAngle = 0.55; // how much spine top leans left relative to bottom
  const spine = {
    tl: { x: front.tl.x - SPINE_W * spineAngle, y: front.tl.y + 30 },
    tr: front.tl,
    br: front.bl,
    bl: { x: front.bl.x - SPINE_W,              y: front.bl.y },
  };

  // Page edges (right of front face, thin strip)
  const pageEdge = {
    tl: front.tr,
    tr: { x: front.tr.x + PAGE_EDGE_W * 0.4, y: front.tr.y + 20 },
    br: { x: front.br.x + PAGE_EDGE_W,        y: front.br.y },
    bl: front.br,
  };

  // ── Draw drop shadow ───────────────────────────────────────────────
  const shadowOffsetX = 60;
  const shadowBlur = 80;
  ctx.save();
  ctx.shadowColor = 'rgba(0,0,0,0.35)';
  ctx.shadowBlur = shadowBlur;
  ctx.shadowOffsetX = shadowOffsetX;
  ctx.shadowOffsetY = 30;
  ctx.beginPath();
  ctx.moveTo(front.bl.x, front.bl.y);
  ctx.lineTo(front.br.x, front.br.y);
  ctx.lineTo(pageEdge.br.x, pageEdge.br.y);
  ctx.lineTo(spine.bl.x, spine.bl.y);
  ctx.closePath();
  ctx.fillStyle = 'rgba(0,0,0,0.01)';
  ctx.fill();
  ctx.restore();

  // ── Draw spine ─────────────────────────────────────────────────────
  // Spine color: darker shade of the cover's navy
  ctx.save();
  ctx.beginPath();
  ctx.moveTo(spine.tl.x, spine.tl.y);
  ctx.lineTo(spine.tr.x, spine.tr.y);
  ctx.lineTo(spine.br.x, spine.br.y);
  ctx.lineTo(spine.bl.x, spine.bl.y);
  ctx.closePath();
  // Dark navy gradient to simulate lighting from right
  const spineGrad = ctx.createLinearGradient(spine.bl.x, 0, spine.tl.x, 0);
  spineGrad.addColorStop(0, '#0a1628');
  spineGrad.addColorStop(1, '#1a2d50');
  ctx.fillStyle = spineGrad;
  ctx.fill();
  ctx.restore();

  // ── Draw front cover using perspective transform ───────────────────
  // Canvas doesn't have native perspective transform for images,
  // so we use a quad-to-quad mapping via manual scanline rendering
  // with save/restore + clip path approach
  await drawQuadImage(ctx, coverImg, front.tl, front.tr, front.br, front.bl);

  // ── Lighting overlay on front cover (subtle left-edge darkening) ──
  ctx.save();
  ctx.beginPath();
  ctx.moveTo(front.tl.x, front.tl.y);
  ctx.lineTo(front.tr.x, front.tr.y);
  ctx.lineTo(front.br.x, front.br.y);
  ctx.lineTo(front.bl.x, front.bl.y);
  ctx.closePath();
  const lightGrad = ctx.createLinearGradient(front.bl.x, 0, front.br.x, 0);
  lightGrad.addColorStop(0, 'rgba(0,0,0,0.18)');
  lightGrad.addColorStop(0.15, 'rgba(0,0,0,0)');
  lightGrad.addColorStop(1, 'rgba(0,0,0,0)');
  ctx.fillStyle = lightGrad;
  ctx.fill();
  ctx.restore();

  // ── Draw page edges ────────────────────────────────────────────────
  ctx.save();
  ctx.beginPath();
  ctx.moveTo(pageEdge.tl.x, pageEdge.tl.y);
  ctx.lineTo(pageEdge.tr.x, pageEdge.tr.y);
  ctx.lineTo(pageEdge.br.x, pageEdge.br.y);
  ctx.lineTo(pageEdge.bl.x, pageEdge.bl.y);
  ctx.closePath();
  const pageGrad = ctx.createLinearGradient(pageEdge.tl.x, 0, pageEdge.tr.x, 0);
  pageGrad.addColorStop(0, '#e8e4dc');
  pageGrad.addColorStop(0.3, '#f5f2ec');
  pageGrad.addColorStop(1, '#d4cfc6');
  ctx.fillStyle = pageGrad;
  ctx.fill();
  // Horizontal line texture on pages
  ctx.strokeStyle = 'rgba(180,170,155,0.4)';
  ctx.lineWidth = 0.8;
  for (let i = 0; i < BOOK_H; i += 3) {
    const t = i / BOOK_H;
    const y1 = pageEdge.tl.y + (pageEdge.bl.y - pageEdge.tl.y) * t;
    const x1l = pageEdge.tl.x + (pageEdge.bl.x - pageEdge.tl.x) * t;
    const x1r = pageEdge.tr.x + (pageEdge.br.x - pageEdge.tr.x) * t;
    ctx.beginPath();
    ctx.moveTo(x1l, y1);
    ctx.lineTo(x1r, y1 + (pageEdge.tr.y - pageEdge.tl.y) * (1 - t) * 0.1);
    ctx.stroke();
  }
  ctx.restore();

  // ── Spine title text ───────────────────────────────────────────────
  ctx.save();
  const spineCenterX = (spine.bl.x + spine.tl.x) / 2 + SPINE_W * 0.5;
  const spineCenterY = (spine.tl.y + spine.bl.y) / 2;
  ctx.translate(spineCenterX - 10, spineCenterY);
  ctx.rotate(-Math.PI / 2);
  ctx.fillStyle = '#ffffff';
  ctx.font = 'bold 22px sans-serif';
  ctx.textAlign = 'center';
  ctx.fillText('AI THINKING FOR EDUCATORS  ·  Dr. Ernesto Lee', 0, 0);
  ctx.restore();

  // ── Ground shadow ellipse ──────────────────────────────────────────
  ctx.save();
  const shadowCX = (front.bl.x + front.br.x) / 2 + 30;
  const shadowCY = BY + 18;
  ctx.beginPath();
  ctx.ellipse(shadowCX, shadowCY, COVER_W * 0.55, 28, 0, 0, Math.PI * 2);
  const groundGrad = ctx.createRadialGradient(shadowCX, shadowCY, 0, shadowCX, shadowCY, COVER_W * 0.55);
  groundGrad.addColorStop(0, 'rgba(0,0,0,0.28)');
  groundGrad.addColorStop(1, 'rgba(0,0,0,0)');
  ctx.fillStyle = groundGrad;
  ctx.fill();
  ctx.restore();

  // ── Save to PNG via sharp (crop to content + small padding) ────────
  const buffer = canvas.toBuffer('image/png');
  await sharp(buffer)
    .trim({ background: '#ffffff', threshold: 10 })
    .extend({ top: 40, bottom: 60, left: 40, right: 40, background: '#ffffff' })
    .png({ compressionLevel: 8 })
    .toFile(OUTPUT);

  const stats = fs.statSync(OUTPUT);
  console.log(JSON.stringify({ success: true, path: OUTPUT, size: stats.size }));
}

/**
 * Draw an image warped into an arbitrary quadrilateral using
 * horizontal scanline slicing for a perspective-correct look.
 */
async function drawQuadImage(ctx, img, tl, tr, br, bl) {
  const SLICES = 300;
  const iw = img.width;
  const ih = img.height;

  ctx.save();
  for (let i = 0; i < SLICES; i++) {
    const t0 = i / SLICES;
    const t1 = (i + 1) / SLICES;

    // Interpolate left and right edges
    const lx0 = tl.x + (bl.x - tl.x) * t0;
    const ly0 = tl.y + (bl.y - tl.y) * t0;
    const rx0 = tr.x + (br.x - tr.x) * t0;
    const ry0 = tr.y + (br.y - tr.y) * t0;

    const lx1 = tl.x + (bl.x - tl.x) * t1;
    const ly1 = tl.y + (bl.y - tl.y) * t1;
    const rx1 = tr.x + (br.x - tr.x) * t1;
    const ry1 = tr.y + (br.y - tr.y) * t1;

    // Source strip from image
    const sy = ih * t0;
    const sh = ih / SLICES + 1;

    // Destination: parallelogram for this strip
    // Use transform: map the source rect to the dest quad strip
    const dx = lx0;
    const dy = ly0;
    const dw = rx0 - lx0;
    const dh = Math.max(ly1 - ly0, ry1 - ry0, 1);

    // Skew: difference between left-bottom and right-bottom at next strip
    const skewX = (lx1 - lx0);
    const scaleX = dw / iw;
    const scaleY = dh / (ih / SLICES);

    ctx.save();
    ctx.transform(scaleX, (ly0 - ry0) / iw, (lx1 - lx0) / (ih / SLICES), scaleY, dx, dy);

    // Clip to this strip
    ctx.beginPath();
    ctx.rect(0, 0, iw, ih / SLICES + 1);
    ctx.clip();

    ctx.drawImage(img, 0, -sy, iw, ih);
    ctx.restore();
  }
  ctx.restore();
}

main().catch(e => { console.error(e); process.exit(1); });
