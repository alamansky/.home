---
name: import-recipe
description: Convert any recipe source — an image, a webpage URL, a document, or raw text — into a JSON file matching the specified schema. Also generates a recipe from scratch when only a dish name is given. Use when the user wants to add a new recipe to the collection.
---

# Recipe Import

Convert a recipe from any input format into a JSON file and save it to `~/docs/recipes/data/`.

## Step 1 — Identify the input type

Determine the input type and process accordingly:

- **Image file** (`.jpg`, `.jpeg`, `.png`, `.heic`, `.webp`, etc.): Use the `Read` tool on the file path. Claude reads images natively.
- **Document** (`.pdf`, `.txt`, `.md`, `.docx`, etc.): Use the `Read` tool on the file path.
- **URL**: Use `WebFetch` to retrieve the page content.
- **Raw text**: The user has already provided the content — proceed to Step 2.
- **Dish name only** (no file, URL, or recipe text — just a name or description like "apple pie" or "a spicy chicken stir fry"): Generate the recipe yourself. Write a complete, accurate recipe for the dish and proceed to Step 2 using that as the content. Do not ask the user for a source.

If the input is ambiguous (e.g. a bare string that could be a file path or a recipe name), check whether the path exists with `ls`. If it does not exist, treat it as a dish name and generate the recipe.

## Step 2 — Parse the recipe

Extract the following fields from the content:

| Field | Type | Notes |
|---|---|---|
| `title` | string | The recipe name, title-cased |
| `ingredients` | array of `[name, quantity]` pairs | See rules below |
| `instructions` | array of strings | One string per step |
| `tags` | array of strings | See rules below |

**Ingredients rules:**
- Each ingredient is a two-element array: `["ingredient name", "quantity"]`.
- The name should be lowercase and not include the quantity.
- Quantity includes the amount and unit, e.g. `"1 cup"`, `"3/4 ounce"`, `"2 cans"`.
- For open-ended amounts use `"season to taste"`, `"to taste"`, or `"as needed"`.
- If a recipe lists no quantity for an ingredient, use `""`.

**Tags rules:**
- Tags are lowercase strings.
- Infer tags from the recipe's content and context. Common tags include: `breakfast`, `lunch`, `dinner`, `soup`, `salad`, `seafood`, `chicken`, `beef`, `pork`, `vegetarian`, `vegan`, `gluten free`, `dairy free`, `dessert`, `snack`, `dip`, `party`, `side dish`, `mexican`, `italian`, `asian`, `quick`, `slow cooker`.
- Use only tags that clearly apply. 1–3 tags is typical; more is fine when warranted.

## Step 3 — Build the JSON

Assemble the parsed fields into this exact schema:

```json
{
  "title": "Recipe Title",
  "ingredients": [
    ["ingredient name", "quantity"],
    ["another ingredient", "quantity"]
  ],
  "instructions": [
    "First step.",
    "Second step."
  ],
  "tags": ["tag1", "tag2"]
}
```

## Step 4 — Save the file

1. Derive the filename by converting the title to kebab-case and appending `.json`:
   - `"Buffalo Chicken Dip"` → `buffalo-chicken-dip.json`
   - `"Salmon Ceviche"` → `salmon-ceviche.json`
2. Write the file to `~/docs/recipes/data/<filename>.json`.
3. Confirm the path to the user and show the JSON content.

## Rules

- **Do not modify existing files.** If a file with the derived filename already exists, stop and ask the user before overwriting.
- **Preserve the source's intent.** When working from a provided source, do not add, remove, or reorder ingredients or steps. If the source is ambiguous, pick the most literal reading and note the ambiguity. When generating a recipe from scratch, write a complete and accurate recipe.
- **No comments in the JSON.** The output must be valid, parseable JSON.
- **If extraction fails** (unreadable image, paywalled URL, unsupported format), stop and tell the user what went wrong rather than guessing.
