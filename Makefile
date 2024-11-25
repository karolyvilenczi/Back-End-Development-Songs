run:
	MONGODB_SERVICE=172.21.54.100:27017 MONGODB_USERNAME=root MONGODB_PASSWORD=fccCWi2eS7zDuI8n8Hamu2S5 flask run --debugger --reload

# GET
test_get_health:
	curl -X GET -i -w '\n' localhost:5000/health

test_get_count:
	curl -X GET -i -w '\n' localhost:5000/count

test_get_songs:
	curl -X GET -i -w '\n' localhost:5000/song

test_get_song_with_id_err:
	curl -X GET -i -w '\n' localhost:5000/song/100

test_get_song_with_id_1_ok:
	curl -X GET -i -w '\n' localhost:5000/song/1

test_get_song_with_id_323_ok:
	curl -X GET -i -w '\n' localhost:5000/song/323

# DELETE
test_delete_song:
	curl --request DELETE -i -w '\n' --url http://localhost:5000/song/323  --header 'Content-Type: "application/json"'

# POST
test_create_song_ok:
	curl --request POST -i -w '\n' --url http://localhost:5000/song --header 'Content-Type: application/json' --data '{"id": 323, "lyrics": "Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\\n\\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.", "title": "in faucibus orci luctus et ultrices"}'

test_create_song_field_missing:
	curl --request POST -i -w '\n' --url http://localhost:5000/song --header 'Content-Type: application/json' --data '{"id": 323, "lyrics": "Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\\n\\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede."}'

test_create_song_malformed_json:
	curl --request POST -i -w '\n' --url http://localhost:5000/song --header 'Content-Type: application/json' --data '{id: 323, "lyrics": "Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\\n\\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede."}'

test_create_song_exists:
	curl --request POST -i -w '\n' --url http://localhost:5000/song --header 'Content-Type: application/json' --data '{"id": 3, "lyrics": "Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\\n\\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.", "title": "in faucibus orci luctus et ultrices"}'

# GET, DELETE & POST song 323
recreate_323: test_create_song_ok test_get_song_with_id_323_ok 	test_delete_song



# PUT
test_update_song_1_ok:
	curl --request PUT -i -w '\n' --url http://localhost:5000/song/1 --header 'Content-Type: application/json' --data '{"lyrics": "yay hey yay yay", "title": "yay song"}'