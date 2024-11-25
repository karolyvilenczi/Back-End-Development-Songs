run:
	MONGODB_SERVICE=172.21.54.100:27017 MONGODB_USERNAME=root MONGODB_PASSWORD=fccCWi2eS7zDuI8n8Hamu2S5 flask run --debugger --reload

test_health:
	curl -X GET -i -w '\n' localhost:5000/health

test_count:
	curl -X GET -i -w '\n' localhost:5000/count