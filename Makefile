run:
	MONGODB_SERVICE=172.21.237.195:27017 MONGODB_USERNAME=root MONGODB_PASSWORD=kmNVR4si106iQh2BUB1Q0eon flask run --debugger --reload

test_health:
	curl -X GET -i -w '\n' localhost:5000/health