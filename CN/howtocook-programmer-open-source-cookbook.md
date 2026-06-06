---
title: "HowToCook: 297 Recipes for Programmers - The Open Source Cookbook"
description: "Discover HowToCook - an open-source cookbook with 297 recipes designed for programmers. Clear, precise cooking instructions like code."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Docker
  - Go
  - JavaScript
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "455.3 MB"
file_md5: ""
download_url: "https://github.com/Anduin2017/HowToCook"
backup_url: ""
github_repo: "https://github.com/Anduin2017/HowToCook"
stars: 100171
maintainer: "Anduin2017"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /posts/howtocook-programmer-open-source-cookbook/
faqs:
  - q: 'What is HowToCook?'
    a: 'HowToCook (程序员做饭指南) is an open-source cookbook project created by programmer Anduin2017. It contains 297 recipes written with the precision and clarity that developers expect from documentation.'
  - q: 'How does HowToCook differ from traditional recipes?'
    a: 'Instead of vague instructions like "a little salt" or "cook until golden," every recipe uses exact measurements (e.g., "3g salt"), precise timings (e.g., "fry for 90 seconds per side"), a complete upfront ingredient list, a required equipment list, and a 1-5 star difficulty rating.'
  - q: 'How are HowToCook recipes rated by difficulty?'
    a: 'Recipes use a 1-5 star system: 1-star covers simple dishes like tomato scrambled eggs and instant noodles, while 5-star covers advanced dishes like shark fin soup and abalone porridge. The collection has 45 one-star, 78 two-star, 89 three-star, 56 four-star, and 29 five-star recipes.'
  - q: 'How do you run HowToCook locally with Docker?'
    a: 'Pull and run the image with: docker pull ghcr.io/anduin2017/how-to-cook:latest then docker run -d -p 5000:5000 ghcr.io/anduin2017/how-to-cook:latest, and access it at http://localhost:5000.'
  - q: 'How can you contribute a recipe to HowToCook?'
    a: 'Fork the repository, copy the template recipe, write your recipe following the project''s structured format, and submit a Pull Request. The project has 200+ contributors and supports Chinese, English, and Japanese.'
---
{</* resource-info */>}

## What is HowToCook?

**HowToCook** (程序员做饭指南) is an open-source cookbook project created by programmer **Anduin2017**. It contains **297 recipes** written with the precision and clarity that developers expect from documentation.

The project's philosophy is simple: **cooking recipes should be as clear as code**. No ambiguous instructions like "a little salt" or "cook until done." Every recipe uses precise measurements, exact timings, and step-by-step procedures.

**GitHub**: https://github.com/Anduin2017/HowToCook  
**Stars**: 70K+  
**Contributors**: 200+  
**License**: Unlicense

---

## Why Programmers Need This

### The Problem with Traditional Recipes

| Issue | Example | HowToCook Solution |
|-------|---------|-------------------|
| Ambiguous quantities | "a little salt" | "3g salt (1/2 teaspoon)" |
| Vague timing | "cook until golden" | "fry for 90 seconds per side" |
| Missing steps | Ingredients appear mid-recipe | Complete ingredient list upfront |
| No difficulty rating | All recipes look equally hard | 1-5 star difficulty system |
| No equipment list | Assume you have everything | Required tools listed first |

### Features Designed for Developers

- **Structured format**: Like functions with parameters
- **Difficulty levels**: 1-5 stars (from instant noodles to Peking Duck)
- **Equipment requirements**: Listed before ingredients
- **Exact measurements**: Grams, milliliters, not "a pinch"
- **Time tracking**: Prep time, cook time, total time
- **Error handling**: Common mistakes and how to avoid them

---

## Recipe Categories

### By Difficulty

| Stars | Count | Examples |
|-------|-------|----------|
| ⭐ | 45 | Tomato scrambled eggs, instant noodles upgrade |
| ⭐⭐ | 78 | Kung Pao chicken, braised pork |
| ⭐⭐⭐ | 89 | Sweet and sour pork ribs, mapo tofu |
| ⭐⭐⭐⭐ | 56 | Peking duck, hot pot base |
| ⭐⭐⭐⭐⭐ | 29 | Shark fin soup, abalone porridge |

### By Type

