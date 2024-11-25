run:
	MONGODB_SERVICE=172.21.54.100:27017 MONGODB_USERNAME=root MONGODB_PASSWORD=fccCWi2eS7zDuI8n8Hamu2S5 flask run --debugger --reload

test_health:
	curl -X GET -i -w '\n' localhost:5000/health

test_count:
	curl -X GET -i -w '\n' localhost:5000/count

test_songs:
	curl -X GET -i -w '\n' localhost:5000/song

test_song_with_id_ok:
	curl -X GET -i -w '\n' localhost:5000/song/1

test_song_with_id_err:
	curl -X GET -i -w '\n' localhost:5000/song/100