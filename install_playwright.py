#!/usr/bin/env python3
"""
Helper script to install Playwright properly in the container
"""
import subprocess
import sys

def install_playwright():
    print("Installing Playwright...")
    # Run the playwright install command with all required dependencies
    result = subprocess.run(
        ["python3", "-m", "playwright", "install", "chromium", "--with-deps"],
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        print(f"Error installing Playwright: {result.stderr}")
        sys.exit(1)
    
    print("Playwright installation completed successfully")
    print(result.stdout)

if __name__ == "__main__":
    install_playwright() 