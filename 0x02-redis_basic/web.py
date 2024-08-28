#!/usr/bin/env python3
'''A module with tools for request caching and tracking.
'''

import requests
import redis
from typing import Callable

# Initialize Redis connection
r = redis.Redis()

def count_requests(method: Callable) -> Callable:
    """
    Decorator to count how many times a URL has been requested.
    """
    def wrapper(url: str) -> str:
        # Increment the counter for the URL
        r.incr(f"count:{url}")
        return method(url)
    return wrapper

def cache_page(method: Callable) -> Callable:
    """
    Decorator to cache the page content with an expiration time.
    """
    def wrapper(url: str) -> str:
        # Check if the content is already cached
        cached_content = r.get(f"cached:{url}")
        if cached_content:
            return cached_content.decode("utf-8")

        # Fetch the content and cache it
        content = method(url)
        r.setex(f"cached:{url}", 10, content)
        return content
    return wrapper

@count_requests
@cache_page
def get_page(url: str) -> str:
    """
    Get the HTML content of a URL and cache it for 10 seconds.
    """
    response = requests.get(url)
    return response.text

# Example usage
if __name__ == "__main__":
    url = "http://slowwly.robertomurray.co.uk/delay/3000/url/http://www.google.com"
    print(get_page(url))  # This will take time the first time
    print(get_page(url))  # This should be instantaneous due to caching
    print(f"URL accessed {r.get(f'count:{url}').decode('utf-8')} times")
