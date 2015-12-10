module SignupForm where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (id, type', for, value, class, classList)

import StartApp
import Effects

import Http
import Task exposing (Task)
import Json.Decode exposing (succeed)

view actionDispatcher model =
    div
        [ class "container"]
        [ div [class "row"]
            [ div [class "col-md-12"]
                [ h1 [] [ text "Sensational Signup Form" ]
                , form [ id "signup-form" ]
                [ div [
                        classList [
                            ("form-group", True), ("has-error", model.errors.username /= "" || model.errors.usernameTaken == True)
                        ]
                    ]
                    [ label [ for "username-field", class "control-label" ] [ text "Username: " ]
                    , input [ id "username-field"
                        , class "form-control"
                        , type' "text", value model.username
                        , on "input" targetValue (\str -> Signal.message actionDispatcher { actionType = "SET_USERNAME", payload = str })
                        ]
                        []
                    , span [ class "help-block" ] [text (viewUsernameErrors model)]
                    ]
                , div [
                        classList [
                            ("form-group", True), ("has-error", model.errors.password /= "")
                        ]
                    ]
                    [ label [ for "password-field" ] [ text "Password: " ]
                    , input [ id "password-field"
                        , class "form-control"
                        , type' "password"
                        , value model.password
                        , on "input" targetValue (\str -> Signal.message actionDispatcher { actionType = "SET_PASSWORD", payload = str })
                        ]
                        []
                    , span [ class "help-block" ] [text model.errors.password]
                    ]
                , button [ class "btn btn-default", type' "button", onClick actionDispatcher { actionType = "VALIDATE", payload = "" } ] [ text "Sign Up" ]
                ]
            ]
        ]
        ]

initialErrors =
    { username = "", password = "", usernameTaken = False }

initialModel =
    { username = "", password = "", errors = initialErrors }

getErrors model =
    { username =
        if model.username == "" then
            "Please enter a username"
        else
            ""
    , password =
        if model.password == "" then
            "Please enter a password"
        else
            ""
    , usernameTaken = model.errors.usernameTaken
    }

withUsernameTaken isTaken model =
    let
        currentErrors =
            model.errors

        newErrors =
            { currentErrors | usernameTaken = isTaken }
    in
        { model | errors = newErrors }

viewUsernameErrors model =
   if model.errors.usernameTaken then
       "That username is taken!"
   else
       model.errors.username

update action model =
    if action.actionType == "VALIDATE" then
        let
            url =
                "https://api.github.com/users/" ++ model.username

            usernameTakenAction =
                { actionType = "USERNAME_TAKEN", payload = "" }

            usernameAvailableAction =
                { actionType = "USERNAME_AVAILABLE", payload = "" }

            request =
                Http.get (succeed usernameTakenAction) url

            neverFailingRequest =
                Task.onError request (\err -> Task.succeed usernameAvailableAction)
        in
            ({ model | errors = getErrors model }, Effects.task neverFailingRequest)
    else if action.actionType == "SET_USERNAME" then
        ( { model | username = action.payload }, Effects.none )
    else if action.actionType == "SET_PASSWORD" then
        ( { model | password = action.payload }, Effects.none )
    else if action.actionType == "USERNAME_TAKEN" then
        ( withUsernameTaken True model, Effects.none )
    else if action.actionType == "USERNAME_AVAILABLE" then
        ( withUsernameTaken False model, Effects.none )
    else
        ( model, Effects.none )

port tasks : Signal (Task Effects.Never ())

port tasks =
    app.tasks

app =
    StartApp.start
        { init = ( initialModel, Effects.none )
        , update = update
        , view = view
        , inputs = []
        }

main =
    app.html
