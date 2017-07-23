port module Main exposing (..)

import Html exposing (..)
import Html.Attributes as HA exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode exposing (..)
import Json.Encode exposing (Value)
import Task exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { singleImage : String
    , singleThumbs : List String
    , allThumbs : List String
    , route : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" [ "" ] [ "" ] "single", Cmd.none )


type Msg
    = UpdateInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateInput message ->
            ( { model | singleImage = "hi.jpg" }, Cmd.none )


view : Model -> Html Msg
view model =
    case model.route of
        "single" ->
            single model

        _ ->
            home model


single : Model -> Html Msg
single model =
    Html.section []
        [ Html.img [ src "./images/test.jpg" ] []
        ]


home : Model -> Html Msg
home model =
    div [] []


subscriptions : a -> Sub Msg
subscriptions model =
    Sub.none
