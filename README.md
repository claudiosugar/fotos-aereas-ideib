# IDEIB Aerial Photo Fetcher

This Flask application automates the process of fetching historical aerial photos for a given cadastral reference from the [IDEIB Visor](https://ideib.caib.es/visor/) website using Playwright.

## Features

*   Accepts a cadastral reference via a web form.
*   Navigates the IDEIB Visor website automatically.
*   Takes screenshots for predefined historical years (1956, 1984, ..., 2023).
*   Displays the generated screenshots in the web interface.

## Local Setup & Running

1.  **Clone the repository (if you haven't already):**
    ```bash
    git clone <your-repository-url>
    cd <repository-directory>
    ```

2.  **Create and activate a virtual environment (recommended):**
    ```bash
    python -m venv .venv
    # On Windows
    .venv\Scripts\activate
    # On macOS/Linux
    source .venv/bin/activate
    ```

3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Install Playwright browsers:**
    ```bash
    playwright install --with-deps chromium
    ```

5.  **Set the FLASK_APP environment variable:**
    ```bash
    # On Windows (Command Prompt)
    set FLASK_APP=fotos-aereas-ideib.py
    # On Windows (PowerShell)
    $env:FLASK_APP="fotos-aereas-ideib.py"
    # On macOS/Linux
    export FLASK_APP=fotos-aereas-ideib.py
    ```

6.  **Run the Flask development server:**
    ```bash
    flask run
    ```
    The application should be available at `http://127.0.0.1:5000`.

## Deployment

This application is configured for deployment to [Fly.io](https://fly.io/) using the provided `Dockerfile`. The Dockerfile handles the installation of system dependencies, Python packages, and Playwright browser binaries.

The `fly.toml` file (currently excluded by `.gitignore`) would typically be configured for the Fly.io deployment settings. 