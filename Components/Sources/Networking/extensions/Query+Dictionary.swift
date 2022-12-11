extension Query {
  public func toDictionary() -> [String: Any] {
    return ["query": query]
  }
}
