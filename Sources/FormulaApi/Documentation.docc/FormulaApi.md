# ``FormulaApi``

Interact with Formula 1 racing data API.

## Overview

FormulaApi provides access to historical recordu of motor racing data for non-commercial purposes.
All of the available API endpoints provided by this library are accessible through the ``F1`` type.

## Topics

### API

- ``F1``

### Filtering

- ``FilterCriteria``
- ``RaceSeason``
- ``RaceRound``

### Pagination

- ``Page``
- ``Paginable``

### Season list

- ``F1/seasons(season:by:page:)``
- ``F1/seasons(season:criteria:page:)``
- ``Season``

### Race schedule

- ``F1/races(season:by:page:)``
- ``F1/races(season:criteria:page:)``
- ``Race``

### Circuits

- ``F1/circuits(season:by:page:)``
- ``F1/circuits(season:criteria:page:)``
- ``Circuit``
- ``Location``
- ``CircuitID``
