#!/usr/bin/env python3
import os
import sys
import urllib.request
import urllib.error
import socket
from typing import Optional, Tuple

def check_endpoint_status() -> None:
    """
    Check if an endpoint returns the expected status code.
    Uses environment variables ENDPOINT and EXPECTED_STATUS_CODE.
    Optionally uses METHOD (defaults to GET).
    Uses standard library only (no requests module).
    """
    print("Running endpoint status check")
    
    # Check required environment variables
    endpoint = os.environ.get("ENDPOINT")
    if not endpoint:
        print("Error: ENDPOINT environment variable is not set")
        sys.exit(1)
    
    expected_status_code_str = os.environ.get("EXPECTED_STATUS_CODE")
    if not expected_status_code_str:
        print("Error: EXPECTED_STATUS_CODE environment variable is not set")
        sys.exit(1)
    
    try:
        expected_status_code = int(expected_status_code_str)
    except ValueError:
        print(f"Error: Invalid EXPECTED_STATUS_CODE: {expected_status_code_str}")
        print("Must be a valid HTTP status code (e.g., 200, 404, 500)")
        sys.exit(1)
    
    # Get HTTP method (default to GET)
    method = os.environ.get("METHOD", "GET").upper()
    
    # Validate HTTP method
    valid_methods = ["GET", "HEAD", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"]
    if method not in valid_methods:
        print(f"Error: Invalid HTTP method: {method}")
        print(f"Supported methods: {', '.join(valid_methods)}")
        sys.exit(2)
    
    print(f"Endpoint: {endpoint}")
    print(f"Expected status code: {expected_status_code}")
    print(f"HTTP method: {method}")
    
    # Make the request using urllib
    try:
        # Create a request with the specified method
        request = urllib.request.Request(endpoint, method=method)
        
        # Set a timeout (in seconds)
        timeout = 30
        
        # Make the request and get the response
        try:
            with urllib.request.urlopen(request, timeout=timeout) as response:
                status_code = response.getcode()
        except urllib.error.HTTPError as e:
            # HTTPError already contains the status code
            status_code = e.code
        
        print(f"Actual status code: {status_code}")
        
        # Check if status code matches expected
        if status_code == expected_status_code:
            print("✅ Status check passed")
            sys.exit(0)
        else:
            print("❌ Status check failed")
            sys.exit(1)
            
    except urllib.error.URLError as e:
        if isinstance(e.reason, socket.timeout):
            print(f"Error: Request timed out after {timeout} seconds")
        else:
            print(f"Error making request: {e.reason}")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    check_endpoint_status()
