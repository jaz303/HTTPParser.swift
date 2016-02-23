let parser = HTTPParser()

print("HTTP parser version",
	HTTPParser.versionMajor,
	HTTPParser.versionMinor,
	HTTPParser.versionPatch
)

parser.onMessageBegin = { (_) in
	print(parser.majorVersion)
	return 0
}

parser.onURL = { (_, data, len) in
	print(data[0])
	return 0
}
