module MenuMPSPA exposing (..)
import Html exposing (..)
import MessageMPSPA as Message exposing (Message)


type alias MenuModel =
    { message : String }


update : Message -> MenuModel -> MenuModel
update message model = model


view : MenuModel -> Html Message
view model = div [] [ text "This is the menu"]




