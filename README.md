# fish function for go build

编译工具的fish脚本。

It's like the [golang-crosscompile](http://github.com/davecheney/golang-crosscompile) for `go build`.

example:

```fish
    gobuild linux amd64        --> GOOS = amd64;GOARCH = linux; go build
    gobuild linux amd64 samll  --> GOOS = amd64;GOARCH = linux; go build -ldflags "-s -w"
    gobuild linux amd64 -ldflags \"-s -w\"  --> like prev cmd
```

Download it  to the [oh-my-fish]( https://github.com/oh-my-fish/oh-my-fish)/plugins or add to functions of fish.
