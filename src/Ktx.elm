port module Ktx exposing (Model, init, main, subscriptions, update, view)

import Browser
import Element exposing (..)
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes
import Json.Encode as E


port render : E.Value -> Cmd msg


main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type alias Model =
    String


init : () -> ( Model, Cmd Msg )
init _ =
    ( "\\int_a^b x dx", Cmd.none )


type Msg
    = NoOp
    | TextInput String


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


sendToKatex : String -> Cmd msg
sendToKatex s =
    render <|
        E.object
            [ ( "id", E.string "hole" )
            , ( "eq", E.string s )
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        TextInput t ->
            ( t, sendToKatex t )


modelToString : Model -> String
modelToString model =
    model


view : Model -> Html Msg
view model =
    layout []
        (column
            [ padding 10
            , spacing 10
            , width fill
            , centerX
            ]
            [ el
                [ htmlAttribute <| Html.Attributes.id "hole"
                , centerX
                ]
                (text " ")
            , Input.text
                []
                { label =
                    Input.labelHidden "raw LaTex Input"
                , onChange = TextInput
                , placeholder = Nothing
                , text = model
                }
            ]
        )
