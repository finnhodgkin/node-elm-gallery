port module Main exposing (..)

-- import Html.Events exposing (..)
-- import Json.Encode exposing (Value)

import Html exposing (..)
import Html.Attributes as HA exposing (..)
import Http exposing (..)
import Json.Decode exposing (..)
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
    , error : String
    }


init : ( Model, Cmd Msg )
init =
    let
        test =
            "./images/test.jpg"
    in
    ( Model test [ test, test, test ] [ "" ] "" ""
    , Task.attempt handleFetch (Http.toTask (Http.get "/imgs/all" decodeImageList))
    )


handleFetch : Result error (List String) -> Msg
handleFetch result =
    case result of
        Ok result ->
            DisplayAllThumbs result

        Err _ ->
            ShowErrorMessage "Error fetching list of images."


decodeImageList : Decoder (List String)
decodeImageList =
    Json.Decode.list Json.Decode.string


type Msg
    = DisplayAllThumbs (List String)
    | ShowErrorMessage String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DisplayAllThumbs thumbs ->
            ( { model | allThumbs = thumbs }, Cmd.none )

        ShowErrorMessage errorString ->
            ( { model | error = errorString }, Cmd.none )


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
        [ Html.img [ src model.singleImage, class "single" ] []
        , Html.section []
            (List.map buildSingleThumb model.singleThumbs)
        ]


buildSingleThumb : String -> Html Msg
buildSingleThumb thumb =
    Html.figure
        [ class "singleThumb"
        , style [ ( "background-image", "url(./images/" ++ thumb ++ ")" ) ]
        ]
        []


home : Model -> Html Msg
home model =
    div []
        [ div [] [ text model.error ]
        , div [] (List.map buildAllThumbs model.allThumbs)
        ]


buildAllThumbs : String -> Html Msg
buildAllThumbs thumbs =
    Html.figure
        [ class "allThumb"
        , style [ ( "background-image", "url(./images/" ++ thumbs ++ "/thumb.jpg)" ) ]
        ]
        []


subscriptions : a -> Sub Msg
subscriptions model =
    Sub.none
