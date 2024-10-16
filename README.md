# SkillSanity (Tech Skills Standardization POC)

## Overview

Many people in the tech recruitment space have expressed frustration over inconsistencies in skill naming. For instance, terms like "react.js," "ReactJS," and "react js" are often used interchangeably.

This project aims to tackle challenges faced by developers by providing an API that returns a unique slug for skills, regardless of variations in spelling or even misspellings, by leveraging user input and external resources.

Full credit for the idea goes to [Ronan Camus](https://www.linkedin.com/in/freelance-cto/), which he shared in [this LinkedIn post](https://www.linkedin.com/feed/update/urn:li:activity:7246776440753393664).

## Plan of action

1. **Database Schema Creation** ✅
   - Implement a PostgreSQL database with the following tables:
     - **`skills`**: Store standardized skill names with unique slugs (e.g. name: "React", slug: "react").
     - **`skill_variations`**: Store different variations and spellings of each skill.

2. **Search Implementation** ✅
   - Use PostgreSQL's `trgm` module to find the best match from dirty input.

3. **API Development** ✅
   - Create a basic API endpoint to retrieve a skill slug from any of its variations (should work with lists).

4. **Add Skill/Variation Access Logs** ✅
   - In order to prioritize/automate data cleanup, add a log of every skill/variation access.

5. **Handling Missing Skills**
   - Integrate with external APIs (LinkedIn, GitHub, StackOverflow) to supplement the database with missing skills when needed.

6. **Future Work**
   - Skill/variation versioning.
   - Skill/variation soft-delete.
   - Skill flagging for manual review based on similarity, lemmatized similarity and other methods.
   - Skill/variation merging in a practical manner for API consumers.
   - Localization for skill names and variations.
   - Skills extraction from blocks of text (resumes, job descriptions, ...).
   - Simple front-end to allow users to experiment with instant search results.
   - User feedback (flagging/voting) & suggestions (adding/updating existing data).
   - Related skills.
   - Context-dependent search (e.g. "Enzyme" means different things on a JavaScript CV or a science CV).

## Potential issues

- Very similar in name but actually different skills (e.g. AngularJS & Angular, Wine (compatibility layer) & Wine (beverage))

## Running locally

To start the project:

  * Run `mix setup` to install and set up dependencies.
  * Start the Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) in your browser.
