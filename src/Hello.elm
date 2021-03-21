module Hello exposing (..)

import Browser

import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Employee exposing(Employee, employeeDecoder)
import Hello3 exposing (viewAll)
-- import Json.Decode exposing (Decoder, field, int, map2, map3, map4, string)
-- import Json.Encode as Encode
-- main : Program flags ...
main = Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

type Model
  = Failure String
  | Saving String
  | Waiting
  | Loading
  | Succes Employee

type Message
  = TryAgainPlease
  | EmployeeResult (Result Http.Error Employee)

init : () -> (Model, Cmd Message)
init _ = (Waiting, Cmd.none)

handleError : Http.Error -> (Model, Cmd Message)
handleError error =
    case error of
        Http.BadStatus code ->
          (Failure <| "Code: "++(String.fromInt code), Cmd.none)
        Http.NetworkError ->
          (Failure "Network Error", Cmd.none)
        Http.BadBody err ->
          (Failure <| "Bad Body: "++err, Cmd.none)
        Http.Timeout ->
          (Failure "Timeout", Cmd.none)
        Http.BadUrl string ->
          (Failure <| "Bad Url: "++string, Cmd.none)


update : Message -> Model -> (Model, Cmd Message)
update message model =
    case message of
        TryAgainPlease ->
            (Loading, getEmployee1)

        EmployeeResult result ->
            case result of
                Ok employee -> (Succes employee, Cmd.none)
                Err error -> handleError error

getEmployee1 : Cmd Message
getEmployee1 = Http.get
    { url = "http://localhost:8080/FP-Asignment1/api/department/random"
    , expect = Http.expectJson EmployeeResult employeeDecoder
    }

getEmployees : Cmd Message
getEmployees = Http.get
    { url = "http://localhost:8080/FP-Asignment1/api/department/all_employees"
    , expect = Http.expectJson EmployeeResult employeeDecoder
    }

view : Model -> Html Message
view model =
    case model of
        Waiting -> button [ onClick TryAgainPlease ] [ text "Click for random employee"]
        Saving msg -> text ("... saving "++msg++"...")
        Failure msg -> text ("Something went wrong: "++msg)
        Loading -> text "... please wait ..."
        Succes employee ->
            div []
                [ h3 [] [ text ("Employee " ++ String.fromInt(employee.id)) ]
                , viewEmployee employee
                ]

viewEmployee : Employee -> Html Message
viewEmployee employee =
        div []
            [ p [] [ text ("ID: "++String.fromInt(employee.id)) ]
            , p [] [ text ("Name: "++employee.firstName++" "++employee.lastName) ]
            , p [] [ text ("Email: "++employee.email) ]
            , p [] [ text (employee.firstName++" "++employee.lastName++" works in "++employee.depName++" ("++employee.depCode++")") ]
            , p [] [ text ("Department description: "++employee.depDescription) ]
            , button [ onClick TryAgainPlease ] [ text "Click for another random employee" ]
            ]


subscriptions : Model -> Sub Message
subscriptions _ = Sub.none