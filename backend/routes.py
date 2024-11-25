from . import app

import os
import json
import pymongo
from flask import jsonify, request, make_response, abort, url_for  # noqa; F401
from http import HTTPStatus

from pymongo import MongoClient
from bson import json_util
from pymongo.errors import OperationFailure
from pymongo.results import InsertOneResult
from bson.objectid import ObjectId
import sys

SITE_ROOT = os.path.realpath(os.path.dirname(__file__))
json_url = os.path.join(SITE_ROOT, "data", "songs.json")
songs_list: list = json.load(open(json_url))

# client = MongoClient(
#     f"mongodb://{app.config['MONGO_USERNAME']}:{app.config['MONGO_PASSWORD']}@localhost")
mongodb_service = os.environ.get('MONGODB_SERVICE')
mongodb_username = os.environ.get('MONGODB_USERNAME')
mongodb_password = os.environ.get('MONGODB_PASSWORD')
mongodb_port = os.environ.get('MONGODB_PORT')

print(f'The value of MONGODB_SERVICE is: {mongodb_service}')

if mongodb_service == None:
    app.logger.error('Missing MongoDB server in the MONGODB_SERVICE variable')
    # abort(500, 'Missing MongoDB server in the MONGODB_SERVICE variable')
    sys.exit(1)

if mongodb_username and mongodb_password:
    url = f"mongodb://{mongodb_username}:{mongodb_password}@{mongodb_service}"
else:
    url = f"mongodb://{mongodb_service}"


print(f"connecting to url: {url}")

try:
    client = MongoClient(url)
except OperationFailure as e:
    app.logger.error(f"Authentication error: {str(e)}")

db = client.songs
db.songs.drop()
db.songs.insert_many(songs_list)

def parse_json(data):
    return json.loads(json_util.dumps(data))

######################################################################
# INSERT CODE HERE
######################################################################

def get_song_by_id(id):
    filter_query = {"id": id}
    
    try:
        db_resp_song = db.songs.find_one(filter_query)
    except Exception as e:
        app.logger.error(f"Error fetching song with id {id}: {e}")
        return None
    else:
        app.logger.info(f"Song with id {id} found.")
        return db_resp_song


@app.route("/health", methods=["GET"])
def fetch_health():
    return jsonify({"status":"OK"}), 200


@app.route("/count", methods=["GET"])
def fetch_count():
    
    filter_query = {}
    try:
        songs_count = db.songs.count_documents(filter_query)
    except Exception as e:
        app.logger.error(f"Error fetching songs count: {e}")
        resp = {"response":"Server error"}
        return jsonify(resp), 404
    else:
        resp = {"count":songs_count}
        app.logger.info(f"Fetched songs count: {songs_count}")
        return jsonify(resp), 200


@app.route("/song/<int:id>", methods=["GET"])
def fetch_song_by_id(id):
    
    db_resp_song = get_song_by_id(id = id)
    
    if not db_resp_song:
        return jsonify({"message": "song with id not found"}), 404

    try:
        song = json_util.dumps(db_resp_song)
    except Exception as e:
        app.logger.error(f"Error serializing mongo response {db_resp_song}: {e}")
        return jsonify({"message": "song with id not found"}), 404
    else:
        return jsonify(song), 200


@app.route("/song/<int:id>", methods=["DELETE"])
def delete_song(id):
    
    if not id:
        app.logger.error("Field missing") 
        return jsonify({"error": "No data provided"}), 400
        
    filter_query = {"id":id}
        
    try:
        db_resp_delete_song = db.songs.delete_one(filter_query)        
    except Exception as e:
        app.logger.error(f"Error deleting song with id: {id}: {e}")
        return jsonify({"error": "Error deleting song."}), 500
    
    if db_resp_delete_song.deleted_count == 0:
        return jsonify({"message": "song not found"}), 404
    else:
        app.logger.info(f"Song with id: {id} deleted.")
        return jsonify({}), 204


@app.route("/song", methods=["POST"])
def create_song():
    
    data = None
    try:
        data = request.get_json()
    except Exception as e:
        app.logger.error(f"Cannot process request: {e}")
        return jsonify({"error": "Bad request"}), 400

    if not data:
        return jsonify({"error": "No data provided"}), 400

    id, title, lyrics = data.get("id"), data.get("title"), data.get("lyrics")
    if None in [id, title, lyrics]:
        app.logger.error("Field missing") 
        return jsonify({"error": "No data provided"}), 400
    
    # all data given, test if song present
    db_resp_song = get_song_by_id(id)
    if db_resp_song:
        return jsonify({"Message": f"song with id '{id}' already present"}), 302

    # create if not present

    try:
        db_resp_new_song = db.songs.insert_one(data)        
    except Exception as e:
        app.logger.error(f"Error creating song with data\n {data}: {e}")
        resp = {"message": "Cannot create song"}
        return jsonify(resp), 500
    else:
        song_created_id = json_util.dumps(db_resp_new_song.inserted_id)
        resp_created = {"inserted id":song_created_id}
        return jsonify(resp_created), 201
         

@app.route("/song", methods=["GET"])
def fetch_songs():
    filter_query = {}
    try:
        songs = json_util.dumps(db.songs.find(filter_query), default=str)
    except Exception as e:
        app.logger.error(f"Error fetching songs: {e}")
        resp = {"response":"Server error"}
        return jsonify(resp), 404
    else:
        resp = {"songs":songs}
        app.logger.info(f"Fetched songs: {songs}")
        return jsonify(resp), 200