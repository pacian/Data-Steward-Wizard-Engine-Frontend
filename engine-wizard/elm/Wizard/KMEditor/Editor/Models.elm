module Wizard.KMEditor.Editor.Models exposing
    ( EditorType(..)
    , Model
    , addSessionEvents
    , containsChanges
    , getAllEvents
    , getCurrentActiveEditorUuid
    , getSavingError
    , hasSavingError
    , initialModel
    )

import ActionResult exposing (ActionResult(..))
import Shared.Data.BranchDetail exposing (BranchDetail)
import Shared.Data.Event exposing (Event)
import Shared.Data.KnowledgeModel exposing (KnowledgeModel)
import Shared.Data.KnowledgeModel.Level exposing (Level)
import Shared.Data.KnowledgeModel.Metric exposing (Metric)
import Uuid exposing (Uuid)
import Wizard.KMEditor.Editor.KMEditor.Models as KMEditorModel
import Wizard.KMEditor.Editor.Preview.Models
import Wizard.KMEditor.Editor.TagEditor.Models as TagEditorModel


type EditorType
    = KMEditor
    | TagsEditor
    | PreviewEditor
    | HistoryEditor


type alias Model =
    { kmUuid : Uuid
    , km : ActionResult BranchDetail
    , metrics : ActionResult (List Metric)
    , levels : ActionResult (List Level)
    , preview : ActionResult KnowledgeModel
    , currentEditor : EditorType
    , sessionEvents : List Event
    , sessionActiveEditor : Maybe String
    , previewEditorModel : Maybe Wizard.KMEditor.Editor.Preview.Models.Model
    , tagEditorModel : Maybe TagEditorModel.Model
    , editorModel : Maybe KMEditorModel.Model
    , saving : ActionResult String
    }


initialModel : Uuid -> Model
initialModel kmUuid =
    { kmUuid = kmUuid
    , km = Loading
    , metrics = Loading
    , levels = Loading
    , preview = Unset
    , currentEditor = KMEditor
    , sessionEvents = []
    , sessionActiveEditor = Nothing
    , previewEditorModel = Nothing
    , tagEditorModel = Nothing
    , editorModel = Nothing
    , saving = Unset
    }


containsChanges : Model -> Bool
containsChanges model =
    let
        tagEditorDirty =
            model.tagEditorModel
                |> Maybe.map TagEditorModel.containsChanges
                |> Maybe.withDefault False

        kmEditorDirty =
            model.editorModel
                |> Maybe.map KMEditorModel.containsChanges
                |> Maybe.withDefault False
    in
    List.length model.sessionEvents > 0 || tagEditorDirty || kmEditorDirty


addSessionEvents : List Event -> Model -> Model
addSessionEvents events model =
    { model | sessionEvents = model.sessionEvents ++ events }


hasSavingError : Model -> Bool
hasSavingError =
    .saving >> ActionResult.isError


getSavingError : Model -> String
getSavingError model =
    case model.saving of
        Error err ->
            err

        _ ->
            ""


getAllEvents : Model -> List Event
getAllEvents model =
    ActionResult.unwrap [] .events model.km ++ model.sessionEvents


getCurrentActiveEditorUuid : Model -> Maybe String
getCurrentActiveEditorUuid =
    .editorModel >> Maybe.andThen .activeEditorUuid
