Game = new Meteor.Collection("game")
Players = new Meteor.Collection("players")

addScore = (id) ->
  Players.update(id, {$inc: {score: 1}});

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
    
  ## Player 1 ##
  Template.player1.events
    "click #ready": ->
      console.log "I'm ready!"

      $.shake callback: ->
        player = Players.find({id: "1"}).fetch()[0]
        addScore(player._id)

  ## Player 2 ##
  Template.player2.events
    "click #ready": ->
      console.log "I'm ready!"

      $.shake callback: ->
        player = Players.find({id: "2"}).fetch()[0]
        addScore(player._id)

  ## Player 3 ##
  Template.player3.events
    "click #ready": ->
      console.log "I'm ready!"

      $.shake callback: ->
        player = Players.find({id: "3"}).fetch()[0]
        addScore(player._id)

  ## Player 4 ##
  Template.player4.events
    "click #ready": ->
      console.log "I'm ready!"

      $.shake callback: ->
        player = Players.find({id: "4"}).fetch()[0]
        addScore(player._id)

    "click #recipies"
      Meteor.call("getRecipies", 2, (err, res) ->
        if err?
          console.log "There was an error", err
        else
          console.log "Success! Data:", JSON.parse(res.content).results
      )

    "click #shake": ->
      player = Players.find({id: "1"}).fetch()[0]
      console.log player._id
      Players.update(player._id, {$inc: {score: 1}});

      console.log "Player Score:", player.score

  Template.room.clock = ->
    clock = 30
    return  if not clock or clock is 0
    
    # format into M:SS
    min = Math.floor(clock / 60)
    sec = clock % 60
    min + ":" + ((if sec < 10 then ("0" + sec) else sec))

  Template.room.events
    'click #start': ->
      console.log 'click'

      # interval = Meteor.setInterval(->
      #   clock -= 1
      #   Games.update game_id,
      #     $set:
      #       clock: clock
      # , 1000)

if Meteor.isServer
  Meteor.methods 
    getRecipies: (butterAmt) ->
      @unblock()

      result = HTTP.call("GET", "http://api.pearson.com/v2/foodanddrink/recipes?limit=5&search=butter&apikey=pl13QLTr4XCoOuSNW2Kp9O5wP5SINfeE"
        #params:
         # user: userId
      )
      
      return result

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
