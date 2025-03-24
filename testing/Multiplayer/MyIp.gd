extends Label

@onready var http_request: HTTPRequest = $HTTPRequest

func _ready() -> void:
	get_public_ip()
	text = get_local_ip()

func get_local_ip():
	var ips = IP.get_local_addresses()
	for ip in ips:
		if ip.begins_with("192.168.") or ip.begins_with("10.") or ip.begins_with("172."):
			return ip
	return "Unknown"



func get_public_ip():
	var headers = ["Content-Type: application/json"]
	http_request.request("https://api64.ipify.org?format=json",headers,HTTPClient.METHOD_GET)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		print("Public IP:", json["ip"])
		text = json["ip"]
	else:
		print("Failed to fetch public IP. Response code:", response_code)
