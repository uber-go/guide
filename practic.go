package main

import "fmt"

func main() {
	fmt.Println("some practics")
	//if err := foo.Open("foo"); err != nil {
	//	if foo.IsNotFoundError(err) {
	//		// handle
	//	} else {
	//		panic("unknown error")
	//	}
	//}
}

// package foo

type errNotFound struct {
	file string
}

func (e errNotFound) Error() string {
	return fmt.Sprintf("file %q not found", e.file)
}

func IsNotFoundError(err error) bool {
	_, ok := err.(errNotFound)
	return ok
}

func Open(file string) error {
	return errNotFound{file: file}
}

// package bar
