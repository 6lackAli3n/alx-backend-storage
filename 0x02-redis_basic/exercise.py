#!/usr/bin/env python3
'''
A module for using the Redis NoSQL data storage.
'''


import redis
import uuid
from typing import Union, Callable, Optional
import functools

def count_calls(method: Callable) -> Callable:
    """
    Decorator that counts the number of calls to the decorated method.
    """
    @functools.wraps(method)
    def wrapper(self, *args, **kwargs):
        """
        Wrapper function that increments the call count and calls the original method.
        """
        key = method.__qualname__
        self._redis.incr(key)
        return method(self, *args, **kwargs)

    return wrapper


class Cache:
    def __init__(self):
        """Initialize the Cache instance."""
        self._redis = redis.Redis()
        self._redis.flushdb()
    
    @count_calls
    def store(self, data: Union[str, bytes, int, float]) -> str:
        """
        Store the data in Redis using a randomly generated key.
        """
        key = str(uuid.uuid4())
        self._redis.set(key, data)
        return key

    def get(self, key: str, fn: Optional[
        Callable] = None) -> Union[
                str, bytes, int, float, None]:
        """
        Retrieve data from Redis and optionally apply a conversion function.
        """
        data = self._redis.get(key)
        if data is None:
            return None

        if fn:
            return fn(data)
        return data

    def get_str(self, key: str) -> Optional[str]:
        """
        Retrieve a string from Redis by decoding the byte string.
        """
        return self.get(key, lambda d: d.decode("utf-8"))

    def get_int(self, key: str) -> Optional[int]:
        """
        Retrieve an integer from Redis.
        """
        return self.get(key, lambda d: int(d))
