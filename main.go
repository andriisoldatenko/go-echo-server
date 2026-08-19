package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

func echoHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("%s %s %s", r.Method, r.URL.Path, r.RemoteAddr)

	fmt.Fprintf(w, "Method: %s\n", r.Method)
	fmt.Fprintf(w, "URL:    %s\n", r.URL.String())
	fmt.Fprintf(w, "Proto:  %s\n", r.Proto)
	fmt.Fprintf(w, "Host:   %s\n", r.Host)
	fmt.Fprintf(w, "Remote: %s\n", r.RemoteAddr)
	fmt.Fprintf(w, "\n--- Headers ---\n")
	for k, v := range r.Header {
		fmt.Fprintf(w, "%s: %s\n", k, v)
	}

	if r.ContentLength > 0 {
		fmt.Fprintf(w, "\n--- Body ---\n")
		io.Copy(w, r.Body)
	}
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/", echoHandler)

	log.Printf("echo server listening on :%s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatalf("server error: %v", err)
	}
}
