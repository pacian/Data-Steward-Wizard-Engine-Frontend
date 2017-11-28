module KnowledgeModels.Index.Update exposing (..)

import Auth.Models exposing (Session)
import Common.Types exposing (ActionResult(..))
import Jwt
import KnowledgeModels.Index.Models exposing (Model)
import KnowledgeModels.Index.Msgs exposing (Msg(..))
import KnowledgeModels.Models exposing (KnowledgeModel)
import KnowledgeModels.Requests exposing (deleteKnowledgeModel, getKnowledgeModels)
import Msgs
import Requests exposing (toCmd)
import Routing exposing (Route(..), cmdNavigate)


getKnowledgeModelsCmd : Session -> Cmd Msgs.Msg
getKnowledgeModelsCmd session =
    getKnowledgeModels session
        |> toCmd GetKnowledgeModelsCompleted Msgs.KnowledgeModelsIndexMsg


deleteKnowledgeModelCmd : String -> Session -> Cmd Msgs.Msg
deleteKnowledgeModelCmd kmId session =
    deleteKnowledgeModel kmId session
        |> toCmd DeleteKnowledgeModelCompleted Msgs.KnowledgeModelsIndexMsg


getKnowledgeModelsCompleted : Model -> Result Jwt.JwtError (List KnowledgeModel) -> ( Model, Cmd Msgs.Msg )
getKnowledgeModelsCompleted model result =
    let
        newModel =
            case result of
                Ok knowledgeModels ->
                    { model | knowledgeModels = Success knowledgeModels }

                Err error ->
                    { model | knowledgeModels = Error "Unable to fetch knowledge models" }
    in
    ( newModel, Cmd.none )


handleDeleteKM : Session -> Model -> ( Model, Cmd Msgs.Msg )
handleDeleteKM session model =
    case model.kmToBeDeleted of
        Just km ->
            ( { model | deletingKnowledgeModel = Loading }
            , deleteKnowledgeModelCmd km.uuid session
            )

        _ ->
            ( model, Cmd.none )


deleteKnowledgeModelCompleted : Model -> Result Jwt.JwtError String -> ( Model, Cmd Msgs.Msg )
deleteKnowledgeModelCompleted model result =
    case result of
        Ok km ->
            ( model, cmdNavigate KnowledgeModels )

        Err error ->
            ( { model | deletingKnowledgeModel = Error "Knowledge model could not be deleted" }
            , Cmd.none
            )


update : Msg -> Session -> Model -> ( Model, Cmd Msgs.Msg )
update msg session model =
    case msg of
        GetKnowledgeModelsCompleted result ->
            getKnowledgeModelsCompleted model result

        ShowHideDeleteKnowledgeModel km ->
            ( { model | kmToBeDeleted = km, deletingKnowledgeModel = Unset }, Cmd.none )

        DeleteKnowledgeModel ->
            handleDeleteKM session model

        DeleteKnowledgeModelCompleted result ->
            deleteKnowledgeModelCompleted model result