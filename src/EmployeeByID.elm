module EmployeeByID exposing (..)
-- A text input for reversing text. Very useful!
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/text_fields.html
--

import Browser
import Employee exposing (Employee, employeeDecoder)
import Html exposing (Attribute, Html, a, button, div, input, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import ErrorHandler



-- MAIN


main =
  Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }

subscriptions : InputModel -> Sub Msg
subscriptions _ = Sub.none

-- MODEL


type alias InputModel =
  { content : String
  , employee : Maybe Employee
  , note : String
  }

init : () -> (InputModel, Cmd Msg)
{-
init =
  { content = ""
  , employee = Nothing}
-}
init _ =
    (InputModel "" Nothing "", Cmd.none)

-- UPDATE


type Msg
  = Change String
  | EmployeeResult (Result Http.Error Employee)
  | EmployeeRequest


update : Msg -> InputModel -> (InputModel, Cmd Msg)
update msg model =
  case msg of
    Change newContent ->
        ({ model | content = newContent }, Cmd.none)
    EmployeeResult result ->
        case result of
            Ok employee -> ({ model | employee = Just employee }, Cmd.none)
            Err error -> ({ model | employee = Nothing, note = ErrorHandler.toString error }, Cmd.none)
    EmployeeRequest ->
        ( model, findEmployee model)


findEmployee : InputModel -> Cmd Msg
findEmployee model =
    let
        empId = model.content
    in
        Http.get
            { url = "http://localhost:8080/FP-Asignment1/api/department/search_employee/"++empId
            , expect = Http.expectJson EmployeeResult employeeDecoder
            }



-- VIEW


view : InputModel -> Html Msg
view model =
  div []
    [ input [ placeholder "Employee ID", value model.content, onInput Change ] []
    , button [onClick EmployeeRequest][text "Find employee"]
    , viewEmployee model.employee
    , p[] [a [href "http://localhost:8000/src/Main.elm"] [ text "Go back"]]
    ]

viewEmployee : Maybe Employee -> Html Msg
viewEmployee maybeEmployee =
        case maybeEmployee of
            Just e ->
                div []
                    [ p [] [ text ("ID: "++String.fromInt(e.id)) ]
                    , p [] [ text ("Name: "++e.firstName++" "++e.lastName) ]
                    , p [] [ text ("Email: "++e.email) ]
                    , p [] [ text (e.firstName++" "++e.lastName++" works in "++e.depName++" ("++e.depCode++")") ]
                    , p [] [ text ("Department description: "++e.depDescription) ]
                    ]
            Nothing ->
                div []
                    [ text "No employee found."]

