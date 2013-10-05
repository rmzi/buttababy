Players = new Meteor.Collection("players")

if Meteor.isClient
  Meteor.Router.add
    "/": "room"
    "/1": "player1"
    "/2": "player2"
    "/3": "player3"
    "/4": "player4"

  ## Room ##
  Template.room.players = ->
    Players.find {}

  Template.room.player1 = ->
    #Players.

  ## Player 1 ##
  Template.player1.events
    "click #ready": ->


    "click #shake": ->
      player = Players.find({id: "1"}).fetch()[0]
      console.log player._id
      Players.update(player._id, {$inc: {score: 1}});

      console.log "Player Score:", player.score

if Meteor.isServer
  Meteor.startup ->
    if Players.find().count() is 0
      names = ["1", "2", "3", "4"]
      i = 0

      while i < names.length
        console.log "Inserting ", i
        Players.insert
          id: names[i]
          score: 0

        i++

# code to run on server at startup
