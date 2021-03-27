module AddEmployee exposing (..)


import Browser
import Employee exposing (Employee, employeeDecoder, encodeEmployee)
import ErrorHandler
import Html exposing (Attribute, Html, a, button, div, input, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http



-- MAIN


main = Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

subscriptions : Employee -> Sub Msg
subscriptions _ = Sub.none


-- MODEL

{-
type alias Employee =
    { id: Int
    , firstName: String
    , lastName: String
    , email: String
    , depCode: String
    , depName: String
    , depDescription: String
    , addingEmployee : Employee
    , addingResult : String
    }
-}
type alias Employee =
        { id : Int
        , firstName : String
        , lastName : String
        , email : String
        , depCode : String
        , depName : String
        , depDescription : String
        , addingResult : String
        }

type AddingEmployeeModel
    = AddingEmployee Employee

init : () -> (Employee, Cmd Msg)
{-
init =
  { content = ""
  , employee = Nothing}
-}
init _ =
    (Employee 0 "" "" "" "" "" "" "", Cmd.none)

-- UPDATE

type Msg
  = FirstName String
  | LastName String
  | Email String
  | DepCode String
  | DepName String
  | DepDescription String
  | AddEmployee Employee
  | AddEmployeeResult (Result Http.Error String)

update : Msg -> Employee -> (Employee, Cmd Msg)
update msg employee =
  case msg of
    FirstName fname ->
      ({ employee | firstName = fname }, Cmd.none)

    LastName lname ->
      ({ employee | lastName = lname }, Cmd.none)

    Email email ->
      ({ employee | email = email }, Cmd.none)

    DepCode depCode ->
      ({ employee | depCode = depCode }, Cmd.none)

    DepName name ->
       ({ employee | depName = name }, Cmd.none)

    DepDescription des ->
       ({ employee | depDescription = des }, Cmd.none)

    AddEmployee e ->
       (employee, addEmployee e)

    AddEmployeeResult result ->
        case result of
            Ok message -> ({ employee | addingResult = message }, Cmd.none)
            Err error -> ({ employee | id = 0
                                       , firstName = ""
                                       , lastName = ""
                                       , email = ""
                                       , depCode = ""
                                       , depName = ""
                                       , depDescription = ""
                                       , addingResult = ErrorHandler.toString error }, Cmd.none)


addEmployee : Employee -> Cmd Msg
addEmployee employee = Http.post
    { url = "http://localhost:8080/FP-Asignment1/api/department"
    , body = Http.jsonBody (encodeEmployee employee)
    , expect = Http.expectString AddEmployeeResult
    }


-- VIEW


view : Employee -> Html Msg
view employee =
  div []
    [ viewInput "text" "firstName" employee.firstName FirstName
    , viewInput "text" "lastName" employee.lastName LastName
    , viewInput "text" "email" employee.email Email
    , viewInput "text" "depCode" employee.depCode DepCode
    , viewInput "text" "depName" employee.depName DepName
    , viewInput "text" "depDescription" employee.depDescription DepDescription
    , button [ onClick (AddEmployee employee)] [ text "Add Employee" ]
    , p [] [ text ("Result: "++employee.addingResult) ]
    , p[] [a [href "http://localhost:8000/src/Main.elm"] [ text "Go back"]]
    ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []
