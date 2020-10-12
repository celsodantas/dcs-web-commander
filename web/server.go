package main 

import (
  "fmt"
  "net/http"
)

func main() {
  http.HandleFunc("/", HandleRequest)
  http.HandleFunc("/command", HandleCommandRequest)
  http.ListenAndServe(":8080", nil)
}

func HandleCommandRequest(w http.ResponseWriter, r *http.Request) {
  if (r.Method != "POST") {
    http.NotFound(w, r)
    return
  }

  // TODO: write command to file
  path := r.URL.Path[1:]
  fmt.Fprintf(w, "Command: %s!", path)
}

func HandleRequest(w http.ResponseWriter, r *http.Request) {
  path := r.URL.Path[1:]
  fmt.Fprintf(w, "Hello, %s!", path)
}

