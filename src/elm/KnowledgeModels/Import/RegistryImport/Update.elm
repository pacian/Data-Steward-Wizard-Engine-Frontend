module KnowledgeModels.Import.RegistryImport.Update exposing (update)

import ActionResult exposing (ActionResult(..))
import Common.Api exposing (applyResult)
import Common.Api.Packages as PackagesApi
import Common.AppState exposing (AppState)
import Common.Setters exposing (setPackage)
import KnowledgeModels.Import.RegistryImport.Models exposing (Model)
import KnowledgeModels.Import.RegistryImport.Msgs exposing (Msg(..))
import Msgs


update : Msg -> (Msg -> Msgs.Msg) -> AppState -> Model -> ( Model, Cmd Msgs.Msg )
update msg wrapMsg appState model =
    case msg of
        ChangePackageId packageId ->
            ( { model | packageId = packageId }, Cmd.none )

        Submit ->
            if String.length model.packageId > 0 then
                ( { model | package = Loading }
                , PackagesApi.pullPackage model.packageId appState (wrapMsg << PullPackageCompleted)
                )

            else
                ( model, Cmd.none )

        PullPackageCompleted result ->
            applyResult
                { setResult = setPackage
                , defaultError = "Unable to import package."
                , model = model
                , result = result
                }
