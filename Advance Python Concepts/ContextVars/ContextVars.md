# Context Variables in Python

## What are context variables?

`contextvars` provides a way to store values that are local to the current execution context. This is especially useful in asynchronous programs, where multiple tasks may run at the same time.

## Why use them?

- They avoid shared-state bugs in async code.
- They keep request-specific data isolated.
- They are useful for request IDs, user sessions, and tracing.

## Key idea

A `ContextVar` behaves like a variable that is unique to the current context. Each task or thread can have its own value without overwriting another task's data.

## Example

The Python example in this folder shows two requests running at the same time. Even though both requests use the same variable name, each one keeps its own request ID.

## When to use `contextvars`

Use `contextvars` when you need values that should follow a single flow of execution, such as:

- tracking a request ID in a web server
- storing user context in async services
- keeping trace information for debugging
