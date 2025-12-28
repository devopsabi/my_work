package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {
	r := mux.NewRouter()

	// Routes
	r.HandleFunc("/", HomeHandler).Methods("GET")
	r.HandleFunc("/hello/{name}", HelloHandler).Methods("GET")

	// Start server
	fmt.Println("Server running on http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", r))
}

// Handlers

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Welcome to the Go web server using mux!\n"))
}

func HelloHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)       // Get URL parameters
	name := vars["name"]
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(fmt.Sprintf("Hello, %s!\n", name)))
}

