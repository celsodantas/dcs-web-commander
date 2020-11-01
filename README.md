# Web Commander

WIP project to export and display live DCS data into a web interface.

## Installation

 1. Add `Moose.lua` to your mission and the `web_commander.lua` on the MISSION START event.
 2. Add a trigger with a `DO SCRIPT` and add `WebExporter.Start(PATH)`, `PATH` here is the path to the /data folder of where this project is located on your computer.
 3. (temporary, while development), inside the `/web` folder, run `python http_server.py` from the terminal to serve the web application
 4. visit `http://localhost:8080/` to see live map.

Notice that you need to have the mission running to generate the file used by the web application.