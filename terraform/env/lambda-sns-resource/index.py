import os

def handler(event, context):
    hello = os.environ.get('HELLO')
    print(f"Hello {hello}!")
