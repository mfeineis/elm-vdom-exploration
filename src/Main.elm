port module Main exposing (main)

import Html exposing (Html)
import Html.Events as Events
import Html.Keyed as Keyed


port fromElm : String -> Cmd msg


type alias Model =
    { mounted : Bool
    , position : Int
    }


type Msg
    = Up
    | Down
    | Mount
    | Unmount


main =
    Html.program
        { init = ( { position = 0, mounted = False }, fromElm "init" )
        , subscriptions = \_ -> Sub.none
        , update = update
        , view = view
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ position } as model) =
    case msg of
        Up ->
            ( { model | position = max 0 (position - 1) }, fromElm (toString msg) )

        Down ->
            ( { model | position = position + 1 }, fromElm (toString msg) )

        Mount ->
            ( { model | mounted = True }, fromElm (toString msg) )

        Unmount ->
            ( { model | mounted = False }, fromElm (toString msg) )


view : Model -> Html Msg
view { mounted, position } =
    Keyed.node "div"
        []
        [ ( "up", Html.button [ Events.onClick Up ] [ Html.text "Up" ] )
        , ( "down", Html.button [ Events.onClick Down ] [ Html.text "Down" ] )
        , ( "mount", Html.button [ Events.onClick Mount ] [ Html.text "Mount" ] )
        , ( "unmount", Html.button [ Events.onClick Unmount ] [ Html.text "Unmount" ] )
        , if mounted then
            ( "content-filled"
            , Keyed.ul []
                (List.map (\index -> ( toString index, Html.div [] [ Html.text (toString index) ] )) (List.range 0 position)
                    ++ [ ( "please-dont-kill-me", Html.node "my-element" [] [] )
                       ]
                    ++ List.map (\index -> ( toString (index + 30), Html.div [] [ Html.text (toString index) ] )) (List.range position 15)
                )
            )
          else
            ( "content-empty", Html.text "" )
        ]
