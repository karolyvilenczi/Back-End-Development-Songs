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

test_add_song_ok:
	curl --request POST -i -w '\n' --url http://localhost:5000/song --header 'Content-Type: application/json' --data '{"id": 323, "lyrics": "Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\\n\\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.", "title": "in faucibus orci luctus et ultrices"}'

test_add_song_field_missing:
	curl --request POST -i -w '\n' --url http://localhost:5000/song --header 'Content-Type: application/json' --data '{"id": 323, "lyrics": "Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\\n\\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede."}'

test_add_song_malformed_json:
	curl --request POST -i -w '\n' --url http://localhost:5000/song --header 'Content-Type: application/json' --data '{id: 323, "lyrics": "Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\\n\\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede."}'


test_add_song_exists:
	curl --request POST -i -w '\n' --url http://localhost:5000/song --header 'Content-Type: application/json' --data '{"id": 3, "lyrics": "Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\\n\\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.", "title": "in faucibus orci luctus et ultrices"}'
