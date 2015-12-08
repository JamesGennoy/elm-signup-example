module SignupForm where
-- declares that this is the SignupForm module, which is how other modules
-- will reference this one if they want to import it and reuse its code.


-- Elm’s "import" keyword works mostly like "require" in node.js.
-- The “exposing (..)” option says that we want to bring the Html module’s contents
-- into this file’s current namespace, so that instead of writing out
-- Html.form and Html.label we can use "form" and "label" without the "Html."
import Html exposing (..)

-- This works the same way; we also want to import the entire
-- Html.Events module into the current namespace.
import Html.Events exposing (..)

-- With this import we are only bringing a few specific functions into our
-- namespace, specifically "id", "type'", "for", "value", and "class".
import Html.Attributes exposing (id, type', for, value, class)


view model =
    div
        [ class "container"]
        [ div [class "row"]
            [ div [class "col-md-12"]
                [ h1 [] [ text "Sensational Signup Form" ]
                , form [ id "signup-form" ]
                [ div [class "form-group"]
                    [ label [ for "username-field" ] [ text "Username: " ]
                    , input [ id "username-field", class "form-control", type' "text", value model.username ] []
                    ]
                , div [class "form-group"]
                    [ label [ for "password-field" ] [ text "Password: " ]
                    , input [ id "password-field", class "form-control", type' "password", value model.password ] []
                    ]
                , button [ class "btn btn-default", type' "submit" ] [ text "Sign Up!" ]
                ]
            ]
        ]
        ]


-- Take a look at this starting model we’re passing to our view function.
-- Note that in Elm syntax, we use = to separate fields from values
-- instead of : like JavaScript uses for its object literals.
main =
    view { username = "", password = "" }
