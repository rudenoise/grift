import Foundation

public func readFromFile(path: String) -> Graph? {
  if let jsonStr = Grift.readFile(path: path) {
    if let data = jsonStr.data(using: String.Encoding.utf8) {
      do {
        let json = try JSONSerialization.jsonObject(
          with: data,
          options: .allowFragments
        )
        if let topicDict = json as? [String: Any] {
          return createGraph(rawData: topicDict)
        }
      } catch {
        print("error serializing topic JSON: \(error)")
        return nil
      }
    }
  }
  return nil
}

internal func writeGraphToFile(graph: Graph, path: String) -> Bool {
  if let json = graph.toJSON() {
    return writeStringToFile(string: json, path: path)
  }
  return false
}

private func createGraph(rawData: [String: Any]) -> Graph? {
  if
    let id = rawData["id"] as? String,
    let vertices = getVertices(rawData["vertices"] as? [[String: String]]),
    let edges = getEdges(rawData["edges"] as? [[String: String]])
  {
    return Graph(
      id: NSUUID(uuidString: id),
      vertices: vertices,
      edges: edges
    )
  }
  return nil
}

private func getVertices(_ verticesArrOpt: [[String: String]]?) -> [Vertex]? {
  if let verticesOptArr = verticesArrOpt {
    // unwrap vertices to array ignoring nil values
    let vertices: [Vertex] = verticesOptArr.flatMap({
      return getVertex($0) ?? nil
    })
    // any nil value invalidates graph
    if vertices.count == verticesOptArr.count {
      return vertices
    }
  }
  return nil
}

private func getVertex(_ vertexJSONOpt: [String: String]?) -> Vertex? {
  if let vertexJSON = vertexJSONOpt {
    if
      let id = vertexJSON["id"],
      let title = vertexJSON["title"],
      let body = vertexJSON["body"],
      // unwrap id to valid UUID
      let idUUID = NSUUID(uuidString: id)
    {
      return Vertex(id: idUUID, title: title, body: body)
    }
  }
  return nil
}

private func getEdges(_ edgesOpt: [[String: String]]?) -> [Edge]? {
  if let edgesOptArr = edgesOpt {
    let edges: [Edge] = edgesOptArr.flatMap({
      return getEdge($0) ?? nil
    })
    // ensure all edges are valid
    if edges.count == edgesOptArr.count {
      return edges
    }
  }
  return nil
}

private func getEdge(_ edgeJSONOpt: [String: String]?) -> Edge? {
  if let edgeJSON = edgeJSONOpt {
    if
      let id = edgeJSON["id"],
      let from = edgeJSON["from"],
      let to = edgeJSON["to"],
      // attempt to unwrap valid UUIDs
      let idUUID = NSUUID(uuidString: id),
      let fromUUID = NSUUID(uuidString: from),
      let toUUID = NSUUID(uuidString: to)
    {
      return Edge(
        id: idUUID,
        from: fromUUID,
        to: toUUID,
        note: edgeJSON["note"]
      )
    }
  }
  return nil
}
