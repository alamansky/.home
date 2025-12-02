const pug = require("pug");
const fs = require("node:fs/promises");
const { opendir } = require("node:fs/promises");

/*
process.argv[2] - path to directory with input JSON data
process.argv[3] - path to pug template file
process.argv[4] - path to output directory for html files
*/
async function main() {
  const inputDir = process.argv[2];
  const templateFile = process.argv[3];
  const outputDir = process.argv[4];
  try {
    const dir = await opendir(inputDir);
    for await (const dirent of dir) {
      console.log(`Processing file: ${dirent}`);
      const contents = await fs.readFile(`${inputDir}/${dirent.name}`);
      const locals = JSON.parse(contents);
      const html = pug.renderFile(templateFile, locals);
      await fs.writeFile(
        `${outputDir}/${dirent.name.split(".")[0]}.html`,
        html,
      );
    }
  } catch (err) {
    console.error(err);
  }
}

main();
