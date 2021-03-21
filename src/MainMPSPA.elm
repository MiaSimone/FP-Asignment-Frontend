module MainMPSPA exposing (..)


import Browser
import Html exposing (Html, div, text)
import MenuMPSPA as Menu exposing (MenuModel)
import ListMPSPA as List exposing (ListModel)
import MessageMPSPA as Message exposing (Message)


main = Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

{-
type alias MainModel =
    { menu : MenuModel
    , list : ListModel
    }
-}
type MainModel
    = MenuModel MenuModel
    | ListModel ListModel
    | Empty


init : () -> (MainModel, Cmd Message)
--init _ = (MainModel (MenuModel "") (ListModel ""), Cmd.none)
init _ = (Empty, Cmd.none)

update : Message -> MainModel -> (MainModel, Cmd Message)
update  message model =
    case model of
        MenuModel menu -> (MenuModel (Menu.update message menu), Cmd.none)
        ListModel list -> (ListModel (List.update message list), Cmd.none)
        Empty -> (model, Cmd.none)

view : MainModel -> Html Message
view model =
    case model of
        MenuModel menu -> Menu.view menu
        ListModel list -> List.view list
        Empty -> div [] [text "No menu yet"]


subscriptions : MainModel -> Sub Message
subscriptions _ = Sub.none