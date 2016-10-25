import Kitura
import HeliumLogger

HeliumLogger.use()

let router = Router()

router.get("/*") { request, response, next in
  response.send(
    "request: \(request)\n" +
    "request.matchedPath: \(request.matchedPath)\n" +
    "request.parsedURL.path: \(request.parsedURL.path)\n" +
    "request.url: \(request.url)\n"
  )
  next()
}

// http://localhost:8090/users/1234 is matched with "/*" and "users/:userId"
router.get("/users/:userId") { request, response, next in
  response.send(
    "request: \(request)\n" +
    "request.matchedPath: \(request.matchedPath)\n" +
    "request.parsedURL: \(request.parsedURL)\n" +
    "request.url: \(request.url)\n" +
    "request.parameters: \(request.parameters)\n"
  )
  next()
}

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
