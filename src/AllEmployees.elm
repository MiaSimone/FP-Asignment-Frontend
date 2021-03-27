module AllEmployees exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode
import Employee exposing(Employee, employeeDecoder)

type alias Employees =
    { data : List Employee}

employeesDecoder : Decode.Decoder (List Employee)
employeesDecoder =
    Decode.field "all" (Decode.list employeeDecoder)




