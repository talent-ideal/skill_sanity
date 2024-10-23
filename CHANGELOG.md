# Changelog

## [1.0.0-alpha.8](https://github.com/talent-ideal/skill_sanity/compare/v1.0.0-alpha.7...v1.0.0-alpha.8) (2024-10-23)

### 🐛 Bug Fixes

* return empty data on skill not found instead of erroring ([73dbee0](https://github.com/talent-ideal/skill_sanity/commit/73dbee033d890cece9b8d9c2ee86ba201ededc0a))

## [1.0.0-alpha.7](https://github.com/talent-ideal/skill_sanity/compare/v1.0.0-alpha.6...v1.0.0-alpha.7) (2024-10-19)

### 🛠 Builds

* **deps:** update dependency appsignal to == 2.13.0 ([#12](https://github.com/talent-ideal/skill_sanity/issues/12)) [skip ci] ([8474056](https://github.com/talent-ideal/skill_sanity/commit/8474056a570ba15aa16a989a244d9d68d5935509))
* **deps:** update dependency appsignal_phoenix to == 2.5.0 ([#13](https://github.com/talent-ideal/skill_sanity/issues/13)) [skip ci] ([3ddbd85](https://github.com/talent-ideal/skill_sanity/commit/3ddbd855d273e26649a86072b59192eb9121478e))
* **deps:** update dependency ash to == 3.4.33 ([#19](https://github.com/talent-ideal/skill_sanity/issues/19)) [skip ci] ([a9f7a90](https://github.com/talent-ideal/skill_sanity/commit/a9f7a90d18a9ee454d08835eb40562e6590fcbfa))
* **deps:** update dependency ash_appsignal to == 0.1.3 ([#2](https://github.com/talent-ideal/skill_sanity/issues/2)) [skip ci] ([1569b3c](https://github.com/talent-ideal/skill_sanity/commit/1569b3c4424894d1d253e668f405808ff6c5f321))
* **deps:** update dependency ash_phoenix to == 2.1.6 ([#20](https://github.com/talent-ideal/skill_sanity/issues/20)) [skip ci] ([b655f36](https://github.com/talent-ideal/skill_sanity/commit/b655f363cd50791048325836436225b2dd9f5957))
* **deps:** update dependency ash_postgres to == 2.4.9 ([#21](https://github.com/talent-ideal/skill_sanity/issues/21)) [skip ci] ([901fbdf](https://github.com/talent-ideal/skill_sanity/commit/901fbdf084fb99198300dbc5282057c70618dbd0))
* **deps:** update dependency dialyxir to == 1.4.4 ([#3](https://github.com/talent-ideal/skill_sanity/issues/3)) [skip ci] ([f9970b5](https://github.com/talent-ideal/skill_sanity/commit/f9970b57cd3e5119533cd048cdc869833c61da22))
* **deps:** update dependency ecto_sql to == 3.12.1 ([#4](https://github.com/talent-ideal/skill_sanity/issues/4)) [skip ci] ([dfdcf93](https://github.com/talent-ideal/skill_sanity/commit/dfdcf93f8ca2c9c2855119fc620060f8354ca03d))
* **deps:** update dependency esbuild to == 0.8.2 ([#27](https://github.com/talent-ideal/skill_sanity/issues/27)) ([9f00cd5](https://github.com/talent-ideal/skill_sanity/commit/9f00cd51d00442ac5f9984b1e0d002b11a64234a))
* **deps:** update dependency heroicons to == v2.1.5 ([#7](https://github.com/talent-ideal/skill_sanity/issues/7)) ([d4b89bc](https://github.com/talent-ideal/skill_sanity/commit/d4b89bc368dbef4923e8c1f919491bafe00866f4))
* **deps:** update dependency phoenix_live_view to == 1.0.0-rc.7 ([#24](https://github.com/talent-ideal/skill_sanity/issues/24)) [skip ci] ([8570c95](https://github.com/talent-ideal/skill_sanity/commit/8570c954f6d44f2c2c28b4720cda52fc6284166c))
* **deps:** update dependency swoosh to == 1.17.2 ([#8](https://github.com/talent-ideal/skill_sanity/issues/8)) [skip ci] ([179baa0](https://github.com/talent-ideal/skill_sanity/commit/179baa02e890ffecd86e9b5a246dad82b1aff6ad))
* **deps:** update dependency tailwind to == 0.2.4 ([#28](https://github.com/talent-ideal/skill_sanity/issues/28)) [skip ci] ([11756e2](https://github.com/talent-ideal/skill_sanity/commit/11756e202f8ab0fa116aef116b5fc73a80294265))

### ⚙️ Continuous Integrations

* **action:** update actions/cache action to v4.1.1 ([#15](https://github.com/talent-ideal/skill_sanity/issues/15)) [skip ci] ([9de8680](https://github.com/talent-ideal/skill_sanity/commit/9de86809643e483e42b7213b8077346894d3b8b2))
* **action:** update actions/checkout action to v4.2.1 ([#10](https://github.com/talent-ideal/skill_sanity/issues/10)) [skip ci] ([b57f7a1](https://github.com/talent-ideal/skill_sanity/commit/b57f7a1ddd8380ff805de5df47baae95dc625806))
* **action:** update dependency flyctl to v0.3.24 ([#11](https://github.com/talent-ideal/skill_sanity/issues/11)) [skip ci] ([cd19d48](https://github.com/talent-ideal/skill_sanity/commit/cd19d48ea48e8067aab5a7c609e8cbaa303ba7a4))

### ♻️ Chores

* **docker:** update postgres:16.4 docker digest to 91f464e ([#23](https://github.com/talent-ideal/skill_sanity/issues/23)) [skip ci] ([cf4648f](https://github.com/talent-ideal/skill_sanity/commit/cf4648f283c2909d999b7f1f9d19440b757f2089))
* migrate renovate config ([d44b518](https://github.com/talent-ideal/skill_sanity/commit/d44b518a511abd1f43c15e26cce985d7dc462460))

## [1.0.0-alpha.6](https://github.com/talent-ideal/skill_sanity/compare/v1.0.0-alpha.5...v1.0.0-alpha.6) (2024-10-18)

### ⚠ Breaking changes

* switch to uuid v7 primary keys

### 📦 Code Refactoring

* switch to uuid v7 primary keys ([9d25568](https://github.com/talent-ideal/skill_sanity/commit/9d25568989bed736c5dcdf66e100a67574e8ec2c))

### ♻️ Chores

* update Fly database names in Makefile ([c82b13c](https://github.com/talent-ideal/skill_sanity/commit/c82b13c4738a3bbcafe19957a3671041a6eed570))

## [1.0.0-alpha.5](https://github.com/talent-ideal/skill_sanity/compare/v1.0.0-alpha.4...v1.0.0-alpha.5) (2024-10-17)

### ✨ Features

* **search:** log skill search requests & results ([d453e85](https://github.com/talent-ideal/skill_sanity/commit/d453e8539dedd426dbf71984b6cec7b2be7aec9e))

### 🛠 Builds

* **deps:** pin dependencies ([#1](https://github.com/talent-ideal/skill_sanity/issues/1)) [skip ci] ([4be712c](https://github.com/talent-ideal/skill_sanity/commit/4be712c8f5c06b2a735984b88f051ff33998b3d1))

### 📦 Code Refactoring

* update health check route ([c161f15](https://github.com/talent-ideal/skill_sanity/commit/c161f15390576013f009ad4a5756ff3caca4abf0))

### 📚 Documentation

* update "Future Work" section ([0a067d8](https://github.com/talent-ideal/skill_sanity/commit/0a067d875da32529d064ba60d0bd17483b9b66c5))

### ♻️ Chores

* add Pylote dataset import script ([70316e5](https://github.com/talent-ideal/skill_sanity/commit/70316e5e06f4a21d3bd44d03c7c09683115b7bce))
* **docker:** update postgres docker tag to v16.4 [skip ci] ([b8e8257](https://github.com/talent-ideal/skill_sanity/commit/b8e82573257c530692701c68707e916268964442))
* update CHANGELOG commit refs after rebase ([cdf9484](https://github.com/talent-ideal/skill_sanity/commit/cdf9484bcd94796b227ee59eae363f7bb093c451))

## [1.0.0-alpha.4](https://github.com/talent-ideal/skill_sanity/compare/v1.0.0-alpha.3...v1.0.0-alpha.4) (2024-10-15)

### ✨ Features

* **search:** return best match skills and variations & parallelize searches ([bbdd5f9](https://github.com/talent-ideal/skill_sanity/commit/bbdd5f919ae771e69c821836b380e53b11283c08))

## [1.0.0-alpha.3](https://github.com/talent-ideal/skill_sanity/compare/v1.0.0-alpha.2...v1.0.0-alpha.3) (2024-10-15)

### ✨ Features

* add source attributes ([3edda3f](https://github.com/talent-ideal/skill_sanity/commit/3edda3f4c169958cb01e3bca6b55ddf48d7dce20))
* also implement search on skill slug ([c20a6c2](https://github.com/talent-ideal/skill_sanity/commit/c20a6c2aba6fa793ab81fc8218f9e6f3b37cc74c))

### 📚 Documentation

* update "Future Work" section ([fae3f61](https://github.com/talent-ideal/skill_sanity/commit/fae3f616e5295d04292a6ff53b049ce785d2553b))

### 🚨 Tests

* fix creation signature in tests ([5c126b9](https://github.com/talent-ideal/skill_sanity/commit/5c126b9db35a47d9c07118e5a3e7257cfb23e7fe))

### ♻️ Chores

* add application monitoring (AppSignal) ([87c0b0b](https://github.com/talent-ideal/skill_sanity/commit/87c0b0bb7afa1ad3e74c737ab343da62aef5e761))
* configure Renovate ([4d9b033](https://github.com/talent-ideal/skill_sanity/commit/4d9b033e45a8245f7a6dab95f5f262e6f0d6eec9))

## [1.0.0-alpha.2](https://github.com/talent-ideal/skill_sanity/compare/v1.0.0-alpha.1...v1.0.0-alpha.2) (2024-10-06)

### 🐛 Bug Fixes

* fix Gettext deprecation warning ([ef2c8b9](https://github.com/talent-ideal/skill_sanity/commit/ef2c8b92bf4d005e2df3044e6a67fe723fae90ec))

### ⚙️ Continuous Integrations

* configure semantic_release & add workflows ([37f0d7c](https://github.com/talent-ideal/skill_sanity/commit/37f0d7c8ebb8fde4d6916d8dde7f989883466928))

### ♻️ Chores

* deploy to Fly.io ([418244c](https://github.com/talent-ideal/skill_sanity/commit/418244cbd1d9ab9bde0d8e3849c0ee40b1480ecd))

## 1.0.0-alpha.1 (2024-10-04)

### ✨ Features

* add /skills/search endpoint ([e80a2b6](https://github.com/talent-ideal/skill_sanity/commit/e80a2b68f870f6b4c51b3de57c1ad099e67f66a6))
* add skill & skill variation resources ([03428cc](https://github.com/talent-ideal/skill_sanity/commit/03428cc505e50c8489244890e322268bea9fc1a4))
* first commit ([ad9f38d](https://github.com/talent-ideal/skill_sanity/commit/ad9f38d2805342bc512e07e2873f2c58bb79acaa))
* implement skills fuzzy searching ([38b6a61](https://github.com/talent-ideal/skill_sanity/commit/38b6a61957f107ea54333b7312410eb36ab2ca2a))

### 📚 Documentation

* **readme:** add overview, plan of action, and potential issues sections ([cc52176](https://github.com/talent-ideal/skill_sanity/commit/cc52176d8a6a59a891a4927580413a110458fc4f))

### 🚨 Tests

* switch to property-based testing ([39668b7](https://github.com/talent-ideal/skill_sanity/commit/39668b778cd6954ac5f42e2153a3b13ebefec3a3))

### ♻️ Chores

* add database seeding script ([d6c58cc](https://github.com/talent-ideal/skill_sanity/commit/d6c58ccc5436730fcd010a1269588457424a6e1d))
* add license file ([7424600](https://github.com/talent-ideal/skill_sanity/commit/7424600cb536ba5b4f2e92d4fa2a466377fd62db))
* add more seed data ([b8c730e](https://github.com/talent-ideal/skill_sanity/commit/b8c730e52b4932644981cfe7c49d4aa1ceb63c28))