- **Vegetables**: 85 recipes (stir-fried, braised, steamed)
- **Meat**: 92 recipes (pork, beef, chicken, lamb)
- **Seafood**: 34 recipes (fish, shrimp, crab)
- **Soups**: 46 recipes (quick soups, slow-cooked broths)
- **Breakfast**: 23 recipes (congee, pancakes, sandwiches)
- **Desserts**: 17 recipes (cakes, puddings, sweet soups)

---

## Sample Recipe: Tomato Scrambled Eggs

```markdown
# Tomato Scrambled Eggs (西红柿炒鸡蛋) ⭐

## Ingredients
- 2 eggs (100g)
- 2 tomatoes (300g)
- 3g salt (1/2 teaspoon)
- 5g sugar (1 teaspoon)
- 10ml cooking oil
- 2g green onion (optional)

## Equipment
- Frying pan
- Spatula
- Bowl

## Time
- Prep: 5 minutes
- Cook: 5 minutes
- Total: 10 minutes

## Steps
1. Crack eggs into bowl, add 1g salt, beat until uniform
2. Wash tomatoes, cut into 2cm chunks
3. Heat pan to medium-high (180°C)
4. Add oil, wait 10 seconds
5. Pour eggs, stir constantly for 30 seconds
6. Remove eggs when 80% solid (slightly runny)
7. Add tomatoes to same pan, cook 2 minutes
8. Add remaining salt and sugar
9. Return eggs to pan, mix 20 seconds
10. Serve immediately

## Tips
- Don't overcook eggs - they continue cooking after removal
- If tomatoes are too acidic, add 1g more sugar
- For softer texture, add 10ml milk to eggs
```

---

## Community & Contributions

### How to Contribute

1. **Fork** the repository
2. **Copy** the template recipe
3. **Write** your recipe following the format
4. **Submit** a Pull Request

### Contribution Stats

- **200+ contributors** worldwide
- **297 recipes** and growing
- **Multiple languages**: Chinese, English, Japanese
- **Docker support**: Run locally with one command

### Web Deployment

```bash
# Deploy locally
docker pull ghcr.io/anduin2017/how-to-cook:latest
docker run -d -p 5000:5000 ghcr.io/anduin2017/how-to-cook:latest

# Access at http://localhost:5000
```

---

## NPM Package

Install as a Node.js package:

```bash
npm install how-to-cook
```

Use programmatically:

```javascript
const recipes = require('how-to-cook');

// Search recipes
const tomatoRecipes = recipes.search('tomato');

// Get by difficulty
const easyRecipes = recipes.filterByStars(1);

// Get random recipe
const dinner = recipes.random();
```

---

## Learning Path

### Beginner (Week 1-2)
- Kitchen preparation
- Basic knife skills
- 1-star recipes
- Rice cooking

### Intermediate (Week 3-4)
- 2-3 star recipes
- Meat preparation
- Stir-fry techniques
- Soup basics

### Advanced (Week 5+)
- 4-5 star recipes
- Multi-dish coordination
- Flavor balancing
- Presentation

---

## Why This Matters for SEO

**HowToCook** is a perfect example of:

1. **Community-driven content**: 200+ contributors create authentic content
2. **Structured data**: Recipes follow schema.org format
3. **Long-tail keywords**: "程序员做饭指南", "how to cook for developers"
4. **Evergreen content**: Cooking never goes out of style
5. **Multi-language**: Chinese, English, Japanese versions

---

## Related Articles

- [Free Claude Code: Open Source AI Coding Agent](/resources/ai-tools/free-claude-code-open-source-proxy/) - Another developer-focused open source tool
- [Pixelle-Video: AI Short Video Generator](/resources/ai-tools/pixelle-video-ai-short-video-generator/) - AI tools for content creation
- [OpenClaw 42 Use Cases](/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/) - AI agents for daily tasks

---

*Disclaimer: This article introduces an open-source project. All recipe content belongs to the HowToCook community. Please follow food safety guidelines when cooking.*

---

## Recommended Tools

For developers building or deploying open-source AI tools, we recommend:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for new users, 14+ global regions, one-click GPU/CPU droplets ideal for AI workloads.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API proxy. Most AI tools above (chatbots, code gen, translation, search, etc) need an LLM API key — this proxy delivers stable access to top models at ~30% of official pricing.

*Affiliate link — supports dibi8.com at no cost to you.*

