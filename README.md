## rq_network_flutter: Flutter Network API Layer

**A simple and easy-to-use network API layer for Flutter applications.**

This package, **rq_network_flutter**, provides a clean and concise API for making network requests and handling responses in your Flutter projects. With minimal code, you can easily send requests, parse responses, and handle errors.

**Note:** This package is still under development, and its features and documentation are continuously evolving.


### Features


* **Simple API:** Make `GET`, `POST`, `PUT`, and `DELETE` requests with a single line of code.
* **Automatic JSON serialization:** Automatically convert objects to and from JSON.
* **Error handling:** Gracefully handle network and response errors.
* **Interceptors:** Intercept requests and responses for custom behavior.
* **Cancellable requests:** Stop ongoing network requests.
* **Built-in progress tracking:** Monitor the progress of network requests.
* **Offline support:** (Coming soon) Cache responses for offline use.


### Getting Started


**1. Add the package:**

Open your `pubspec.yaml` file and add the following line under the `dependencies` section:

```yaml
dependencies:
  rq_network_flutter: ^latest
