port module Main exposing (..)

-- import Json.Encode exposing (Value)

import Html exposing (..)
import Html.Attributes as HA exposing (..)
import Html.Events exposing (..)
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
    , singleImageDirectory : String
    , singleImageLoaded : Maybe String
    , singleImageList : List String
    , allThumbs : List String
    , route : String
    , error : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" "" Nothing [ "" ] [ "" ] "" ""
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
    | GetSinglePage String
    | DisplaySingleResult (List String) String
    | ImageLoaded String
      -- | LoadingPainting String String
    | ShowSingleImage String String
    | SwapSingleImage String String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DisplayAllThumbs thumbs ->
            ( { model | allThumbs = thumbs }, Cmd.none )

        GetSinglePage imageDirectory ->
            ( model, getImage imageDirectory )

        DisplaySingleResult imageList directory ->
            let
                newModel =
                    { model | singleImageList = imageList, singleImage = "main.jpg", singleImageDirectory = directory }
            in
            ( { model | singleImageList = imageList, route = shouldSingleImage newModel, singleImage = "main.jpg", singleImageDirectory = directory }, Cmd.none )

        ShowErrorMessage errorString ->
            ( { model | error = errorString }, Cmd.none )

        ImageLoaded imgSrc ->
            ( { model | singleImageLoaded = Just imgSrc }, Cmd.none )

        ShowSingleImage directory imageName ->
            ( { model | singleImage = imageName, singleImageDirectory = directory }, getImage directory )

        SwapSingleImage directory imageName ->
            ( { model | singleImage = imageName }, Cmd.none )


shouldSingleImage : Model -> String
shouldSingleImage model =
    if model.singleImage /= "" && model.singleImageList /= [ "" ] then
        "single"
    else
        ""


getImage : String -> Cmd Msg
getImage imageDirectory =
    Task.attempt (handleSingleImageFetch imageDirectory) (Http.toTask (Http.get ("/imgs/single?image=" ++ imageDirectory) decodeImageList))


handleSingleImageFetch : String -> Result error (List String) -> Msg
handleSingleImageFetch directory result =
    case result of
        Ok result ->
            DisplaySingleResult result directory

        Err _ ->
            ShowErrorMessage "Error fetching list of images."


view : Model -> Html Msg
view model =
    case model.route of
        "single" ->
            single model

        _ ->
            home model


single : Model -> Html Msg
single model =
    let
        imageLoader =
            case model.singleImageLoaded of
                Just imageSrc ->
                    Html.img [ class "single", src imageSrc ] []

                Nothing ->
                    div
                        []
                        [ text "blah" ]

        imageDirectory =
            "./images/" ++ model.singleImageDirectory ++ "/"
    in
    Html.section []
        [ imageLoader
        , Html.section []
            (List.map (buildSingleThumb imageDirectory) model.singleImageList)
        , Html.img [ class "visuallyhidden", src (imageDirectory ++ model.singleImage), onLoadSrc ImageLoaded ] []
        , Html.section []
            (List.map preloadFullSize model.singleImageList)
        ]


preloadFullSize : String -> Html Msg
preloadFullSize image =
    Html.img [ class "visuallyhidden", src image ] []


onLoadSrc : (String -> msg) -> Html.Attribute msg
onLoadSrc tagger =
    on "load" (Json.Decode.map tagger targetSrc)


targetSrc : Json.Decode.Decoder String
targetSrc =
    Json.Decode.at [ "target", "src" ] Json.Decode.string


buildSingleThumb : String -> String -> Html Msg
buildSingleThumb directory image =
    Html.figure
        [ class "singleThumb"
        , style [ ( "background-image", "url(" ++ directory ++ "thumbs/" ++ image ++ ")" ) ]
        , onClick (SwapSingleImage directory image)
        ]
        []


home : Model -> Html Msg
home model =
    div []
        [ div [] [ text model.error ]
        , div [] (List.map buildAllThumbs model.allThumbs)
        ]


buildAllThumbs : String -> Html Msg
buildAllThumbs directory =
    Html.figure
        [ class "allThumb"
        , style [ ( "background-image", "url(./images/" ++ directory ++ "/thumbs/main.jpg)" ) ]
        , onClick (ShowSingleImage directory "main.jpg")
        ]
        []


subscriptions : a -> Sub Msg
subscriptions model =
    Sub.none
