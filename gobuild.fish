

# build smaller 20%
function gobuild.small
  go build -ldflags "-s -w"
  #echo "Note: use upx to compress"
end

# go crosscompile.bash to fish
function gobuild

  if test (count $argv) -lt 2
    gobuild.helper
    return 1
  end

  if  gobuild.isgoarch $argv[1]
    # env GOARCH "$argv[1]"
    echo "set GOARCH = " $argv[1]
  else
    echo "Error: set os Name Form goarchs darwin freebsd linux windows openbsd"
    return 1
  end

  if  gobuild.isgoos $argv[2]
    # env GOOS "$argv[2]"
    echo "set GOOS = " $argv[2]
  else
    echo "Error: set GOOS Form 386 amd64"
    return 1
  end

  # set env
  set -lx GOOS "$argv[1]"
  set -lx GOARCH "$argv[2]"

  set -l cmd go build

  # 三个以上的参数
  if test (count $argv) -gt 2
    switch $argv[3]
      case "make"
        gobuild.makego $argv[1] $argv[2]
      case "small"
        set cmd "go build -ldflags \"-s -w\""
      case '*'
        set cmd go build
        for i in $argv
          switch $i
            case $argv[1]
            case $argv[2]
            case '*'
              set cmd $cmd $i
          end
        end
    end
  end

  echo $cmd
  eval $cmd
  return 0

end

function gobuild.isgoarch
  set -l goarchs darwin freebsd linux windows openbsd

  for i in $goarchs
    if test $argv[1] = $i
      return 0
    end
  end

  return 1
end

function gobuild.isgoos
  set -l gooss 386 amd64

  for i in $gooss
    if test $argv[1] = $i
      return 0
    end
  end

  return 1
end

function gobuild.helper
  echo 'darwin/386 darwin/amd64 freebsd/386 freebsd/amd64 freebsd/arm linux/386 linux/amd64 linux/arm windows/386 windows/amd64 openbsd/386 openbsd/amd64'

  echo 'like this:'
  echo '> gobuild windows amd64'
  echo 'or this:'
  echo '> gobuild windows amd64 -ldflags \"-s -w\"'

  echo 'rebuild go use make.bash,like this'
  echo '> gobuild windows amd64 make'
end

function gobuild.makego

  if test (count $argv) -lt 2
    echo "use like:"
    echo "gobuild.makego windows 386"
    return 1
  end

  if  gobuild.isgoarch $argv[1]
    # env GOARCH "$argv[1]"
    echo "set GOARCH = " $argv[1]
  else
    echo "Error: Set goarchs from [FreeBSD Linux windows OpenBSD Darwin] ."
    return 1
  end

  if  gobuild.isgoos $argv[2]
    # env GOOS "$argv[2]"
    echo "set GOOS = " $argv[2]
  else
    echo "Error: Set GOOS from [386 amd64]."
    return 1
  end

  # set env
  set -lx GOOS "$argv[1]"
  set -lx GOARCH "$argv[2]"

  set lpwd (pwd)
  cd (go env GOROOT)
  cd src
  bash ./make.bash
  cd $lpwd

end
