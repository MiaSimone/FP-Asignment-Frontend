module ListMPSPA exposing (..)
import MessageMPSPA as Message exposing (Message)
import Html exposing (..)

type alias ListModel =
    { description : String }

update : Message -> ListModel -> ListModel
update message model = model

view : ListModel -> Html Message
view model = div [] [ text "This should be a list"]
