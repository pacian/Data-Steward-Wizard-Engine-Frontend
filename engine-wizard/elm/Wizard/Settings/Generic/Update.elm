module Wizard.Settings.Generic.Update exposing
    ( UpdateProps
    , fetchData
    , update
    )

import ActionResult exposing (ActionResult(..))
import Form exposing (Form)
import Form.Validate exposing (Validation)
import Shared.Error.ApiError as ApiError exposing (ApiError)
import Shared.Locale exposing (lg)
import Wizard.Common.Api exposing (ToMsg, getResultCmd)
import Wizard.Common.Api.Configs as ConfigsApi
import Wizard.Common.AppState exposing (AppState)
import Wizard.Common.Form exposing (CustomFormError)
import Wizard.Msgs
import Wizard.Ports as Ports
import Wizard.Settings.Common.EditableConfig as EditableConfig exposing (EditableConfig)
import Wizard.Settings.Generic.Model exposing (Model)
import Wizard.Settings.Generic.Msgs exposing (Msg(..))


type alias UpdateProps form =
    { initForm : EditableConfig -> Form CustomFormError form
    , formToConfig : form -> EditableConfig -> EditableConfig
    , formValidation : Validation CustomFormError form
    }


fetchData : AppState -> Cmd Msg
fetchData appState =
    ConfigsApi.getAppConfig appState GetConfigCompleted


update :
    UpdateProps form
    -> (Msg -> Wizard.Msgs.Msg)
    -> Msg
    -> AppState
    -> Model form
    -> ( Model form, Cmd Wizard.Msgs.Msg )
update props wrapMsg msg appState model =
    case msg of
        GetConfigCompleted result ->
            handleGetConfigCompleted props appState model result

        PutConfigCompleted result ->
            handlePutConfigCompleted props appState model result

        FormMsg formMsg ->
            handleForm props formMsg wrapMsg appState model


handleGetConfigCompleted :
    UpdateProps form
    -> AppState
    -> Model form
    -> Result ApiError EditableConfig
    -> ( Model form, Cmd Wizard.Msgs.Msg )
handleGetConfigCompleted props appState model result =
    let
        newModel =
            case result of
                Ok config ->
                    { model | form = props.initForm config, config = Success config }

                Err error ->
                    { model | config = ApiError.toActionResult (lg "apiError.config.app.getError" appState) error }

        cmd =
            getResultCmd result
    in
    ( newModel, cmd )


handlePutConfigCompleted :
    UpdateProps form
    -> AppState
    -> Model form
    -> Result ApiError ()
    -> ( Model form, Cmd Wizard.Msgs.Msg )
handlePutConfigCompleted props appState model result =
    let
        ( newResult, cmd ) =
            case result of
                Ok _ ->
                    ( Success ()
                    , Ports.refresh ()
                    )

                Err error ->
                    ( ApiError.toActionResult (lg "apiError.config.app.putError" appState) error
                    , getResultCmd result
                    )
    in
    ( { model | savingConfig = newResult }, Cmd.batch [ cmd, Ports.scrollToTop ".Settings__content" ] )


handleForm :
    UpdateProps form
    -> Form.Msg
    -> (Msg -> Wizard.Msgs.Msg)
    -> AppState
    -> Model form
    -> ( Model form, Cmd Wizard.Msgs.Msg )
handleForm props formMsg wrapMsg appState model =
    case ( formMsg, Form.getOutput model.form, model.config ) of
        ( Form.Submit, Just form, Success config ) ->
            let
                body =
                    EditableConfig.encode <| props.formToConfig form config

                cmd =
                    Cmd.map wrapMsg <|
                        ConfigsApi.putAppConfig body appState PutConfigCompleted
            in
            ( { model | savingConfig = Loading }, cmd )

        _ ->
            let
                form =
                    Form.update props.formValidation formMsg model.form
            in
            ( { model | form = form }, Cmd.none )