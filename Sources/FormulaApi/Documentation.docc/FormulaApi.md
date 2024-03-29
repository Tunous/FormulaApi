# ``FormulaApi``

Interact with Formula 1 racing data API.

## Overview

FormulaApi provides access to historical records of motor racing data for non-commercial purposes.
All of the available API endpoints provided by this library are accessible through the ``F1`` type.

## Topics

### API

- ``F1``

### Filtering

- ``FilterCriteria``
- ``RaceSeason``
- ``RaceRound``
- ``FinishingResult``

### Pagination

- ``Page``
- ``Paginable``

### Season list

- ``F1/seasons(season:by:page:)``
- ``Season``

### Race schedule

- ``F1/races(season:by:page:)``
- ``Race``

### Circuits

- ``F1/circuits(season:by:page:)``
- ``CircuitID``
- ``Circuit``
- ``Location``

### Drivers

- ``F1/drivers(season:by:page:)``
- ``DriverID``
- ``Driver``

### Constructors

- ``F1/constructors(season:by:page:)``
- ``ConstructorID``
- ``Constructor``
