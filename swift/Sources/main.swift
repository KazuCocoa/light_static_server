import Foundation

import Kitura

import LoggerAPI
import HeliumLogger

#if os(Linux)
    import Glibc
#endif

let router = Router()
Log.logger = HeliumLogger()

enum HeadersContentType: String {
    case Text = "text/plain; charset=utf-8"
    case Json = "application/json; charset=utf-8"
}

struct Headers {
    func setContentText(response: RouterResponse) -> RouterResponse {
        response.headers["Content-Type"] = HeadersContentType.Text.rawValue
        return response
    }
}

let headers = Headers()

router.all("/static", middleware: StaticFileServer(path: "./static")) // default

// http://localhost:8090/users/1234 is matched with "/*" and "users/:userId"
router.get("/users/:userId") { request, response, next in
  defer {
    next()
  }

  headers.setContentText(response: response)
    .send(
      "request: \(request)\n" +
      "request.matchedPath: \(request.matchedPath)\n" +
      "request.parsedURL: \(request.parsedURL)\n" +
      "request.url: \(request.url)\n" +
      "request.parameters: \(request.parameters)\n"
    )
}

router.get("/users") { request, response, next in
  defer {
    next()
  }
  headers.setContentText(response: response)
    .send(
      "request: \(request)\n" +
      "request.matchedPath: \(request.matchedPath)\n" +
      "request.parsedURL.path: \(request.parsedURL.path)\n" +
      "request.url: \(request.url)\n"
    )
}

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
