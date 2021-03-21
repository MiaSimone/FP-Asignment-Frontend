module Hello2 exposing (..)

import Browser

import Employee exposing (Employee)
import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import AllEmployees exposing(Employees, employeesDecoder)
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
  | Waiting
  | Loading
  | Succes (List Employee)

type Message
  = TryAgainPlease
  | EmployeesResult (Result Http.Error (List Employee))

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
            (Loading, getEmployees)

        EmployeesResult result ->
            case result of
                Ok employees -> (Succes employees, Cmd.none)
                Err error -> handleError error

getEmployees : Cmd Message
getEmployees = Http.get
    { url = "http://localhost:8080/FP-Asignment1/api/department/all_employees"
    , expect = Http.expectJson EmployeesResult employeesDecoder
    }

view : Model -> Html Message
view model =
    case model of
        Waiting -> button [ onClick TryAgainPlease ] [ text "Click for employees"]
        Failure msg -> text ("Something went wrong: "++msg)
        Loading -> text "... please wait ..."
        Succes employeeList ->
            div []
                [ viewEmployees employeeList]


viewEmployees : List Employee -> Html msg
viewEmployees employees =
    div []
        [ h3 [] [ text "Employees" ]
        , table []
            ([ viewTableHeader ] ++ List.map viewEmployee employees)
        ]


viewTableHeader : Html msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Firstname" ]
        , th []
            [ text "Lastname" ]
        , th []
            [ text "Email" ]
        , th []
            [ text "Department Code" ]
        , th []
            [ text "Department Name" ]
        , th []
            [ text "Department Description" ]
        ]


viewEmployee : Employee -> Html msg
viewEmployee employee =
    tr []
        [ td []
            [ text (String.fromInt employee.id) ]
        , td []
            [ text employee.firstName ]
        , td []
            [ text employee.lastName ]
        , td []
            [ text employee.email ]
        , td []
            [ text employee.depCode ]
        , td []
            [ text employee.depName ]
        , td []
            [ text employee.depDescription ]
        ]



subscriptions : Model -> Sub Message
subscriptions _ = Sub.none