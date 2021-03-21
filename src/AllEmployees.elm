module AllEmployees exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode
import Employee exposing(Employee, employeeDecoder)

type alias Employees =
    { data : List Employee}

employeesDecoder : Decode.Decoder (List Employee)
employeesDecoder =
    Decode.field "all" (Decode.list employeeDecoder)


{-
encodeEmployee : Employee -> Encode.Value
encodeEmployee employee =
    Encode.object
        [ ("id", Encode.int employee.id)
        , ("firstName", Encode.string employee.firstName)
        , ("lastName", Encode.string employee.lastName)
        , ("email", Encode.string employee.email)
        , ("department", encodeDepartment employee.department)
        ]

-}



