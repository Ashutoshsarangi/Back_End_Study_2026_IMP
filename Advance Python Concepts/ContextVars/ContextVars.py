"""Example of using contextvars for request-scoped state in async code."""

import asyncio
import random
from contextvars import ContextVar

request_id_var: ContextVar[str] = ContextVar("request_id")


async def log_message(message: str) -> None:
    """Print a message with the current request ID."""
    req_id = request_id_var.get()
    print(f"[{req_id}] {message}")


async def handle_request(req_name: str) -> None:
    """Simulate one request with its own isolated context value."""
    request_id_var.set(req_name)

    await log_message("Processing started")
    await asyncio.sleep(random.uniform(0.1, 0.5))
    await log_message("Database query finished")
    await log_message("Request completed")


async def main() -> None:
    """Run two requests concurrently to show context isolation."""
    await asyncio.gather(
        handle_request("REQ-A"),
        handle_request("REQ-B"),
    )


if __name__ == "__main__":
    asyncio.run(main())

# The Output
# Notice how the logs do not mix up the IDs, even though log_message doesn't accept a request_id argument and both tasks run at the same time:

# Plaintext
# [REQ-A] Processing started...
# [REQ-B] Processing started...
# [REQ-B] Database query finished.
# [REQ-B] Request complete.
# [REQ-A] Database query finished.
# [REQ-A] Request complete.