module Shared.Data.Member exposing
    ( Member
    , decoder
    , encode
    )

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D
import Json.Encode as E
import Uuid exposing (Uuid)


type alias Member =
    { uuid : Uuid
    , firstName : String
    , lastName : String
    , gravatarHash : String
    , imageUrl : Maybe String
    , type_ : String
    }


decoder : Decoder Member
decoder =
    D.succeed Member
        |> D.required "uuid" Uuid.decoder
        |> D.required "firstName" D.string
        |> D.required "lastName" D.string
        |> D.required "gravatarHash" D.string
        |> D.required "imageUrl" (D.maybe D.string)
        |> D.required "type" D.string


encode : Member -> E.Value
encode member =
    E.object
        [ ( "uuid", E.string (Uuid.toString member.uuid) )
        , ( "type", E.string member.type_ )
        ]
