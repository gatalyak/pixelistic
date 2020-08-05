db.createUser(
  {
    user  : "admin",
    pwd   : "PassMongo",
    roles : [
      {
        role : "readWrite",
        db   : "pixelapp",
      }
    ]
  }
)
