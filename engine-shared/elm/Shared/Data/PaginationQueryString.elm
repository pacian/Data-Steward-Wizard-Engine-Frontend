module Shared.Data.PaginationQueryString exposing
    ( PaginationQueryString
    , SortDirection(..)
    , empty
    , fromQ
    , parser
    , toApiUrl
    , toApiUrlWith
    , toUrl
    , toUrlWith
    , withSize
    , withSort
    , wrapRoute
    )

import List.Extra as List
import Maybe.Extra as Maybe
import Url.Parser exposing ((<?>), Parser)
import Url.Parser.Query as Query


type alias PaginationQueryString =
    { page : Maybe Int
    , q : Maybe String
    , sortBy : Maybe String
    , sortDirection : SortDirection
    , size : Maybe Int
    }


type SortDirection
    = SortASC
    | SortDESC


empty : PaginationQueryString
empty =
    PaginationQueryString Nothing Nothing Nothing SortASC (Just defaultPageSize)


fromQ : String -> PaginationQueryString
fromQ q =
    { empty | q = Just q }


withSize : Maybe Int -> PaginationQueryString -> PaginationQueryString
withSize size qs =
    { qs | size = size }


withSort : Maybe String -> SortDirection -> PaginationQueryString -> PaginationQueryString
withSort sortBy sortDirection qs =
    { qs | sortBy = sortBy, sortDirection = sortDirection }


defaultPageSize : Int
defaultPageSize =
    20


wrapRoute : (PaginationQueryString -> a) -> Maybe String -> Maybe Int -> Maybe String -> Maybe String -> a
wrapRoute route defaultSortBy page q sort =
    let
        ( sortBy, sortDirection ) =
            parseSort defaultSortBy sort
    in
    route <| PaginationQueryString page q sortBy sortDirection (Just defaultPageSize)


parser : Parser a (Maybe Int -> Maybe String -> Maybe String -> b) -> Parser a b
parser p =
    p <?> Query.int "page" <?> Query.string "q" <?> Query.string "sort"


toUrl : PaginationQueryString -> String
toUrl =
    toUrlWith []


toUrlWith : List ( String, String ) -> PaginationQueryString -> String
toUrlWith extraParams qs =
    let
        sortQuery sortBy =
            sortBy ++ "," ++ sortDirectionToString qs.sortDirection

        params =
            [ ( "page", Maybe.unwrap "" String.fromInt qs.page )
            , ( "q", Maybe.withDefault "" qs.q )
            , ( "sort", Maybe.unwrap "" sortQuery qs.sortBy )
            ]
                ++ extraParams
    in
    toQueryString params


toApiUrl : PaginationQueryString -> String
toApiUrl =
    toApiUrlWith []


toApiUrlWith : List ( String, String ) -> PaginationQueryString -> String
toApiUrlWith extraParams qs =
    let
        sortQuery sortBy =
            sortBy ++ "," ++ sortDirectionToString qs.sortDirection

        params =
            [ ( "page", Maybe.unwrap "0" (\p -> String.fromInt (p - 1)) qs.page )
            , ( "q", Maybe.withDefault "" qs.q )
            , ( "sort", Maybe.unwrap "" sortQuery qs.sortBy )
            , ( "size", Maybe.unwrap "" String.fromInt qs.size )
            ]
                ++ extraParams
    in
    toQueryString params


toQueryString : List ( String, String ) -> String
toQueryString params =
    let
        queryString =
            params
                |> List.filter (\( _, v ) -> not (String.isEmpty v))
                |> List.map (\( k, v ) -> k ++ "=" ++ v)
                |> String.join "&"
    in
    if String.length queryString > 0 then
        "?" ++ queryString

    else
        ""


parseSort : Maybe String -> Maybe String -> ( Maybe String, SortDirection )
parseSort defaultSortBy mbSort =
    let
        parts =
            Maybe.unwrap [] (String.split ",") mbSort

        defaultParts =
            Maybe.unwrap [] (String.split ",") defaultSortBy

        sortBy =
            case ( List.head parts, List.head defaultParts ) of
                ( Just s, _ ) ->
                    Just s

                ( Nothing, Just s ) ->
                    Just s

                _ ->
                    Nothing

        sortDirection =
            case
                ( Maybe.map parseSortDirection (List.last parts)
                , Maybe.map parseSortDirection (List.last defaultParts)
                )
            of
                ( Just d, _ ) ->
                    d

                ( Nothing, Just d ) ->
                    d

                _ ->
                    SortASC
    in
    ( sortBy, sortDirection )


parseSortDirection : String -> SortDirection
parseSortDirection direction =
    if direction == "desc" then
        SortDESC

    else
        SortASC


sortDirectionToString : SortDirection -> String
sortDirectionToString sortDirection =
    if sortDirection == SortASC then
        "asc"

    else
        "desc"
