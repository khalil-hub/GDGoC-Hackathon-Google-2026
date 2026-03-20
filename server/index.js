// server.js — Paw Couture Backend
// npm install express cors multer node-fetch dotenv

require("dotenv").config();
const fs      = require("fs");
const path    = require("path");
const express = require("express");
const cors    = require("cors");
const multer  = require("multer");
const fetch   = require("node-fetch");

const app  = express();
const PORT = process.env.PORT || 3000;
const API_KEY = process.env.GEMINI_API_KEY;

const GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

// ── Middleware ───────────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// ── Multer ───────────────────────────────────────────────────────
const ALLOWED = ["image/jpeg","image/png","image/webp","image/gif"];
const storage = multer.diskStorage({
  destination: "uploads/",
  filename: (_, file, cb) => cb(null, `${Date.now()}-${Math.random().toString(36).slice(2)}${path.extname(file.originalname)}`),
});
const upload = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: (_, file, cb) => ALLOWED.includes(file.mimetype) ? cb(null, true) : cb(new Error("Images only (JPEG/PNG/WEBP/GIF)")),
});

if (!fs.existsSync("uploads")) fs.mkdirSync("uploads");

// ── Helpers ──────────────────────────────────────────────────────
function deleteTempFile(p) {
  if (p && fs.existsSync(p)) fs.unlink(p, () => {});
}

async function callGemini(contents) {
  if (!API_KEY) throw new Error("GEMINI_API_KEY not set");
  const r = await fetch(`${GEMINI_URL}?key=${API_KEY}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ contents }),
  });
  if (!r.ok) throw new Error(`Gemini ${r.status}: ${await r.text()}`);
  const d = await r.json();
  const text = d.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!text) throw new Error("Empty Gemini response");
  return text;
}

async function analyzePet(imagePath, mimeType) {
  const b64 = fs.readFileSync(imagePath).toString("base64");
  return callGemini([{
    role: "user",
    parts: [
      { text: "Describe this pet in 2-3 sentences: animal type, breed if visible, coat color and pattern, approximate size, and any distinctive features. Be specific and vivid." },
      { inlineData: { mimeType: mimeType || "image/jpeg", data: b64 } },
    ],
  }]);
}

async function generateOutfits(petDescription) {
  const prompt = `
You are a luxury pet fashion stylist, sizing expert, and visual designer.

Pet: ${petDescription}

First derive a sizing profile for this pet from their breed, build, and size description.
Then create 3 distinct outfit concepts tailored to their measurements.

Respond ONLY with a valid JSON object — no markdown fences, no extra text:
{
  "sizing": {
    "sizeLabel": "XS / S / M / L / XL — pick the single best fit",
    "weightEstimate": "e.g. 4–6 kg",
    "neckGirth": "e.g. 24–28 cm",
    "chestGirth": "e.g. 38–44 cm",
    "backLength": "e.g. 30–36 cm",
    "fitNote": "One sentence on breed-specific fit considerations, e.g. deep-chested breeds need extra chest room, short legs mean shorter back length, fluffy coats add 1–2 cm bulk, etc."
  },
  "outfits": [
    {
      "name": "Outfit name (2-4 words)",
      "emoji": "one emoji",
      "vibe": "One evocative sentence capturing the mood and aesthetic",
      "season": "Spring / Summer / Autumn / Winter",
      "colors": [
        { "name": "Color name", "hex": "#RRGGBB" },
        { "name": "Color name", "hex": "#RRGGBB" },
        { "name": "Color name", "hex": "#RRGGBB" }
      ],
      "items": ["specific garment or accessory", "item 2", "item 3", "item 4"],
      "sizeAdjustment": "Outfit-specific fit tip referencing the sizing above, e.g. order size M but request extra chest width, choose a stretchy knit for freedom of movement, etc.",
      "overlayShapes": [
        {
          "type": "body",
          "description": "Main garment — e.g. fitted jacket, flowing dress, knit sweater",
          "primaryColor": "#RRGGBB",
          "pattern": "solid|stripes|plaid|dots|floral|none"
        },
        {
          "type": "accessory",
          "description": "Hat, bow, collar, shoes, bag, etc.",
          "primaryColor": "#RRGGBB",
          "pattern": "solid|stripes|plaid|dots|floral|none"
        }
      ]
    }
  ]
}`.trim();

  const raw = await callGemini([{ role: "user", parts: [{ text: prompt }] }]);
  const clean = raw.replace(/```json|```/g, "").trim();
  const parsed = JSON.parse(clean);
  // Support both old array shape and new object shape gracefully
  if (Array.isArray(parsed)) return { sizing: null, outfits: parsed };
  return parsed;
}


// ── Route: POST /generate-outfit ─────────────────────────────────
app.post("/generate-outfit", upload.single("image"), async (req, res) => {
  const tempPath = req.file?.path;
  try {
    // 1. Get pet description
    let petDescription = "";
    if (req.file) {
      petDescription = await analyzePet(tempPath, req.file.mimetype);
    } else if (req.body.description?.trim()) {
      petDescription = req.body.description.trim();
    } else {
      return res.status(400).json({ error: "Provide an image or description." });
    }

    // 2. Generate outfit structured data + sizing
    const { sizing, outfits } = await generateOutfits(petDescription);

    res.json({ description: petDescription, sizing, outfits });

  } catch (err) {
    console.error("Route error:", err.message);
    if (err.message.includes("JSON"))   return res.status(502).json({ error: "AI returned unexpected format. Try again." });
    if (err.message.includes("Gemini")) return res.status(502).json({ error: "AI service error. Try again." });
    res.status(500).json({ error: "Something went wrong." });
  } finally {
    deleteTempFile(tempPath);
  }
});

// Multer errors
app.use((err, req, res, next) => {
  if (err?.code === "LIMIT_FILE_SIZE") return res.status(400).json({ error: "File too large. Max 5MB." });
  if (err?.message) return res.status(400).json({ error: err.message });
  next(err);
});

app.listen(PORT, () => {
  console.log(`🐾 Paw Couture → http://localhost:${PORT}`);
  if (!API_KEY) console.warn("⚠  Add GEMINI_API_KEY to your .env file");
});