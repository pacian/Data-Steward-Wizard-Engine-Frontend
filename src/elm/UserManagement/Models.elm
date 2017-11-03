module UserManagement.Models exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required)


type alias User =
    { uuid : String
    , email : String
    , name : String
    , surname : String
    , role : String
    }


userDecoder : Decoder User
userDecoder =
    decode User
        |> required "uuid" Decode.string
        |> required "email" Decode.string
        |> required "name" Decode.string
        |> required "surname" Decode.string
        |> required "role" Decode.string

userListDecoder : Decoder (List User)
userListDecoder =
    Decode.list userDecoder