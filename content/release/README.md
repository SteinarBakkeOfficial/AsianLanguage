# Active release source

This directory contains only the current Symbol packages used to generate the V1 app data. Edit the matching folder under `symbols/<id>/`; when a Symbol changes, first preserve the current file or package under `content/archive/symbols/<id>/revisions/<timestamp>/`, then put the replacement content here.

The app does not bundle this authoring directory directly. `Tools/Import-V1RuntimeCorpus.ps1` generates the downloadable app content under `Resources/`.
