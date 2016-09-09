import Foundation

public func validateGraphStructInternals(_ graphStruct: GraphStruct) -> Bool {
  return validateVertices(graphStruct) &&
    validateEdges(graphStruct)
}

private func graphIdForVertexId(graphs: GraphStructArray, vertexId: NSUUID) -> NSUUID? {
  let filtered = graphs.filter({
    return graphHasVertex(graph: $0, vertexId: vertexId)
  })
  if filtered.count == 1 {
    return filtered[0].id
  }
  return nil
}

private func graphHasVertex(graph: GraphStruct, vertexId: NSUUID) -> Bool {
  return graph
    .vertices
    .map({ $0.id })
    .contains(vertexId)
}

private func allVertexIdsUnique(_ allIds: [NSUUID]) -> Bool {
  let idCount = allIds.count
  let uniqueIdCount = dedupeIds(allIds).count
  return idCount == uniqueIdCount
}

private func dedupeIds(_ idArr: [NSUUID]) -> [NSUUID] {
  return idArr.reduce([NSUUID]()) {
    collect, id in
    if !collect.contains(id) {
      return collect + [id]
    }
    return collect
  }
}

private func validateVertices(_ graphStruct: GraphStruct) -> Bool {
  let matches = graphStruct.vertices.reduce([NSUUID]()) {
    idArr, vertex in
    if !idArr.contains(vertex.id) {
      return idArr + [vertex.id]
    }
    return idArr
  }
  return matches.count == graphStruct.vertices.count
}

private func validateEdges(_ graphStruct: GraphStruct) -> Bool {
  return graphStruct.edges.reduce(true) {
    valid, edge in
    let validFromVertexId = graphStruct.vertices.reduce(false) {
      exists, vertex in
      if vertex.id == edge.from {
        return true
      }
      return exists
    }
    let validToVertexId = graphStruct.vertices.reduce(false) {
      exists, vertex in
      if vertex.id == edge.to {
        return true
      }
      return exists
    }
    if !validFromVertexId || !validToVertexId {
      return false
    }
    return valid
  }
}
