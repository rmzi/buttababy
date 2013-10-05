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

  Template.room.events
    "click #reset": ->
      player1 = Players.find({id: "1"}).fetch()[0]
      player2 = Players.find({id: "2"}).fetch()[0]
      player3 = Players.find({id: "3"}).fetch()[0]
      player4 = Players.find({id: "4"}).fetch()[0]

      Players.update(player1._id, {$set: {score: 0}});
      Players.update(player2._id, {$set: {score: 0}});
      Players.update(player3._id, {$set: {score: 0}});
      Players.update(player4._id, {$set: {score: 0}});      

  Template.player.rendered = ->
    console.log @.find('.score')
    data = @.data.score
    bar = d3.select(@.find('.score'))
    
    bar.append('div')
      .style('width', data*10 + 'px')

  ## Player 1 ##
  Template.player1.recipe = ->
    return Session.get("recipe")

  Template.player1.events
    "click #ready": ->
      console.log "I'm ready!"

      $.shake callback: ->
        player = Players.find({id: "1"}).fetch()[0]
        addScore(player._id)

    "click #recipies": ->
      Meteor.call("getRecipies", 2, (err, res) ->
        if err?
          console.log "There was an error", err
        else
          results = JSON.parse(res.content).results
          recipie = ""
          for result in results
            recipie = recipie + ", " + result.summary.title

          Session.set("recipe", recipie)
      )

  ## Player 2 ##
  Template.player2.recipe = ->
    return Session.get("recipe")

  Template.player2.events
    "click #ready": ->
      console.log "I'm ready!"

      $.shake callback: ->
        player = Players.find({id: "2"}).fetch()[0]
        addScore(player._id)

    "click #recipies": ->
      Meteor.call("getRecipies", 2, (err, res) ->
        if err?
          console.log "There was an error", err
        else
          results = JSON.parse(res.content).results
          recipie = ""
          for result in results
            recipie = recipie + ", " + result.summary.title

          Session.set("recipe", recipie)
      )

  ## Player 3 ##
  Template.player3.recipe = ->
    return Session.get("recipe")

  Template.player3.events
    "click #ready": ->
      console.log "I'm ready!"

      $.shake callback: ->
        player = Players.find({id: "3"}).fetch()[0]
        addScore(player._id)

    "click #recipies": ->
      Meteor.call("getRecipies", 2, (err, res) ->
        if err?
          console.log "There was an error", err
        else
          results = JSON.parse(res.content).results
          recipie = ""
          for result in results
            recipie = recipie + ", " + result.summary.title

          Session.set("recipe", recipie)
      )

  ## Player 4 ##
  Template.player4.recipe = ->
    return Session.get("recipe")

  Template.player4.events
    "click #ready": ->
      console.log "I'm ready!"

      $.shake callback: ->
        player = Players.find({id: "4"}).fetch()[0]
        addScore(player._id)

    "click #recipies": ->
      Meteor.call("getRecipies", 2, (err, res) ->
        if err?
          console.log "There was an error", err
        else
          results = JSON.parse(res.content).results
          recipie = ""
          for result in results
            recipie = recipie + ", " + result.summary.title

          Session.set("recipe", recipie)
      )

if Meteor.isServer
  Meteor.methods 
    getRecipies: (num) ->
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
