#!/usr/bin/python3

from makeDeb import makeDeb

def makeAllDebs(args):
    for dict in args:
        makeDeb(dict["binary"], dict["version"], dict["architecture"])

def main():
    import sys
    args = []

    for i in range(1, len(sys.argv), 3):
        args.append({"binary": sys.argv[i], "version": sys.argv[i + 1], "architecture": sys.argv[i + 2]})
    
    makeAllDebs(args)

if __name__ == "__main__":
    main()