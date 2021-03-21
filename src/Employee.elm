module Employee exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode

type alias Employee =
    { id: Int
    , firstName: String
    , lastName: String
    , email: String
    , depCode: String
    , depName: String
    , depDescription: String
    }


type alias Department =
    { depCode: String
    , depName: String
    , depDescription: String
    }

departmentDecoder: Decode.Decoder Department
departmentDecoder =
    Decode.map3 Department
        (Decode.field "depCode" Decode.string)
        (Decode.field "depName" Decode.string)
        (Decode.field "depDescription" Decode.string)

employeeDecoder : Decode.Decoder Employee
employeeDecoder =
    Decode.map7 Employee
        (Decode.field "id" Decode.int)
        (Decode.field "firstName" Decode.string)
        (Decode.field "lastName" Decode.string)
        (Decode.field "email" Decode.string)
        (Decode.field "depCode" Decode.string)
        (Decode.field "depName" Decode.string)
        (Decode.field "depDescription" Decode.string)

encodeDepartment : Department -> Encode.Value
encodeDepartment department =
    Encode.object
        [ ("depCode", Encode.string department.depCode)
        , ("depName", Encode.string department.depName)
        , ("depDescription", Encode.string department.depDescription)
        ]
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



