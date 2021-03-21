module Main exposing (..)

import Browser

import Html exposing (..)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Http
import Employee exposing(Employee, employeeDecoder)
import AllEmployees exposing(Employees, employeesDecoder)
import EmployeeByID exposing (InputModel)

-- import Json.Decode exposing (Decoder, field, int, map2, map3, map4, string)
-- import Json.Encode as Encode
-- main : Program flags ...
main = Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

type alias Input =
  { content : String
  }

type Model
  = Failure String
  | Saving String
  | Waiting
  | Loading
  | Succes1 Employee
  | Succes2 (List Employee)

type Msg
  = TryAgainPlease
  | AllEmpsButton
  | EmployeeResult (Result Http.Error Employee)
  | EmployeesResult (Result Http.Error (List Employee))

init : () -> (Model, Cmd Msg)
init _ = (Waiting, Cmd.none)

handleError : Http.Error -> (Model, Cmd Msg)
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


update : Msg -> Model -> (Model, Cmd Msg)
update message model =
    case message of
        TryAgainPlease ->
            (Loading, getRandomEmployee)

        AllEmpsButton ->
            (Loading, getEmployees)

        EmployeeResult result ->
            case result of
                Ok employee -> (Succes1 employee, Cmd.none)
                Err error -> handleError error

        EmployeesResult result ->
            case result of
                Ok employees -> (Succes2 employees, Cmd.none)
                Err error -> handleError error

getRandomEmployee : Cmd Msg
getRandomEmployee = Http.get
    { url = "http://localhost:8080/FP-Asignment1/api/department/random"
    , expect = Http.expectJson EmployeeResult employeeDecoder
    }

getEmployees : Cmd Msg
getEmployees = Http.get
    { url = "http://localhost:8080/FP-Asignment1/api/department/all_employees"
    , expect = Http.expectJson EmployeesResult employeesDecoder
    }

view : Model -> Html Msg
view model =
    case model of
        Waiting ->
            div []
                [ h3 [] [ text ("Random employees") ]
                , button [ onClick TryAgainPlease ] [ text "Click for random employee"]
                , h3 [] [ text ("All employees") ]
                , button [ onClick AllEmpsButton ] [ text "Click to show all employees"]
                ]
        Saving msg -> text ("... saving "++msg++"...")
        Failure msg -> text ("Something went wrong: "++msg)
        Loading -> text "... please wait ..."
        Succes1 employee ->
            div []
                [ h3 [] [ text ("Employee " ++ String.fromInt(employee.id)) ]
                , viewEmployee employee
                ]
        Succes2 employeeList ->
            div []
                [ viewEmployees employeeList]

-- Random Employee --

viewEmployee : Employee -> Html Msg
viewEmployee employee =
        div []
            [ p [] [ text ("ID: "++String.fromInt(employee.id)) ]
            , p [] [ text ("Name: "++employee.firstName++" "++employee.lastName) ]
            , p [] [ text ("Email: "++employee.email) ]
            , p [] [ text (employee.firstName++" "++employee.lastName++" works in "++employee.depName++" ("++employee.depCode++")") ]
            , p [] [ text ("Department description: "++employee.depDescription) ]
            , button [ onClick TryAgainPlease ] [ text "Click for another random employee" ]
            ]


-- All Employees --

viewEmployees : List Employee -> Html Msg
viewEmployees employees =
    div []
        [ h3 [] [ text "Employees" ]
        , table []
            ([ viewTableHeader ] ++ List.map viewSingleEmployee employees)
        ]


viewTableHeader : Html Msg
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


viewSingleEmployee : Employee -> Html Msg
viewSingleEmployee employee =
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



subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none