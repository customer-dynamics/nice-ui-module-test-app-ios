# CXone Chat UI Module Test App

## Description

This is a testbed project for demoing and testing various features of the NICE CXone Chat UI Module, a drop-in chat interface for iOS applications. The project is currently configured for a live chat chat channel, but the implementation is nearly the same for asynchronous messaging channels.

## Items of Interest

### AppDelegate

Passes the device token to the SDK for push notifications.

### ContentView

The main view that launches the chat. A simple example of how you might integrate the UI Module in your app. Also provides some options illustrating use of the CXone Guide web widget within an app context.

### ChatManager

Manages all chat behavior using the SDK and UI Module. Important to reference for all chat behavior, including launching the chat, custom fields, theme customization, and custom behavior.
