#!/usr/bin/env node
fetch(`https://api.github.com/repos/${process.argv[2]}`)
  .then(response => response.json())
  .then(({ created_at }) =>
      console.log(created_at.replace(/T(.*)Z/gm, "$1"))
  )
  .catch(error => {
    const { cause } = error;

    if (cause.code === "ENOTFOUND") {
      console.log("\x1b[31m%s\x1b[0m", "Address not found")
      return;
    }
    console.error(error)
  })

