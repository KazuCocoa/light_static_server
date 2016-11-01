import Foundation

import Kitura
import KituraStencil

import LoggerAPI
import HeliumLogger

#if os(Linux)
    import Glibc
#endif

let router = Router()
router.add(templateEngine: StencilTemplateEngine())

Log.logger = HeliumLogger()

enum HeadersContentType: String {
    case Html = "text/html; charset=utf-8"
    case Text = "text/plain; charset=utf-8"
    case Json = "application/json; charset=utf-8"
}

struct Headers {
    func setContentText(response: RouterResponse, type: HeadersContentType) -> RouterResponse {
        response.headers["Content-Type"] = type.rawValue
        return response
    }
}

let headers = Headers()

router.all("/static", middleware: StaticFileServer(path: "./static")) // default

router.get("/files/*") { request, response, next in
  defer {
    next()
  }

  let url = request.url
  let filteredPath = url.substring(from: url.index(url.startIndex, offsetBy: 7))

  var context = [
     "articles": [
       ["title": "url: \(filteredPath)", "author": "my name"]
     ]
  ]

  try headers.setContentText(response: response, type: HeadersContentType.Html)
        .render("document.stencil", context: context).end()
}

// http://localhost:8090/users/1234 is matched with "/*" and "users/:userId"
router.get("/*") { request, response, next in
  defer {
    next()
  }

  headers.setContentText(response: response, type: HeadersContentType.Text)
    .send(
      "request: \(request)\n" +
      "request.matchedPath: \(request.matchedPath)\n" +
      "request.parsedURL: \(request.parsedURL)\n" +
      "request.url: \(request.url)\n" +
      "request.parameters: \(request.parameters)\n"
    )
}

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
