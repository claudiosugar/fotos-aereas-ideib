# IDEIB Aerial Photo Fetcher

This Flask application automates the process of fetching historical aerial photos for a given cadastral reference from the [IDEIB Visor](https://ideib.caib.es/visor/) website using Playwright.

## Features

*   Accepts a cadastral reference via a web form or directly in the URL path.
*   Navigates the IDEIB Visor website automatically.
*   Takes screenshots for predefined historical years.
*   Creates a zip archive containing the generated screenshots.
*   Initiates a download of the zip file in the user's browser.

## Usage

There are two ways to use the deployed application:

1.  **Web Form:** Visit the application's base URL (e.g., `https://your-app-name.fly.dev/`). Enter the cadastral reference into the form and click "Download Photos".
2.  **Direct URL:** Append the cadastral reference directly to the application's base URL (e.g., `https://your-app-name.fly.dev/7805508DD6870F`).

In both cases, the process will run on the server, and a zip file containing the photos will be downloaded automatically once ready. This may take several minutes depending on the number of years configured and website performance.

## Local Setup & Running

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/claudiosugar/fotos-aereas-ideib.git
    cd fotos-aereas-ideib
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

5.  **Run for Local Testing:**
    *   **Uncomment** the last two lines in `fotos-aereas-ideib.py`:
        ```python
        # if __name__ == '__main__':
        #    app.run(debug=True)
        ```
        becomes:
        ```python
        if __name__ == '__main__':
           app.run(debug=True)
        ```
    *   Run the Flask development server:
        ```bash
        # On Windows
        py fotos-aereas-ideib.py
        # On macOS/Linux
        python fotos-aereas-ideib.py
        ```
    *   The application will be available at `http://127.0.0.1:5000`.

6.  **(IMPORTANT) Re-comment for Deployment:** Before committing and deploying changes, make sure to **re-comment** the `if __name__ == '__main__':` block in `fotos-aereas-ideib.py`.

## Configuration

*   **Years:** The list of years to capture can be modified by editing the `years_to_screenshot` list near the top of `fotos-aereas-ideib.py`.

## Deployment

This application is configured for deployment to [Fly.io](https://fly.io/) using the provided `Dockerfile`. The Dockerfile handles the installation of system dependencies, Python packages, and Playwright browser binaries.

The Gunicorn worker timeout is set within the `Dockerfile`'s `CMD` instruction to handle the potentially long-running Playwright tasks.

The `fly.toml` file (excluded by `.gitignore`) contains the specific Fly.io application settings (name, region, memory, etc.). 