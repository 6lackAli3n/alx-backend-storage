#!/usr/bin/env python3
""" 8-all.py """


def list_all(mongo_collection):
    """
    Lists all documents in the given MongoDB collection.
    """
    return [doc for doc in mongo_collection.find()]
