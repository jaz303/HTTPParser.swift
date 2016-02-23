import CHTTPParser

public typealias HTTPParserState = http_parser
public typealias HTTPParserType = http_parser_type
public typealias HTTPParserCallback = http_cb
public typealias HTTPParserDataCallback = http_data_cb

// TODO: http_method_str
// TODO: http_errno_name
// TODO: http_errno_description
// TODO: http_parser_pause

public class HTTPParser {
	public static let version: UInt = http_parser_version()

	public static var versionMajor: Int {
		get { return Int((self.version >> 16) & 0xFF) }
	}
	
	public static var versionMinor: Int {
		get { return Int((self.version >> 8) & 0xFF) }
	}
	
	public static var versionPatch: Int {
		get { return Int(self.version & 0xFF) }
	}

	init(type: HTTPParserType = HTTP_BOTH) {
		http_parser_init(&parser, type)
		http_parser_settings_init(&settings)
	}

	//
	//

	public func execute(data: Array<Int8>) {
		data.withUnsafeBufferPointer() { (cArray) in
			http_parser_execute(&parser, &settings, cArray.baseAddress, data.count)
		}
	}

	public func execute(data: UnsafePointer<Int8>, length: Int) {
		http_parser_execute(&parser, &settings, data, length)
	}

	//
	//

	public var shouldKeepAlive: Bool {
		get { return http_should_keep_alive(&parser) > 0 }
	}

	public var bodyIsFinal: Bool {
		get { return http_body_is_final(&parser) > 0 }
	}

	public var majorVersion: Int {
		get { return Int(parser.http_major) }
	}

	public var minorVersion: Int {
		get { return Int(parser.http_minor) }
	}

	public var statusCode: Int {
		get { return Int(parser.status_code) }
	}

	public var method: Int {
		get { return Int(parser.method) }
	}

/*
	public var methodName: String {
		get { return http_method_str(self.method) }
	}
*/

	//
	// Callbacks

	public var onMessageBegin: HTTPParserCallback? {
		get { return settings.on_message_begin }
		set(cb) { settings.on_message_begin = cb }
	}

	public var onURL: HTTPParserDataCallback? {
		get { return settings.on_url }
		set(cb) { settings.on_url = cb }
	}

	public var onStatus: HTTPParserDataCallback? {
		get { return settings.on_status }
		set(cb) { settings.on_status = cb }
	}

	public var onHeaderField: HTTPParserDataCallback? {
		get { return settings.on_header_field }
		set(cb) { settings.on_header_field = cb }
	}

	public var onHeaderValue: HTTPParserDataCallback? {
		get { return settings.on_header_value }
		set(cb) { settings.on_header_value = cb }
	}

	public var onHeadersComplete: HTTPParserCallback? {
		get { return settings.on_headers_complete }
		set(cb) { settings.on_headers_complete = cb }
	}

	public var onBody: HTTPParserDataCallback? {
		get { return settings.on_body }
		set(cb) { settings.on_body = cb }
	}

	public var onMessageComplete: HTTPParserCallback? {
		get { return settings.on_message_complete }
		set(cb) { settings.on_message_complete = cb }
	}

	public var onChunkHeader: HTTPParserCallback? {
		get { return settings.on_chunk_header }
		set(cb) { settings.on_chunk_header = cb }
	}

	public var onChunkComplete: HTTPParserCallback? {
		get { return settings.on_chunk_complete }
		set(cb) { settings.on_chunk_complete = cb }
	}

	//
	//

	var parser = http_parser()
	var settings = http_parser_settings()
}
